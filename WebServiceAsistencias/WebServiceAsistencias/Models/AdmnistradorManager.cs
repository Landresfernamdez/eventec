using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Text;
namespace WebServiceAsistencias.Models
{
    public class AdmnistradorManager
    {
        public string cadenaConexion = RouteConfig.cadenaConexion;
        
        public Usuario ObtenerAdmi(byte[] ida,byte[] pass)
        {
            Usuario admi = null;
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "SELECT a.cedula, a.contraseña,a.tipoCuenta from Usuarios as a where a.cedula=@idadmi and a.contraseña=@pass";

            String b64 = HttpServerUtility.UrlTokenEncode(ida);
            String id2 = Encoding.UTF8.GetString(HttpServerUtility.UrlTokenDecode(b64));
            String b641 = HttpServerUtility.UrlTokenEncode(pass);
            String pass2 = Encoding.UTF8.GetString(HttpServerUtility.UrlTokenDecode(b641));

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@idadmi", System.Data.SqlDbType.NVarChar).Value = id2;
            cmd.Parameters.Add("@pass", System.Data.SqlDbType.NVarChar).Value = pass2;
            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                admi = new Usuario();
                admi.cedula = reader.GetString(0);
                admi.contraseña = reader.GetString(1);
                admi.tipoCuenta = reader.GetString(2);
                admi.success = false;
            }
            reader.Close();
            if (admi != null)
            {
                if (admi.tipoCuenta.Equals("a") || admi.tipoCuenta.Equals("n"))
                {
                    admi.success = true;
                    admi.token = "Andresf12serviceBeach";
                    return admi;
                }
            }
            admi = new Usuario();
            admi.success = false;
            admi.cedula = "";
            admi.contraseña = "";
            admi.tipoCuenta = "";
            return admi;
        }
    }
}