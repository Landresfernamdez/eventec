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
        public List<Persona> ObtenerEdecanes()
        {
            List<Persona> lista = new List<Persona>();

            SqlConnection con = new SqlConnection(cadenaConexion);

            con.Open();

            string sql = "select * from Persona ";

            SqlCommand cmd = new SqlCommand(sql, con);

            SqlDataReader reader =
                cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

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
        public bool InsertarPersona(Persona per)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "INSERT INTO Persona(cedula,nombre,apellido1,apellido2,estado,edad,direccion) VALUES (@cedula,@nombre,@primerapellido,@segundoapellido,@estado,@edad,@direccion)";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@cedula", System.Data.SqlDbType.NVarChar).Value = per.cedula;
            cmd.Parameters.Add("@nombre", System.Data.SqlDbType.NVarChar).Value = per.nombre;
            cmd.Parameters.Add("@primerapelllido", System.Data.SqlDbType.NVarChar).Value = per.apellido1;
            cmd.Parameters.Add("@segundoapellido", System.Data.SqlDbType.NVarChar).Value = per.apellido2;
            cmd.Parameters.Add("@estado", System.Data.SqlDbType.NVarChar).Value = per.estado;
            cmd.Parameters.Add("@edad", System.Data.SqlDbType.NVarChar).Value = per.edad;
            cmd.Parameters.Add("@direccion", System.Data.SqlDbType.NVarChar).Value = per.direccion;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
        public bool InsertarEdecan(Usuario usua)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "INSERT INTO Usuario(cedula,contrasena,tipoCuenta) VALUES (@cedula,@contraseña,@tipoCuenta)";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@cedula", System.Data.SqlDbType.NVarChar).Value =usua.cedula;
            cmd.Parameters.Add("@contraseña", System.Data.SqlDbType.NVarChar).Value = usua.contraseña;
            cmd.Parameters.Add("@tipoCuenta", System.Data.SqlDbType.NVarChar).Value = usua.tipoCuenta;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
        public bool modificarEdecanActividades(string cedula,string idActividad)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "INSERT INTO Edecan_Actividades(cedula,idActividad)VALUES(@cedula,@idActividad)";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@cedula", System.Data.SqlDbType.NVarChar).Value =cedula ;
            cmd.Parameters.Add("@idActividad", System.Data.SqlDbType.NVarChar).Value = idActividad;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }
        public bool deleteEdecan(Persona per)
        {
            SqlConnection con = new SqlConnection(cadenaConexion);
            con.Open();
            string sql = "GO EXEC EliminarEdecan @ced";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.Add("@ced", System.Data.SqlDbType.NVarChar).Value = per.cedula;
            int res = cmd.ExecuteNonQuery();

            con.Close();

            return (res == 1);
        }

    }
}