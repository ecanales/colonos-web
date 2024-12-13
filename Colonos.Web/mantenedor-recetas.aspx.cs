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
    public partial class mantenedor_recetas : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                CargaRecetas();
            }
        }

        protected void CheckAllProductos(object sender, EventArgs e)
        {
            CheckBox chckheader = (CheckBox)gvResultado.HeaderRow.FindControl("checkbox2");
            foreach (GridViewRow row in gvResultado.Rows)
            {
                CheckBox chckrw = (CheckBox)row.FindControl("chkSeleccionado");
                if (chckheader.Checked == true)
                {
                    chckrw.Checked = true;

                }
                else
                {
                    chckrw.Checked = false;
                }

            }
        }

        private void CargaRecetas()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var list = mng.ProductoSearch("productos/search", "","S");

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

            string prodcode = (row.FindControl("lblProdCode") as LinkButton).Text;
            GetReceta(prodcode);
            btnBuscarProductos.Visible = false;
            HiddenFieldEsNuevo.Value = "N";
            popupProducto.Show();
        }


        protected void AddProductoSeleccionado(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["Lineasreceta"] == null)
            {
                HttpContext.Current.Session["Lineasreceta"] = new List<RecetaProductoList>();
            }
            var list = (List<RecetaProductoList>)HttpContext.Current.Session["Lineasreceta"];

            foreach (GridViewRow row in gvResultado.Rows)
            {
                if ((row.FindControl("chkSeleccionado") as CheckBox).Checked)
                {
                    string prodcode = (row.FindControl("lblProdCode") as LinkButton).Text;
                    string prodnombre = (row.FindControl("lblProdNombre") as Label).Text;
                    string costo = (row.FindControl("lblCosto") as Label).Text;
                    string stock = (row.FindControl("lblStock") as Label).Text;

                    if ((string)ViewState["HiddenFieldEsProdCode"] == "N")
                    {

                        if (list.Find(x => x.ProdCode == prodcode) == null)
                        {
                            list.Add(new RecetaProductoList { ProdCode = txtItemCode.Text, ProdNombreRef = prodnombre, ProdCodeRef = prodcode, Cantidad = 1, Costo = Convert.ToDecimal(costo.Replace(".", "")), Stock = Convert.ToDecimal(stock.Replace(".", "")) });

                        }
                    }
                }
            }
            HttpContext.Current.Session["Lineasreceta"] = list;
            gvReceta.DataSource = list;
            gvReceta.DataBind();
            popupBuscarProducto.Hide();
            popupProducto.Show();
        }
        protected void Select_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            if (HttpContext.Current.Session["Lineasreceta"] == null)
            {
                HttpContext.Current.Session["Lineasreceta"] = new List<RecetaProductoList>();
            }
            var list = (List<RecetaProductoList>)HttpContext.Current.Session["Lineasreceta"];

            //foreach (GridViewRow row in gvResultado.Rows)
            //{
            //    if ((row.FindControl("chkSeleccionado") as CheckBox).Checked)
            //    {
                    string prodcode = (row.FindControl("lblProdCode") as LinkButton).Text;
                    string prodnombre = (row.FindControl("lblProdNombre") as Label).Text;
                    string costo = (row.FindControl("lblCosto") as Label).Text;
                    string stock= (row.FindControl("lblStock") as Label).Text;

                    if ((string)ViewState["HiddenFieldEsProdCode"] == "N")
                    {

                        if (list.Find(x => x.ProdCode == prodcode) == null)
                        {
                            list.Add(new RecetaProductoList { ProdCode = txtItemCode.Text, ProdNombreRef = prodnombre, ProdCodeRef = prodcode, Cantidad = 1,Costo=Convert.ToDecimal(costo.Replace(".","")),Stock= Convert.ToDecimal(stock.Replace(".", ""))});

                        }
                    }
                    else if ((string)ViewState["HiddenFieldEsProdCode"] == "S")
                    {
                        txtItemCode.Text = prodcode;
                        txtItemName.Text = prodnombre;
                        popupBuscarProducto.Hide();
                        popupProducto.Show();
                    }
            //    }
            //}
            HttpContext.Current.Session["Lineasreceta"] = list;
            gvReceta.DataSource = list;
            gvReceta.DataBind();
            popupBuscarProducto.Hide();
            popupProducto.Show();
        }
        private void GetReceta(string prodcode)
        {
            HttpContext.Current.Session["Lineasreceta"] = null;

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var item = mng.GetReceta("recetas", prodcode);
            if (item != null)
            {
                txtItemCode.Text = item.ProdCode;
                txtItemName.Text = item.ProdNombre;
                if(item.Lineas.Any())
                {
                    gvReceta.DataSource = item.Lineas;
                    gvReceta.DataBind();
                    HttpContext.Current.Session["Lineasreceta"] = item.Lineas;
                }
            }
        }
        protected void ClosePopup(object sender, EventArgs e)
        {
            popupProducto.Hide();
        }

        protected void Nuevo_Event(object sender, EventArgs e)
        {
            HttpContext.Current.Session["Lineasreceta"] = null;
            txtItemCode.Text = "";
            txtItemName.Text = "";
            gvReceta.DataSource = null;
            gvReceta.DataBind();
            HiddenFieldEsNuevo.Value = "S";
            btnBuscarProductos.Visible = true;
            popupProducto.Show();
            
        }

        protected void Eliminar_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string prodcoderef = (row.FindControl("lblProdCodeRef") as Label).Text;
            var list = (List<RecetaProductoList>)HttpContext.Current.Session["Lineasreceta"];
            list.Remove(list.Find(x => x.ProdCodeRef == prodcoderef));
            gvReceta.DataSource = list;
            gvReceta.DataBind();
            HttpContext.Current.Session["Lineasreceta"] = list;
        }
        protected void Guardar_Event(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["Lineasreceta"] != null)
            {
                var list = (List<RecetaProductoList>)HttpContext.Current.Session["Lineasreceta"];
                RecetaProducto receta = new RecetaProducto { ProdCode = txtItemCode.Text, ProdNombre = txtItemName.Text, Lineas = new List<RecetaProductoList>() };
                foreach(var i in list)
                {
                    receta.Lineas.Add(new RecetaProductoList { ProdCode = receta.ProdCode, ProdCodeRef = i.ProdCodeRef, ProdNombreRef = i.ProdNombreRef, Cantidad = i.Cantidad });

                }
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerInventario mng = new ManagerInventario(urlbase, logger);
                bool nuevo = HiddenFieldEsNuevo.Value == "S" ? true : false;
                mng.Guardar("recetas", receta, nuevo);
                popupProducto.Hide();
            }

        }

        protected void Buscar_Event(object sender, EventArgs e)
        {
            if (txtBuscar.Text.Trim().Length > 0)
            {
                BuscarRecetas(txtBuscar.Text);
            }
        }
        protected void BuscarRecetas(string palabras)
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
                            list = list.FindAll(x => x.Tipo=="B").ToList();
                        }
                        else
                        {
                            list = list.FindAll(x => x.Tipo == "A").ToList();
                        }
                        list = list.FindAll(x => x.Activo == "S").ToList();
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

            btnAgregar.Visible = true;
            HiddenFieldEsProdCode.Value = "N";
            ViewState["HiddenFieldEsProdCode"] = "N";
            popupProducto.Hide();
            gvResultado.DataSource = null;
            gvResultado.Caption = "";
            gvResultado.DataBind();
            popupBuscarProducto.Show();
        }

        protected void BuscarProductoReceta_Event(object sender, EventArgs e)
        {
            btnAgregar.Visible = false;
            HiddenFieldEsProdCode.Value = "S";
            ViewState["HiddenFieldEsProdCode"] = "S";
            popupProducto.Hide();
            gvResultado.DataSource = null;
            gvResultado.Caption = "";
            gvResultado.DataBind();
            popupBuscarProducto.Show();
        }

        protected void ClosePopupBusqueda(object sender, EventArgs e)
        {
            popupBuscarProducto.Hide();
            popupProducto.Show();
        }
    }
}