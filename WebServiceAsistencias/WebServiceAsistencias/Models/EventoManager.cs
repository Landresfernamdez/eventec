using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace WebServiceAsistencias.Models
{
    class EventoManager
    {

        public string cadenaConexion = RouteConfig.cadenaConexion;
        public  List<Event> ObtenerEvento(string id)
        {
            List<Event> lista = new List<Event>();

            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "select e.idEvento,e.nombre,e.descripcion,e.fechaInicio,e.fechaFinal from Evento e inner join Edecan_Eventos as ee on e.idEvento=ee.idEvento and ee.cedula=@id";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@id", System.Data.SqlDbType.NVarChar).Value = id;

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                Event evento = new Event();
                evento.idEvento = reader.GetString(0);
                evento.nombre = reader.GetString(1);
                try
                {
                    evento.descripcion = reader.GetString(2);
                }
                catch (Exception e)
                {
                    evento.descripcion = e.Message;
                }
                evento.fechaInicio = reader.GetDateTime(3).Date.ToString();
                evento.fechaFinal = reader.GetDateTime(4).Date.ToString();
                lista.Add(evento);
            }
            reader.Close();
            return lista;
        }
        public List<Event> ObtenerEventosAdministradores()
        {
            List<Event> lista = new List<Event>();

            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "EXEC TodosEventos";

            SqlCommand cmd = new SqlCommand(sql, con);

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                Event evento = new Event();
                evento.idEvento = reader.GetString(0);
                evento.nombre = reader.GetString(1);
                try
                {
                    evento.descripcion = reader.GetString(2);
                }
                catch (Exception e)
                {
                    evento.descripcion = e.Message;
                }
                evento.fechaInicio = reader.GetDateTime(3).Date.ToString();
                evento.fechaFinal = reader.GetDateTime(4).Date.ToString();
                lista.Add(evento);
            }
            reader.Close();
            return lista;
        }
        public List<Event> ObtenerEventosEncargados(String ID)
        {
            List<Event> lista = new List<Event>();

            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "  select * from Evento where Evento.idEvento=(select idEvento from Administradores_Eventos where Administradores_Eventos.cedula='"+ID+"');";

            SqlCommand cmd = new SqlCommand(sql, con);

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                Event evento = new Event();
                evento.idEvento = reader.GetString(0);
                evento.nombre = reader.GetString(1);
                try
                {
                    evento.descripcion = reader.GetString(2);
                }
                catch (Exception e)
                {
                    evento.descripcion = e.Message;
                }
                evento.fechaInicio = reader.GetDateTime(3).Date.ToString();
                evento.fechaFinal = reader.GetDateTime(4).Date.ToString();
                lista.Add(evento);
            }
            reader.Close();
            return lista;
        }
        public bool InsertarEvento(Eventofuser evt)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            //string sql = "INSERT INTO Evento(idEvento,nombre,descripcion,fechaInicio,fechaFinal) VALUES (@id,@name,@desc,@fechI,@fechF)";
            string sql = "EXEC AddEvents @cedula,@name,@desc,@fechI,@fechF";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@cedula", System.Data.SqlDbType.NVarChar).Value = evt.cedula;
            cmd.Parameters.Add("@name", System.Data.SqlDbType.NVarChar).Value = evt.nombre;
            cmd.Parameters.Add("@desc", System.Data.SqlDbType.NVarChar).Value = evt.descripcion;
            cmd.Parameters.Add("@fechI", System.Data.SqlDbType.NVarChar).Value = evt.fechaInicio;
            cmd.Parameters.Add("@fechF", System.Data.SqlDbType.NVarChar).Value = evt.fechaFinal;
            int res = cmd.ExecuteNonQuery();
    
            con.Close();

            return (res == 1);
        }
        public bool modificarEvento(Event evt)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "Update Evento set nombre=@name,descripcion = @desc,fechaInicio = @fechI,fechaFinal = @fechF where idEvento = @id;";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@id", System.Data.SqlDbType.NVarChar).Value = evt.idEvento;
            cmd.Parameters.Add("@name", System.Data.SqlDbType.NVarChar).Value = evt.nombre;
            cmd.Parameters.Add("@desc", System.Data.SqlDbType.NVarChar).Value = evt.descripcion;
            cmd.Parameters.Add("@fechI", System.Data.SqlDbType.NVarChar).Value = evt.fechaInicio;
            cmd.Parameters.Add("@fechF", System.Data.SqlDbType.NVarChar).Value = evt.fechaFinal;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
        public bool deleteEvento(Event evt)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "EXEC EliminarEvento @id";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@id", System.Data.SqlDbType.NVarChar).Value = evt.idEvento;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }


    }
}