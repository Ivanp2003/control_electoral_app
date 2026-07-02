import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../domain/usecases/asignar_veedor_jrv_usecase.dart';
import '../../domain/usecases/listar_usuarios_usecase.dart';
import '../../data/repositories/usuarios_repository_impl.dart';

import '../../../recintos/data/repositories/recintos_repository_impl.dart';

import '../../domain/usecases/asignar_coordinador_recinto_usecase.dart';
import '../../../../database/app_database.dart';

final listarUsuariosUseCaseProvider = Provider<ListarUsuariosUseCase>((ref) {
  return ListarUsuariosUseCase(ref.watch(usuarioRepositoryProvider));
});

final asignarVeedorJrvUseCaseProvider = Provider<AsignarVeedorJrvUseCase>((ref) {
  return AsignarVeedorJrvUseCase(
    ref.watch(usuarioRepositoryProvider),
    ref.watch(recintosRepositoryProvider),
  );
});

final asignarCoordinadorRecintoUseCaseProvider = Provider<AsignarCoordinadorRecintoUseCase>((ref) {
  return AsignarCoordinadorRecintoUseCase(
    usuarioRepository: ref.watch(usuarioRepositoryProvider),
    recintosRepository: ref.watch(recintosRepositoryProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

final listarUsuariosProvider = FutureProvider.family<List<Usuario>, String?>((ref, rol) async {
  final useCase = ref.watch(listarUsuariosUseCaseProvider);
  final result = await useCase(rol: rol);
  return result.fold(
    (failure) => throw failure,
    (usuarios) => usuarios,
  );
});
