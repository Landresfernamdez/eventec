using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebServiceAsistencias.Models
{
    public class Event
    {
        public string idEvento { get; set; }
        public string nombre { get; set; }
        public string descripcion { get; set; }
        public string fechaInicio { get; set; }
        public string fechaFinal { get; set; }
    }
}