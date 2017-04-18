using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;
namespace WebServiceAsistencias.Controllers
{
    public class RegistrosController : Controller
    {
        private RegistroManager registrosManager;

        public RegistrosController()
        {
            registrosManager = new RegistroManager();
        }

        

        // POST    Clientes/Lugar    { Nombre:"nombre", Telefono:123456789 }
        // PUT     Clientes/Lugar/3  { Id:3, Nombre:"nombre", Telefono:123456789 }
        // GET     Clientes/Lugar/3
        // DELETE  Clientes/Lugar/3
        public JsonResult Registro(string register, Registro item)
        {
            switch (Request.HttpMethod)
            {
                case "POST":
                    return Json(registrosManager.InsertarRegistro(item));
               
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
	}
}