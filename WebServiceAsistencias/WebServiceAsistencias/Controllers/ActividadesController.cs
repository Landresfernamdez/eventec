using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;

namespace WebServiceAsistencias.Controllers
{
    public class ActividadesController : Controller
    {
        private ActividadManager actividadManager;

        public ActividadesController()
        {
            actividadManager = new ActividadManager();
        }
        
        public JsonResult Evento( string ida, Usuario item)
        {
            switch (Request.HttpMethod)
            {   
                case "GET":
                    return Json(actividadManager.ObtenerActividadesDeAnfitrion(ida),
                                JsonRequestBehavior.AllowGet);
                    
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}