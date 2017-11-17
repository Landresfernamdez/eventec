using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;

namespace WebServiceAsistencias.Controllers
{
    public class AdministradoresController : Controller
    {
        private AdministradorManager administratorManager;
        // GET: Administrador
        public AdministradoresController()
        {
            administratorManager = new AdministradorManager();
        }
        public JsonResult Administrador(byte[] ida, byte[] pass)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(administratorManager.ObtenerAdmi(ida,pass),
                                JsonRequestBehavior.AllowGet);
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}