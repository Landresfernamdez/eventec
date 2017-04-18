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

        public JsonResult Evento(string id, string pass, Usuario item)
        {
            switch (Request.HttpMethod)
            {
                
                case "GET":
                    return Json(eventsManager.ObtenerEvento(id), JsonRequestBehavior.AllowGet);
                    
            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}