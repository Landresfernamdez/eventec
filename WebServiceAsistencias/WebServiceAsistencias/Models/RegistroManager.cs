using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace WebServiceAsistencias.Models
{
    public class RegistroManager
    {
        public string cadenaConexion = RouteConfig.cadenaConexion;
        public bool InsertarRegistro(Registro regi)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "INSERT INTO regEntrada (idActividad,cedula,fecha,hora) VALUES (@id,@car,@fech,@hor)";
            SqlCommand cmd = new SqlCommand(sql,con);
            cmd.Parameters.Add("@id", System.Data.SqlDbType.NVarChar).Value = regi.idActividad;
            cmd.Parameters.Add("@car", System.Data.SqlDbType.NVarChar).Value = regi.cedula;
            cmd.Parameters.Add("@fech", System.Data.SqlDbType.NVarChar).Value = regi.fecha;
            cmd.Parameters.Add("@hor", System.Data.SqlDbType.NVarChar).Value = regi.hora;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
    }
}