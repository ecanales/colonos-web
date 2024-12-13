using Colonos.Entidades;
using Colonos.Manager;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class maestro_precio_fijo : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargaPreciosFijos();
            }
        }

        private void CargaPreciosFijos()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerPrecioFijos mng = new ManagerPrecioFijos(urlbase, logger);
            var list = mng.List("preciofijo/list");

            if (list != null)
            {
                gvList.DataSource = list;
                gvList.Caption = String.Format("Registros encontrados: {0}", list.Count());
                gvList.DataBind();
            }
        }

        protected void Editar_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string prodcode = (row.FindControl("lblListaCode") as LinkButton).Text;
            GetListaPrecioFijo(prodcode);
            //btnBuscarProductos.Visible = false;
            HiddenFieldEsNuevo.Value = "N";
            popupProducto.Show();
        }

        protected void Select_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string prodcode = (row.FindControl("lblProdCode") as LinkButton).Text;
            string prodnombre = (row.FindControl("lblProdNombre") as Label).Text;
            string familia = (row.FindControl("lblFamiliaNombre") as Label).Text;
            string origen = (row.FindControl("lblOrigenNombre") as Label).Text;
            string costo = (row.FindControl("lblCosto") as Label).Text.Replace(".","").Trim();
            string precionormal = (row.FindControl("lblPrecioUnitario") as Label).Text.Replace(".", "").Replace("$", "");

            //string margen = (row.FindControl("lblMargen") as Label).Text.Replace("%","").Trim();
            //string precio = (row.FindControl("lblPrecio") as Label).Text.Replace(".", "").Trim();

            if ((string)ViewState["HiddenFieldEsProdCode"] == "N")
            {
                if (HttpContext.Current.Session["Lineaspreciofijo"] == null)
                {
                    HttpContext.Current.Session["Lineaspreciofijo"] = new List<ListaPrecioFijoList>();
                }

                var list = (List<ListaPrecioFijoList>)HttpContext.Current.Session["Lineaspreciofijo"];
                if (list.Find(x => x.ProdCode == prodcode) == null)
                {
                    list.Add(new ListaPrecioFijoList { 
                        ProdCode = prodcode, 
                        ProdNombre = prodnombre,
                        Desde = Convert.ToDateTime(txtDesde.Text),
                        Hasta = Convert.ToDateTime(txtHasta.Text),
                        FamiliaNombre = familia,
                        OrigenNombre = origen,
                        ListaCode = txtItemCode.Text,
                        Costo = Convert.ToDecimal(costo),
                        PrecioNormal= Convert.ToDecimal(precionormal)
                        //Precio = Convert.ToDecimal(precio),
                        //Margen = Convert.ToDecimal(precio) != 0 ? (Convert.ToDecimal(precio) - Convert.ToDecimal(costo))/ Convert.ToDecimal(precio):0,
                    });

                    HttpContext.Current.Session["Lineaspreciofijo"] = list;
                    gvListaPrecioFijo.DataSource = list;
                    gvListaPrecioFijo.DataBind();
                    popupBuscarProducto.Hide();
                    popupProducto.Show();
                }
            }
            else if ((string)ViewState["HiddenFieldEsProdCode"] == "S")
            {
                txtItemCode.Text = prodcode;
                txtItemName.Text = prodnombre;
                popupBuscarProducto.Hide();
                popupProducto.Show();
            }
        }

        private void GetListaPrecioFijo(string listacode)
        {
            HttpContext.Current.Session["Lineaspreciofijo"] = null;

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerPrecioFijos mng = new ManagerPrecioFijos(urlbase, logger);
            var item = mng.Get("preciofijo", listacode);
            if (item != null && item.ListaCode != null && item.ListaNombre != null)
            {
                txtItemCode.Text = item.ListaCode;
                txtItemName.Text = item.ListaNombre;
                txtDesde.Text = String.Format("{0:yyyy-MM-dd}", item.Desde);
                txtHasta.Text = String.Format("{0:yyyy-MM-dd}", item.Hasta);

                btnEliminar.Visible = true;
                chkEliminar.Visible = true;
                lblEliminar.Visible = true;

                if (item.Lineas.Any())
                {
                    gvListaPrecioFijo.DataSource = item.Lineas;
                    gvListaPrecioFijo.DataBind();
                    HttpContext.Current.Session["Lineaspreciofijo"] = item.Lineas;
                }
            }
        }

        protected void ClosePopup(object sender, EventArgs e)
        {
            popupProducto.Hide();
        }

        protected void Nuevo_Event(object sender, EventArgs e)
        {
            HttpContext.Current.Session["Lineaspreciofijo"] = null;
            txtItemCode.Text = "";
            txtItemName.Text = "";
            txtItemCode.ReadOnly = false;
            txtItemName.ReadOnly = false;
            txtDesde.ReadOnly = false;
            txtHasta.ReadOnly=false;
            btnEliminar.Visible = false;
            chkEliminar.Visible = false;
            lblEliminar.Visible = false;

            gvListaPrecioFijo.DataSource = null;
            gvListaPrecioFijo.DataBind();
            HiddenFieldEsNuevo.Value = "S";
            //btnBuscarProductos.Visible = true;
            txtItemCode.Focus();
            popupProducto.Show();

        }

        protected void Eliminar_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string prodcoderef = (row.FindControl("lblProdCode") as Label).Text;
            var list = (List<ListaPrecioFijoList>)HttpContext.Current.Session["Lineaspreciofijo"];
            if (list != null && list.Any())
            {
                list.Remove(list.Find(x => x.ProdCode == prodcoderef));
                gvListaPrecioFijo.DataSource = list;
                gvListaPrecioFijo.DataBind();
                HttpContext.Current.Session["Lineasreceta"] = list;
            }
        }
        protected void Guardar_Event(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["Lineaspreciofijo"] != null)
            {
                ActualizarGrilla();
                var list = (List<ListaPrecioFijoList>)HttpContext.Current.Session["Lineaspreciofijo"];
                ListaPrecioFijo preciofijo = new ListaPrecioFijo { 
                    ListaCode =txtItemCode.Text,
                    ListaNombre=txtItemName.Text,
                    Desde= Convert.ToDateTime(txtDesde.Text),
                    Hasta= Convert.ToDateTime(txtHasta.Text), 
                    Lineas = new List<ListaPrecioFijoList>()
                };

                foreach (var i in list)
                {
                    preciofijo.Lineas.Add(new ListaPrecioFijoList {
                        ProdCode = i.ProdCode,
                        ProdNombre=i.ProdNombre,
                        Costo=i.Costo,
                        Desde = preciofijo.Desde,
                        Hasta = preciofijo.Hasta,
                        FamiliaNombre =i.FamiliaNombre,
                        ListaCode=preciofijo.ListaCode,
                        Margen=i.Margen,
                        OrigenNombre=i.OrigenNombre,
                        Precio=i.Precio,
                        PrecioNormal=i.PrecioNormal
                    });

                }
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerPrecioFijos mng = new ManagerPrecioFijos(urlbase, logger);
                bool nuevo = HiddenFieldEsNuevo.Value == "S" ? true : false;
                mng.Guardar("preciofijo", preciofijo, nuevo);
                popupProducto.Hide();
                CargaPreciosFijos();
            }

        }

        protected void Buscar_Event(object sender, EventArgs e)
        {
            if (txtBuscar.Text.Trim().Length > 0)
            {
                BuscarListaPrecioFijo(txtBuscar.Text);
            }
        }
        protected void BuscarListaPrecioFijo(string palabras)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var list = mng.ProductoSearch("recetas/search", palabras);

            if (list != null)
            {
                gvList.DataSource = list;
                gvList.Caption = String.Format("Registros encontrados: {0}", list.Count());
                gvList.DataBind();
            }
        }

        protected void Cargaprod(object sender, EventArgs e)
        {
            if (txtPalabrasProducto.Text.Length > 0)
            {
                string palabras = txtPalabrasProducto.Text;
                if (palabras.Trim().Length > 0)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerInventario mng = new ManagerInventario(urlbase, logger);
                    var list = mng.ProductoSearch("productos/search", palabras);

                    if (list != null)
                    {
                        list = list.FindAll(x => x.Activo == "S").ToList();
                        if (ViewState["HiddenFieldEsProdCode"].ToString() == "S")
                        {
                            list = list.FindAll(x => x.Tipo == "B").ToList();
                        }
                        else
                        {
                            //list = list.FindAll(x => x.Tipo == "A").ToList();
                        }
                        //list = list.FindAll(x => x.Activo == "S").ToList();
                        gvResultado.DataSource = list;
                        gvResultado.Caption = String.Format("Registros encontrados: {0}", list.Count());
                        gvResultado.DataBind();
                        //HttpContext.Current.Session["palabrabusqueda"] = txtPalabrasProducto.Text;
                        //HttpContext.Current.Session["BusquedaProductos"] = list;
                    }
                }
            }
            popupBuscarProducto.Show();
        }

        protected void BuscarProducto_Event(object sender, EventArgs e)
        {
            try
            {
                var d = Convert.ToDateTime(txtDesde.Text);
                var h = Convert.ToDateTime(txtHasta.Text);
            }
            catch (Exception ex)
            {
                var mensaje = "Debe indicar un rango de fechas";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                return;
            }
            if (txtItemCode.Text.Trim().Length > 5 && txtItemName.Text.Trim().Length > 5)
            {
                HiddenFieldEsProdCode.Value = "N";
                ViewState["HiddenFieldEsProdCode"] = "N";
                popupProducto.Hide();
                gvResultado.DataSource = null;
                gvResultado.Caption = "";
                gvResultado.DataBind();
                popupBuscarProducto.Show();
            }
            else
            {
                var mensaje = "Debe indicar un nombre a la lista";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                return;
            }
        }

        protected void BuscarProductoReceta_Event(object sender, EventArgs e)
        {
            HiddenFieldEsProdCode.Value = "S";
            ViewState["HiddenFieldEsProdCode"] = "S";
            popupProducto.Hide();
            gvResultado.DataSource = null;
            gvResultado.Caption = "";
            gvResultado.DataBind();
            popupBuscarProducto.Show();
        }

        protected void Actualizar_Event(object sender, EventArgs e)
        {
            ActualizarGrilla();
        }


        private void ActualizarGrilla()
        {
            if (HttpContext.Current.Session["Lineaspreciofijo"] != null)
            {
                var list = (List<ListaPrecioFijoList>)HttpContext.Current.Session["Lineaspreciofijo"];
                foreach (GridViewRow row in gvListaPrecioFijo.Rows)
                {
                    //(row.FindControl("txtCantidad") as TextBox).Text = (row.FindControl("txtCantidad") as TextBox).Text.Replace(".", ",");
                    string prodcode = (row.FindControl("lblProdCode") as Label).Text;
                    string costo = (row.FindControl("lblCosto") as Label).Text.Replace("$", "").Replace(".", "").Trim();
                    string precio = (row.FindControl("lblPrecio") as TextBox).Text.Replace("$", "").Replace(".", "").Trim();
                    decimal margen = Convert.ToDecimal(costo) == 0 ? 0 : Math.Round((Convert.ToDecimal(precio) - Convert.ToDecimal(costo)) / Convert.ToDecimal(precio), 4);
                    (row.FindControl("lblMargen") as Label).Text = String.Format("{0:P1}", Convert.ToDecimal(margen));
                    list.Find(x => x.ProdCode == prodcode).Margen = margen;
                    list.Find(x => x.ProdCode == prodcode).Precio = Convert.ToDecimal(precio);
                    //list.Find(x => x.ProdCode == prodcode).Precio = Convert.ToDecimal(precio);
                }
                HttpContext.Current.Session["Lineaspreciofijo"] = list;
            }
        }

        protected void EliminarLista_Event(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["Lineaspreciofijo"] != null && chkEliminar.Checked)
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerPrecioFijos mng = new ManagerPrecioFijos(urlbase, logger);
                var item = mng.Delete("preciofijo", txtItemCode.Text);
                popupProducto.Hide();
                HttpContext.Current.Session["Lineaspreciofijo"] = null;
                CargaPreciosFijos();
                //if (item != null && item.ListaCode != null && item.ListaNombre != null)
                //{
                //    txtItemCode.Text = item.ListaCode;
                //    txtItemName.Text = item.ListaNombre;
                //    txtDesde.Text = String.Format("{0:yyyy-MM-dd}", item.Desde);
                //    txtHasta.Text = String.Format("{0:yyyy-MM-dd}", item.Hasta);

                //    if (item.Lineas.Any())
                //    {
                //        gvListaPrecioFijo.DataSource = item.Lineas;
                //        gvListaPrecioFijo.DataBind();
                //        HttpContext.Current.Session["Lineaspreciofijo"] = item.Lineas;
                //    }
                //    popupProducto.Hide();
                //}
            }
        }
        protected void ClosePopupBusqueda(object sender, EventArgs e)
        {
            popupBuscarProducto.Hide();
            popupProducto.Show();
        }
    }
}