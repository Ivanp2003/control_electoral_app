import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/validators/acta_validator.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/utils/appwrite_id_helper.dart';
import '../../../../database/app_database.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../organizaciones/data/datasources/organizaciones_remote_datasource.dart';
import '../../../organizaciones/data/models/organizacion_politica_model.dart';
import '../../../organizaciones/domain/entities/organizacion_politica.dart';
import '../../../recintos/data/models/jrv_model.dart';
import '../../../evidencia/domain/entities/evidencia_data.dart';
import '../../../evidencia/presentation/screens/captura_evidencia_screen.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';
import '../../domain/usecases/registrar_acta_usecase.dart';
import '../providers/actas_providers.dart';
import '../../../sync/presentation/widgets/sync_indicator.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../recintos/presentation/providers/jrv_context_provider.dart';

class RegistrarActaScreen extends ConsumerStatefulWidget {
  final Acta? actaExistente;
  const RegistrarActaScreen({super.key, this.actaExistente});

  @override
  ConsumerState<RegistrarActaScreen> createState() =>
      _RegistrarActaScreenState();
}

enum _PasoRegistro { seleccionarJrv, llenarDatos, evidencia, resumen }

class _RegistrarActaScreenState extends ConsumerState<RegistrarActaScreen> {
  _PasoRegistro _paso = _PasoRegistro.seleccionarJrv;
  JrvModel? _jrvSeleccionado;
  String _cargoSeleccionado = 'alcalde';
  final _totalCtrl = TextEditingController();
  final _blancosCtrl = TextEditingController();
  final _nulosCtrl = TextEditingController();
  final Map<String, TextEditingController> _votosControllers = {};
  List<OrganizacionPolitica> _organizaciones = [];
  String? _error;
  bool _guardando = false;
  EvidenciaData? _evidencia;

  @override
  void initState() {
    super.initState();
    if (widget.actaExistente != null) {
      final acta = widget.actaExistente!;
      _cargoSeleccionado = acta.cargoElectoral;
      _totalCtrl.text = acta.totalSufragantes.toString();
      _blancosCtrl.text = acta.votosBlancos.toString();
      _nulosCtrl.text = acta.votosNulos.toString();
      _jrvSeleccionado = JrvModel(id: acta.jrvId, codigo: 'JRV', recintoId: '');
      _paso = _PasoRegistro.llenarDatos;
      _cargarOrganizacionesParaEdicion(acta);
    }
  }

  Future<void> _cargarOrganizacionesParaEdicion(Acta acta) async {
    await _cargarOrganizaciones();
    setState(() {
      for (final orgVoto in acta.organizaciones) {
        if (_votosControllers.containsKey(orgVoto.organizacionId)) {
          _votosControllers[orgVoto.organizacionId]!.text = orgVoto.votos.toString();
        } else {
          _votosControllers[orgVoto.organizacionId] = TextEditingController(text: orgVoto.votos.toString());
        }
      }
    });
  }

  @override
  void dispose() {
    _totalCtrl.dispose();
    _blancosCtrl.dispose();
    _nulosCtrl.dispose();
    for (final c in _votosControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _cargarOrganizaciones() async {
    try {
      final remote = OrganizacionesRemoteDatasourceImpl(
        databases: ref.read(appwriteDatabasesProvider),
      );
      final orgs = await remote.obtenerOrganizaciones(_cargoSeleccionado);
      setState(() {
        _organizaciones = orgs;
        _votosControllers.clear();
        for (final org in orgs) {
          _votosControllers[org.id] = TextEditingController();
        }
      });
    } catch (e) {
      setState(() => _error = 'Error al cargar organizaciones: $e');
    }
  }

  void _onCargoChanged(String cargo) {
    setState(() {
      _cargoSeleccionado = cargo;
      _organizaciones = [];
      _votosControllers.clear();
    });
    _cargarOrganizaciones();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.actaExistente != null ? 'Corregir Acta' : 'Registrar Acta',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            if (_jrvSeleccionado != null)
              Consumer(
                builder: (context, ref, child) {
                  final ctxAsync = ref.watch(jrvContextProvider(_jrvSeleccionado!.id));
                  return ctxAsync.when(
                    data: (contexto) => Text(contexto,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: theme.colorScheme.onSurface.withOpacity(0.7))),
                    loading: () => Text('Cargando contexto...',
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.5))),
                    error: (_, __) => const Text('Error al cargar contexto',
                        style: TextStyle(fontSize: 12, color: Colors.red)),
                  );
                },
              ),
          ],
        ),
        actions: const [
          ThemeToggleButton(),
          SyncIndicator(),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_paso) {
      case _PasoRegistro.seleccionarJrv:
        return _PasoSeleccionarJrv();
      case _PasoRegistro.llenarDatos:
        return _PasoLlenarDatos();
      case _PasoRegistro.evidencia:
        return _PasoEvidencia();
      case _PasoRegistro.resumen:
        return _PasoResumen();
    }
  }

  Widget _PasoSeleccionarJrv() {
    final usuario = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    if (usuario == null) {
      return Center(child: Text('No autenticado',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))));
    }

    return FutureBuilder<List<JrvModel>>(
      future: _obtenerJrvDisponibles(usuario.id, usuario.rol),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(
              color: colorScheme.primary));
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent)),
            ),
          );
        }
        final jrvList = snapshot.data ?? [];
        if (jrvList.isEmpty) {
          return Center(
            child: Text('No tienes JRV asignadas.',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54), fontSize: 16)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jrvList.length,
          itemBuilder: (context, index) {
            final jrv = jrvList[index];
            return FutureBuilder<String>(
              future: (() async {
                final recinto = await (ref.read(appDatabaseProvider).select(
                  ref.read(appDatabaseProvider).recintosLocal)
                  ..where((t) => t.id.equals(jrv.recintoId)))
                  .getSingleOrNull();
                return recinto?.nombre ?? '';
              })(),
              builder: (context, snap) {
                return Card(
                  color: surfaceColor,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(jrv.codigo,
                        style: TextStyle(
                            color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
                    subtitle: snap.hasData && snap.data!.isNotEmpty
                        ? Text(snap.data!,
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.55), fontSize: 12))
                        : null,
                    trailing: Icon(Icons.chevron_right, color: colorScheme.onSurface.withOpacity(0.54)),
                    onTap: () {
                      setState(() {
                        _jrvSeleccionado = jrv;
                        _paso = _PasoRegistro.llenarDatos;
                      });
                      _cargarOrganizaciones();
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<JrvModel>> _obtenerJrvDisponibles(
      String userId, AppRole rol) async {
    if (rol == AppRole.coordinadorRecinto) {
      return [];
    }
    if (rol == AppRole.veedor) {
      final db = ref.read(appDatabaseProvider);
      final asignaciones = await db.obtenerJrvPorVeedor(userId);
      final result = <JrvModel>[];
      for (final asig in asignaciones) {
        final jrvList = await db.obtenerJrvLocal(asig.recintoId);
        for (final jrv in jrvList) {
          if (jrv.id == asig.jrvId) {
            result.add(JrvModel(
                id: jrv.id, codigo: jrv.codigo, recintoId: jrv.recintoId));
          }
        }
      }
      return result;
    }
    return [];
  }

  Widget _PasoLlenarDatos() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('JRV: ${_jrvSeleccionado?.codigo ?? ""}',
              style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14)),
          const SizedBox(height: 8),
          // Selector de cargo
          Row(
            children: [
              _CargoBoton(
                label: 'Alcalde',
                selected: _cargoSeleccionado == 'alcalde',
                onTap: () => _onCargoChanged('alcalde'),
              ),
              const SizedBox(width: 12),
              _CargoBoton(
                label: 'Prefecto',
                selected: _cargoSeleccionado == 'prefecto',
                onTap: () => _onCargoChanged('prefecto'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_organizaciones.isEmpty)
            Center(child: CircularProgressIndicator(
                color: colorScheme.primary))
          else ...[
            Text('VOTOS POR ORGANIZACIÓN',
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.38),
                    fontSize: 11,
                    letterSpacing: 1.5)),
            const SizedBox(height: 8),
            ..._organizaciones.map((org) => _VotoField(
                  label: org.nombre,
                  controller: _votosControllers[org.id]!,
                  onChanged: _validarEnTiempoReal,
                )),
            Divider(color: colorScheme.onSurface.withOpacity(0.12), height: 24),
            _VotoField(
                label: 'Votos en Blanco',
                controller: _blancosCtrl,
                onChanged: _validarEnTiempoReal),
            _VotoField(
                label: 'Votos Nulos',
                controller: _nulosCtrl,
                onChanged: _validarEnTiempoReal),
            Divider(color: colorScheme.onSurface.withOpacity(0.12), height: 24),
            _VotoField(
                label: 'Total Sufragantes',
                controller: _totalCtrl,
                onChanged: _validarEnTiempoReal),
            const SizedBox(height: 24),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.4)),
                ),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.redAccent)),
              ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _guardando ? null : _validarYResumir,
                child: _guardando
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorScheme.onPrimary))
                    : const Text('Validar y Continuar',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _validarEnTiempoReal() {
    final votos = _organizaciones
        .map((org) => int.tryParse(
                _votosControllers[org.id]?.text ?? '') ??
            0)
        .toList();
    final blancos = int.tryParse(_blancosCtrl.text) ?? 0;
    final nulos = int.tryParse(_nulosCtrl.text) ?? 0;
    final total = int.tryParse(_totalCtrl.text) ?? 0;

    final resultado = validarActa(
      totalSufragantes: total,
      votosOrganizaciones: votos,
      votosBlancos: blancos,
      votosNulos: nulos,
    );

    resultado.fold(
      (failure) {
        setState(() => _error = failure.message);
      },
      (_) {
        setState(() => _error = null);
      },
    );
  }

  void _validarYResumir() {
    _validarEnTiempoReal();
    if (_error == null) {
      setState(() {
        _paso = _PasoRegistro.evidencia;
      });
    }
  }

  Widget _PasoEvidencia() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined,
                size: 72, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text('Evidencia Fotográfica',
                style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Acta de ${_cargoSeleccionado == "alcalde" ? "Alcalde" : "Prefecto"}',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'La fotografía es obligatoria. Captura una imagen nítida del acta y registra tu ubicación GPS.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54), fontSize: 14),
            ),
            const SizedBox(height: 32),
            if (_evidencia != null)
              Column(
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.greenAccent, size: 40),
                  const SizedBox(height: 8),
                  const Text('Evidencia capturada',
                      style: TextStyle(color: Colors.greenAccent)),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: _navegarACapturaEvidencia,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Volver a tomar'),
                    style: TextButton.styleFrom(foregroundColor: colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () =>
                          setState(() => _paso = _PasoRegistro.resumen),
                      child: const Text('Continuar al Resumen',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tomar Fotografía',
                          style: TextStyle(fontSize: 16)),
                      onPressed: _navegarACapturaEvidencia,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () =>
                          setState(() => _paso = _PasoRegistro.llenarDatos),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface.withOpacity(0.6),
                        side: BorderSide(color: colorScheme.onSurface.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Volver a los datos'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _navegarACapturaEvidencia() async {
    final result = await Navigator.push<EvidenciaData>(
      context,
      MaterialPageRoute(
        builder: (_) => const CapturaEvidenciaScreen(),
      ),
    );
    if (result != null) {
      setState(() => _evidencia = result);
    }
  }

  Widget _PasoResumen() {
    final votos = _organizaciones
        .map((org) => OrganizacionConVotos(
              organizacionId: org.id,
              nombreOrganizacion: org.nombre,
              votos: int.tryParse(
                      _votosControllers[org.id]?.text ?? '') ??
                  0,
            ))
        .toList();
    final blancos = int.tryParse(_blancosCtrl.text) ?? 0;
    final nulos = int.tryParse(_nulosCtrl.text) ?? 0;
    final total = int.tryParse(_totalCtrl.text) ?? 0;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen - ${_cargoSeleccionado == 'alcalde' ? 'Alcalde' : 'Prefecto'}',
              style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('JRV: ${_jrvSeleccionado?.codigo ?? ""}',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))),
          Divider(color: colorScheme.onSurface.withOpacity(0.12)),
          ..._organizaciones.map((org) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(org.nombre,
                            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)))),
                    Text(
                        '${_votosControllers[org.id]?.text ?? "0"}',
                        style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
          Divider(color: colorScheme.onSurface.withOpacity(0.12)),
          _ResumenLinea(
              label: 'Blancos', valor: blancos.toString(), colorScheme: colorScheme),
          _ResumenLinea(
              label: 'Nulos', valor: nulos.toString(), colorScheme: colorScheme),
          _ResumenLinea(
              label: 'Total Sufragantes',
              valor: total.toString(),
              destacado: true,
              colorScheme: colorScheme),
          if (_evidencia != null) ...[
            Divider(color: colorScheme.onSurface.withOpacity(0.12)),
            Text('EVIDENCIA',
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.38),
                    fontSize: 11,
                    letterSpacing: 1.5)),
            const SizedBox(height: 4),
            _ResumenLinea(
                label: 'Ubicación',
                valor:
                    '${_evidencia!.latitud.toStringAsFixed(4)}, ${_evidencia!.longitud.toStringAsFixed(4)}',
                colorScheme: colorScheme),
            _ResumenLinea(label: 'Foto', valor: 'Capturada ✓', colorScheme: colorScheme),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _guardando ? null : _guardarActa,
              child: _guardando
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Guardar Acta',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () =>
                  setState(() => _paso = _PasoRegistro.evidencia),
              child: Text('Volver y corregir',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _guardarActa() async {
    setState(() => _guardando = true);

    final organizacionesConVotos = _organizaciones
        .map((org) => OrganizacionConVotos(
              organizacionId: org.id,
              nombreOrganizacion: org.nombre,
              votos: int.tryParse(
                      _votosControllers[org.id]?.text ?? '') ??
                  0,
            ))
        .toList();

    final blancos = int.tryParse(_blancosCtrl.text) ?? 0;
    final nulos = int.tryParse(_nulosCtrl.text) ?? 0;
    final total = int.tryParse(_totalCtrl.text) ?? 0;

    final usuario = ref.read(currentUserProvider)!;

    final acta = Acta(
      id: AppwriteIdHelper.actaId(
        jrvId: _jrvSeleccionado!.id,
        cargoElectoral: _cargoSeleccionado,
      ),
      jrvId: _jrvSeleccionado!.id,
      cargoElectoral: _cargoSeleccionado,
      totalSufragantes: total,
      votosBlancos: blancos,
      votosNulos: nulos,
      organizaciones: organizacionesConVotos,
      evidenciaFoto: _evidencia?.fotoPath,
      latitud: _evidencia?.latitud ?? 0.0,
      longitud: _evidencia?.longitud ?? 0.0,
      creadoPor: usuario.id,
      synced: false,
    );

    final registrar = ref.read(registrarActaUseCaseProvider);
    final result = await registrar(acta, usuario);

    setState(() => _guardando = false);

    result.fold(
      (failure) {
        if (mounted) {
          setState(() => _error = failure.message);
          _paso = _PasoRegistro.llenarDatos;
        }
      },
      (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Acta registrada exitosamente'),
                backgroundColor: Colors.greenAccent),
          );
          Navigator.pop(context);
        }
      },
    );
  }
}

class _CargoBoton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CargoBoton(
      {required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = Theme.of(context).cardTheme.color ?? colorScheme.surface;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary
                : surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.24),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.54),
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _VotoField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback? onChanged;
  const _VotoField({required this.label, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = Theme.of(context).cardTheme.color ?? colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 14)),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              onChanged: (_) => onChanged?.call(),
              keyboardType: TextInputType.number,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumenLinea extends StatelessWidget {
  final String label;
  final String valor;
  final bool destacado;
  final ColorScheme colorScheme;
  const _ResumenLinea(
      {required this.label,
      required this.valor,
      this.destacado = false,
      required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: destacado ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.7),
                  fontWeight:
                      destacado ? FontWeight.bold : FontWeight.normal)),
          Text(valor,
              style: TextStyle(
                  color: destacado
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight:
                      destacado ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
