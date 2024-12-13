using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class sysGrupoAccesos
    {
        public Nullable<short> FK_MenuMain { get; set; }
        public Nullable<short> FK_MenuSubA { get; set; }
        public Nullable<short> FK_MenuSubB { get; set; }
        public string FK_Grupo { get; set; }
        public Nullable<bool> Acceso { get; set; }
        public int Id { get; set; }
    }
}
