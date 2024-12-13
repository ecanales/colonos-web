using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class TopUltimosPrecios
    {
        public string Familia { get; set; }
        public Nullable<System.DateTime> Fecha { get; set; }
        public Nullable<double> Cantidad { get; set; }
        public Nullable<double> Precio { get; set; }
        public string TipoDoc { get; set; }
        public string Origen { get; set; }
        public string Marca { get; set; }
    }
}
