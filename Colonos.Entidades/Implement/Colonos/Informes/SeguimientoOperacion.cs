using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class SeguimientoOperacion
    {
        public int DocEntry { get; set; }
        public string VendedorCode { get; set; }
        public string DocEstado { get; set; }
        public string EstadoOperativo { get; set; }
        public string RazonSocial { get; set; }
        public Nullable<System.DateTime> DocFecha { get; set; }
        public Nullable<int> Credito { get; set; }
        public Nullable<int> Precio { get; set; }
        public Nullable<int> Toledo { get; set; }
        public Nullable<int> Produccion { get; set; }
        public Nullable<int> Facturacion { get; set; }
        public int Logistica { get; set; }
        public Nullable<System.DateTime> FechaEntrega { get; set; }
        public Nullable<decimal> Total { get; set; }
        public string CondicionDF { get; set; }
        public string Ventana { get; set; }
        public string ComunaNombre { get; set; }

        
    }
}
