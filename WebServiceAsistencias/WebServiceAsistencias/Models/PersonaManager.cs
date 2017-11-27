using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
namespace WebServiceAsistencias.Models
{
    public class PersonaManager
    {
        public string cadenaConexion = RouteConfig.cadenaConexion;
        public Persona ObtenerPersona(string id)
        {
            Persona person = null;

            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "select p.cedula,p.nombre,p.apellido1,p.apellido2,p.edad,p.direccion,p.estado from Persona as p where p.cedula=@carne";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.Parameters.Add("@carne",System.Data.SqlDbType.NVarChar).Value = id;
            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                person = new Persona();
                person.cedula = reader.GetString(0);
                person.nombre = reader.GetString(1);
                person.apellido1 = reader.GetString(2);
                person.apellido2 = reader.GetString(3);
                person.edad = reader.GetInt32(4);
                person.direccion = reader.GetString(5);
                person.estado = reader.GetString(6);
            }
            reader.Close();
            return person;
        }
        public bool ActualizarEstudiante(Persona persona)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "UPDATE Persona SET estado=@estado WHERE cedula=@cedula";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@estado", System.Data.SqlDbType.NVarChar).Value = persona.estado;
            cmd.Parameters.Add("@cedula", System.Data.SqlDbType.NVarChar).Value = persona.cedula;
            
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
    }
}