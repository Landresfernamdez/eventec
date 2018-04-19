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
        public JsonResult Activity(string id)
        {
            switch (Request.HttpMethod)
            {
                case "GET":
                    return Json(activityManager.ObtenerActividadesDeEvento(id),
                                JsonRequestBehavior.AllowGet);
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult ActivityDelete(Act_event item)
        {
            switch (Request.HttpMethod)
            {
                
                case "POST":
                    return Json(activityManager.deleteActivity(item));
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult ActivityAdd(Activityofevent item)
        {
            switch (Request.HttpMethod)
            {
                case "POST":
                    return Json(activityManager.InsertarActivity(item));
            }
            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
        public JsonResult ActivityUpdate(Actividad item)
        {
            switch (Request.HttpMethod)
            {

                case "POST":
                    return Json(activityManager.modificarActivity(item));
            }

            return Json(new { Error = true, Message = "Operación HTTP desconocida" });
        }
    }
}