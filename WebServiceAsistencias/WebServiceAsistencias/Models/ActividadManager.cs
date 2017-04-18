using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

using System.Data.SqlTypes;
namespace WebServiceAsistencias.Models
{
    public class ActividadManager
    {
        public string cadenaConexion = RouteConfig.cadenaConexion;
        public List<Actividad> ObtenerActividadesDeAnfitrion(string ida)
        {
            List<Actividad> lista = new List<Actividad>();
            
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "select a.idActividad,a.nombre,a.lugar,a.horaInicio,a.horaFinal,a.descripcion,a.fecha,a.cupo,a.duracion from Actividad a   inner join Eventos_Actividades as ea on ea.idEvento=@ida and a.idActividad=ea.idActividad";

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@ida", System.Data.SqlDbType.NVarChar).Value = ida;

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            while (reader.Read())
            {
                Actividad actividad = new Actividad();
                actividad.idActividad = reader.GetString(0);
                actividad.nombre = reader.GetString(1);
                actividad.lugar = reader.GetString(2);
                actividad.horaInicio = reader.GetTimeSpan(3).ToString();
                actividad.horaFinal = reader.GetTimeSpan(4).ToString();
                actividad.descripcion = reader.GetString(5).ToString();
                actividad.fecha = reader.GetDateTime(6).Date.ToString();
                actividad.cupo = reader.GetInt32(7);
                actividad.duracion = reader.GetTimeSpan(8).ToString();
                
                lista.Add(actividad);
            }
            reader.Close();
            return lista;
        }
        
        
        
    }
}