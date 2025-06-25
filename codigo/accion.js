// Obtener los parámetros de la URL
const params = new URLSearchParams(window.location.search);
const tipo = params.get('tipo');   // agregar, eliminar, etc.
const tabla = params.get('tabla'); // Hotel, Cliente, etc.

const contenedor = document.getElementById('accion-contenido');

// Validación básica para los parámetros
if (!tipo || !tabla) {
  contenedor.innerHTML = "<p>Error: acción o tabla no especificadas.</p>";
  throw new Error("Faltan parámetros tipo o tabla en la URL.");
}

// Función para capitalizar nombres
function capitalizar(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

// ========== Campos o espacios para rellenar segun x tabla ==========
const camposPorTabla = {
  Hotel: [
    "Nombre", "Cedula J.", "Provincia", "Cantón", "Distrito", "Barrio",
    "Ref. GPS", "Tipo", "Correo Elect.", "URL", "Señas Exactas"
  ],
  Telefonos: ["Número", "ID Hotel"],
  RedesSociales: ["Nombre", "URL", "ID Hotel"],
  Servicio: ["Descripción", "ID Hotel"],
  Cliente: [
    "Nombre", "Apellido 1", "Apellido 2", "Correo", "Teléfono 1", "Cedula", 
    "Tipo Identificación", "País Recidencia", "Teléfono 2", "Fecha Nacimiento",
    "Provincia", "Cantón", "Distrito", "Teléfono 3"
  ],
  Reservaciones: ["Cant. Personas", "Fecha Ingreso", "Fecha Salida", "Vehículo", "ID Habitación", "ID Cliente"],
  Facturas: ["Total Pagar", "ID Reserva", "Fecha Factura", "Metodo Pago"],
  DatosHabitaciones: ["Número", "ID Hotel"],
  TipoHabitacion: ["Nombre", "Descripción", "Tipo de Cama", "ID Habitación", "Precio"],
  Comodidades: ["Descripción", "id Tipo Habitac."],
  Actividad: ["Descripción", "ID Hotel", "Precio", "ID Empresa"],
  EmpresasRecreaciones: [ 
    "Nombre", "Cedula J.", "Provincia", "Cantón", "Distrito", "Teléfono",
    "Ref. GPS", "Tipo Servicios", "Correo Elect.", "Nombre Conta.", "Señas Exactas"
],
  FotosHabitacion: ["id tipo Habitación", "URL Foto"],
};

// Título dinámico
const titulo = document.createElement('h2');
titulo.textContent = `${capitalizar(tipo)} en tabla ${tabla}`;
contenedor.appendChild(titulo);


switch (tipo) {
  case 'agregar':
    mostrarFormularioAgregar(tabla);
    break;
  case 'eliminar':
    mostrarFormularioEliminar(tabla);
    break;
  case 'modificar':
    mostrarFormularioModificar(tabla);
    break;
  case 'listar':
    mostrarListado(tabla);
    break;
  default:
    contenedor.innerHTML = "<p>Acción no reconocida.</p>";
}

// ========== FORMULARIO AGREGAR ==========
function mostrarFormularioAgregar(tabla) {
  const campos = camposPorTabla[tabla] || ["Campo1", "Campo2"];

  let formHtml = '<form class="formulario"><div class="grid">';

  campos.forEach((campo) => {
    const safeName = campo.replace(/\s+/g, '_').toLowerCase().replace(/[^\w]/g, '');
    formHtml += `
      <div class="campo">
        <input type="text" placeholder="Ingrese ${campo}" name="${safeName}">
      </div>
    `;
  });

  formHtml += '</div><button type="submit" class="boton">Confirmar</button></form>';
  contenedor.innerHTML += formHtml;
}

// ========== FORMULARIO ELIMINAR ==========
function mostrarFormularioEliminar(tabla) {
  contenedor.innerHTML += `
    <form class="formulario">
      <div class="campo">
        <input type="number" placeholder="Ingrese ID de ${tabla}" name="id">
      </div>
      <button type="submit" class="boton eliminar">Eliminar</button>
    </form>
  `;
}

// ========== FORMULARIO MODIFICAR ==========
function mostrarFormularioModificar(tabla) {
  mostrarFormularioAgregar(tabla); 
}

// ========== FORMULARIO LISTAR ==========
function mostrarListado(tabla) {
  contenedor.innerHTML += `
    <form class="formulario">
      <div class="campo">
        <input type="number" placeholder="Ingrese ID de ${tabla}" name="id">
      </div>
      <button type="submit" class="boton listar">Buscar</button>
    </form>
  `;
}