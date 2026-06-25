import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/app_roles.dart';
import '../../../core/network/appwrite_client.dart';
import '../../../database/app_database.dart';
import '../data/seeder_datasource.dart';
import '../domain/seeder_resultado.dart';
import '../domain/usecases/ejecutar_seeder_usecase.dart';

part 'seeder_providers.g.dart';

/// Provider del mensaje de progreso actual durante la ejecución del Seeder.
final seederProgressProvider = StateProvider<String>((ref) => '');

/// Notifier principal del Seeder.
/// Estado: AsyncValue<SeederResultado?> — null = idle, loading, data, error.
@riverpod
class SeederNotifier extends _$SeederNotifier {
  @override
  AsyncValue<SeederResultado?> build() => const AsyncValue.data(null);

  Future<void> ejecutar(AppRole rolUsuario) async {
    state = const AsyncValue.loading();
    ref.read(seederProgressProvider.notifier).state = '';

    final useCase = EjecutarSeederUseCase(
      datasource: SeederDatasource(
        databases: ref.read(appwriteDatabasesProvider),
      ),
      databases: ref.read(appwriteDatabasesProvider),
      localDb: ref.read(appDatabaseProvider),
    );

    final result = await useCase(
      rolUsuario: rolUsuario,
      onProgress: (mensaje) {
        ref.read(seederProgressProvider.notifier).state = mensaje;
      },
    );

    state = result.fold<AsyncValue<SeederResultado?>>(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (resultado) => AsyncValue.data(resultado),
    );
  }
}
