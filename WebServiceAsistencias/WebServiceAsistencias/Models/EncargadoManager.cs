using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Text;
namespace WebServiceAsistencias.Models
{
    public class EncargadoManager
    {
        public string cadenaConexion = RouteConfig.cadenaConexion;
        
        public Usuario ObtenerEnc(byte[] idm,byte[] pass)
        {
            Usuario enc = null;
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "SELECT m.cedula, m.contraseña,m.tipoCuenta from Usuarios as m where m.cedula=@idenc and m.contraseña=@pass";
            
            String id2 = Encoding.UTF8.GetString(idm);
            String pass2 = Encoding.UTF8.GetString(pass);

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@idenc", System.Data.SqlDbType.NVarChar).Value = id2;
            cmd.Parameters.Add("@pass", System.Data.SqlDbType.NVarChar).Value = pass2;
            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                enc = new Usuario();
                enc.cedula = reader.GetString(0);
                enc.contraseña = reader.GetString(1);
                enc.tipoCuenta = reader.GetString(2);
                enc.success = false;
            }
            reader.Close();
            if (enc != null)
            {
                if (enc.tipoCuenta.Equals("m"))
                {
                    enc.success = true;
                    enc.token = "Andresf12serviceBeach";
                    return enc;
                }
            }
            enc = new Usuario();
            enc.success = false;
            enc.cedula = "";
            enc.contraseña = "";
            enc.tipoCuenta = "";
            return enc;
        }
    }
}