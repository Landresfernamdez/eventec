using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;

namespace WebServiceAsistencias.Controllers
{
    public class PersonasController:Controller
    {
        private PersonaManager personasManager;

        public PersonasController()
        {
            personasManager = new PersonaManager();
        }

        // GET /Api/Clientes
        

        // POST    Clientes/Lugar    { Nombre:"nombre", Telefono:123456789 }
        // PUT     Clientes/Lugar/3  { Id:3, Nombre:"nombre", Telefono:123456789 }
        // GET     Clientes/Lugar/3
        // DELETE  Clientes/Lugar/3
        public JsonResult Persona(string id, Persona item)
        {
            switch (Request.HttpMethod)
            {
             //   case "POST":
               //     return Json(anfitrionesManager.InsertarCliente(item));
                case "POST":
                    return Json(personasManager.ActualizarEstudiante(item));
                case "GET":
                    return Json(personasManager.ObtenerPersona(id), 
                                JsonRequestBehavior.AllowGet);
               // case "DELETE":
                //    return Json(anfitrionesManager.EliminarCliente(id.GetValueOrDefault()));
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}