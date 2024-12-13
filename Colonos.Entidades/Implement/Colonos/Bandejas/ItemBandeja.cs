using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class ItemBandeja
    {
        public int DocEntry {get;set;}
        public string BandejaCode {get;set;}
        public int DocLinea {get;set;}
        public bool Estado {get;set;}
        public DateTime FechaIngreso {get;set;}
        public string UsuarioCodeIngreso {get;set;}
        public string MotivoIngreso {get;set;}
        public DateTime? FechaAutorizado {get;set;}
        public bool Autorizado {get;set;}
        public string UsuarioCodeAutoriza {get;set;}
        public string MotivoRechazo {get;set;}
        public int? LineaItem {get;set;}
        public decimal? ValorSolicitado {get;set;}
        public decimal? ValorRegla { get; set; }
        public decimal? MargenRegla { get; set; }
    }
}
