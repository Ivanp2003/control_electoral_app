// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ActasLocalTable extends ActasLocal
    with TableInfo<$ActasLocalTable, ActasLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActasLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jrvIdMeta = const VerificationMeta('jrvId');
  @override
  late final GeneratedColumn<String> jrvId = GeneratedColumn<String>(
    'jrv_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargoElectoralMeta = const VerificationMeta(
    'cargoElectoral',
  );
  @override
  late final GeneratedColumn<String> cargoElectoral = GeneratedColumn<String>(
    'cargo_electoral',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _votosBlancosMeta = const VerificationMeta(
    'votosBlancos',
  );
  @override
  late final GeneratedColumn<int> votosBlancos = GeneratedColumn<int>(
    'votos_blancos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _votosNulosMeta = const VerificationMeta(
    'votosNulos',
  );
  @override
  late final GeneratedColumn<int> votosNulos = GeneratedColumn<int>(
    'votos_nulos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSufragantesMeta = const VerificationMeta(
    'totalSufragantes',
  );
  @override
  late final GeneratedColumn<int> totalSufragantes = GeneratedColumn<int>(
    'total_sufragantes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fotoUrlMeta = const VerificationMeta(
    'fotoUrl',
  );
  @override
  late final GeneratedColumn<String> fotoUrl = GeneratedColumn<String>(
    'foto_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudMeta = const VerificationMeta(
    'latitud',
  );
  @override
  late final GeneratedColumn<double> latitud = GeneratedColumn<double>(
    'latitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudMeta = const VerificationMeta(
    'longitud',
  );
  @override
  late final GeneratedColumn<double> longitud = GeneratedColumn<double>(
    'longitud',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creadoPorMeta = const VerificationMeta(
    'creadoPor',
  );
  @override
  late final GeneratedColumn<String> creadoPor = GeneratedColumn<String>(
    'creado_por',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editadoPorMeta = const VerificationMeta(
    'editadoPor',
  );
  @override
  late final GeneratedColumn<String> editadoPor = GeneratedColumn<String>(
    'editado_por',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaEdicionMeta = const VerificationMeta(
    'fechaEdicion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEdicion = GeneratedColumn<DateTime>(
    'fecha_edicion',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jrvId,
    cargoElectoral,
    votosBlancos,
    votosNulos,
    totalSufragantes,
    fotoUrl,
    latitud,
    longitud,
    synced,
    syncError,
    creadoPor,
    editadoPor,
    fechaEdicion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'actas_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActasLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('jrv_id')) {
      context.handle(
        _jrvIdMeta,
        jrvId.isAcceptableOrUnknown(data['jrv_id']!, _jrvIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jrvIdMeta);
    }
    if (data.containsKey('cargo_electoral')) {
      context.handle(
        _cargoElectoralMeta,
        cargoElectoral.isAcceptableOrUnknown(
          data['cargo_electoral']!,
          _cargoElectoralMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cargoElectoralMeta);
    }
    if (data.containsKey('votos_blancos')) {
      context.handle(
        _votosBlancosMeta,
        votosBlancos.isAcceptableOrUnknown(
          data['votos_blancos']!,
          _votosBlancosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_votosBlancosMeta);
    }
    if (data.containsKey('votos_nulos')) {
      context.handle(
        _votosNulosMeta,
        votosNulos.isAcceptableOrUnknown(data['votos_nulos']!, _votosNulosMeta),
      );
    } else if (isInserting) {
      context.missing(_votosNulosMeta);
    }
    if (data.containsKey('total_sufragantes')) {
      context.handle(
        _totalSufragantesMeta,
        totalSufragantes.isAcceptableOrUnknown(
          data['total_sufragantes']!,
          _totalSufragantesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalSufragantesMeta);
    }
    if (data.containsKey('foto_url')) {
      context.handle(
        _fotoUrlMeta,
        fotoUrl.isAcceptableOrUnknown(data['foto_url']!, _fotoUrlMeta),
      );
    }
    if (data.containsKey('latitud')) {
      context.handle(
        _latitudMeta,
        latitud.isAcceptableOrUnknown(data['latitud']!, _latitudMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudMeta);
    }
    if (data.containsKey('longitud')) {
      context.handle(
        _longitudMeta,
        longitud.isAcceptableOrUnknown(data['longitud']!, _longitudMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('creado_por')) {
      context.handle(
        _creadoPorMeta,
        creadoPor.isAcceptableOrUnknown(data['creado_por']!, _creadoPorMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoPorMeta);
    }
    if (data.containsKey('editado_por')) {
      context.handle(
        _editadoPorMeta,
        editadoPor.isAcceptableOrUnknown(data['editado_por']!, _editadoPorMeta),
      );
    }
    if (data.containsKey('fecha_edicion')) {
      context.handle(
        _fechaEdicionMeta,
        fechaEdicion.isAcceptableOrUnknown(
          data['fecha_edicion']!,
          _fechaEdicionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActasLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActasLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jrvId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jrv_id'],
      )!,
      cargoElectoral: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cargo_electoral'],
      )!,
      votosBlancos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}votos_blancos'],
      )!,
      votosNulos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}votos_nulos'],
      )!,
      totalSufragantes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_sufragantes'],
      )!,
      fotoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_url'],
      ),
      latitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitud'],
      )!,
      longitud: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitud'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      creadoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creado_por'],
      )!,
      editadoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}editado_por'],
      ),
      fechaEdicion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_edicion'],
      ),
    );
  }

  @override
  $ActasLocalTable createAlias(String alias) {
    return $ActasLocalTable(attachedDatabase, alias);
  }
}

class ActasLocalData extends DataClass implements Insertable<ActasLocalData> {
  final String id;
  final String jrvId;
  final String cargoElectoral;
  final int votosBlancos;
  final int votosNulos;
  final int totalSufragantes;
  final String? fotoUrl;
  final double latitud;
  final double longitud;
  final bool synced;
  final String? syncError;
  final String creadoPor;
  final String? editadoPor;
  final DateTime? fechaEdicion;
  const ActasLocalData({
    required this.id,
    required this.jrvId,
    required this.cargoElectoral,
    required this.votosBlancos,
    required this.votosNulos,
    required this.totalSufragantes,
    this.fotoUrl,
    required this.latitud,
    required this.longitud,
    required this.synced,
    this.syncError,
    required this.creadoPor,
    this.editadoPor,
    this.fechaEdicion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['jrv_id'] = Variable<String>(jrvId);
    map['cargo_electoral'] = Variable<String>(cargoElectoral);
    map['votos_blancos'] = Variable<int>(votosBlancos);
    map['votos_nulos'] = Variable<int>(votosNulos);
    map['total_sufragantes'] = Variable<int>(totalSufragantes);
    if (!nullToAbsent || fotoUrl != null) {
      map['foto_url'] = Variable<String>(fotoUrl);
    }
    map['latitud'] = Variable<double>(latitud);
    map['longitud'] = Variable<double>(longitud);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['creado_por'] = Variable<String>(creadoPor);
    if (!nullToAbsent || editadoPor != null) {
      map['editado_por'] = Variable<String>(editadoPor);
    }
    if (!nullToAbsent || fechaEdicion != null) {
      map['fecha_edicion'] = Variable<DateTime>(fechaEdicion);
    }
    return map;
  }

  ActasLocalCompanion toCompanion(bool nullToAbsent) {
    return ActasLocalCompanion(
      id: Value(id),
      jrvId: Value(jrvId),
      cargoElectoral: Value(cargoElectoral),
      votosBlancos: Value(votosBlancos),
      votosNulos: Value(votosNulos),
      totalSufragantes: Value(totalSufragantes),
      fotoUrl: fotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoUrl),
      latitud: Value(latitud),
      longitud: Value(longitud),
      synced: Value(synced),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      creadoPor: Value(creadoPor),
      editadoPor: editadoPor == null && nullToAbsent
          ? const Value.absent()
          : Value(editadoPor),
      fechaEdicion: fechaEdicion == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaEdicion),
    );
  }

  factory ActasLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActasLocalData(
      id: serializer.fromJson<String>(json['id']),
      jrvId: serializer.fromJson<String>(json['jrvId']),
      cargoElectoral: serializer.fromJson<String>(json['cargoElectoral']),
      votosBlancos: serializer.fromJson<int>(json['votosBlancos']),
      votosNulos: serializer.fromJson<int>(json['votosNulos']),
      totalSufragantes: serializer.fromJson<int>(json['totalSufragantes']),
      fotoUrl: serializer.fromJson<String?>(json['fotoUrl']),
      latitud: serializer.fromJson<double>(json['latitud']),
      longitud: serializer.fromJson<double>(json['longitud']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      creadoPor: serializer.fromJson<String>(json['creadoPor']),
      editadoPor: serializer.fromJson<String?>(json['editadoPor']),
      fechaEdicion: serializer.fromJson<DateTime?>(json['fechaEdicion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jrvId': serializer.toJson<String>(jrvId),
      'cargoElectoral': serializer.toJson<String>(cargoElectoral),
      'votosBlancos': serializer.toJson<int>(votosBlancos),
      'votosNulos': serializer.toJson<int>(votosNulos),
      'totalSufragantes': serializer.toJson<int>(totalSufragantes),
      'fotoUrl': serializer.toJson<String?>(fotoUrl),
      'latitud': serializer.toJson<double>(latitud),
      'longitud': serializer.toJson<double>(longitud),
      'synced': serializer.toJson<bool>(synced),
      'syncError': serializer.toJson<String?>(syncError),
      'creadoPor': serializer.toJson<String>(creadoPor),
      'editadoPor': serializer.toJson<String?>(editadoPor),
      'fechaEdicion': serializer.toJson<DateTime?>(fechaEdicion),
    };
  }

  ActasLocalData copyWith({
    String? id,
    String? jrvId,
    String? cargoElectoral,
    int? votosBlancos,
    int? votosNulos,
    int? totalSufragantes,
    Value<String?> fotoUrl = const Value.absent(),
    double? latitud,
    double? longitud,
    bool? synced,
    Value<String?> syncError = const Value.absent(),
    String? creadoPor,
    Value<String?> editadoPor = const Value.absent(),
    Value<DateTime?> fechaEdicion = const Value.absent(),
  }) => ActasLocalData(
    id: id ?? this.id,
    jrvId: jrvId ?? this.jrvId,
    cargoElectoral: cargoElectoral ?? this.cargoElectoral,
    votosBlancos: votosBlancos ?? this.votosBlancos,
    votosNulos: votosNulos ?? this.votosNulos,
    totalSufragantes: totalSufragantes ?? this.totalSufragantes,
    fotoUrl: fotoUrl.present ? fotoUrl.value : this.fotoUrl,
    latitud: latitud ?? this.latitud,
    longitud: longitud ?? this.longitud,
    synced: synced ?? this.synced,
    syncError: syncError.present ? syncError.value : this.syncError,
    creadoPor: creadoPor ?? this.creadoPor,
    editadoPor: editadoPor.present ? editadoPor.value : this.editadoPor,
    fechaEdicion: fechaEdicion.present ? fechaEdicion.value : this.fechaEdicion,
  );
  ActasLocalData copyWithCompanion(ActasLocalCompanion data) {
    return ActasLocalData(
      id: data.id.present ? data.id.value : this.id,
      jrvId: data.jrvId.present ? data.jrvId.value : this.jrvId,
      cargoElectoral: data.cargoElectoral.present
          ? data.cargoElectoral.value
          : this.cargoElectoral,
      votosBlancos: data.votosBlancos.present
          ? data.votosBlancos.value
          : this.votosBlancos,
      votosNulos: data.votosNulos.present
          ? data.votosNulos.value
          : this.votosNulos,
      totalSufragantes: data.totalSufragantes.present
          ? data.totalSufragantes.value
          : this.totalSufragantes,
      fotoUrl: data.fotoUrl.present ? data.fotoUrl.value : this.fotoUrl,
      latitud: data.latitud.present ? data.latitud.value : this.latitud,
      longitud: data.longitud.present ? data.longitud.value : this.longitud,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      creadoPor: data.creadoPor.present ? data.creadoPor.value : this.creadoPor,
      editadoPor: data.editadoPor.present
          ? data.editadoPor.value
          : this.editadoPor,
      fechaEdicion: data.fechaEdicion.present
          ? data.fechaEdicion.value
          : this.fechaEdicion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActasLocalData(')
          ..write('id: $id, ')
          ..write('jrvId: $jrvId, ')
          ..write('cargoElectoral: $cargoElectoral, ')
          ..write('votosBlancos: $votosBlancos, ')
          ..write('votosNulos: $votosNulos, ')
          ..write('totalSufragantes: $totalSufragantes, ')
          ..write('fotoUrl: $fotoUrl, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('synced: $synced, ')
          ..write('syncError: $syncError, ')
          ..write('creadoPor: $creadoPor, ')
          ..write('editadoPor: $editadoPor, ')
          ..write('fechaEdicion: $fechaEdicion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jrvId,
    cargoElectoral,
    votosBlancos,
    votosNulos,
    totalSufragantes,
    fotoUrl,
    latitud,
    longitud,
    synced,
    syncError,
    creadoPor,
    editadoPor,
    fechaEdicion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActasLocalData &&
          other.id == this.id &&
          other.jrvId == this.jrvId &&
          other.cargoElectoral == this.cargoElectoral &&
          other.votosBlancos == this.votosBlancos &&
          other.votosNulos == this.votosNulos &&
          other.totalSufragantes == this.totalSufragantes &&
          other.fotoUrl == this.fotoUrl &&
          other.latitud == this.latitud &&
          other.longitud == this.longitud &&
          other.synced == this.synced &&
          other.syncError == this.syncError &&
          other.creadoPor == this.creadoPor &&
          other.editadoPor == this.editadoPor &&
          other.fechaEdicion == this.fechaEdicion);
}

class ActasLocalCompanion extends UpdateCompanion<ActasLocalData> {
  final Value<String> id;
  final Value<String> jrvId;
  final Value<String> cargoElectoral;
  final Value<int> votosBlancos;
  final Value<int> votosNulos;
  final Value<int> totalSufragantes;
  final Value<String?> fotoUrl;
  final Value<double> latitud;
  final Value<double> longitud;
  final Value<bool> synced;
  final Value<String?> syncError;
  final Value<String> creadoPor;
  final Value<String?> editadoPor;
  final Value<DateTime?> fechaEdicion;
  final Value<int> rowid;
  const ActasLocalCompanion({
    this.id = const Value.absent(),
    this.jrvId = const Value.absent(),
    this.cargoElectoral = const Value.absent(),
    this.votosBlancos = const Value.absent(),
    this.votosNulos = const Value.absent(),
    this.totalSufragantes = const Value.absent(),
    this.fotoUrl = const Value.absent(),
    this.latitud = const Value.absent(),
    this.longitud = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncError = const Value.absent(),
    this.creadoPor = const Value.absent(),
    this.editadoPor = const Value.absent(),
    this.fechaEdicion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActasLocalCompanion.insert({
    required String id,
    required String jrvId,
    required String cargoElectoral,
    required int votosBlancos,
    required int votosNulos,
    required int totalSufragantes,
    this.fotoUrl = const Value.absent(),
    required double latitud,
    required double longitud,
    this.synced = const Value.absent(),
    this.syncError = const Value.absent(),
    required String creadoPor,
    this.editadoPor = const Value.absent(),
    this.fechaEdicion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jrvId = Value(jrvId),
       cargoElectoral = Value(cargoElectoral),
       votosBlancos = Value(votosBlancos),
       votosNulos = Value(votosNulos),
       totalSufragantes = Value(totalSufragantes),
       latitud = Value(latitud),
       longitud = Value(longitud),
       creadoPor = Value(creadoPor);
  static Insertable<ActasLocalData> custom({
    Expression<String>? id,
    Expression<String>? jrvId,
    Expression<String>? cargoElectoral,
    Expression<int>? votosBlancos,
    Expression<int>? votosNulos,
    Expression<int>? totalSufragantes,
    Expression<String>? fotoUrl,
    Expression<double>? latitud,
    Expression<double>? longitud,
    Expression<bool>? synced,
    Expression<String>? syncError,
    Expression<String>? creadoPor,
    Expression<String>? editadoPor,
    Expression<DateTime>? fechaEdicion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jrvId != null) 'jrv_id': jrvId,
      if (cargoElectoral != null) 'cargo_electoral': cargoElectoral,
      if (votosBlancos != null) 'votos_blancos': votosBlancos,
      if (votosNulos != null) 'votos_nulos': votosNulos,
      if (totalSufragantes != null) 'total_sufragantes': totalSufragantes,
      if (fotoUrl != null) 'foto_url': fotoUrl,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (synced != null) 'synced': synced,
      if (syncError != null) 'sync_error': syncError,
      if (creadoPor != null) 'creado_por': creadoPor,
      if (editadoPor != null) 'editado_por': editadoPor,
      if (fechaEdicion != null) 'fecha_edicion': fechaEdicion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActasLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? jrvId,
    Value<String>? cargoElectoral,
    Value<int>? votosBlancos,
    Value<int>? votosNulos,
    Value<int>? totalSufragantes,
    Value<String?>? fotoUrl,
    Value<double>? latitud,
    Value<double>? longitud,
    Value<bool>? synced,
    Value<String?>? syncError,
    Value<String>? creadoPor,
    Value<String?>? editadoPor,
    Value<DateTime?>? fechaEdicion,
    Value<int>? rowid,
  }) {
    return ActasLocalCompanion(
      id: id ?? this.id,
      jrvId: jrvId ?? this.jrvId,
      cargoElectoral: cargoElectoral ?? this.cargoElectoral,
      votosBlancos: votosBlancos ?? this.votosBlancos,
      votosNulos: votosNulos ?? this.votosNulos,
      totalSufragantes: totalSufragantes ?? this.totalSufragantes,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      synced: synced ?? this.synced,
      syncError: syncError ?? this.syncError,
      creadoPor: creadoPor ?? this.creadoPor,
      editadoPor: editadoPor ?? this.editadoPor,
      fechaEdicion: fechaEdicion ?? this.fechaEdicion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jrvId.present) {
      map['jrv_id'] = Variable<String>(jrvId.value);
    }
    if (cargoElectoral.present) {
      map['cargo_electoral'] = Variable<String>(cargoElectoral.value);
    }
    if (votosBlancos.present) {
      map['votos_blancos'] = Variable<int>(votosBlancos.value);
    }
    if (votosNulos.present) {
      map['votos_nulos'] = Variable<int>(votosNulos.value);
    }
    if (totalSufragantes.present) {
      map['total_sufragantes'] = Variable<int>(totalSufragantes.value);
    }
    if (fotoUrl.present) {
      map['foto_url'] = Variable<String>(fotoUrl.value);
    }
    if (latitud.present) {
      map['latitud'] = Variable<double>(latitud.value);
    }
    if (longitud.present) {
      map['longitud'] = Variable<double>(longitud.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (creadoPor.present) {
      map['creado_por'] = Variable<String>(creadoPor.value);
    }
    if (editadoPor.present) {
      map['editado_por'] = Variable<String>(editadoPor.value);
    }
    if (fechaEdicion.present) {
      map['fecha_edicion'] = Variable<DateTime>(fechaEdicion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActasLocalCompanion(')
          ..write('id: $id, ')
          ..write('jrvId: $jrvId, ')
          ..write('cargoElectoral: $cargoElectoral, ')
          ..write('votosBlancos: $votosBlancos, ')
          ..write('votosNulos: $votosNulos, ')
          ..write('totalSufragantes: $totalSufragantes, ')
          ..write('fotoUrl: $fotoUrl, ')
          ..write('latitud: $latitud, ')
          ..write('longitud: $longitud, ')
          ..write('synced: $synced, ')
          ..write('syncError: $syncError, ')
          ..write('creadoPor: $creadoPor, ')
          ..write('editadoPor: $editadoPor, ')
          ..write('fechaEdicion: $fechaEdicion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    operation,
    payload,
    timestamp,
    attempts,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String entityType;
  final String operation;
  final String payload;
  final DateTime timestamp;
  final int attempts;
  final String status;
  const SyncQueueData({
    required this.id,
    required this.entityType,
    required this.operation,
    required this.payload,
    required this.timestamp,
    required this.attempts,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['attempts'] = Variable<int>(attempts);
    map['status'] = Variable<String>(status);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      operation: Value(operation),
      payload: Value(payload),
      timestamp: Value(timestamp),
      attempts: Value(attempts),
      status: Value(status),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      attempts: serializer.fromJson<int>(json['attempts']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'attempts': serializer.toJson<int>(attempts),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? entityType,
    String? operation,
    String? payload,
    DateTime? timestamp,
    int? attempts,
    String? status,
  }) => SyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    timestamp: timestamp ?? this.timestamp,
    attempts: attempts ?? this.attempts,
    status: status ?? this.status,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp, ')
          ..write('attempts: $attempts, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    operation,
    payload,
    timestamp,
    attempts,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.timestamp == this.timestamp &&
          other.attempts == this.attempts &&
          other.status == this.status);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> timestamp;
  final Value<int> attempts;
  final Value<String> status;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.attempts = const Value.absent(),
    this.status = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String operation,
    required String payload,
    this.timestamp = const Value.absent(),
    this.attempts = const Value.absent(),
    this.status = const Value.absent(),
  }) : entityType = Value(entityType),
       operation = Value(operation),
       payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? timestamp,
    Expression<int>? attempts,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (timestamp != null) 'timestamp': timestamp,
      if (attempts != null) 'attempts': attempts,
      if (status != null) 'status': status,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? timestamp,
    Value<int>? attempts,
    Value<String>? status,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      attempts: attempts ?? this.attempts,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp, ')
          ..write('attempts: $attempts, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $ProvinciasLocalTable extends ProvinciasLocal
    with TableInfo<$ProvinciasLocalTable, ProvinciasLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvinciasLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provincias_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProvinciasLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProvinciasLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProvinciasLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $ProvinciasLocalTable createAlias(String alias) {
    return $ProvinciasLocalTable(attachedDatabase, alias);
  }
}

class ProvinciasLocalData extends DataClass
    implements Insertable<ProvinciasLocalData> {
  /// ID del documento de Appwrite.
  final String id;
  final String nombre;
  const ProvinciasLocalData({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  ProvinciasLocalCompanion toCompanion(bool nullToAbsent) {
    return ProvinciasLocalCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory ProvinciasLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProvinciasLocalData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  ProvinciasLocalData copyWith({String? id, String? nombre}) =>
      ProvinciasLocalData(id: id ?? this.id, nombre: nombre ?? this.nombre);
  ProvinciasLocalData copyWithCompanion(ProvinciasLocalCompanion data) {
    return ProvinciasLocalData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProvinciasLocalData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProvinciasLocalData &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class ProvinciasLocalCompanion extends UpdateCompanion<ProvinciasLocalData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<int> rowid;
  const ProvinciasLocalCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProvinciasLocalCompanion.insert({
    required String id,
    required String nombre,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre);
  static Insertable<ProvinciasLocalData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProvinciasLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<int>? rowid,
  }) {
    return ProvinciasLocalCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvinciasLocalCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CantonesLocalTable extends CantonesLocal
    with TableInfo<$CantonesLocalTable, CantonesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CantonesLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provinciaIdMeta = const VerificationMeta(
    'provinciaId',
  );
  @override
  late final GeneratedColumn<String> provinciaId = GeneratedColumn<String>(
    'provincia_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, provinciaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cantones_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<CantonesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('provincia_id')) {
      context.handle(
        _provinciaIdMeta,
        provinciaId.isAcceptableOrUnknown(
          data['provincia_id']!,
          _provinciaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_provinciaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CantonesLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CantonesLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      provinciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provincia_id'],
      )!,
    );
  }

  @override
  $CantonesLocalTable createAlias(String alias) {
    return $CantonesLocalTable(attachedDatabase, alias);
  }
}

class CantonesLocalData extends DataClass
    implements Insertable<CantonesLocalData> {
  final String id;
  final String nombre;
  final String provinciaId;
  const CantonesLocalData({
    required this.id,
    required this.nombre,
    required this.provinciaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['provincia_id'] = Variable<String>(provinciaId);
    return map;
  }

  CantonesLocalCompanion toCompanion(bool nullToAbsent) {
    return CantonesLocalCompanion(
      id: Value(id),
      nombre: Value(nombre),
      provinciaId: Value(provinciaId),
    );
  }

  factory CantonesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CantonesLocalData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      provinciaId: serializer.fromJson<String>(json['provinciaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'provinciaId': serializer.toJson<String>(provinciaId),
    };
  }

  CantonesLocalData copyWith({
    String? id,
    String? nombre,
    String? provinciaId,
  }) => CantonesLocalData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    provinciaId: provinciaId ?? this.provinciaId,
  );
  CantonesLocalData copyWithCompanion(CantonesLocalCompanion data) {
    return CantonesLocalData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      provinciaId: data.provinciaId.present
          ? data.provinciaId.value
          : this.provinciaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CantonesLocalData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('provinciaId: $provinciaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, provinciaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CantonesLocalData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.provinciaId == this.provinciaId);
}

class CantonesLocalCompanion extends UpdateCompanion<CantonesLocalData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> provinciaId;
  final Value<int> rowid;
  const CantonesLocalCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.provinciaId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CantonesLocalCompanion.insert({
    required String id,
    required String nombre,
    required String provinciaId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       provinciaId = Value(provinciaId);
  static Insertable<CantonesLocalData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? provinciaId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (provinciaId != null) 'provincia_id': provinciaId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CantonesLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? provinciaId,
    Value<int>? rowid,
  }) {
    return CantonesLocalCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      provinciaId: provinciaId ?? this.provinciaId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (provinciaId.present) {
      map['provincia_id'] = Variable<String>(provinciaId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CantonesLocalCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('provinciaId: $provinciaId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParroquiasLocalTable extends ParroquiasLocal
    with TableInfo<$ParroquiasLocalTable, ParroquiasLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParroquiasLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantonIdMeta = const VerificationMeta(
    'cantonId',
  );
  @override
  late final GeneratedColumn<String> cantonId = GeneratedColumn<String>(
    'canton_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, cantonId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parroquias_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParroquiasLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('canton_id')) {
      context.handle(
        _cantonIdMeta,
        cantonId.isAcceptableOrUnknown(data['canton_id']!, _cantonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cantonIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParroquiasLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParroquiasLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      cantonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canton_id'],
      )!,
    );
  }

  @override
  $ParroquiasLocalTable createAlias(String alias) {
    return $ParroquiasLocalTable(attachedDatabase, alias);
  }
}

class ParroquiasLocalData extends DataClass
    implements Insertable<ParroquiasLocalData> {
  final String id;
  final String nombre;
  final String cantonId;
  const ParroquiasLocalData({
    required this.id,
    required this.nombre,
    required this.cantonId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['canton_id'] = Variable<String>(cantonId);
    return map;
  }

  ParroquiasLocalCompanion toCompanion(bool nullToAbsent) {
    return ParroquiasLocalCompanion(
      id: Value(id),
      nombre: Value(nombre),
      cantonId: Value(cantonId),
    );
  }

  factory ParroquiasLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParroquiasLocalData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cantonId: serializer.fromJson<String>(json['cantonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'cantonId': serializer.toJson<String>(cantonId),
    };
  }

  ParroquiasLocalData copyWith({
    String? id,
    String? nombre,
    String? cantonId,
  }) => ParroquiasLocalData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    cantonId: cantonId ?? this.cantonId,
  );
  ParroquiasLocalData copyWithCompanion(ParroquiasLocalCompanion data) {
    return ParroquiasLocalData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cantonId: data.cantonId.present ? data.cantonId.value : this.cantonId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParroquiasLocalData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantonId: $cantonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, cantonId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParroquiasLocalData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.cantonId == this.cantonId);
}

class ParroquiasLocalCompanion extends UpdateCompanion<ParroquiasLocalData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> cantonId;
  final Value<int> rowid;
  const ParroquiasLocalCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cantonId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParroquiasLocalCompanion.insert({
    required String id,
    required String nombre,
    required String cantonId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       cantonId = Value(cantonId);
  static Insertable<ParroquiasLocalData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? cantonId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (cantonId != null) 'canton_id': cantonId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParroquiasLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? cantonId,
    Value<int>? rowid,
  }) {
    return ParroquiasLocalCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantonId: cantonId ?? this.cantonId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cantonId.present) {
      map['canton_id'] = Variable<String>(cantonId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParroquiasLocalCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantonId: $cantonId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecintosLocalTable extends RecintosLocal
    with TableInfo<$RecintosLocalTable, RecintosLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecintosLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parroquiaIdMeta = const VerificationMeta(
    'parroquiaId',
  );
  @override
  late final GeneratedColumn<String> parroquiaId = GeneratedColumn<String>(
    'parroquia_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latRefMeta = const VerificationMeta('latRef');
  @override
  late final GeneratedColumn<double> latRef = GeneratedColumn<double>(
    'lat_ref',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lonRefMeta = const VerificationMeta('lonRef');
  @override
  late final GeneratedColumn<double> lonRef = GeneratedColumn<double>(
    'lon_ref',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coordinadorIdMeta = const VerificationMeta(
    'coordinadorId',
  );
  @override
  late final GeneratedColumn<String> coordinadorId = GeneratedColumn<String>(
    'coordinador_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    parroquiaId,
    direccion,
    latRef,
    lonRef,
    coordinadorId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recintos_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecintosLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('parroquia_id')) {
      context.handle(
        _parroquiaIdMeta,
        parroquiaId.isAcceptableOrUnknown(
          data['parroquia_id']!,
          _parroquiaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parroquiaIdMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('lat_ref')) {
      context.handle(
        _latRefMeta,
        latRef.isAcceptableOrUnknown(data['lat_ref']!, _latRefMeta),
      );
    }
    if (data.containsKey('lon_ref')) {
      context.handle(
        _lonRefMeta,
        lonRef.isAcceptableOrUnknown(data['lon_ref']!, _lonRefMeta),
      );
    }
    if (data.containsKey('coordinador_id')) {
      context.handle(
        _coordinadorIdMeta,
        coordinadorId.isAcceptableOrUnknown(
          data['coordinador_id']!,
          _coordinadorIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecintosLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecintosLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      parroquiaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parroquia_id'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      latRef: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat_ref'],
      ),
      lonRef: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon_ref'],
      ),
      coordinadorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coordinador_id'],
      ),
    );
  }

  @override
  $RecintosLocalTable createAlias(String alias) {
    return $RecintosLocalTable(attachedDatabase, alias);
  }
}

class RecintosLocalData extends DataClass
    implements Insertable<RecintosLocalData> {
  final String id;
  final String nombre;
  final String parroquiaId;
  final String direccion;
  final double? latRef;
  final double? lonRef;
  final String? coordinadorId;
  const RecintosLocalData({
    required this.id,
    required this.nombre,
    required this.parroquiaId,
    required this.direccion,
    this.latRef,
    this.lonRef,
    this.coordinadorId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['parroquia_id'] = Variable<String>(parroquiaId);
    map['direccion'] = Variable<String>(direccion);
    if (!nullToAbsent || latRef != null) {
      map['lat_ref'] = Variable<double>(latRef);
    }
    if (!nullToAbsent || lonRef != null) {
      map['lon_ref'] = Variable<double>(lonRef);
    }
    if (!nullToAbsent || coordinadorId != null) {
      map['coordinador_id'] = Variable<String>(coordinadorId);
    }
    return map;
  }

  RecintosLocalCompanion toCompanion(bool nullToAbsent) {
    return RecintosLocalCompanion(
      id: Value(id),
      nombre: Value(nombre),
      parroquiaId: Value(parroquiaId),
      direccion: Value(direccion),
      latRef: latRef == null && nullToAbsent
          ? const Value.absent()
          : Value(latRef),
      lonRef: lonRef == null && nullToAbsent
          ? const Value.absent()
          : Value(lonRef),
      coordinadorId: coordinadorId == null && nullToAbsent
          ? const Value.absent()
          : Value(coordinadorId),
    );
  }

  factory RecintosLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecintosLocalData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      parroquiaId: serializer.fromJson<String>(json['parroquiaId']),
      direccion: serializer.fromJson<String>(json['direccion']),
      latRef: serializer.fromJson<double?>(json['latRef']),
      lonRef: serializer.fromJson<double?>(json['lonRef']),
      coordinadorId: serializer.fromJson<String?>(json['coordinadorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'parroquiaId': serializer.toJson<String>(parroquiaId),
      'direccion': serializer.toJson<String>(direccion),
      'latRef': serializer.toJson<double?>(latRef),
      'lonRef': serializer.toJson<double?>(lonRef),
      'coordinadorId': serializer.toJson<String?>(coordinadorId),
    };
  }

  RecintosLocalData copyWith({
    String? id,
    String? nombre,
    String? parroquiaId,
    String? direccion,
    Value<double?> latRef = const Value.absent(),
    Value<double?> lonRef = const Value.absent(),
    Value<String?> coordinadorId = const Value.absent(),
  }) => RecintosLocalData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    parroquiaId: parroquiaId ?? this.parroquiaId,
    direccion: direccion ?? this.direccion,
    latRef: latRef.present ? latRef.value : this.latRef,
    lonRef: lonRef.present ? lonRef.value : this.lonRef,
    coordinadorId: coordinadorId.present
        ? coordinadorId.value
        : this.coordinadorId,
  );
  RecintosLocalData copyWithCompanion(RecintosLocalCompanion data) {
    return RecintosLocalData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      parroquiaId: data.parroquiaId.present
          ? data.parroquiaId.value
          : this.parroquiaId,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      latRef: data.latRef.present ? data.latRef.value : this.latRef,
      lonRef: data.lonRef.present ? data.lonRef.value : this.lonRef,
      coordinadorId: data.coordinadorId.present
          ? data.coordinadorId.value
          : this.coordinadorId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecintosLocalData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('parroquiaId: $parroquiaId, ')
          ..write('direccion: $direccion, ')
          ..write('latRef: $latRef, ')
          ..write('lonRef: $lonRef, ')
          ..write('coordinadorId: $coordinadorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    parroquiaId,
    direccion,
    latRef,
    lonRef,
    coordinadorId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecintosLocalData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.parroquiaId == this.parroquiaId &&
          other.direccion == this.direccion &&
          other.latRef == this.latRef &&
          other.lonRef == this.lonRef &&
          other.coordinadorId == this.coordinadorId);
}

class RecintosLocalCompanion extends UpdateCompanion<RecintosLocalData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> parroquiaId;
  final Value<String> direccion;
  final Value<double?> latRef;
  final Value<double?> lonRef;
  final Value<String?> coordinadorId;
  final Value<int> rowid;
  const RecintosLocalCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.parroquiaId = const Value.absent(),
    this.direccion = const Value.absent(),
    this.latRef = const Value.absent(),
    this.lonRef = const Value.absent(),
    this.coordinadorId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecintosLocalCompanion.insert({
    required String id,
    required String nombre,
    required String parroquiaId,
    required String direccion,
    this.latRef = const Value.absent(),
    this.lonRef = const Value.absent(),
    this.coordinadorId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       parroquiaId = Value(parroquiaId),
       direccion = Value(direccion);
  static Insertable<RecintosLocalData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? parroquiaId,
    Expression<String>? direccion,
    Expression<double>? latRef,
    Expression<double>? lonRef,
    Expression<String>? coordinadorId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (parroquiaId != null) 'parroquia_id': parroquiaId,
      if (direccion != null) 'direccion': direccion,
      if (latRef != null) 'lat_ref': latRef,
      if (lonRef != null) 'lon_ref': lonRef,
      if (coordinadorId != null) 'coordinador_id': coordinadorId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecintosLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? parroquiaId,
    Value<String>? direccion,
    Value<double?>? latRef,
    Value<double?>? lonRef,
    Value<String?>? coordinadorId,
    Value<int>? rowid,
  }) {
    return RecintosLocalCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      parroquiaId: parroquiaId ?? this.parroquiaId,
      direccion: direccion ?? this.direccion,
      latRef: latRef ?? this.latRef,
      lonRef: lonRef ?? this.lonRef,
      coordinadorId: coordinadorId ?? this.coordinadorId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (parroquiaId.present) {
      map['parroquia_id'] = Variable<String>(parroquiaId.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (latRef.present) {
      map['lat_ref'] = Variable<double>(latRef.value);
    }
    if (lonRef.present) {
      map['lon_ref'] = Variable<double>(lonRef.value);
    }
    if (coordinadorId.present) {
      map['coordinador_id'] = Variable<String>(coordinadorId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecintosLocalCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('parroquiaId: $parroquiaId, ')
          ..write('direccion: $direccion, ')
          ..write('latRef: $latRef, ')
          ..write('lonRef: $lonRef, ')
          ..write('coordinadorId: $coordinadorId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JrvLocalTable extends JrvLocal
    with TableInfo<$JrvLocalTable, JrvLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JrvLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recintoIdMeta = const VerificationMeta(
    'recintoId',
  );
  @override
  late final GeneratedColumn<String> recintoId = GeneratedColumn<String>(
    'recinto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, codigo, recintoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jrv_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<JrvLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('recinto_id')) {
      context.handle(
        _recintoIdMeta,
        recintoId.isAcceptableOrUnknown(data['recinto_id']!, _recintoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recintoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JrvLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JrvLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      recintoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recinto_id'],
      )!,
    );
  }

  @override
  $JrvLocalTable createAlias(String alias) {
    return $JrvLocalTable(attachedDatabase, alias);
  }
}

class JrvLocalData extends DataClass implements Insertable<JrvLocalData> {
  final String id;
  final String codigo;
  final String recintoId;
  const JrvLocalData({
    required this.id,
    required this.codigo,
    required this.recintoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['codigo'] = Variable<String>(codigo);
    map['recinto_id'] = Variable<String>(recintoId);
    return map;
  }

  JrvLocalCompanion toCompanion(bool nullToAbsent) {
    return JrvLocalCompanion(
      id: Value(id),
      codigo: Value(codigo),
      recintoId: Value(recintoId),
    );
  }

  factory JrvLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JrvLocalData(
      id: serializer.fromJson<String>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      recintoId: serializer.fromJson<String>(json['recintoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'codigo': serializer.toJson<String>(codigo),
      'recintoId': serializer.toJson<String>(recintoId),
    };
  }

  JrvLocalData copyWith({String? id, String? codigo, String? recintoId}) =>
      JrvLocalData(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        recintoId: recintoId ?? this.recintoId,
      );
  JrvLocalData copyWithCompanion(JrvLocalCompanion data) {
    return JrvLocalData(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      recintoId: data.recintoId.present ? data.recintoId.value : this.recintoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JrvLocalData(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('recintoId: $recintoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, codigo, recintoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JrvLocalData &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.recintoId == this.recintoId);
}

class JrvLocalCompanion extends UpdateCompanion<JrvLocalData> {
  final Value<String> id;
  final Value<String> codigo;
  final Value<String> recintoId;
  final Value<int> rowid;
  const JrvLocalCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.recintoId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JrvLocalCompanion.insert({
    required String id,
    required String codigo,
    required String recintoId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       codigo = Value(codigo),
       recintoId = Value(recintoId);
  static Insertable<JrvLocalData> custom({
    Expression<String>? id,
    Expression<String>? codigo,
    Expression<String>? recintoId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (recintoId != null) 'recinto_id': recintoId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JrvLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? codigo,
    Value<String>? recintoId,
    Value<int>? rowid,
  }) {
    return JrvLocalCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      recintoId: recintoId ?? this.recintoId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (recintoId.present) {
      map['recinto_id'] = Variable<String>(recintoId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JrvLocalCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('recintoId: $recintoId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrganizacionesLocalTable extends OrganizacionesLocal
    with TableInfo<$OrganizacionesLocalTable, OrganizacionesLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizacionesLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cargoMeta = const VerificationMeta('cargo');
  @override
  late final GeneratedColumn<String> cargo = GeneratedColumn<String>(
    'cargo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listaMeta = const VerificationMeta('lista');
  @override
  late final GeneratedColumn<int> lista = GeneratedColumn<int>(
    'lista',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _candidatoPrincipalMeta =
      const VerificationMeta('candidatoPrincipal');
  @override
  late final GeneratedColumn<String> candidatoPrincipal =
      GeneratedColumn<String>(
        'candidato_principal',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _candidatoSecundarioMeta =
      const VerificationMeta('candidatoSecundario');
  @override
  late final GeneratedColumn<String> candidatoSecundario =
      GeneratedColumn<String>(
        'candidato_secundario',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    cargo,
    lista,
    candidatoPrincipal,
    candidatoSecundario,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organizaciones_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganizacionesLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('cargo')) {
      context.handle(
        _cargoMeta,
        cargo.isAcceptableOrUnknown(data['cargo']!, _cargoMeta),
      );
    } else if (isInserting) {
      context.missing(_cargoMeta);
    }
    if (data.containsKey('lista')) {
      context.handle(
        _listaMeta,
        lista.isAcceptableOrUnknown(data['lista']!, _listaMeta),
      );
    }
    if (data.containsKey('candidato_principal')) {
      context.handle(
        _candidatoPrincipalMeta,
        candidatoPrincipal.isAcceptableOrUnknown(
          data['candidato_principal']!,
          _candidatoPrincipalMeta,
        ),
      );
    }
    if (data.containsKey('candidato_secundario')) {
      context.handle(
        _candidatoSecundarioMeta,
        candidatoSecundario.isAcceptableOrUnknown(
          data['candidato_secundario']!,
          _candidatoSecundarioMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrganizacionesLocalData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganizacionesLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      cargo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cargo'],
      )!,
      lista: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lista'],
      ),
      candidatoPrincipal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidato_principal'],
      ),
      candidatoSecundario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidato_secundario'],
      ),
    );
  }

  @override
  $OrganizacionesLocalTable createAlias(String alias) {
    return $OrganizacionesLocalTable(attachedDatabase, alias);
  }
}

class OrganizacionesLocalData extends DataClass
    implements Insertable<OrganizacionesLocalData> {
  final String id;
  final String nombre;

  /// Cargo electoral: 'alcalde' o 'prefecto'.
  final String cargo;
  final int? lista;
  final String? candidatoPrincipal;
  final String? candidatoSecundario;
  const OrganizacionesLocalData({
    required this.id,
    required this.nombre,
    required this.cargo,
    this.lista,
    this.candidatoPrincipal,
    this.candidatoSecundario,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['cargo'] = Variable<String>(cargo);
    if (!nullToAbsent || lista != null) {
      map['lista'] = Variable<int>(lista);
    }
    if (!nullToAbsent || candidatoPrincipal != null) {
      map['candidato_principal'] = Variable<String>(candidatoPrincipal);
    }
    if (!nullToAbsent || candidatoSecundario != null) {
      map['candidato_secundario'] = Variable<String>(candidatoSecundario);
    }
    return map;
  }

  OrganizacionesLocalCompanion toCompanion(bool nullToAbsent) {
    return OrganizacionesLocalCompanion(
      id: Value(id),
      nombre: Value(nombre),
      cargo: Value(cargo),
      lista: lista == null && nullToAbsent
          ? const Value.absent()
          : Value(lista),
      candidatoPrincipal: candidatoPrincipal == null && nullToAbsent
          ? const Value.absent()
          : Value(candidatoPrincipal),
      candidatoSecundario: candidatoSecundario == null && nullToAbsent
          ? const Value.absent()
          : Value(candidatoSecundario),
    );
  }

  factory OrganizacionesLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganizacionesLocalData(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cargo: serializer.fromJson<String>(json['cargo']),
      lista: serializer.fromJson<int?>(json['lista']),
      candidatoPrincipal: serializer.fromJson<String?>(
        json['candidatoPrincipal'],
      ),
      candidatoSecundario: serializer.fromJson<String?>(
        json['candidatoSecundario'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'cargo': serializer.toJson<String>(cargo),
      'lista': serializer.toJson<int?>(lista),
      'candidatoPrincipal': serializer.toJson<String?>(candidatoPrincipal),
      'candidatoSecundario': serializer.toJson<String?>(candidatoSecundario),
    };
  }

  OrganizacionesLocalData copyWith({
    String? id,
    String? nombre,
    String? cargo,
    Value<int?> lista = const Value.absent(),
    Value<String?> candidatoPrincipal = const Value.absent(),
    Value<String?> candidatoSecundario = const Value.absent(),
  }) => OrganizacionesLocalData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    cargo: cargo ?? this.cargo,
    lista: lista.present ? lista.value : this.lista,
    candidatoPrincipal: candidatoPrincipal.present
        ? candidatoPrincipal.value
        : this.candidatoPrincipal,
    candidatoSecundario: candidatoSecundario.present
        ? candidatoSecundario.value
        : this.candidatoSecundario,
  );
  OrganizacionesLocalData copyWithCompanion(OrganizacionesLocalCompanion data) {
    return OrganizacionesLocalData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cargo: data.cargo.present ? data.cargo.value : this.cargo,
      lista: data.lista.present ? data.lista.value : this.lista,
      candidatoPrincipal: data.candidatoPrincipal.present
          ? data.candidatoPrincipal.value
          : this.candidatoPrincipal,
      candidatoSecundario: data.candidatoSecundario.present
          ? data.candidatoSecundario.value
          : this.candidatoSecundario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganizacionesLocalData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cargo: $cargo, ')
          ..write('lista: $lista, ')
          ..write('candidatoPrincipal: $candidatoPrincipal, ')
          ..write('candidatoSecundario: $candidatoSecundario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    cargo,
    lista,
    candidatoPrincipal,
    candidatoSecundario,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganizacionesLocalData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.cargo == this.cargo &&
          other.lista == this.lista &&
          other.candidatoPrincipal == this.candidatoPrincipal &&
          other.candidatoSecundario == this.candidatoSecundario);
}

class OrganizacionesLocalCompanion
    extends UpdateCompanion<OrganizacionesLocalData> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> cargo;
  final Value<int?> lista;
  final Value<String?> candidatoPrincipal;
  final Value<String?> candidatoSecundario;
  final Value<int> rowid;
  const OrganizacionesLocalCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cargo = const Value.absent(),
    this.lista = const Value.absent(),
    this.candidatoPrincipal = const Value.absent(),
    this.candidatoSecundario = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizacionesLocalCompanion.insert({
    required String id,
    required String nombre,
    required String cargo,
    this.lista = const Value.absent(),
    this.candidatoPrincipal = const Value.absent(),
    this.candidatoSecundario = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       cargo = Value(cargo);
  static Insertable<OrganizacionesLocalData> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? cargo,
    Expression<int>? lista,
    Expression<String>? candidatoPrincipal,
    Expression<String>? candidatoSecundario,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (cargo != null) 'cargo': cargo,
      if (lista != null) 'lista': lista,
      if (candidatoPrincipal != null) 'candidato_principal': candidatoPrincipal,
      if (candidatoSecundario != null)
        'candidato_secundario': candidatoSecundario,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizacionesLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? cargo,
    Value<int?>? lista,
    Value<String?>? candidatoPrincipal,
    Value<String?>? candidatoSecundario,
    Value<int>? rowid,
  }) {
    return OrganizacionesLocalCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cargo: cargo ?? this.cargo,
      lista: lista ?? this.lista,
      candidatoPrincipal: candidatoPrincipal ?? this.candidatoPrincipal,
      candidatoSecundario: candidatoSecundario ?? this.candidatoSecundario,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cargo.present) {
      map['cargo'] = Variable<String>(cargo.value);
    }
    if (lista.present) {
      map['lista'] = Variable<int>(lista.value);
    }
    if (candidatoPrincipal.present) {
      map['candidato_principal'] = Variable<String>(candidatoPrincipal.value);
    }
    if (candidatoSecundario.present) {
      map['candidato_secundario'] = Variable<String>(candidatoSecundario.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrganizacionesLocalCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cargo: $cargo, ')
          ..write('lista: $lista, ')
          ..write('candidatoPrincipal: $candidatoPrincipal, ')
          ..write('candidatoSecundario: $candidatoSecundario, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConfigSistemaLocalTable extends ConfigSistemaLocal
    with TableInfo<$ConfigSistemaLocalTable, ConfigSistemaLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigSistemaLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _claveMeta = const VerificationMeta('clave');
  @override
  late final GeneratedColumn<String> clave = GeneratedColumn<String>(
    'clave',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [clave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'config_sistema_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfigSistemaLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('clave')) {
      context.handle(
        _claveMeta,
        clave.isAcceptableOrUnknown(data['clave']!, _claveMeta),
      );
    } else if (isInserting) {
      context.missing(_claveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clave};
  @override
  ConfigSistemaLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigSistemaLocalData(
      clave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
    );
  }

  @override
  $ConfigSistemaLocalTable createAlias(String alias) {
    return $ConfigSistemaLocalTable(attachedDatabase, alias);
  }
}

class ConfigSistemaLocalData extends DataClass
    implements Insertable<ConfigSistemaLocalData> {
  /// Clave de configuración (ej. 'seed_ejecutado'). Actúa como PK.
  final String clave;
  final String valor;
  const ConfigSistemaLocalData({required this.clave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['clave'] = Variable<String>(clave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  ConfigSistemaLocalCompanion toCompanion(bool nullToAbsent) {
    return ConfigSistemaLocalCompanion(
      clave: Value(clave),
      valor: Value(valor),
    );
  }

  factory ConfigSistemaLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigSistemaLocalData(
      clave: serializer.fromJson<String>(json['clave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clave': serializer.toJson<String>(clave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  ConfigSistemaLocalData copyWith({String? clave, String? valor}) =>
      ConfigSistemaLocalData(
        clave: clave ?? this.clave,
        valor: valor ?? this.valor,
      );
  ConfigSistemaLocalData copyWithCompanion(ConfigSistemaLocalCompanion data) {
    return ConfigSistemaLocalData(
      clave: data.clave.present ? data.clave.value : this.clave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfigSistemaLocalData(')
          ..write('clave: $clave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigSistemaLocalData &&
          other.clave == this.clave &&
          other.valor == this.valor);
}

class ConfigSistemaLocalCompanion
    extends UpdateCompanion<ConfigSistemaLocalData> {
  final Value<String> clave;
  final Value<String> valor;
  final Value<int> rowid;
  const ConfigSistemaLocalCompanion({
    this.clave = const Value.absent(),
    this.valor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConfigSistemaLocalCompanion.insert({
    required String clave,
    required String valor,
    this.rowid = const Value.absent(),
  }) : clave = Value(clave),
       valor = Value(valor);
  static Insertable<ConfigSistemaLocalData> custom({
    Expression<String>? clave,
    Expression<String>? valor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clave != null) 'clave': clave,
      if (valor != null) 'valor': valor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConfigSistemaLocalCompanion copyWith({
    Value<String>? clave,
    Value<String>? valor,
    Value<int>? rowid,
  }) {
    return ConfigSistemaLocalCompanion(
      clave: clave ?? this.clave,
      valor: valor ?? this.valor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clave.present) {
      map['clave'] = Variable<String>(clave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigSistemaLocalCompanion(')
          ..write('clave: $clave, ')
          ..write('valor: $valor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActaDetalleLocalTable extends ActaDetalleLocal
    with TableInfo<$ActaDetalleLocalTable, ActaDetalleLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActaDetalleLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actaIdMeta = const VerificationMeta('actaId');
  @override
  late final GeneratedColumn<String> actaId = GeneratedColumn<String>(
    'acta_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizacionIdMeta = const VerificationMeta(
    'organizacionId',
  );
  @override
  late final GeneratedColumn<String> organizacionId = GeneratedColumn<String>(
    'organizacion_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreOrganizacionMeta =
      const VerificationMeta('nombreOrganizacion');
  @override
  late final GeneratedColumn<String> nombreOrganizacion =
      GeneratedColumn<String>(
        'nombre_organizacion',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _votosMeta = const VerificationMeta('votos');
  @override
  late final GeneratedColumn<int> votos = GeneratedColumn<int>(
    'votos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actaId,
    organizacionId,
    nombreOrganizacion,
    votos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'acta_detalle_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActaDetalleLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('acta_id')) {
      context.handle(
        _actaIdMeta,
        actaId.isAcceptableOrUnknown(data['acta_id']!, _actaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actaIdMeta);
    }
    if (data.containsKey('organizacion_id')) {
      context.handle(
        _organizacionIdMeta,
        organizacionId.isAcceptableOrUnknown(
          data['organizacion_id']!,
          _organizacionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizacionIdMeta);
    }
    if (data.containsKey('nombre_organizacion')) {
      context.handle(
        _nombreOrganizacionMeta,
        nombreOrganizacion.isAcceptableOrUnknown(
          data['nombre_organizacion']!,
          _nombreOrganizacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreOrganizacionMeta);
    }
    if (data.containsKey('votos')) {
      context.handle(
        _votosMeta,
        votos.isAcceptableOrUnknown(data['votos']!, _votosMeta),
      );
    } else if (isInserting) {
      context.missing(_votosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActaDetalleLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActaDetalleLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      actaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}acta_id'],
      )!,
      organizacionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organizacion_id'],
      )!,
      nombreOrganizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_organizacion'],
      )!,
      votos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}votos'],
      )!,
    );
  }

  @override
  $ActaDetalleLocalTable createAlias(String alias) {
    return $ActaDetalleLocalTable(attachedDatabase, alias);
  }
}

class ActaDetalleLocalData extends DataClass
    implements Insertable<ActaDetalleLocalData> {
  final String id;
  final String actaId;
  final String organizacionId;
  final String nombreOrganizacion;
  final int votos;
  const ActaDetalleLocalData({
    required this.id,
    required this.actaId,
    required this.organizacionId,
    required this.nombreOrganizacion,
    required this.votos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['acta_id'] = Variable<String>(actaId);
    map['organizacion_id'] = Variable<String>(organizacionId);
    map['nombre_organizacion'] = Variable<String>(nombreOrganizacion);
    map['votos'] = Variable<int>(votos);
    return map;
  }

  ActaDetalleLocalCompanion toCompanion(bool nullToAbsent) {
    return ActaDetalleLocalCompanion(
      id: Value(id),
      actaId: Value(actaId),
      organizacionId: Value(organizacionId),
      nombreOrganizacion: Value(nombreOrganizacion),
      votos: Value(votos),
    );
  }

  factory ActaDetalleLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActaDetalleLocalData(
      id: serializer.fromJson<String>(json['id']),
      actaId: serializer.fromJson<String>(json['actaId']),
      organizacionId: serializer.fromJson<String>(json['organizacionId']),
      nombreOrganizacion: serializer.fromJson<String>(
        json['nombreOrganizacion'],
      ),
      votos: serializer.fromJson<int>(json['votos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'actaId': serializer.toJson<String>(actaId),
      'organizacionId': serializer.toJson<String>(organizacionId),
      'nombreOrganizacion': serializer.toJson<String>(nombreOrganizacion),
      'votos': serializer.toJson<int>(votos),
    };
  }

  ActaDetalleLocalData copyWith({
    String? id,
    String? actaId,
    String? organizacionId,
    String? nombreOrganizacion,
    int? votos,
  }) => ActaDetalleLocalData(
    id: id ?? this.id,
    actaId: actaId ?? this.actaId,
    organizacionId: organizacionId ?? this.organizacionId,
    nombreOrganizacion: nombreOrganizacion ?? this.nombreOrganizacion,
    votos: votos ?? this.votos,
  );
  ActaDetalleLocalData copyWithCompanion(ActaDetalleLocalCompanion data) {
    return ActaDetalleLocalData(
      id: data.id.present ? data.id.value : this.id,
      actaId: data.actaId.present ? data.actaId.value : this.actaId,
      organizacionId: data.organizacionId.present
          ? data.organizacionId.value
          : this.organizacionId,
      nombreOrganizacion: data.nombreOrganizacion.present
          ? data.nombreOrganizacion.value
          : this.nombreOrganizacion,
      votos: data.votos.present ? data.votos.value : this.votos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActaDetalleLocalData(')
          ..write('id: $id, ')
          ..write('actaId: $actaId, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('nombreOrganizacion: $nombreOrganizacion, ')
          ..write('votos: $votos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, actaId, organizacionId, nombreOrganizacion, votos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActaDetalleLocalData &&
          other.id == this.id &&
          other.actaId == this.actaId &&
          other.organizacionId == this.organizacionId &&
          other.nombreOrganizacion == this.nombreOrganizacion &&
          other.votos == this.votos);
}

class ActaDetalleLocalCompanion extends UpdateCompanion<ActaDetalleLocalData> {
  final Value<String> id;
  final Value<String> actaId;
  final Value<String> organizacionId;
  final Value<String> nombreOrganizacion;
  final Value<int> votos;
  final Value<int> rowid;
  const ActaDetalleLocalCompanion({
    this.id = const Value.absent(),
    this.actaId = const Value.absent(),
    this.organizacionId = const Value.absent(),
    this.nombreOrganizacion = const Value.absent(),
    this.votos = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActaDetalleLocalCompanion.insert({
    required String id,
    required String actaId,
    required String organizacionId,
    required String nombreOrganizacion,
    required int votos,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       actaId = Value(actaId),
       organizacionId = Value(organizacionId),
       nombreOrganizacion = Value(nombreOrganizacion),
       votos = Value(votos);
  static Insertable<ActaDetalleLocalData> custom({
    Expression<String>? id,
    Expression<String>? actaId,
    Expression<String>? organizacionId,
    Expression<String>? nombreOrganizacion,
    Expression<int>? votos,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actaId != null) 'acta_id': actaId,
      if (organizacionId != null) 'organizacion_id': organizacionId,
      if (nombreOrganizacion != null) 'nombre_organizacion': nombreOrganizacion,
      if (votos != null) 'votos': votos,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActaDetalleLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? actaId,
    Value<String>? organizacionId,
    Value<String>? nombreOrganizacion,
    Value<int>? votos,
    Value<int>? rowid,
  }) {
    return ActaDetalleLocalCompanion(
      id: id ?? this.id,
      actaId: actaId ?? this.actaId,
      organizacionId: organizacionId ?? this.organizacionId,
      nombreOrganizacion: nombreOrganizacion ?? this.nombreOrganizacion,
      votos: votos ?? this.votos,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (actaId.present) {
      map['acta_id'] = Variable<String>(actaId.value);
    }
    if (organizacionId.present) {
      map['organizacion_id'] = Variable<String>(organizacionId.value);
    }
    if (nombreOrganizacion.present) {
      map['nombre_organizacion'] = Variable<String>(nombreOrganizacion.value);
    }
    if (votos.present) {
      map['votos'] = Variable<int>(votos.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActaDetalleLocalCompanion(')
          ..write('id: $id, ')
          ..write('actaId: $actaId, ')
          ..write('organizacionId: $organizacionId, ')
          ..write('nombreOrganizacion: $nombreOrganizacion, ')
          ..write('votos: $votos, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VeedorJrvLocalTable extends VeedorJrvLocal
    with TableInfo<$VeedorJrvLocalTable, VeedorJrvLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VeedorJrvLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _veedorIdMeta = const VerificationMeta(
    'veedorId',
  );
  @override
  late final GeneratedColumn<String> veedorId = GeneratedColumn<String>(
    'veedor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jrvIdMeta = const VerificationMeta('jrvId');
  @override
  late final GeneratedColumn<String> jrvId = GeneratedColumn<String>(
    'jrv_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recintoIdMeta = const VerificationMeta(
    'recintoId',
  );
  @override
  late final GeneratedColumn<String> recintoId = GeneratedColumn<String>(
    'recinto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, veedorId, jrvId, recintoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'veedor_jrv_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<VeedorJrvLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('veedor_id')) {
      context.handle(
        _veedorIdMeta,
        veedorId.isAcceptableOrUnknown(data['veedor_id']!, _veedorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_veedorIdMeta);
    }
    if (data.containsKey('jrv_id')) {
      context.handle(
        _jrvIdMeta,
        jrvId.isAcceptableOrUnknown(data['jrv_id']!, _jrvIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jrvIdMeta);
    }
    if (data.containsKey('recinto_id')) {
      context.handle(
        _recintoIdMeta,
        recintoId.isAcceptableOrUnknown(data['recinto_id']!, _recintoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recintoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VeedorJrvLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VeedorJrvLocalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      veedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}veedor_id'],
      )!,
      jrvId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jrv_id'],
      )!,
      recintoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recinto_id'],
      )!,
    );
  }

  @override
  $VeedorJrvLocalTable createAlias(String alias) {
    return $VeedorJrvLocalTable(attachedDatabase, alias);
  }
}

class VeedorJrvLocalData extends DataClass
    implements Insertable<VeedorJrvLocalData> {
  final String id;
  final String veedorId;
  final String jrvId;
  final String recintoId;
  const VeedorJrvLocalData({
    required this.id,
    required this.veedorId,
    required this.jrvId,
    required this.recintoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['veedor_id'] = Variable<String>(veedorId);
    map['jrv_id'] = Variable<String>(jrvId);
    map['recinto_id'] = Variable<String>(recintoId);
    return map;
  }

  VeedorJrvLocalCompanion toCompanion(bool nullToAbsent) {
    return VeedorJrvLocalCompanion(
      id: Value(id),
      veedorId: Value(veedorId),
      jrvId: Value(jrvId),
      recintoId: Value(recintoId),
    );
  }

  factory VeedorJrvLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VeedorJrvLocalData(
      id: serializer.fromJson<String>(json['id']),
      veedorId: serializer.fromJson<String>(json['veedorId']),
      jrvId: serializer.fromJson<String>(json['jrvId']),
      recintoId: serializer.fromJson<String>(json['recintoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'veedorId': serializer.toJson<String>(veedorId),
      'jrvId': serializer.toJson<String>(jrvId),
      'recintoId': serializer.toJson<String>(recintoId),
    };
  }

  VeedorJrvLocalData copyWith({
    String? id,
    String? veedorId,
    String? jrvId,
    String? recintoId,
  }) => VeedorJrvLocalData(
    id: id ?? this.id,
    veedorId: veedorId ?? this.veedorId,
    jrvId: jrvId ?? this.jrvId,
    recintoId: recintoId ?? this.recintoId,
  );
  VeedorJrvLocalData copyWithCompanion(VeedorJrvLocalCompanion data) {
    return VeedorJrvLocalData(
      id: data.id.present ? data.id.value : this.id,
      veedorId: data.veedorId.present ? data.veedorId.value : this.veedorId,
      jrvId: data.jrvId.present ? data.jrvId.value : this.jrvId,
      recintoId: data.recintoId.present ? data.recintoId.value : this.recintoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VeedorJrvLocalData(')
          ..write('id: $id, ')
          ..write('veedorId: $veedorId, ')
          ..write('jrvId: $jrvId, ')
          ..write('recintoId: $recintoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, veedorId, jrvId, recintoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VeedorJrvLocalData &&
          other.id == this.id &&
          other.veedorId == this.veedorId &&
          other.jrvId == this.jrvId &&
          other.recintoId == this.recintoId);
}

class VeedorJrvLocalCompanion extends UpdateCompanion<VeedorJrvLocalData> {
  final Value<String> id;
  final Value<String> veedorId;
  final Value<String> jrvId;
  final Value<String> recintoId;
  final Value<int> rowid;
  const VeedorJrvLocalCompanion({
    this.id = const Value.absent(),
    this.veedorId = const Value.absent(),
    this.jrvId = const Value.absent(),
    this.recintoId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VeedorJrvLocalCompanion.insert({
    required String id,
    required String veedorId,
    required String jrvId,
    required String recintoId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       veedorId = Value(veedorId),
       jrvId = Value(jrvId),
       recintoId = Value(recintoId);
  static Insertable<VeedorJrvLocalData> custom({
    Expression<String>? id,
    Expression<String>? veedorId,
    Expression<String>? jrvId,
    Expression<String>? recintoId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (veedorId != null) 'veedor_id': veedorId,
      if (jrvId != null) 'jrv_id': jrvId,
      if (recintoId != null) 'recinto_id': recintoId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VeedorJrvLocalCompanion copyWith({
    Value<String>? id,
    Value<String>? veedorId,
    Value<String>? jrvId,
    Value<String>? recintoId,
    Value<int>? rowid,
  }) {
    return VeedorJrvLocalCompanion(
      id: id ?? this.id,
      veedorId: veedorId ?? this.veedorId,
      jrvId: jrvId ?? this.jrvId,
      recintoId: recintoId ?? this.recintoId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (veedorId.present) {
      map['veedor_id'] = Variable<String>(veedorId.value);
    }
    if (jrvId.present) {
      map['jrv_id'] = Variable<String>(jrvId.value);
    }
    if (recintoId.present) {
      map['recinto_id'] = Variable<String>(recintoId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VeedorJrvLocalCompanion(')
          ..write('id: $id, ')
          ..write('veedorId: $veedorId, ')
          ..write('jrvId: $jrvId, ')
          ..write('recintoId: $recintoId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActasLocalTable actasLocal = $ActasLocalTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $ProvinciasLocalTable provinciasLocal = $ProvinciasLocalTable(
    this,
  );
  late final $CantonesLocalTable cantonesLocal = $CantonesLocalTable(this);
  late final $ParroquiasLocalTable parroquiasLocal = $ParroquiasLocalTable(
    this,
  );
  late final $RecintosLocalTable recintosLocal = $RecintosLocalTable(this);
  late final $JrvLocalTable jrvLocal = $JrvLocalTable(this);
  late final $OrganizacionesLocalTable organizacionesLocal =
      $OrganizacionesLocalTable(this);
  late final $ConfigSistemaLocalTable configSistemaLocal =
      $ConfigSistemaLocalTable(this);
  late final $ActaDetalleLocalTable actaDetalleLocal = $ActaDetalleLocalTable(
    this,
  );
  late final $VeedorJrvLocalTable veedorJrvLocal = $VeedorJrvLocalTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    actasLocal,
    syncQueue,
    provinciasLocal,
    cantonesLocal,
    parroquiasLocal,
    recintosLocal,
    jrvLocal,
    organizacionesLocal,
    configSistemaLocal,
    actaDetalleLocal,
    veedorJrvLocal,
  ];
}

typedef $$ActasLocalTableCreateCompanionBuilder =
    ActasLocalCompanion Function({
      required String id,
      required String jrvId,
      required String cargoElectoral,
      required int votosBlancos,
      required int votosNulos,
      required int totalSufragantes,
      Value<String?> fotoUrl,
      required double latitud,
      required double longitud,
      Value<bool> synced,
      Value<String?> syncError,
      required String creadoPor,
      Value<String?> editadoPor,
      Value<DateTime?> fechaEdicion,
      Value<int> rowid,
    });
typedef $$ActasLocalTableUpdateCompanionBuilder =
    ActasLocalCompanion Function({
      Value<String> id,
      Value<String> jrvId,
      Value<String> cargoElectoral,
      Value<int> votosBlancos,
      Value<int> votosNulos,
      Value<int> totalSufragantes,
      Value<String?> fotoUrl,
      Value<double> latitud,
      Value<double> longitud,
      Value<bool> synced,
      Value<String?> syncError,
      Value<String> creadoPor,
      Value<String?> editadoPor,
      Value<DateTime?> fechaEdicion,
      Value<int> rowid,
    });

class $$ActasLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ActasLocalTable> {
  $$ActasLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jrvId => $composableBuilder(
    column: $table.jrvId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cargoElectoral => $composableBuilder(
    column: $table.cargoElectoral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get votosBlancos => $composableBuilder(
    column: $table.votosBlancos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get votosNulos => $composableBuilder(
    column: $table.votosNulos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSufragantes => $composableBuilder(
    column: $table.totalSufragantes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoUrl => $composableBuilder(
    column: $table.fotoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadoPor => $composableBuilder(
    column: $table.creadoPor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editadoPor => $composableBuilder(
    column: $table.editadoPor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEdicion => $composableBuilder(
    column: $table.fechaEdicion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActasLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ActasLocalTable> {
  $$ActasLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jrvId => $composableBuilder(
    column: $table.jrvId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cargoElectoral => $composableBuilder(
    column: $table.cargoElectoral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get votosBlancos => $composableBuilder(
    column: $table.votosBlancos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get votosNulos => $composableBuilder(
    column: $table.votosNulos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSufragantes => $composableBuilder(
    column: $table.totalSufragantes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoUrl => $composableBuilder(
    column: $table.fotoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitud => $composableBuilder(
    column: $table.latitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitud => $composableBuilder(
    column: $table.longitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadoPor => $composableBuilder(
    column: $table.creadoPor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editadoPor => $composableBuilder(
    column: $table.editadoPor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEdicion => $composableBuilder(
    column: $table.fechaEdicion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActasLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActasLocalTable> {
  $$ActasLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get jrvId =>
      $composableBuilder(column: $table.jrvId, builder: (column) => column);

  GeneratedColumn<String> get cargoElectoral => $composableBuilder(
    column: $table.cargoElectoral,
    builder: (column) => column,
  );

  GeneratedColumn<int> get votosBlancos => $composableBuilder(
    column: $table.votosBlancos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get votosNulos => $composableBuilder(
    column: $table.votosNulos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSufragantes => $composableBuilder(
    column: $table.totalSufragantes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fotoUrl =>
      $composableBuilder(column: $table.fotoUrl, builder: (column) => column);

  GeneratedColumn<double> get latitud =>
      $composableBuilder(column: $table.latitud, builder: (column) => column);

  GeneratedColumn<double> get longitud =>
      $composableBuilder(column: $table.longitud, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<String> get creadoPor =>
      $composableBuilder(column: $table.creadoPor, builder: (column) => column);

  GeneratedColumn<String> get editadoPor => $composableBuilder(
    column: $table.editadoPor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaEdicion => $composableBuilder(
    column: $table.fechaEdicion,
    builder: (column) => column,
  );
}

class $$ActasLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActasLocalTable,
          ActasLocalData,
          $$ActasLocalTableFilterComposer,
          $$ActasLocalTableOrderingComposer,
          $$ActasLocalTableAnnotationComposer,
          $$ActasLocalTableCreateCompanionBuilder,
          $$ActasLocalTableUpdateCompanionBuilder,
          (
            ActasLocalData,
            BaseReferences<_$AppDatabase, $ActasLocalTable, ActasLocalData>,
          ),
          ActasLocalData,
          PrefetchHooks Function()
        > {
  $$ActasLocalTableTableManager(_$AppDatabase db, $ActasLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActasLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActasLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActasLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jrvId = const Value.absent(),
                Value<String> cargoElectoral = const Value.absent(),
                Value<int> votosBlancos = const Value.absent(),
                Value<int> votosNulos = const Value.absent(),
                Value<int> totalSufragantes = const Value.absent(),
                Value<String?> fotoUrl = const Value.absent(),
                Value<double> latitud = const Value.absent(),
                Value<double> longitud = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<String> creadoPor = const Value.absent(),
                Value<String?> editadoPor = const Value.absent(),
                Value<DateTime?> fechaEdicion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActasLocalCompanion(
                id: id,
                jrvId: jrvId,
                cargoElectoral: cargoElectoral,
                votosBlancos: votosBlancos,
                votosNulos: votosNulos,
                totalSufragantes: totalSufragantes,
                fotoUrl: fotoUrl,
                latitud: latitud,
                longitud: longitud,
                synced: synced,
                syncError: syncError,
                creadoPor: creadoPor,
                editadoPor: editadoPor,
                fechaEdicion: fechaEdicion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jrvId,
                required String cargoElectoral,
                required int votosBlancos,
                required int votosNulos,
                required int totalSufragantes,
                Value<String?> fotoUrl = const Value.absent(),
                required double latitud,
                required double longitud,
                Value<bool> synced = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                required String creadoPor,
                Value<String?> editadoPor = const Value.absent(),
                Value<DateTime?> fechaEdicion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActasLocalCompanion.insert(
                id: id,
                jrvId: jrvId,
                cargoElectoral: cargoElectoral,
                votosBlancos: votosBlancos,
                votosNulos: votosNulos,
                totalSufragantes: totalSufragantes,
                fotoUrl: fotoUrl,
                latitud: latitud,
                longitud: longitud,
                synced: synced,
                syncError: syncError,
                creadoPor: creadoPor,
                editadoPor: editadoPor,
                fechaEdicion: fechaEdicion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActasLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActasLocalTable,
      ActasLocalData,
      $$ActasLocalTableFilterComposer,
      $$ActasLocalTableOrderingComposer,
      $$ActasLocalTableAnnotationComposer,
      $$ActasLocalTableCreateCompanionBuilder,
      $$ActasLocalTableUpdateCompanionBuilder,
      (
        ActasLocalData,
        BaseReferences<_$AppDatabase, $ActasLocalTable, ActasLocalData>,
      ),
      ActasLocalData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String entityType,
      required String operation,
      required String payload,
      Value<DateTime> timestamp,
      Value<int> attempts,
      Value<String> status,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> operation,
      Value<String> payload,
      Value<DateTime> timestamp,
      Value<int> attempts,
      Value<String> status,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityType: entityType,
                operation: operation,
                payload: payload,
                timestamp: timestamp,
                attempts: attempts,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String operation,
                required String payload,
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                operation: operation,
                payload: payload,
                timestamp: timestamp,
                attempts: attempts,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$ProvinciasLocalTableCreateCompanionBuilder =
    ProvinciasLocalCompanion Function({
      required String id,
      required String nombre,
      Value<int> rowid,
    });
typedef $$ProvinciasLocalTableUpdateCompanionBuilder =
    ProvinciasLocalCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<int> rowid,
    });

class $$ProvinciasLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ProvinciasLocalTable> {
  $$ProvinciasLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProvinciasLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ProvinciasLocalTable> {
  $$ProvinciasLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProvinciasLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProvinciasLocalTable> {
  $$ProvinciasLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);
}

class $$ProvinciasLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProvinciasLocalTable,
          ProvinciasLocalData,
          $$ProvinciasLocalTableFilterComposer,
          $$ProvinciasLocalTableOrderingComposer,
          $$ProvinciasLocalTableAnnotationComposer,
          $$ProvinciasLocalTableCreateCompanionBuilder,
          $$ProvinciasLocalTableUpdateCompanionBuilder,
          (
            ProvinciasLocalData,
            BaseReferences<
              _$AppDatabase,
              $ProvinciasLocalTable,
              ProvinciasLocalData
            >,
          ),
          ProvinciasLocalData,
          PrefetchHooks Function()
        > {
  $$ProvinciasLocalTableTableManager(
    _$AppDatabase db,
    $ProvinciasLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProvinciasLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProvinciasLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProvinciasLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProvinciasLocalCompanion(
                id: id,
                nombre: nombre,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<int> rowid = const Value.absent(),
              }) => ProvinciasLocalCompanion.insert(
                id: id,
                nombre: nombre,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProvinciasLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProvinciasLocalTable,
      ProvinciasLocalData,
      $$ProvinciasLocalTableFilterComposer,
      $$ProvinciasLocalTableOrderingComposer,
      $$ProvinciasLocalTableAnnotationComposer,
      $$ProvinciasLocalTableCreateCompanionBuilder,
      $$ProvinciasLocalTableUpdateCompanionBuilder,
      (
        ProvinciasLocalData,
        BaseReferences<
          _$AppDatabase,
          $ProvinciasLocalTable,
          ProvinciasLocalData
        >,
      ),
      ProvinciasLocalData,
      PrefetchHooks Function()
    >;
typedef $$CantonesLocalTableCreateCompanionBuilder =
    CantonesLocalCompanion Function({
      required String id,
      required String nombre,
      required String provinciaId,
      Value<int> rowid,
    });
typedef $$CantonesLocalTableUpdateCompanionBuilder =
    CantonesLocalCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> provinciaId,
      Value<int> rowid,
    });

class $$CantonesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $CantonesLocalTable> {
  $$CantonesLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provinciaId => $composableBuilder(
    column: $table.provinciaId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CantonesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $CantonesLocalTable> {
  $$CantonesLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provinciaId => $composableBuilder(
    column: $table.provinciaId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CantonesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $CantonesLocalTable> {
  $$CantonesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get provinciaId => $composableBuilder(
    column: $table.provinciaId,
    builder: (column) => column,
  );
}

class $$CantonesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CantonesLocalTable,
          CantonesLocalData,
          $$CantonesLocalTableFilterComposer,
          $$CantonesLocalTableOrderingComposer,
          $$CantonesLocalTableAnnotationComposer,
          $$CantonesLocalTableCreateCompanionBuilder,
          $$CantonesLocalTableUpdateCompanionBuilder,
          (
            CantonesLocalData,
            BaseReferences<
              _$AppDatabase,
              $CantonesLocalTable,
              CantonesLocalData
            >,
          ),
          CantonesLocalData,
          PrefetchHooks Function()
        > {
  $$CantonesLocalTableTableManager(_$AppDatabase db, $CantonesLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CantonesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CantonesLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CantonesLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> provinciaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CantonesLocalCompanion(
                id: id,
                nombre: nombre,
                provinciaId: provinciaId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String provinciaId,
                Value<int> rowid = const Value.absent(),
              }) => CantonesLocalCompanion.insert(
                id: id,
                nombre: nombre,
                provinciaId: provinciaId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CantonesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CantonesLocalTable,
      CantonesLocalData,
      $$CantonesLocalTableFilterComposer,
      $$CantonesLocalTableOrderingComposer,
      $$CantonesLocalTableAnnotationComposer,
      $$CantonesLocalTableCreateCompanionBuilder,
      $$CantonesLocalTableUpdateCompanionBuilder,
      (
        CantonesLocalData,
        BaseReferences<_$AppDatabase, $CantonesLocalTable, CantonesLocalData>,
      ),
      CantonesLocalData,
      PrefetchHooks Function()
    >;
typedef $$ParroquiasLocalTableCreateCompanionBuilder =
    ParroquiasLocalCompanion Function({
      required String id,
      required String nombre,
      required String cantonId,
      Value<int> rowid,
    });
typedef $$ParroquiasLocalTableUpdateCompanionBuilder =
    ParroquiasLocalCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> cantonId,
      Value<int> rowid,
    });

class $$ParroquiasLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ParroquiasLocalTable> {
  $$ParroquiasLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cantonId => $composableBuilder(
    column: $table.cantonId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParroquiasLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ParroquiasLocalTable> {
  $$ParroquiasLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cantonId => $composableBuilder(
    column: $table.cantonId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParroquiasLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParroquiasLocalTable> {
  $$ParroquiasLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get cantonId =>
      $composableBuilder(column: $table.cantonId, builder: (column) => column);
}

class $$ParroquiasLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParroquiasLocalTable,
          ParroquiasLocalData,
          $$ParroquiasLocalTableFilterComposer,
          $$ParroquiasLocalTableOrderingComposer,
          $$ParroquiasLocalTableAnnotationComposer,
          $$ParroquiasLocalTableCreateCompanionBuilder,
          $$ParroquiasLocalTableUpdateCompanionBuilder,
          (
            ParroquiasLocalData,
            BaseReferences<
              _$AppDatabase,
              $ParroquiasLocalTable,
              ParroquiasLocalData
            >,
          ),
          ParroquiasLocalData,
          PrefetchHooks Function()
        > {
  $$ParroquiasLocalTableTableManager(
    _$AppDatabase db,
    $ParroquiasLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParroquiasLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParroquiasLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParroquiasLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> cantonId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParroquiasLocalCompanion(
                id: id,
                nombre: nombre,
                cantonId: cantonId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String cantonId,
                Value<int> rowid = const Value.absent(),
              }) => ParroquiasLocalCompanion.insert(
                id: id,
                nombre: nombre,
                cantonId: cantonId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParroquiasLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParroquiasLocalTable,
      ParroquiasLocalData,
      $$ParroquiasLocalTableFilterComposer,
      $$ParroquiasLocalTableOrderingComposer,
      $$ParroquiasLocalTableAnnotationComposer,
      $$ParroquiasLocalTableCreateCompanionBuilder,
      $$ParroquiasLocalTableUpdateCompanionBuilder,
      (
        ParroquiasLocalData,
        BaseReferences<
          _$AppDatabase,
          $ParroquiasLocalTable,
          ParroquiasLocalData
        >,
      ),
      ParroquiasLocalData,
      PrefetchHooks Function()
    >;
typedef $$RecintosLocalTableCreateCompanionBuilder =
    RecintosLocalCompanion Function({
      required String id,
      required String nombre,
      required String parroquiaId,
      required String direccion,
      Value<double?> latRef,
      Value<double?> lonRef,
      Value<String?> coordinadorId,
      Value<int> rowid,
    });
typedef $$RecintosLocalTableUpdateCompanionBuilder =
    RecintosLocalCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> parroquiaId,
      Value<String> direccion,
      Value<double?> latRef,
      Value<double?> lonRef,
      Value<String?> coordinadorId,
      Value<int> rowid,
    });

class $$RecintosLocalTableFilterComposer
    extends Composer<_$AppDatabase, $RecintosLocalTable> {
  $$RecintosLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parroquiaId => $composableBuilder(
    column: $table.parroquiaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latRef => $composableBuilder(
    column: $table.latRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lonRef => $composableBuilder(
    column: $table.lonRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coordinadorId => $composableBuilder(
    column: $table.coordinadorId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecintosLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $RecintosLocalTable> {
  $$RecintosLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parroquiaId => $composableBuilder(
    column: $table.parroquiaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latRef => $composableBuilder(
    column: $table.latRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lonRef => $composableBuilder(
    column: $table.lonRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coordinadorId => $composableBuilder(
    column: $table.coordinadorId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecintosLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecintosLocalTable> {
  $$RecintosLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get parroquiaId => $composableBuilder(
    column: $table.parroquiaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<double> get latRef =>
      $composableBuilder(column: $table.latRef, builder: (column) => column);

  GeneratedColumn<double> get lonRef =>
      $composableBuilder(column: $table.lonRef, builder: (column) => column);

  GeneratedColumn<String> get coordinadorId => $composableBuilder(
    column: $table.coordinadorId,
    builder: (column) => column,
  );
}

class $$RecintosLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecintosLocalTable,
          RecintosLocalData,
          $$RecintosLocalTableFilterComposer,
          $$RecintosLocalTableOrderingComposer,
          $$RecintosLocalTableAnnotationComposer,
          $$RecintosLocalTableCreateCompanionBuilder,
          $$RecintosLocalTableUpdateCompanionBuilder,
          (
            RecintosLocalData,
            BaseReferences<
              _$AppDatabase,
              $RecintosLocalTable,
              RecintosLocalData
            >,
          ),
          RecintosLocalData,
          PrefetchHooks Function()
        > {
  $$RecintosLocalTableTableManager(_$AppDatabase db, $RecintosLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecintosLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecintosLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecintosLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> parroquiaId = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<double?> latRef = const Value.absent(),
                Value<double?> lonRef = const Value.absent(),
                Value<String?> coordinadorId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecintosLocalCompanion(
                id: id,
                nombre: nombre,
                parroquiaId: parroquiaId,
                direccion: direccion,
                latRef: latRef,
                lonRef: lonRef,
                coordinadorId: coordinadorId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String parroquiaId,
                required String direccion,
                Value<double?> latRef = const Value.absent(),
                Value<double?> lonRef = const Value.absent(),
                Value<String?> coordinadorId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecintosLocalCompanion.insert(
                id: id,
                nombre: nombre,
                parroquiaId: parroquiaId,
                direccion: direccion,
                latRef: latRef,
                lonRef: lonRef,
                coordinadorId: coordinadorId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecintosLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecintosLocalTable,
      RecintosLocalData,
      $$RecintosLocalTableFilterComposer,
      $$RecintosLocalTableOrderingComposer,
      $$RecintosLocalTableAnnotationComposer,
      $$RecintosLocalTableCreateCompanionBuilder,
      $$RecintosLocalTableUpdateCompanionBuilder,
      (
        RecintosLocalData,
        BaseReferences<_$AppDatabase, $RecintosLocalTable, RecintosLocalData>,
      ),
      RecintosLocalData,
      PrefetchHooks Function()
    >;
typedef $$JrvLocalTableCreateCompanionBuilder =
    JrvLocalCompanion Function({
      required String id,
      required String codigo,
      required String recintoId,
      Value<int> rowid,
    });
typedef $$JrvLocalTableUpdateCompanionBuilder =
    JrvLocalCompanion Function({
      Value<String> id,
      Value<String> codigo,
      Value<String> recintoId,
      Value<int> rowid,
    });

class $$JrvLocalTableFilterComposer
    extends Composer<_$AppDatabase, $JrvLocalTable> {
  $$JrvLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recintoId => $composableBuilder(
    column: $table.recintoId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JrvLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $JrvLocalTable> {
  $$JrvLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recintoId => $composableBuilder(
    column: $table.recintoId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JrvLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $JrvLocalTable> {
  $$JrvLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get recintoId =>
      $composableBuilder(column: $table.recintoId, builder: (column) => column);
}

class $$JrvLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JrvLocalTable,
          JrvLocalData,
          $$JrvLocalTableFilterComposer,
          $$JrvLocalTableOrderingComposer,
          $$JrvLocalTableAnnotationComposer,
          $$JrvLocalTableCreateCompanionBuilder,
          $$JrvLocalTableUpdateCompanionBuilder,
          (
            JrvLocalData,
            BaseReferences<_$AppDatabase, $JrvLocalTable, JrvLocalData>,
          ),
          JrvLocalData,
          PrefetchHooks Function()
        > {
  $$JrvLocalTableTableManager(_$AppDatabase db, $JrvLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JrvLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JrvLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JrvLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> recintoId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JrvLocalCompanion(
                id: id,
                codigo: codigo,
                recintoId: recintoId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String codigo,
                required String recintoId,
                Value<int> rowid = const Value.absent(),
              }) => JrvLocalCompanion.insert(
                id: id,
                codigo: codigo,
                recintoId: recintoId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JrvLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JrvLocalTable,
      JrvLocalData,
      $$JrvLocalTableFilterComposer,
      $$JrvLocalTableOrderingComposer,
      $$JrvLocalTableAnnotationComposer,
      $$JrvLocalTableCreateCompanionBuilder,
      $$JrvLocalTableUpdateCompanionBuilder,
      (
        JrvLocalData,
        BaseReferences<_$AppDatabase, $JrvLocalTable, JrvLocalData>,
      ),
      JrvLocalData,
      PrefetchHooks Function()
    >;
typedef $$OrganizacionesLocalTableCreateCompanionBuilder =
    OrganizacionesLocalCompanion Function({
      required String id,
      required String nombre,
      required String cargo,
      Value<int?> lista,
      Value<String?> candidatoPrincipal,
      Value<String?> candidatoSecundario,
      Value<int> rowid,
    });
typedef $$OrganizacionesLocalTableUpdateCompanionBuilder =
    OrganizacionesLocalCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> cargo,
      Value<int?> lista,
      Value<String?> candidatoPrincipal,
      Value<String?> candidatoSecundario,
      Value<int> rowid,
    });

class $$OrganizacionesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizacionesLocalTable> {
  $$OrganizacionesLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cargo => $composableBuilder(
    column: $table.cargo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lista => $composableBuilder(
    column: $table.lista,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidatoPrincipal => $composableBuilder(
    column: $table.candidatoPrincipal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidatoSecundario => $composableBuilder(
    column: $table.candidatoSecundario,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrganizacionesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizacionesLocalTable> {
  $$OrganizacionesLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cargo => $composableBuilder(
    column: $table.cargo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lista => $composableBuilder(
    column: $table.lista,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidatoPrincipal => $composableBuilder(
    column: $table.candidatoPrincipal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidatoSecundario => $composableBuilder(
    column: $table.candidatoSecundario,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizacionesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizacionesLocalTable> {
  $$OrganizacionesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get cargo =>
      $composableBuilder(column: $table.cargo, builder: (column) => column);

  GeneratedColumn<int> get lista =>
      $composableBuilder(column: $table.lista, builder: (column) => column);

  GeneratedColumn<String> get candidatoPrincipal => $composableBuilder(
    column: $table.candidatoPrincipal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get candidatoSecundario => $composableBuilder(
    column: $table.candidatoSecundario,
    builder: (column) => column,
  );
}

class $$OrganizacionesLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizacionesLocalTable,
          OrganizacionesLocalData,
          $$OrganizacionesLocalTableFilterComposer,
          $$OrganizacionesLocalTableOrderingComposer,
          $$OrganizacionesLocalTableAnnotationComposer,
          $$OrganizacionesLocalTableCreateCompanionBuilder,
          $$OrganizacionesLocalTableUpdateCompanionBuilder,
          (
            OrganizacionesLocalData,
            BaseReferences<
              _$AppDatabase,
              $OrganizacionesLocalTable,
              OrganizacionesLocalData
            >,
          ),
          OrganizacionesLocalData,
          PrefetchHooks Function()
        > {
  $$OrganizacionesLocalTableTableManager(
    _$AppDatabase db,
    $OrganizacionesLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizacionesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizacionesLocalTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OrganizacionesLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> cargo = const Value.absent(),
                Value<int?> lista = const Value.absent(),
                Value<String?> candidatoPrincipal = const Value.absent(),
                Value<String?> candidatoSecundario = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizacionesLocalCompanion(
                id: id,
                nombre: nombre,
                cargo: cargo,
                lista: lista,
                candidatoPrincipal: candidatoPrincipal,
                candidatoSecundario: candidatoSecundario,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String cargo,
                Value<int?> lista = const Value.absent(),
                Value<String?> candidatoPrincipal = const Value.absent(),
                Value<String?> candidatoSecundario = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizacionesLocalCompanion.insert(
                id: id,
                nombre: nombre,
                cargo: cargo,
                lista: lista,
                candidatoPrincipal: candidatoPrincipal,
                candidatoSecundario: candidatoSecundario,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrganizacionesLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizacionesLocalTable,
      OrganizacionesLocalData,
      $$OrganizacionesLocalTableFilterComposer,
      $$OrganizacionesLocalTableOrderingComposer,
      $$OrganizacionesLocalTableAnnotationComposer,
      $$OrganizacionesLocalTableCreateCompanionBuilder,
      $$OrganizacionesLocalTableUpdateCompanionBuilder,
      (
        OrganizacionesLocalData,
        BaseReferences<
          _$AppDatabase,
          $OrganizacionesLocalTable,
          OrganizacionesLocalData
        >,
      ),
      OrganizacionesLocalData,
      PrefetchHooks Function()
    >;
typedef $$ConfigSistemaLocalTableCreateCompanionBuilder =
    ConfigSistemaLocalCompanion Function({
      required String clave,
      required String valor,
      Value<int> rowid,
    });
typedef $$ConfigSistemaLocalTableUpdateCompanionBuilder =
    ConfigSistemaLocalCompanion Function({
      Value<String> clave,
      Value<String> valor,
      Value<int> rowid,
    });

class $$ConfigSistemaLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ConfigSistemaLocalTable> {
  $$ConfigSistemaLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfigSistemaLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfigSistemaLocalTable> {
  $$ConfigSistemaLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clave => $composableBuilder(
    column: $table.clave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfigSistemaLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfigSistemaLocalTable> {
  $$ConfigSistemaLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clave =>
      $composableBuilder(column: $table.clave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$ConfigSistemaLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfigSistemaLocalTable,
          ConfigSistemaLocalData,
          $$ConfigSistemaLocalTableFilterComposer,
          $$ConfigSistemaLocalTableOrderingComposer,
          $$ConfigSistemaLocalTableAnnotationComposer,
          $$ConfigSistemaLocalTableCreateCompanionBuilder,
          $$ConfigSistemaLocalTableUpdateCompanionBuilder,
          (
            ConfigSistemaLocalData,
            BaseReferences<
              _$AppDatabase,
              $ConfigSistemaLocalTable,
              ConfigSistemaLocalData
            >,
          ),
          ConfigSistemaLocalData,
          PrefetchHooks Function()
        > {
  $$ConfigSistemaLocalTableTableManager(
    _$AppDatabase db,
    $ConfigSistemaLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigSistemaLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigSistemaLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigSistemaLocalTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clave = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConfigSistemaLocalCompanion(
                clave: clave,
                valor: valor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clave,
                required String valor,
                Value<int> rowid = const Value.absent(),
              }) => ConfigSistemaLocalCompanion.insert(
                clave: clave,
                valor: valor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfigSistemaLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfigSistemaLocalTable,
      ConfigSistemaLocalData,
      $$ConfigSistemaLocalTableFilterComposer,
      $$ConfigSistemaLocalTableOrderingComposer,
      $$ConfigSistemaLocalTableAnnotationComposer,
      $$ConfigSistemaLocalTableCreateCompanionBuilder,
      $$ConfigSistemaLocalTableUpdateCompanionBuilder,
      (
        ConfigSistemaLocalData,
        BaseReferences<
          _$AppDatabase,
          $ConfigSistemaLocalTable,
          ConfigSistemaLocalData
        >,
      ),
      ConfigSistemaLocalData,
      PrefetchHooks Function()
    >;
typedef $$ActaDetalleLocalTableCreateCompanionBuilder =
    ActaDetalleLocalCompanion Function({
      required String id,
      required String actaId,
      required String organizacionId,
      required String nombreOrganizacion,
      required int votos,
      Value<int> rowid,
    });
typedef $$ActaDetalleLocalTableUpdateCompanionBuilder =
    ActaDetalleLocalCompanion Function({
      Value<String> id,
      Value<String> actaId,
      Value<String> organizacionId,
      Value<String> nombreOrganizacion,
      Value<int> votos,
      Value<int> rowid,
    });

class $$ActaDetalleLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ActaDetalleLocalTable> {
  $$ActaDetalleLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actaId => $composableBuilder(
    column: $table.actaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreOrganizacion => $composableBuilder(
    column: $table.nombreOrganizacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get votos => $composableBuilder(
    column: $table.votos,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActaDetalleLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ActaDetalleLocalTable> {
  $$ActaDetalleLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actaId => $composableBuilder(
    column: $table.actaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreOrganizacion => $composableBuilder(
    column: $table.nombreOrganizacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get votos => $composableBuilder(
    column: $table.votos,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActaDetalleLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActaDetalleLocalTable> {
  $$ActaDetalleLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actaId =>
      $composableBuilder(column: $table.actaId, builder: (column) => column);

  GeneratedColumn<String> get organizacionId => $composableBuilder(
    column: $table.organizacionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreOrganizacion => $composableBuilder(
    column: $table.nombreOrganizacion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get votos =>
      $composableBuilder(column: $table.votos, builder: (column) => column);
}

class $$ActaDetalleLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActaDetalleLocalTable,
          ActaDetalleLocalData,
          $$ActaDetalleLocalTableFilterComposer,
          $$ActaDetalleLocalTableOrderingComposer,
          $$ActaDetalleLocalTableAnnotationComposer,
          $$ActaDetalleLocalTableCreateCompanionBuilder,
          $$ActaDetalleLocalTableUpdateCompanionBuilder,
          (
            ActaDetalleLocalData,
            BaseReferences<
              _$AppDatabase,
              $ActaDetalleLocalTable,
              ActaDetalleLocalData
            >,
          ),
          ActaDetalleLocalData,
          PrefetchHooks Function()
        > {
  $$ActaDetalleLocalTableTableManager(
    _$AppDatabase db,
    $ActaDetalleLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActaDetalleLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActaDetalleLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActaDetalleLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> actaId = const Value.absent(),
                Value<String> organizacionId = const Value.absent(),
                Value<String> nombreOrganizacion = const Value.absent(),
                Value<int> votos = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActaDetalleLocalCompanion(
                id: id,
                actaId: actaId,
                organizacionId: organizacionId,
                nombreOrganizacion: nombreOrganizacion,
                votos: votos,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String actaId,
                required String organizacionId,
                required String nombreOrganizacion,
                required int votos,
                Value<int> rowid = const Value.absent(),
              }) => ActaDetalleLocalCompanion.insert(
                id: id,
                actaId: actaId,
                organizacionId: organizacionId,
                nombreOrganizacion: nombreOrganizacion,
                votos: votos,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActaDetalleLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActaDetalleLocalTable,
      ActaDetalleLocalData,
      $$ActaDetalleLocalTableFilterComposer,
      $$ActaDetalleLocalTableOrderingComposer,
      $$ActaDetalleLocalTableAnnotationComposer,
      $$ActaDetalleLocalTableCreateCompanionBuilder,
      $$ActaDetalleLocalTableUpdateCompanionBuilder,
      (
        ActaDetalleLocalData,
        BaseReferences<
          _$AppDatabase,
          $ActaDetalleLocalTable,
          ActaDetalleLocalData
        >,
      ),
      ActaDetalleLocalData,
      PrefetchHooks Function()
    >;
typedef $$VeedorJrvLocalTableCreateCompanionBuilder =
    VeedorJrvLocalCompanion Function({
      required String id,
      required String veedorId,
      required String jrvId,
      required String recintoId,
      Value<int> rowid,
    });
typedef $$VeedorJrvLocalTableUpdateCompanionBuilder =
    VeedorJrvLocalCompanion Function({
      Value<String> id,
      Value<String> veedorId,
      Value<String> jrvId,
      Value<String> recintoId,
      Value<int> rowid,
    });

class $$VeedorJrvLocalTableFilterComposer
    extends Composer<_$AppDatabase, $VeedorJrvLocalTable> {
  $$VeedorJrvLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get veedorId => $composableBuilder(
    column: $table.veedorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jrvId => $composableBuilder(
    column: $table.jrvId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recintoId => $composableBuilder(
    column: $table.recintoId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VeedorJrvLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $VeedorJrvLocalTable> {
  $$VeedorJrvLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get veedorId => $composableBuilder(
    column: $table.veedorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jrvId => $composableBuilder(
    column: $table.jrvId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recintoId => $composableBuilder(
    column: $table.recintoId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VeedorJrvLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $VeedorJrvLocalTable> {
  $$VeedorJrvLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get veedorId =>
      $composableBuilder(column: $table.veedorId, builder: (column) => column);

  GeneratedColumn<String> get jrvId =>
      $composableBuilder(column: $table.jrvId, builder: (column) => column);

  GeneratedColumn<String> get recintoId =>
      $composableBuilder(column: $table.recintoId, builder: (column) => column);
}

class $$VeedorJrvLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VeedorJrvLocalTable,
          VeedorJrvLocalData,
          $$VeedorJrvLocalTableFilterComposer,
          $$VeedorJrvLocalTableOrderingComposer,
          $$VeedorJrvLocalTableAnnotationComposer,
          $$VeedorJrvLocalTableCreateCompanionBuilder,
          $$VeedorJrvLocalTableUpdateCompanionBuilder,
          (
            VeedorJrvLocalData,
            BaseReferences<
              _$AppDatabase,
              $VeedorJrvLocalTable,
              VeedorJrvLocalData
            >,
          ),
          VeedorJrvLocalData,
          PrefetchHooks Function()
        > {
  $$VeedorJrvLocalTableTableManager(
    _$AppDatabase db,
    $VeedorJrvLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VeedorJrvLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VeedorJrvLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VeedorJrvLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> veedorId = const Value.absent(),
                Value<String> jrvId = const Value.absent(),
                Value<String> recintoId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VeedorJrvLocalCompanion(
                id: id,
                veedorId: veedorId,
                jrvId: jrvId,
                recintoId: recintoId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String veedorId,
                required String jrvId,
                required String recintoId,
                Value<int> rowid = const Value.absent(),
              }) => VeedorJrvLocalCompanion.insert(
                id: id,
                veedorId: veedorId,
                jrvId: jrvId,
                recintoId: recintoId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VeedorJrvLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VeedorJrvLocalTable,
      VeedorJrvLocalData,
      $$VeedorJrvLocalTableFilterComposer,
      $$VeedorJrvLocalTableOrderingComposer,
      $$VeedorJrvLocalTableAnnotationComposer,
      $$VeedorJrvLocalTableCreateCompanionBuilder,
      $$VeedorJrvLocalTableUpdateCompanionBuilder,
      (
        VeedorJrvLocalData,
        BaseReferences<_$AppDatabase, $VeedorJrvLocalTable, VeedorJrvLocalData>,
      ),
      VeedorJrvLocalData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActasLocalTableTableManager get actasLocal =>
      $$ActasLocalTableTableManager(_db, _db.actasLocal);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$ProvinciasLocalTableTableManager get provinciasLocal =>
      $$ProvinciasLocalTableTableManager(_db, _db.provinciasLocal);
  $$CantonesLocalTableTableManager get cantonesLocal =>
      $$CantonesLocalTableTableManager(_db, _db.cantonesLocal);
  $$ParroquiasLocalTableTableManager get parroquiasLocal =>
      $$ParroquiasLocalTableTableManager(_db, _db.parroquiasLocal);
  $$RecintosLocalTableTableManager get recintosLocal =>
      $$RecintosLocalTableTableManager(_db, _db.recintosLocal);
  $$JrvLocalTableTableManager get jrvLocal =>
      $$JrvLocalTableTableManager(_db, _db.jrvLocal);
  $$OrganizacionesLocalTableTableManager get organizacionesLocal =>
      $$OrganizacionesLocalTableTableManager(_db, _db.organizacionesLocal);
  $$ConfigSistemaLocalTableTableManager get configSistemaLocal =>
      $$ConfigSistemaLocalTableTableManager(_db, _db.configSistemaLocal);
  $$ActaDetalleLocalTableTableManager get actaDetalleLocal =>
      $$ActaDetalleLocalTableTableManager(_db, _db.actaDetalleLocal);
  $$VeedorJrvLocalTableTableManager get veedorJrvLocal =>
      $$VeedorJrvLocalTableTableManager(_db, _db.veedorJrvLocal);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'105bd8a8ef41e172ff5db2d8e451479a0697fd42';

/// Proveedor Riverpod del AppDatabase. keepAlive: true para que sea singleton.
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
