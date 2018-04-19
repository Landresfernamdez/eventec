using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Text;
namespace WebServiceAsistencias.Models
{
    public class AdministradorManager
    {
        public string cadenaConexion = RouteConfig.cadenaConexion;
        
        public Usuario ObtenerAdmi(byte[] ida,byte[] pass)
        {
            Usuario admi = null;
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "SELECT a.cedula, p.contraseña,a.tipoCuenta from Usuarios as a inner join Persona as p on p.cedula=a.cedula and p.cedula=@idadmi and p.contraseña=@pass";

            String b64 = HttpServerUtility.UrlTokenEncode(ida);
            String id2 = Encoding.UTF8.GetString(HttpServerUtility.UrlTokenDecode(b64));
            String b641 = HttpServerUtility.UrlTokenEncode(pass);
            String pass2 = Encoding.UTF8.GetString(HttpServerUtility.UrlTokenDecode(b641));

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@idadmi", System.Data.SqlDbType.NVarChar).Value = id2;
            cmd.Parameters.Add("@pass", System.Data.SqlDbType.NVarChar).Value = pass2;
            SqlDataReader reader =cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

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
                if (admi.tipoCuenta.Equals("a"))
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
        public List<Persona> ObtenerAdministradores()
        {
            List<Persona> lista = new List<Persona>();

            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "SELECT p.nombre,p.apellido1,p.apellido2,p.direccion,p.cedula FROM Persona as p inner join Usuarios as u on p.cedula=u.cedula and u.tipoCuenta='m'";

            SqlCommand cmd = new SqlCommand(sql, con);

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                Persona persona = new Persona();
                persona.nombre = reader.GetString(0);
                persona.apellido1 = reader.GetString(1);
                persona.apellido2 = reader.GetString(2);
                persona.direccion = reader.GetString(3);
                persona.cedula = reader.GetString(4);
                lista.Add(persona);
            }
            reader.Close();
            return lista;
        }//Esta funcion accesa a la base de datos y asigna a un evento un administrador
        public bool AsignarEventosAdministrador(AdministradorEvento evt)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            //string sql = "INSERT INTO Evento(idEvento,nombre,descripcion,fechaInicio,fechaFinal) VALUES (@id,@name,@desc,@fechI,@fechF)";
            string sql = "EXEC AddAdmiEvent @cedula,@id_Evento";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@cedula", System.Data.SqlDbType.NVarChar).Value = evt.cedula;
            cmd.Parameters.Add("@id_Evento", System.Data.SqlDbType.NVarChar).Value = evt.idEvento;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
    }
}