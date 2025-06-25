// Lista con las tablas de la Base de Datos
const tablas = [
  'Hotel', 'Telefonos', 'RedesSociales', 'Servicio',
  'Cliente', 'Reservaciones', 'Facturas', 'Habitaciones',
  'TipoHabitacion', 'Comodidades',
  'ActividadesRecreacion', 'EmpresasRecreaciones', 'FotosHabitacion'
];

/**
 * Esto de acá muestra la ventana lateral con las tablas dependiendo de la acción que se escogio
 * @param {string} seccion - Acción ya sea agregar, eliminar, modificar o listar
 */
function mostrarVentana(seccion) {
  const contenido = document.getElementById('contenido');

  // Estructura inicial de la ventana
  let html = `
    <div class="ventana">
      <h2>Seleccione Tabla a ${capitalizar(seccion)}</h2>
      <ul>
  `;

  // Recorre las tablas y genera enlaces hacia accion.html con parámetros tipo y tabla
  for (const tabla of tablas) {
    const url = `accion.html?tipo=${encodeURIComponent(seccion)}&tabla=${encodeURIComponent(tabla)}`;
    html += `<li><a href="${url}">${tabla}</a></li>`;
  }

  html += `</ul></div>`;

  contenido.innerHTML = html;
}

/**
 * Capitaliza la primera letra de un string
 * @param {string} str - Texto a capitalizar
 * @returns {string} - Texto capitalizado
 */
function capitalizar(str) {
  return str.charAt(0).toUpperCase() + str.slice(1); 
}


function mostrarLogin() {
  document.getElementById('ventana-login').classList.remove('oculto');
}

function cerrarLogin() {
  document.getElementById('ventana-login').classList.add('oculto');
}

