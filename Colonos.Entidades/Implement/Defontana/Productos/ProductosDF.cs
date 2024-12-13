using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades.Defontana
{
    public  class ProductosDF
    {

        public string active {get;set;}
        public string code {get;set;}
        public string externalCode { get; set; }
        public string internalCode { get; set; }
        public string name { get; set; }
        public string detailedDescription { get; set; }
        public string comment { get; set; }
        public string companyID { get; set; }
        public string categoryID { get; set; }
        public string coinID { get; set; }
        public decimal sellPrice { get; set; }
        public decimal stock { get; set; }
        public string type { get; set; }
        public string unit { get; set; }
        public string imptoAd { get; set; }
        public string idImptoAd { get; set; }
        public bool usesLotes { get; set; }
        public bool usesSeries { get; set; }
        public List<ProductosDF_stockDetail> stockDetail { get; set; }

    }
}
