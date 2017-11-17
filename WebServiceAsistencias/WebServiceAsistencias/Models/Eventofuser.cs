using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebServiceAsistencias.Models
{
    public class Eventofuser
    {
        public string cedula { get; set; }
        public string nombre { get; set; }
        public string descripcion { get; set; }
        public string fechaInicio { get; set; }
        public string fechaFinal { get; set; }
    }
}