using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class TopVentas
    {
        public int DocEntry {get;set;}
        public DateTime DocFecha {get;set;}
        public int Dias {get;set;}
        public decimal Neto {get;set;}
        public string EstadoOperativo {get;set;}
        
    }
}
