using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Data.SqlClient;

namespace WebServiceAsistencias.Models
{
    public  class EdecanManager //Models views controllera  MVC4
    {
        public string cadenaConexion = RouteConfig.cadenaConexion;
        public Usuario  ObtenerEdecan(string id,string pass)
        {
            Usuario edecan = null;
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "SELECT a.cedula, a.contraseña,a.tipoCuenta from Usuarios as a where a.cedula=@idEdecan";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.Parameters.Add("@idEdecan", System.Data.SqlDbType.NVarChar).Value = id;

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                edecan = new Usuario();
                edecan.cedula = reader.GetString(0);
                edecan.contraseña = reader.GetString(1);
                edecan.tipoCuenta = reader.GetString(2);
            }
            reader.Close();
            if (edecan.contraseña.Equals(pass) && edecan.tipoCuenta.Equals("e"))
            {
                return edecan;
            }
            return null;
        }
        public Usuario ObtenerAdmi(string id, string pass)
        {
            Usuario admi = null;
            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "SELECT a.cedula, a.contraseña,a.tipoCuenta from Usuarios as a where a.cedula=@idAdmi";

            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.Parameters.Add("@idAdmi", System.Data.SqlDbType.NVarChar).Value = id;

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                admi = new Usuario();
                admi.cedula = reader.GetString(0);
                admi.contraseña = reader.GetString(1);
                admi.tipoCuenta = reader.GetString(2);
            }
            reader.Close();
            if (admi.contraseña.Equals(pass) && admi.tipoCuenta.Equals("e"))
            {
                return admi;
            }
            return null;
        }

    }
}