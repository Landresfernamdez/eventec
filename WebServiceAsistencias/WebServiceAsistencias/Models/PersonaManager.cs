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

        public List<Persona> ObtenerPersonadeActividades(string id)
        {
            List<Persona> lista = new List<Persona>();

            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "select p.cedula,p.nombre,p.apellido1,p.apellido2,p.edad,p.direccion,p.estado from Persona as p inner join Persona_Actividades pa on p.cedula = pa.cedula and pa.idActividad=@id";

            SqlCommand cmd = new SqlCommand(sql, con);
 
            cmd.Parameters.Add("@id", System.Data.SqlDbType.NVarChar).Value = id;
        
            SqlDataReader reader = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
            while (reader.Read())
            {
                Persona persona = new Persona();
                persona.cedula = reader.GetString(0);
                persona.nombre = reader.GetString(1);
                persona.apellido1 = reader.GetString(2);
                persona.apellido2 = reader.GetString(3);
                persona.edad = reader.GetInt32(4);
                persona.direccion = reader.GetString(5); ;
                persona.estado = reader.GetString(6); ;

                lista.Add(persona);
            }
            reader.Close();
            return lista;
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
        public bool ActualizarPersona(Persona persona)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "UPDATE Persona SET nombre=@nombre,apellido1=@apellido1,apellido2=@apellido2,edad=@edad,direccion=@direccion WHERE cedula=@cedula";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@cedula", System.Data.SqlDbType.NVarChar).Value = persona.cedula;
            cmd.Parameters.Add("@nombre", System.Data.SqlDbType.NVarChar).Value = persona.nombre;
            cmd.Parameters.Add("@apellido1", System.Data.SqlDbType.NVarChar).Value = persona.apellido1;
            cmd.Parameters.Add("@apellido2", System.Data.SqlDbType.NVarChar).Value = persona.apellido2;
            cmd.Parameters.Add("@edad", System.Data.SqlDbType.NVarChar).Value = persona.edad;
            cmd.Parameters.Add("@direccion", System.Data.SqlDbType.NVarChar).Value = persona.direccion;
            int res = cmd.ExecuteNonQuery();
            con.Close();

            return (res == 1);
        }
        public bool EliminarPersona(PersonaActividad persona)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "EXEC EliminarPersona @id,@ida";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@id", System.Data.SqlDbType.NVarChar).Value = persona.cedula;
            cmd.Parameters.Add("@ida", System.Data.SqlDbType.NVarChar).Value = persona.idActividad;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
    }
}