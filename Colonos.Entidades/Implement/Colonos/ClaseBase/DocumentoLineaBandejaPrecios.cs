using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class DocumentoLineaBandejaPrecios:DocumentoLinea 
    {
        public string MotivoIngreso { get; set; }
        public Nullable<decimal> ValorSolicitado { get; set; }
        public Nullable<decimal> ValorRegla { get; set; }
        public Nullable<decimal> MargenRegla { get; set; }
    }
}
