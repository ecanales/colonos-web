using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class SCP12
    {
        public string code { get; set; }
        public string name { get; set; }
        public string type { get; set; }
        public Nullable<int> duesAmount { get; set; }
        public Nullable<int> daysBetweenPayments { get; set; }
    }
}
