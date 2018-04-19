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
        private EncargadoManager encManager;
        // GET: Encargado
        public EncargadosController()
        {
            encManager = new EncargadoManager();
        }
        public JsonResult Encargado(byte[] ida, byte[] pass)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(encManager.ObtenerEnc(ida, pass),
                                JsonRequestBehavior.AllowGet);
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}