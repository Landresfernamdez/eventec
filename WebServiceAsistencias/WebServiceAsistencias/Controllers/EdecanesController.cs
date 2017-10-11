using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;

namespace WebServiceAsistencias.Controllers
{
    public class EdecanesController : Controller
    {
        private EdecanManager anfitrionesManager;

        public EdecanesController()
        {
            anfitrionesManager = new EdecanManager();
        }

        // GET /Api/Clientes
        

        public JsonResult Edecan(string id,string pass, Usuario item)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(anfitrionesManager.ObtenerEdecan(id,pass), 
                                JsonRequestBehavior.AllowGet);
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult Edecanes(Usuario item)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(anfitrionesManager.ObtenerEdecanes(),
                                JsonRequestBehavior.AllowGet);
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }

    }

