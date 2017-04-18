using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebServiceAsistencias.Models
{
    public class Usuario
    {
          public string cedula { get; set; }
          public string contraseña { get; set; }
          public string tipoCuenta { get; set; }
          public Boolean success { get; set; }
    }
}