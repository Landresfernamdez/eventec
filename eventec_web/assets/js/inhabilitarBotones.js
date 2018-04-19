//Este script inabilita funciones en la pagina que muestra los eventos, funciones como el boton "eliminar" y el boton "nuevo evento"
//solo en caso de que el usuario actual sea un encargado
if (localStorage.getItem("session.role") === 'encargado') {
    document.getElementById("dropdownEvent").children[2].style.display = "none";
    document.getElementById("new_event_button").style.display = "none";
}