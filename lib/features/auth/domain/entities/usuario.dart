import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_roles.dart';

/// usuario.dart
/// 
/// Responsabilidad Única: Representar la entidad de negocio de un Usuario en el dominio
/// electoral, conteniendo sus atributos principales y roles sin dependencias de infraestructura.
/// Cambios en esta clase ocurren si cambian los campos requeridos del perfil del usuario.

class Usuario extends Equatable {
  final String id;
  final String cedula;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String correo;
  final AppRole rol;
  final bool passwordChanged;
  final String? recintoId;

  const Usuario({
    required this.id,
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.correo,
    required this.rol,
    required this.passwordChanged,
    this.recintoId,
  });

  @override
  List<Object?> get props => [
        id,
        cedula,
        nombres,
        apellidos,
        telefono,
        correo,
        rol,
        passwordChanged,
        recintoId,
      ];
}
