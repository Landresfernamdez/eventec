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


    }
}