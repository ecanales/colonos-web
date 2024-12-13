using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Colonos.Web.Models
{
    public class SolicutudCart
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
        //public static readonly SolicutudCart Instance;
        // The static constructor is called as soon as the class is loaded into memory 
        public SolicutudCart()
        {
            // If the cart is not in the session, create one and put it there 
            // Otherwise, get it from the session 
            if (HttpContext.Current.Session["SolicutudCart"] == null)
            {
                //Instance = new SolicutudCart();
                //Instance.Items = new List<CartItem>();

                HttpContext.Current.Session["SolicutudCart"] = new SolicutudCart(1);
            }
            else
            {
                //Instance = (SolicutudCart)HttpContext.Current.Session["SolicutudCart"];
            }
        }

        public SolicutudCart GetInstance()
        {
            if (HttpContext.Current.Session["SolicutudCart"] == null)
                return new SolicutudCart(1);
            else
                return (SolicutudCart)HttpContext.Current.Session["SolicutudCart"];
        }

        public void SaveInstance(SolicutudCart carro)
        {
            HttpContext.Current.Session["SolicutudCart"] = carro;
        }

        // A protected constructor ensures that an object can't be created from outside 
        public SolicutudCart(int id) 
        {
            Costo = 0; DocEntry = 0; Items = new List<CartItem>(); Iva = 0;
            Margen = 0; Neto = 0; Total = 0;
        }
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

            Totalizar();
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
            HttpContext.Current.Session["SolicutudCart"] = null;
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