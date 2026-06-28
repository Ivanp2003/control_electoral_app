import { Client, Databases, Query } from 'node-appwrite';

function isCedulaValida(cedula) {
  if (!cedula || cedula.length !== 10) return false;
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

  const databases = new Databases(client);

  try {
    const payload = req.body ? (typeof req.body === 'string' ? JSON.parse(req.body) : req.body) : {};
    const { cedula } = payload;

    if (!cedula) {
      return res.json({ success: false, error: 'Cédula requerida' }, 400);
    }

    if (!isCedulaValida(String(cedula))) {
      log('Intento de búsqueda con cédula inválida');
      return res.json({ success: false, error: 'Cédula inválida' }, 400);
    }

    const result = await databases.listDocuments(process.env.APPWRITE_DATABASE_ID, 'usuarios', [
      Query.equal('cedula', String(cedula)),
      Query.limit(1)
    ]);

    if (result.documents.length === 0) {
      return res.json({ success: false, error: 'Usuario no encontrado' }, 404);
    }

    const responseObj = { 
      success: true, 
      correo: result.documents[0].correo 
    };
    log("Enviando respuesta al cliente: " + JSON.stringify(responseObj));
    return res.json(responseObj);

  } catch (err) {
    error('Error capturado: ' + err.message);
    return res.json({ success: false, error: 'Error interno del servidor' }, 500);
  }
};
