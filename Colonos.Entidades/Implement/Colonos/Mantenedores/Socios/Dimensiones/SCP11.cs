using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class SCP11
    {
        public int Id { get; set; }
        public string SocioCode { get; set; }
        public string SocioNombre { get; set; }
        public string Documento { get; set; }
        public string Serie { get; set; }
        public Nullable<int> Numero { get; set; }
        public string Vencimiento { get; set; }
        public Nullable<decimal> V91 { get; set; }
        public Nullable<decimal> V90 { get; set; }
        public Nullable<decimal> V60 { get; set; }
        public Nullable<decimal> V30 { get; set; }
        public Nullable<decimal> Saldo { get; set; }
        public Nullable<decimal> Pedidos { get; set; }
    }
}
