import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_task.freezed.dart';

@freezed
class SyncTask with _$SyncTask {
  const factory SyncTask({
    required int id,
    required String entityType,
    required String operation,
    required String payload,
    required DateTime timestamp,
    required int attempts,
    required String status,
  }) = _SyncTask;
}
