import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/validators/acta_validator.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../database/app_database.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../organizaciones/data/datasources/organizaciones_remote_datasource.dart';
import '../../../organizaciones/data/models/organizacion_politica_model.dart';
import '../../../organizaciones/domain/entities/organizacion_politica.dart';
import '../../../recintos/data/models/jrv_model.dart';
import '../../../evidencia/domain/entities/evidencia_data.dart';
import '../../../evidencia/presentation/screens/captura_evidencia_screen.dart';
import '../providers/actas_providers.dart';

class RegistrarActaScreen extends ConsumerStatefulWidget {
  const RegistrarActaScreen({super.key});

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
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Registrar Acta',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
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
    if (usuario == null) {
      return const Center(child: Text('No autenticado',
          style: TextStyle(color: Colors.white54)));
    }

    return FutureBuilder<List<JrvModel>>(
      future: _obtenerJrvDisponibles(usuario.id, usuario.rol),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(
              color: Color(0xFF4A90D9)));
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
          return const Center(
            child: Text('No tienes JRV asignadas.',
                style: TextStyle(color: Colors.white54, fontSize: 16)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jrvList.length,
          itemBuilder: (context, index) {
            final jrv = jrvList[index];
            return Card(
              color: const Color(0xFF0F2442),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(jrv.codigo,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFF4A90D9)),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('JRV: ${_jrvSeleccionado?.codigo ?? ""}',
              style: const TextStyle(
                  color: Colors.white70,
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
            const Center(child: CircularProgressIndicator(
                color: Color(0xFF4A90D9)))
          else ...[
            const Text('VOTOS POR ORGANIZACIÓN',
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    letterSpacing: 1.5)),
            const SizedBox(height: 8),
            ..._organizaciones.map((org) => _VotoField(
                  label: org.nombre,
                  controller: _votosControllers[org.id]!,
                )),
            const Divider(color: Colors.white12, height: 24),
            _VotoField(
                label: 'Votos en Blanco',
                controller: _blancosCtrl),
            _VotoField(
                label: 'Votos Nulos',
                controller: _nulosCtrl),
            const Divider(color: Colors.white12, height: 24),
            _VotoField(
                label: 'Total Sufragantes',
                controller: _totalCtrl),
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
                  backgroundColor: const Color(0xFF4A90D9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _guardando ? null : _validarYResumir,
                child: _guardando
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
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

  void _validarYResumir() {
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
        setState(() {
          _error = null;
          _paso = _PasoRegistro.evidencia;
        });
      },
    );
  }

  Widget _PasoEvidencia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined,
                size: 72, color: Color(0xFF4A90D9)),
            const SizedBox(height: 24),
            const Text('Evidencia Fotográfica',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Captura una fotografía nítida del acta '
              'y registra tu ubicación GPS.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90D9),
                        foregroundColor: Colors.white,
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
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
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
            TextButton(
              onPressed: () =>
                  setState(() => _paso = _PasoRegistro.llenarDatos),
              child: const Text('Omitir y volver',
                  style: TextStyle(color: Colors.white38)),
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
        .map((org) => VotoInput(
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen - ${_cargoSeleccionado == 'alcalde' ? 'Alcalde' : 'Prefecto'}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('JRV: ${_jrvSeleccionado?.codigo ?? ""}',
              style: const TextStyle(color: Colors.white54)),
          const Divider(color: Colors.white12),
          ..._organizaciones.map((org) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(org.nombre,
                            style: const TextStyle(color: Colors.white70))),
                    Text(
                        '${_votosControllers[org.id]?.text ?? "0"}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
          const Divider(color: Colors.white12),
          _ResumenLinea(
              label: 'Blancos', valor: blancos.toString()),
          _ResumenLinea(
              label: 'Nulos', valor: nulos.toString()),
          _ResumenLinea(
              label: 'Total Sufragantes',
              valor: total.toString(),
              destacado: true),
          if (_evidencia != null) ...[
            const Divider(color: Colors.white12),
            const Text('EVIDENCIA',
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    letterSpacing: 1.5)),
            const SizedBox(height: 4),
            _ResumenLinea(
                label: 'Ubicación',
                valor:
                    '${_evidencia!.latitud.toStringAsFixed(4)}, ${_evidencia!.longitud.toStringAsFixed(4)}'),
            _ResumenLinea(label: 'Foto', valor: 'Capturada ✓'),
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
              child: const Text('Volver y corregir',
                  style: TextStyle(color: Colors.white54)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _guardarActa() async {
    setState(() => _guardando = true);

    final votos = _organizaciones
        .map((org) => VotoInput(
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

    final error = await ref
        .read(actaRegistroNotifierProvider.notifier)
        .registrar(
          jrvId: _jrvSeleccionado!.id,
          cargoElectoral: _cargoSeleccionado,
          votosOrganizaciones: votos,
          votosBlancos: blancos,
          votosNulos: nulos,
          totalSufragantes: total,
          organizaciones: _organizaciones,
          evidencia: _evidencia,
        );

    setState(() => _guardando = false);

    if (error == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Acta registrada exitosamente'),
              backgroundColor: Colors.greenAccent),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        setState(() => _error = error);
        _paso = _PasoRegistro.llenarDatos;
      }
    }
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF4A90D9)
                : const Color(0xFF0F2442),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFF4A90D9)
                  : Colors.white24,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white54,
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
  const _VotoField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: const Color(0xFF0F2442),
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
  const _ResumenLinea(
      {required this.label,
      required this.valor,
      this.destacado = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: destacado ? Colors.white : Colors.white70,
                  fontWeight:
                      destacado ? FontWeight.bold : FontWeight.normal)),
          Text(valor,
              style: TextStyle(
                  color: destacado
                      ? const Color(0xFF4A90D9)
                      : Colors.white,
                  fontWeight:
                      destacado ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
