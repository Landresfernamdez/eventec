using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServiceAsistencias.Models;
namespace WebServiceAsistencias.Controllers
{
    public class ActivitiesController : Controller
    {
        private ActivitiesManager activityManager;

        public ActivitiesController()
        {
            activityManager = new ActivitiesManager();
        }
        public JsonResult Activity(string ida, Actividad item)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(activityManager.ObtenerActividadesDeAdministrador(ida),
                                JsonRequestBehavior.AllowGet);
                case "POST":
                    return Json(activityManager.InsertarActivity(item));


            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}