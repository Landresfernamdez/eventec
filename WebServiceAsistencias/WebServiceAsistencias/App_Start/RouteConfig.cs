﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace WebServiceAsistencias
{
    public class RouteConfig
    {
        public static string cadenaConexion = @"Data Source=localhost;Initial Catalog=EvenTEC;User Id=sa;Password=86374844botas";
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            //Esta ruta retorna la informacion de una actividad en especifico por id
            routes.MapRoute(
                "AccesoActividad",
                "Actividades/Actividad/{ida}",
                new
                {
                    controller = "Actividades",
                    action = "Evento",
                    id = UrlParameter.Optional
                }
                );
            //Esta funcion retorna todas las actividades
            routes.MapRoute(
                "AccesoActivity",
                "Activities",
                new
                {
                    controller = "Activities",
                    action = "Activity"
                }
                );
            routes.MapRoute(
                "AccesoActivities",
                "Activities/Activity/{id}",
                new
                {
                    controller = "Activities",
                    action = "Activity",
                    id = UrlParameter.Optional
                }
                );
            routes.MapRoute(
                 "AccesoActivityAdd",
                 "ActivitiesAdd",
                 new
                 {
                     controller = "Activities",
                     action = "ActivityAdd"
                 }
                 );
            routes.MapRoute(
                 "AccesoActivityUpdate",
                 "ActivitiesUpdate",
                 new
                 {
                     controller = "Activities",
                     action = "ActivityUpdate"
                 }
                 );
            routes.MapRoute(
                "AccesoActivitys",
                "ActivitiesDelete",
                new
                {
                    controller = "Activities",
                    action = "ActivityDelete"
                }
                );
            routes.MapRoute(
                "AccesoActividades",
                "Actividades",
                new
                {
                    controller ="Actividades",
                    action ="Actividades"
                }
            );
            routes.MapRoute(
                "AccesoRegistros",//Cambie de Registro a Registros
                "Registros",
                    new
                    {
                        controller ="Registros",
                        action = "Registros",
                        place = UrlParameter.Optional
                    }
                );
            routes.MapRoute(
                "AccesoRegisters",
                "Registers",
                    new
                    {
                        controller = "Registers",
                        action = "Registers",
                        place = UrlParameter.Optional
                    }
                );
            routes.MapRoute(
                "AccesoEventos",
                "Eventos/Evento/{id}",
                new
                {
                    controller ="Eventos",
                    action = "Evento",
                    id = UrlParameter.Optional,
                    pass = UrlParameter.Optional
                }
                );
            routes.MapRoute(
                 "AccesoEventosAdministradores",
                 "Eventos/{filter}/{ced}",
                 new
                 {
                     controller = "Eventos",
                     action = "Eventos",
                     filter = UrlParameter.Optional,
                     CED = UrlParameter.Optional
                 }
                 );
            routes.MapRoute(
                  "AccesoEventosAdministradoresUpdate",
                  "EventosUpdate",
                  new
                  {
                      controller = "Eventos",
                      action = "EventosUpdate"
                  }
                  );
            routes.MapRoute(
                   "AccesoEventosAdministradoresAdd",
                   "EventosAdd",
                   new
                   {
                       controller = "Eventos",
                       action = "EventosAdd"
                   }
                   );
            routes.MapRoute(
                        "AccesoEdecanes",
                        "Edecanes/Edecan/{id}/{pass}",
                        new
                        {
                            controller = "Edecanes",
                            action = "Edecan",
                            id = UrlParameter.Optional,
                            pass = UrlParameter.Optional

                        }
                        );
           routes.MapRoute(
                       "AccesoAdministradores",
                       "Administradores/Administrador/{ida}/{pass}",
                        new
                        {
                           controller = "Administradores",
                           action = "Administrador",
                           id = UrlParameter.Optional,
                           pass = UrlParameter.Optional
                         }
                          );

          routes.MapRoute(
                       "AccesoPersonas",
                        "Personas",
                         new
                         {
                           controller = "Edecanes",
                           action = "Edecanes"
                         }
                          );
         routes.MapRoute(
                         "AccesoPersona",
                         "Personas/Persona/{id}",
                          new
                          {
                            controller = "Personas",
                            action = "Persona",
                            id = UrlParameter.Optional
                            }
                         );
            routes.MapRoute(
                        "AccesoPersonaActividad",
                        "Personas/ActividadesPersona/{id}",
                         new
                         {
                             controller = "Personas",
                             action = "ActividadesPersona",
                             id = UrlParameter.Optional
                         }
                        );
            routes.MapRoute(
                        "AccesoPersonaActividadmodificar",
                        "Personas/ActividadesPersona",
                         new
                         {
                             controller = "Personas",
                             action = "ActividadesPersona",
                             id = UrlParameter.Optional
                         }
                        );
            routes.MapRoute(
                        "AccesoPersonaActividadeliminar",
                        "Personas/EliminarActividadesPersona",
                         new
                         {
                             controller = "Personas",
                             action = "EliminarActividadesPersona",
                             id = UrlParameter.Optional
                         }
                        );
            routes.MapRoute(
                         "AccesoAdministrador",
                         "Administradores",
                          new
                          {
                              controller = "Administradores",
                              action = "Administradores",
                              id = UrlParameter.Optional
                          }
                         );
            routes.MapRoute(
                        "AccesoEncargadoss",
                        "Encargados/Encargado/{ida}/{pass}",
                        new
                        {
                            controller = "Encargados",
                            action = "Encargado",
                            id = UrlParameter.Optional,
                            pass = UrlParameter.Optional
                        }
                        );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}/{pass}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional,pass=UrlParameter.Optional,place= UrlParameter.Optional }
            );
        }
    }
}