// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncTask {
  int get id => throw _privateConstructorUsedError;
  String get entityType => throw _privateConstructorUsedError;
  String get operation => throw _privateConstructorUsedError;
  String get payload => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Create a copy of SyncTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncTaskCopyWith<SyncTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncTaskCopyWith<$Res> {
  factory $SyncTaskCopyWith(SyncTask value, $Res Function(SyncTask) then) =
      _$SyncTaskCopyWithImpl<$Res, SyncTask>;
  @useResult
  $Res call({
    int id,
    String entityType,
    String operation,
    String payload,
    DateTime timestamp,
    int attempts,
    String status,
  });
}

/// @nodoc
class _$SyncTaskCopyWithImpl<$Res, $Val extends SyncTask>
    implements $SyncTaskCopyWith<$Res> {
  _$SyncTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? operation = null,
    Object? payload = null,
    Object? timestamp = null,
    Object? attempts = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as String,
            operation: null == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as String,
            payload: null == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            attempts: null == attempts
                ? _value.attempts
                : attempts // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncTaskImplCopyWith<$Res>
    implements $SyncTaskCopyWith<$Res> {
  factory _$$SyncTaskImplCopyWith(
    _$SyncTaskImpl value,
    $Res Function(_$SyncTaskImpl) then,
  ) = __$$SyncTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String entityType,
    String operation,
    String payload,
    DateTime timestamp,
    int attempts,
    String status,
  });
}

/// @nodoc
class __$$SyncTaskImplCopyWithImpl<$Res>
    extends _$SyncTaskCopyWithImpl<$Res, _$SyncTaskImpl>
    implements _$$SyncTaskImplCopyWith<$Res> {
  __$$SyncTaskImplCopyWithImpl(
    _$SyncTaskImpl _value,
    $Res Function(_$SyncTaskImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? operation = null,
    Object? payload = null,
    Object? timestamp = null,
    Object? attempts = null,
    Object? status = null,
  }) {
    return _then(
      _$SyncTaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _value.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        attempts: null == attempts
            ? _value.attempts
            : attempts // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SyncTaskImpl implements _SyncTask {
  const _$SyncTaskImpl({
    required this.id,
    required this.entityType,
    required this.operation,
    required this.payload,
    required this.timestamp,
    required this.attempts,
    required this.status,
  });

  @override
  final int id;
  @override
  final String entityType;
  @override
  final String operation;
  @override
  final String payload;
  @override
  final DateTime timestamp;
  @override
  final int attempts;
  @override
  final String status;

  @override
  String toString() {
    return 'SyncTask(id: $id, entityType: $entityType, operation: $operation, payload: $payload, timestamp: $timestamp, attempts: $attempts, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entityType,
    operation,
    payload,
    timestamp,
    attempts,
    status,
  );

  /// Create a copy of SyncTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncTaskImplCopyWith<_$SyncTaskImpl> get copyWith =>
      __$$SyncTaskImplCopyWithImpl<_$SyncTaskImpl>(this, _$identity);
}

abstract class _SyncTask implements SyncTask {
  const factory _SyncTask({
    required final int id,
    required final String entityType,
    required final String operation,
    required final String payload,
    required final DateTime timestamp,
    required final int attempts,
    required final String status,
  }) = _$SyncTaskImpl;

  @override
  int get id;
  @override
  String get entityType;
  @override
  String get operation;
  @override
  String get payload;
  @override
  DateTime get timestamp;
  @override
  int get attempts;
  @override
  String get status;

  /// Create a copy of SyncTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncTaskImplCopyWith<_$SyncTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
