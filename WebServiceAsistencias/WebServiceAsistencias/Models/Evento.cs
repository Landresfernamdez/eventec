using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


using System.Data.SqlTypes;
namespace WebServiceAsistencias.Models
{
    public class Actividad
    {
        public string idActividad { get; set; }
        public string nombre { get; set; }
        public string descripcion { get; set; }
        public string fecha { get; set; }
        public int cupo { get; set; }
        public string lugar { get; set; }
        public string horaInicio { get; set; }
        public string horaFinal { get; set; }
        public string duracion { get; set; }
    }
}