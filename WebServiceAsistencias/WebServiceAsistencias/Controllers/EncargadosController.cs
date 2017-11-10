using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;

namespace WebServiceAsistencias.Controllers
{
    public class EncargadosController : Controller
    {
        private EncargadoManager EncargManager;
        // GET: Administrador
        public EncargadosController()
        {
            EncargManager = new EncargadoManager();
        }
        public JsonResult Encargado(byte[] ida, byte[] pass)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(EncargManager.ObtenerEnc(ida, pass),
                                JsonRequestBehavior.AllowGet);
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}