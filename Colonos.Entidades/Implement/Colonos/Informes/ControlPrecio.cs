﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class ControlPrecio
    {
        public string ProdCode { get; set; }
        public string ProdNombre { get; set; }
        public string Tipo { get; set; }
        public string MedidaNombre { get; set; }
        public string FamiliaNombre { get; set; }
        public decimal Costo { get; set; }
        public string BodegaCode { get; set; }
        public decimal Stock { get; set; }
        public decimal Asignado { get; set; }
        public Nullable<decimal> Disponible { get; set; }
        public decimal DescVolumen { get; set; }
        public decimal Volumen { get; set; }
        public decimal Margen { get; set; }
        public Nullable<decimal> PrecioUnitario { get; set; }
        public Nullable<decimal> PrecioVolumen { get; set; }
        public decimal PrecioFijo { get; set; }
        public int PrecioMin { get; set; }
        public int PrecioProm { get; set; }
        public int PrecioMax { get; set; }
        public int KilosActual { get; set; }
        public int KilosPasada { get; set; }
        public int KiloSubPasada { get; set; }
        public string MarcaNombre { get; set; }
        public string OrigenNombre { get; set; }
        public int FamiliaCode { get; set; }
        public int OrigenCode { get; set; }
        public int MarcaCode { get; set; }

    }
}
