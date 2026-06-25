import '../../../../core/constants/app_roles.dart';
import '../../domain/entities/usuario.dart';

/// usuario_model.dart
/// 
/// Responsabilidad Única: Definir la serialización y deserialización de datos de Usuario 
/// entre la infraestructura de bases de datos (Appwrite) y la entidad de dominio.
/// Cambios en esta clase ocurren si se modifica el formato de almacenamiento en Appwrite.

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.cedula,
    required super.nombres,
    required super.apellidos,
    required super.telefono,
    required super.correo,
    required super.rol,
    required super.passwordChanged,
  });

  /// Crea una instancia a partir de un mapa JSON proveniente de Appwrite.
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    // Mapear el string del rol al enum AppRole
    final rolStr = json['rol'] as String? ?? '';
    AppRole parsedRol = AppRole.veedor; // default fallback
    
    if (rolStr == 'coordinadorProvincial') {
      parsedRol = AppRole.coordinadorProvincial;
    } else if (rolStr == 'coordinadorRecinto') {
      parsedRol = AppRole.coordinadorRecinto;
    } else if (rolStr == 'veedor') {
      parsedRol = AppRole.veedor;
    }

    return UsuarioModel(
      id: json[r'$id'] as String? ?? json['id'] as String? ?? '',
      cedula: json['cedula'] as String? ?? '',
      nombres: json['nombres'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      rol: parsedRol,
      passwordChanged: json['passwordChanged'] as bool? ?? false,
    );
  }

  /// Convierte el modelo a un mapa JSON para ser guardado en la base de datos de Appwrite.
  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'correo': correo,
      'rol': rol.name,
      'passwordChanged': passwordChanged,
    };
  }

  /// Convierte este modelo a la entidad pura de dominio [Usuario].
  Usuario toDomain() {
    return Usuario(
      id: id,
      cedula: cedula,
      nombres: nombres,
      apellidos: apellidos,
      telefono: telefono,
      correo: correo,
      rol: rol,
      passwordChanged: passwordChanged,
    );
  }
}
