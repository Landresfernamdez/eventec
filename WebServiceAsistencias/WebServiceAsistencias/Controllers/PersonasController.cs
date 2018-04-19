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
        public JsonResult ActividadesPersona(string id,Persona item)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(personasManager.ObtenerPersonadeActividades(id),
                                JsonRequestBehavior.AllowGet);
                case "POST":
                    return Json(personasManager.ActualizarPersona(item));
            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult EliminarActividadesPersona(string id, PersonaActividad item)
        {
            switch (Request.HttpMethod)
            {
                case "POST":
                    return Json(personasManager.EliminarPersona(item));
            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}