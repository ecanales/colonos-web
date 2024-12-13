using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Colonos.Web.Models
{
    public class CartItem
    {
        public string ProdCode { get; set; }
        public string ProdNombre { get; set; }
        public decimal Disponible { get; set; }
        public string Tipo { get; set; }
        public string MarcaNombre { get; set; }
        public string MedidaNombre { get; set; }
        public string Origen { get; set; }
        public string RefrigeraNombre { get; set; }
        public string FrmtoVenta { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal PrecioVolumen { get; set; }
        public decimal Cantidad { get; set; }
        public decimal Precio { get; set; }
        public decimal Total { get; set; }
        public decimal Costo { get; set; }
        public decimal Volumen { get; set; }
        public int LineaItem { get; set; }
        public int DocLinea { get; set; }
        public decimal Margen { get; set; }
        public decimal FactorPrecio { get; set; }
        public decimal MargenRegla { get; set; }
        public string BodegaCode { get; set; }
        public int FormatoVtaCode { get; set; }
        public int FamiliaCode { get; set; }
        public int AnimalCode { get; set; }
        public string AnimalNombre { get; set; }
        public string FamiliaNombre { get; set; }
        public string FrmtoVentaNombre { get; set; }
        public int RefrigeraCode { get; set; }
        public int? OrigenCode { get; set; }
        public string OrigenNombre { get; set; }
        public int? MarcaCode { get; set; }
        public decimal CantidadAntarior { get; set; }
        public decimal? PrecioFijo { get; set; }
        public decimal StockToledo { get; set; }
        public decimal AsignadoToledo { get; set; }
    }
}