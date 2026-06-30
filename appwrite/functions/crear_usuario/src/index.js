import { Client, Users, Databases, ID, Query, Permission, Role } from 'node-appwrite';

function isCedulaValida(cedula) {
  if (cedula.length !== 10) return false;
  if (!/^[0-9]+$/.test(cedula)) return false;

  const prov = parseInt(cedula.substring(0, 2), 10);
  if (prov < 1 || prov > 24) return false;

  const tercerDigito = parseInt(cedula[2], 10);
  if (tercerDigito >= 6) return false;

  const coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  let suma = 0;
  for (let i = 0; i < 9; i++) {
    let valor = parseInt(cedula[i], 10) * coeficientes[i];
    if (valor > 9) valor -= 9;
    suma += valor;
  }

  const digitoVerificador = (suma % 10 === 0) ? 0 : 10 - (suma % 10);
  const ultimoDigito = parseInt(cedula[9], 10);

  return digitoVerificador === ultimoDigito;
}

export default async ({ req, res, log, error }) => {
  const projectId = process.env.APPWRITE_FUNCTION_PROJECT_ID;
  const apiKey = process.env.APPWRITE_API_KEY;

  const client = new Client()
    .setEndpoint('https://nyc.cloud.appwrite.io/v1') // URL fija para pruebas
    .setProject(projectId)
    .setKey(apiKey);

  const users = new Users(client);
  const databases = new Databases(client);

  try {
    const payload = JSON.parse(req.bodyRaw || req.body || '{}');
    const { cedula, nombres, apellidos, correo, telefono, rol } = payload;
    const passwordDefault = 'Ecuador2026';

    if (!cedula || !correo || !nombres || !apellidos) {
      return res.json({ success: false, error: 'invalid_payload', message: 'Faltan campos obligatorios' }, 400);
    }

    if (!isCedulaValida(cedula)) {
      log('Intento de creación con cédula inválida');
      return res.json({ success: false, error: 'invalid_cedula', message: 'El formato de la cédula no es válido' }, 400);
    }

    // 1(a). Verificar si la cédula ya existe en la BD
    const cedulaCheck = await databases.listDocuments(process.env.APPWRITE_DATABASE_ID, 'usuarios', [
      Query.equal('cedula', cedula),
      Query.limit(1)
    ]);

    if (cedulaCheck.documents.length > 0) {
      return res.json({ success: false, error: 'already_exists', message: 'La cédula ya está registrada' }, 409);
    }

    // 2(a). Verificar si el correo ya existe en la BD
    const correoCheck = await databases.listDocuments(process.env.APPWRITE_DATABASE_ID, 'usuarios', [
      Query.equal('correo', correo),
      Query.limit(1)
    ]);

    if (correoCheck.documents.length > 0) {
      return res.json({ success: false, error: 'already_exists', message: 'El correo ya está registrado' }, 409);
    }

    // 3(b,c). Crear identidad en Auth y atrapar carrera
    let authUser;
    try {
      authUser = await users.create(
        ID.unique(),
        correo,
        telefono || undefined,
        passwordDefault,
        `${nombres} ${apellidos}`
      );
    } catch (err) {
      if (err.type === 'user_already_exists' || err.code === 409) {
        return res.json({ success: false, error: 'auth_already_exists', message: 'El usuario ya existe en Auth' }, 409);
      }
      error('Error al crear usuario en Auth: ' + err.message);
      throw err;
    }

    // 4(d). Crear registro en la BD usando el ID de Auth
    try {
      const dbUser = await databases.createDocument(
        process.env.APPWRITE_DATABASE_ID,
        'usuarios',
        authUser.$id,
        {
          cedula,
          nombres,
          apellidos,
          correo,
          telefono,
          rol: rol || 'veedor',
          passwordChanged: false
        },
        [
          Permission.read(Role.users()),
          Permission.update(Role.user(authUser.$id))
        ]
      );
      return res.json({ success: true, data: dbUser });
    } catch (dbErr) {
      // Compensación: revertir la creación en Auth para no dejar cuenta huérfana
      try {
        await users.delete(authUser.$id);
      } catch (_) {
        error('Fallo crítico: no se pudo revertir usuario huérfano en Auth.');
      }
      error('Error en base de datos: ' + dbErr.message);
      return res.json({ success: false, error: 'internal_error', message: 'Fallo en BD: ' + dbErr.message }, 500);
    }
  } catch (err) {
    error('Error procesando creación de usuario: ' + (err.message || err.toString()));
    return res.json({ success: false, error: 'internal_error', message: 'Fallo interno: ' + (err.message || err.toString()) }, 500);
  }
};
