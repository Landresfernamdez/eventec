using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebServiceAsistencias.Models
{
    public class ListaEA
    {
  
        public List<Evento> eventos = new List<Evento>();
        public List<Actividad> actividades = new List<Actividad>();
        public ListaEA()
        {
           
        }
        public ListaEA(List<Evento>e, List<Actividad>a)
        {
            actividades = a;
            eventos = e;
        }
        public void setEventos(List<Evento> n)
        {
            eventos = n;
        }
        public List<Evento> getEventos()
        {
            return eventos;
        }
        public void setActividades(List<Actividad> a)
        {
            actividades = a;
        }
        public List<Actividad> getActividades()
        {
            return actividades;
        }

    }
}