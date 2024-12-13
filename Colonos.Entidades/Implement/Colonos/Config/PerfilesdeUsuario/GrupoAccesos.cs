using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class GrupoAccesos
    {
        public int? IdMenu { get; set; }
        public string keyMenu { get; set; }
        public string CaptionMenu { get; set; }
        public int? IdSubMenuA { get; set; }
        public string keySubMenuA { get; set; }
        public string CaptionSubMenuA { get; set; }
        public bool? Acceso { get; set; }
        public string idGrupo { get; set; }
        public string Url { get; set; }
        public string icon { get; set; }
    }
}
