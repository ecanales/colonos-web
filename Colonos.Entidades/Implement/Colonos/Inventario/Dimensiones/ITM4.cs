using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class ITM4
    {
        public int FamiliaCode { get; set; }
        public string FamiliaNombre { get; set; }
        public Nullable<decimal> Margen { get; set; }
        public Nullable<decimal> DescVolumen { get; set; }
        public Nullable<decimal> Volumen { get; set; }
        public Nullable<decimal> FactorPrecio { get; set; }
    }
}
