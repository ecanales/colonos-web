using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class ParametrosGenerales
    {
        public int ParamCode { get; set; }
        public Nullable<decimal> Margen { get; set; }
        public Nullable<decimal> FactorPrecio { get; set; }
        public Nullable<decimal> DescVolumen { get; set; }
        public Nullable<decimal> Volumen { get; set; }
        public Nullable<decimal> Tolerancia { get; set; }
        public string BodegaProduccion { get; set; }
    }
}
