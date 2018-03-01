using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;

namespace WebServiceAsistencias.Controllers
{
    public class EventosController : Controller
    {
        private EventoManager eventsManager;

        public EventosController()
        {
            eventsManager = new EventoManager();
        }

        public JsonResult Evento(string id,Event item)
        {
            switch (Request.HttpMethod)
            {
                
                case "GET":
                    return Json(eventsManager.ObtenerEvento(id), JsonRequestBehavior.AllowGet);


            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult Eventos(char filter, string CED, Event item)
        {
            switch (Request.HttpMethod)
            {

                case "GET":
                    return Json(eventsManager.ObtenerEventos(filter, CED), JsonRequestBehavior.AllowGet);
                case "POST":
                    return Json(eventsManager.deleteEvento(item));

            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult EventosUpdate(Event item)
        {
            switch (Request.HttpMethod)
            {
                case "POST":
                    return Json(eventsManager.modificarEvento(item));

            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult EventosAdd(Eventofuser item)
        {
            switch (Request.HttpMethod)
            {
                case "POST":
                    return Json(eventsManager.InsertarEvento(item));

            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}