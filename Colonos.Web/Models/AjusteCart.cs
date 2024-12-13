using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Colonos.Web.Models
{
    public class AjusteCart
    {
        public int DocEntry { get; set; }
        public List<CartItem> Items { get; private set; }

        public int Neto { get; set; }
        public int Iva { get; set; }
        public int Total { get; set; }
        public decimal? Costo { get; set; }
        public decimal? Margen { get; set; }

        #region Singleton Implementation ----------------------------------------
        // Readonly properties can only be set in initialization or in a constructor 
        public static readonly AjusteCart Instance;
        // The static constructor is called as soon as the class is loaded into memory 
        static AjusteCart()
        {
            // If the cart is not in the session, create one and put it there 
            // Otherwise, get it from the session 
            if (HttpContext.Current.Session["AjusteCart"] == null)
            {
                Instance = new AjusteCart();
                Instance.Items = new List<CartItem>();

                HttpContext.Current.Session["AjusteCart"] = Instance;
            }
            else
            {
                Instance = (AjusteCart)HttpContext.Current.Session["AjusteCart"];
            }
        }
        // A protected constructor ensures that an object can't be created from outside 
        protected AjusteCart() { }
        #endregion ----------------------------------------------------------------

        #region Item Modification Methods
        public void AddItem(CartItem newItem)
        {

            if (Items.Contains(newItem))
            {
                foreach (CartItem item in Items)

                {
                    if (item.Equals(newItem))
                    {
                        item.Cantidad += newItem.Cantidad;
                        return;
                    }
                }
            }
            else
            {
                //newItem.Cantidad = 1;
                Items.Add(newItem);
            }

            //Totalizar();
        }

        public void Clear()
        {
            Items = new List<CartItem>();
            DocEntry = 0;
            Neto = 0;
            Iva = 0;
            Total = 0;
            Costo = 0;
            Margen = 0;
            HttpContext.Current.Session["AjusteCart"] = null;
        }

        public void Totalizar()
        {
            int total = 0;
            int iva = 0;
            decimal piva = 0.19M;
            int neto = 0;
            decimal costo = 0;

            if (Items.Any())
            {
                foreach (var i in Items)
                {
                    i.Total = Math.Round(i.Cantidad * i.Precio, 0);
                    i.Margen = i.Precio == 0 ? 0 : (i.Precio - i.Costo) / i.Precio;
                    neto += Convert.ToInt32(i.Total);
                    costo += Math.Round(i.Cantidad * i.Costo, 0);
                }
            }

            iva = Convert.ToInt32(Math.Round(neto * piva, 0));
            total = neto + iva;
            Neto = neto;
            Iva = iva;
            Total = total;
            Costo = costo;
            Margen = costo == 0 ? 0 : (neto - costo) / neto;

        }
        #endregion
    }
}