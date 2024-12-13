using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class OITB
    {
        public string ProdCode { get; set; }
        public string BodegaCode { get; set; }
        public Nullable<decimal> Stock { get; set; }
        public Nullable<decimal> Asignado { get; set; }
        public Nullable<decimal> Ordenado { get; set; }
        public Nullable<decimal> Costo { get; set; }
    }
}
