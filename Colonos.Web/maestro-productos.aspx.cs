using Colonos.Entidades;
using Colonos.Entidades.Defontana;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web.maestros
{
    public partial class maestro_productos : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                CargaPropiedades();
            }
        }

        protected void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
        }
        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var url = String.Format("productos?activo={0}", chkActivos.Checked ? "S" : "");
            var list = mng.List(url);

            if (list != null)
            {
                gvList.DataSource = list;
                gvList.Caption = String.Format("Registros encontrados: {0}", list.Count());
                gvList.DataBind();
            }

            Session["productossearch"] = list;
        }

        protected void Guardar_Event(object sender, EventArgs e)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            //if (txtItemCode.Text.Trim().Length > 0)
            if (true)
            {

                Producto item=null;
                bool nuevo = false;
                if (txtItemCode.Text.Trim().Length == 0)
                {
                    if(cboDFCat.SelectedItem.Text.Trim().Length==0 || cboDFSubCat.SelectedItem.Text.Trim().Length == 0 || cboFamilia.SelectedItem.Text.Trim().Length==0)
                    {
                        var mensaje = cboFamilia.SelectedItem.Text.Trim().Length == 0 ? "Debe seleccionar una Familia" : "Debe seleccionar una categoría y suncategoría Defontana";
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                        if(cboFamilia.SelectedItem.Text.Trim().Length == 0)
                        {
                            cboFamilia.Focus();
                        }
                        else
                        {
                            cboDFCat.Focus();
                        }
                        return;
                    }
                }
                
                if (txtItemCode.Text.Trim().Length>0)
                {
                    item = mng.Get("productos", txtItemCode.Text);
                }
                if (item == null || item.ProdCode==null) //producto no existente
                {
                    item = new Producto();
                    nuevo = true;
                    item.ProdCode = String.Format("{0}", cboDFSubCat.SelectedValue);                    
                }
                item.ProdNombre = txtItemName.Text;
                item.FormatoVtaCode = Convert.ToInt32(cboFormatoVenta.SelectedValue);
                item.RefrigeraCode = Convert.ToInt32(cboRefigeracion.SelectedValue);
                item.Activo = chkActivo.Checked ? "S" : "N";
                item.AnimalCode = Convert.ToInt32(cboAnimal.SelectedValue);
                item.CategoriaCode = cboCategoria.SelectedValue;
                item.FamiliaCode = Convert.ToInt32(cboFamilia.SelectedValue);
                item.FormatoCode = Convert.ToInt32(cboFormato.SelectedValue);
                item.MarcaCode = Convert.ToInt32(cboMarca.SelectedValue);
                item.Medida = cboUmedida.SelectedValue;
                item.OrigenCode = Convert.ToInt32(cboProcedencia.SelectedValue);
                item.SocioCode = txtProveedor.Text;
                item.TipoCode = cboTipo.SelectedValue;
                item.EsDesglose = chkDesglose.Checked ? "S" : "N"; 
                item.TieneReceta= chkTieneReceta.Checked ? "S" : "N";
                if (txtCosto.Text.Trim().Length == 0)
                    txtCosto.Text = "0";
                item.Costo =Convert.ToDecimal(txtCosto.Text);

                try
                {
                    var prodreturn = mng.Guardar("productos", item, nuevo);
                    if (prodreturn != null && prodreturn.ProdCode != null)
                    {
                        var mensaje = String.Format("Producto creado: {0}", prodreturn.ProdCode);
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                        BuscarProductos(prodreturn.ProdCode);
                        popupProducto.Hide();
                    }
                }
                catch(Exception ex)
                {
                    var mensaje = ex.Message;
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                }
            }
        }

        protected void ClosePopup(object sender, EventArgs e)
        {
            popupProducto.Hide();
        }

        private void InicializaPopup()
        {
            txtItemCode.Text = "";
            txtItemName.Text = "";
            txtProveedor.Text = "";
            txtCosto.Text = "0";
            cboUmedida.SelectedValue = "0";
            cboCategoria.SelectedValue = "0";
            cboTipo.SelectedValue = "0";
            cboFamilia.SelectedValue = "0";
            cboAnimal.SelectedValue = "0";
            cboFormato.SelectedValue = "0";
            cboRefigeracion.SelectedValue = "0";
            cboFormatoVenta.SelectedValue = "0";
            cboMarca.SelectedValue = "0";
            cboProcedencia.SelectedValue = "0";
            chkActivo.Checked = false;
            chkDesglose.Checked = false;    
            chkTieneReceta.Checked = false;
        }
        protected void Nuevo_Event(object sender, EventArgs e)
        {
            
            txtItemCode.ReadOnly = true;
            lblTituloPopup.Text = "Producto (Nuevo)";
            InicializaPopup();
            CargaCategoriaDF();
            popupProducto.Show();
        }

        
        private void CargaPropiedades()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var prop=mng.Propiedades("productos/propiedades");
            if(prop!=null)
            {
                var json = JsonConvert.SerializeObject(prop.umedidas);
                var itm1 = JsonConvert.DeserializeObject<List<ITM1>>(json);
                cboUmedida.DataSource = itm1;
                cboUmedida.DataTextField = "MedidaNombre";
                cboUmedida.DataValueField = "MedidaCode";
                cboUmedida.SelectedValue= "0";
                cboUmedida.DataBind();

                json = JsonConvert.SerializeObject(prop.categorias);
                var itm2 = JsonConvert.DeserializeObject<List<ITM2>>(json);
                cboCategoria.DataSource = itm2;
                cboCategoria.DataTextField = "CategoriaNombre";
                cboCategoria.DataValueField = "CategoriaCode";
                cboCategoria.SelectedValue = "0";
                cboCategoria.DataBind();

                json = JsonConvert.SerializeObject(prop.tipos);
                var itm3 = JsonConvert.DeserializeObject<List<ITM3>>(json);
                cboTipo.DataSource = itm3;
                cboTipo.DataTextField = "TipoNombre";
                cboTipo.DataValueField = "TipoCode";
                cboTipo.SelectedValue = "0";
                cboTipo.DataBind();

                json = JsonConvert.SerializeObject(prop.familias);
                var itm4 = JsonConvert.DeserializeObject<List<ITM4>>(json);
                cboFamilia.DataSource = itm4;
                cboFamilia.DataTextField = "FamiliaNombre";
                cboFamilia.DataValueField = "FamiliaCode";
                cboFamilia.SelectedValue = "0";
                cboFamilia.DataBind();

                json = JsonConvert.SerializeObject(prop.animales);
                var itm5 = JsonConvert.DeserializeObject<List<ITM5>>(json);
                cboAnimal.DataSource = itm5;
                cboAnimal.DataTextField = "AnimalNombre";
                cboAnimal.DataValueField = "AnimalCode";
                cboAnimal.SelectedValue = "0";
                cboAnimal.DataBind();

                json = JsonConvert.SerializeObject(prop.formatos);
                var itm6 = JsonConvert.DeserializeObject<List<ITM6>>(json);
                cboFormato.DataSource = itm6;
                cboFormato.DataTextField = "FormatoNombre";
                cboFormato.DataValueField = "FormatoCode";
                cboFormato.SelectedValue = "0";
                cboFormato.DataBind();

                json = JsonConvert.SerializeObject(prop.refrigeracion);
                var itm7 = JsonConvert.DeserializeObject<List<ITM7>>(json);
                cboRefigeracion.DataSource = itm7;
                cboRefigeracion.DataTextField = "RefrigeraNombre";
                cboRefigeracion.DataValueField = "RefrigeraCode";
                cboRefigeracion.SelectedValue = "0";
                cboRefigeracion.DataBind();

                json = JsonConvert.SerializeObject(prop.formatoventa);
                List<ITM8> itm8 = JsonConvert.DeserializeObject<List<ITM8>>(json);
                cboFormatoVenta.DataSource = itm8.OrderBy(x => x.FrmtoVentaCaption);
                cboFormatoVenta.DataTextField = "FrmtoVentaCaption";
                cboFormatoVenta.DataValueField = "FrmtoVentaCode";
                cboFormatoVenta.SelectedValue = "0";
                cboFormatoVenta.DataBind();

                json = JsonConvert.SerializeObject(prop.marcas);
                var itm9 = JsonConvert.DeserializeObject<List<ITM9>>(json);
                cboMarca.DataSource = itm9;
                cboMarca.DataTextField = "MarcaNombre";
                cboMarca.DataValueField = "MarcaCode";
                cboMarca.SelectedValue = "0";
                cboMarca.DataBind();

                json = JsonConvert.SerializeObject(prop.origen);
                var itm10 = JsonConvert.DeserializeObject<List<ITM10>>(json);
                cboProcedencia.DataSource = itm10;
                cboProcedencia.DataTextField = "OrigenNombre";
                cboProcedencia.DataValueField = "OrigenCode";
                cboProcedencia.SelectedValue = "0";
                cboProcedencia.DataBind();


                

                try
                {


                    json = JsonConvert.SerializeObject(prop.categoriasDF);
                    var carDF = JsonConvert.DeserializeObject<itemsCategorias>(json);
                    HttpContext.Current.Session["CatergoriasDF"] = carDF;
                }
                catch
                {

                }
            }
            
        }
        protected void Editar_Event(object sender, EventArgs e)
        {
            InicializaPopup();

            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string prodcode = (row.FindControl("lblProdCode") as LinkButton).Text;
            txtItemCode.Text = prodcode;
            txtItemCode.ReadOnly = true;
            //Consultar Producto
            GetProducto(prodcode);
            lblTituloPopup.Text = "Producto (Editar)";

            //CargaCategoriaDF();
            divcatDF.Attributes.Add("class", "opacity-0");
            popupProducto.Show();
        }

        private void CargaCategoriaDF()
        {
            divcatDF.Attributes.Add("class", "row opacity-100");
            var catDF = (itemsCategorias)HttpContext.Current.Session["CatergoriasDF"];
            catDF.items.Add(new item { code = "", description = "" });
            cboDFCat.DataSource = catDF.items.ToList();
            cboDFCat.DataTextField = "description";
            cboDFCat.DataValueField = "code";
            cboDFCat.DataBind();
            cboDFCat.Text = "";

            cboDFSubCat.DataSource = new List<chield>();
            cboDFSubCat.DataBind();
        }

        protected void CargaSubCatDF_Event(object sender, EventArgs e)
        {
            
            var catsel = cboDFCat.SelectedValue;
            var catDF = (itemsCategorias)HttpContext.Current.Session["CatergoriasDF"];
            var subcat = catDF.items.Find(x => x.code == catsel);
            cboDFSubCat.DataSource = subcat.childs;
            cboDFSubCat.DataTextField = "description";
            cboDFSubCat.DataValueField = "code";
            cboDFSubCat.DataBind();

        }
        protected void Buscar_Event(object sender, EventArgs e)
        {
            //if(txtBuscar.Text.Trim().Length>0)
            //{
                BuscarProductos(txtBuscar.Text);
            //}
        }
        protected void BuscarProductos(string palabras)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var list = mng.ProductoSearch("productos/search", palabras,"","S");

            if (list != null)
            {
                if(chkActivos.Checked)
                {
                    list = list.FindAll(x => x.Activo == "S");
                }

                gvList.DataSource = list;
                gvList.Caption = String.Format("Registros encontrados: {0}", list.Count());
                gvList.DataBind();
            }

            Session["productossearch"] = list;
        }
        private void GetProducto(string prodcode)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var item=mng.Get("productos", prodcode);
            if(item!=null)
            {
                txtItemName.Text = item.ProdNombre;
                txtProveedor.Text = item.SocioCode ==null ? "" : item.SocioCode;
                cboAnimal.SelectedValue = item.AnimalCode==null ? "0" : item.AnimalCode.ToString();
                cboCategoria.SelectedValue = item.CategoriaCode ==null ? "0" : item.CategoriaCode.ToString();
                cboFamilia.SelectedValue = item.FamiliaCode==null ? "0" : item.FamiliaCode.ToString();
                cboFormato.SelectedValue = item.FormatoCode ==null ? "0":item.FormatoCode.ToString();
                cboFormatoVenta.SelectedValue = item.FormatoVtaCode == null ? "0" : item.FormatoVtaCode.ToString();
                cboMarca.SelectedValue = item.MarcaCode==null ? "0" : item.MarcaCode.ToString();
                cboProcedencia.SelectedValue = item.OrigenCode==null ? "0" : item.OrigenCode.ToString();
                cboRefigeracion.SelectedValue = item.RefrigeraCode ==null ? "0" : item.RefrigeraCode.ToString();
                cboTipo.SelectedValue = item.TipoCode == null ? "0" : item.TipoCode;
                cboUmedida.SelectedValue = item.Medida==null ? "0" : item.Medida;
                chkActivo.Checked = item.Activo == "S" ? true : false;
                chkDesglose.Checked = item.EsDesglose == "S" ? true : false;
                chkTieneReceta.Checked = item.TieneReceta == "S" ? true : false;
                if (item.Costo == null)
                    item.Costo = 0;
                txtCosto.Text = String.Format("{0:N0}", item.Costo);
            }
        }

            /// <summary>
            /// /////////////////////////////////////////////////////////////////////////
            /// </summary>
            private const string ASCENDING = "ASC";
            private const string DESCENDING = "DESC";
            public SortDirection GridViewSortDirection
            {
                get
                {
                    if (ViewState["sortDirection"] == null)
                        ViewState["sortDirection"] = SortDirection.Ascending;

                    return (SortDirection)ViewState["sortDirection"];
                }
                set
                {
                    ViewState["sortDirection"] = value;
                }
            }
            protected void gvBandeja_Sorting(object sender, GridViewSortEventArgs e)
            {
                string sortExpression = e.SortExpression;


                if (GridViewSortDirection == SortDirection.Ascending)
                {
                    GridViewSortDirection = SortDirection.Descending;
                    SortGridView(sortExpression, DESCENDING);
                }
                else
                {
                    GridViewSortDirection = SortDirection.Ascending;
                    SortGridView(sortExpression, ASCENDING);
                }
            }

            private void SortGridView(string sortExpression, string direction)
            {
                //string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                //var mng = new ManagerInformes(urlbase, logger);
                //var url = "informes/controlprecios";
                //var list = mng.ControlPrecios(url);

                var list = (List<ProductosResult>)Session["productossearch"];
                var list2 = Utility.DynamicSort1<ProductosResult>(list, sortExpression, direction);
                gvList.DataSource = list2;
                gvList.DataBind();

            }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["productossearch"] == null)
            {
                return;
            }
            List<ProductosResult> listGrilla = (List<ProductosResult>)HttpContext.Current.Session["productossearch"];
            if (listGrilla.Count > 0)
            {

                string nombrearcivo = String.Format("MaesrtroProductos {0:dd-MM-yyyy}.xls", DateTime.Now.Date);
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;filename=" + nombrearcivo);
                Response.Charset = "";
                this.EnableViewState = false;

                System.IO.StringWriter sw = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htw = new System.Web.UI.HtmlTextWriter(sw);


                gvListExport.DataSource = listGrilla;
                gvListExport.DataBind();
                htw.AddAttribute("charset", "UTF-8");
                htw.RenderBeginTag(HtmlTextWriterTag.Meta);

                gvListExport.RenderControl(htw);
                htw.RenderEndTag();
                Response.Write(sw.ToString());

                Response.End();
            }



        }

        protected void gvList_PageIndexChanging(Object sender, GridViewPageEventArgs e)
        {
            List<ProductosResult> listGrilla = (List<ProductosResult>)HttpContext.Current.Session["productossearch"];
            gvList.DataSource = listGrilla;
            gvList.PageIndex = e.NewPageIndex;
            gvList.DataBind();
        }
        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for */
        }

    }
}