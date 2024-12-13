using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using Newtonsoft.Json;
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
    public partial class bandeja_pedidos : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtFechaFin.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtFechaIni.Text = DateTime.Now.ToString("yyyy-MM-dd"); //DateTime.Now.AddDays(-DateTime.Now.Day).AddDays(1).ToString("yyyy-MM-dd");
                User us = (User)HttpContext.Current.Session["us"];
                if(us!=null)
                {
                    CargarVendedores(us);
                }
                Consultar();
            }
        }

        protected void Consultar_Event(object sender, EventArgs e)
        {
            try
            {
                Consultar();
            }
            catch(Exception ex)
            {
                logger.Error(ex.Message);
                logger.Error(ex.StackTrace);
            }
        }

        private void CargarVendedores(User us)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);
            //var prop = mng.ListUsuarios("usuarios/list", "COMERCIAL", "GERENCIA");
            var prop = mng.ListUsuarios("usuarios/list", "");
            if (prop != null && prop.Any())
            {
                prop = prop.FindAll(x => x.VendedorDF != "");
                var json = JsonConvert.SerializeObject(prop);
                var list = JsonConvert.DeserializeObject<List<User>>(json);

                var listoper = new List<User>();

                //listoper.Add(new User { Usuario = "", Nombre = "" });

                foreach (var o in list)
                {
                    listoper.Add(o);
                }

                if ((us.EsSupervisor!=null && us.EsSupervisor=="S") || us.IdGrupo.Equals("ADMINISTRADOR") || us.IdGrupo.Equals("GERENCIA") || us.IdGrupo.Equals("COBRANZA"))
                {
                    listoper.Add(new Entidades.User { Nombre = "(TODOS)",VendedorDF = "" });
                }

                if(listoper.Find(x => x.Usuario== us.Usuario)==null)
                {
                    listoper.Add(new Entidades.User { Nombre = us.Nombre, VendedorDF = us.VendedorDF });
                }
                cboVendedor.DataSource = listoper.OrderBy(x => x.Nombre);
                cboVendedor.DataTextField = "Nombre";
                cboVendedor.DataValueField = "VendedorDF";
                cboVendedor.DataBind();
                cboVendedor.SelectedValue = us.VendedorDF;
                if (us.IdGrupo.Equals("ADMINISTRADOR") || us.IdGrupo.Equals("GERENCIA") || us.IdGrupo.Equals("COBRANZA"))
                {
                    cboVendedor.Enabled = true;
                }
                else
                {
                    cboVendedor.Enabled = false;
                }
            }
        }


        protected void Nuevo_Event(object sender, EventArgs e)
        {
            Nuevo();
        }

        protected void VerPedido_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string docEntry = (row.FindControl("lblDocEntry") as Label).Text;
            HttpContext.Current.Response.Redirect(String.Format("venta-pedido.aspx?docentry={0}", docEntry),true);
            //ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "venta-pedido", String.Format("window.open('venta-pedido.aspx?docentry={0}');", docEntry), true);
        }

        private void Nuevo()
        {
            HttpContext.Current.Response.Redirect("venta-pedido.aspx?nuevo=SI", true);
            //OnClientClick="window.open('venta-pedido.aspx?nuevo=SI')"

            //Page.ClientScript.RegisterStartupScript(this.GetType(), "OpenWindow", "window.open('venta-pedido.aspx','_newtab');", true);
        }

        protected void BuscarPedidoNav_Event(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["usuario"] == null)
            {
                HttpContext.Current.Response.Redirect("/login.aspx", false);
            }
            if (HttpContext.Current.Session["us"] != null)
            {
                User us = (User)HttpContext.Current.Session["us"];
                if (us != null)
                {
                    string vendedorcode = cboVendedor.SelectedValue;
                    BusquedaPedidos(txtBuscar.Text, vendedorcode, us.Usuario);
                }
            }
        }

        private void BusquedaPedidos(string palabras, string vendedorcode, string usuario)
        {
            if (palabras.Trim().Length > 0)
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
                var list = mng.Search("documentos/search", palabras, vendedorcode, 10, usuario); //indicar vendedorcode segun el perfil de usuario
                gvBandeja.DataSource = list;
                gvBandeja.DataBind();
            }
            
        }
        private void Consultar()
        {
            try
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
                var list = mng.ListPedidos("documentos/list", 10, "", "", -1, cboVendedor.SelectedValue, txtFechaIni.Text, txtFechaFin.Text);
                lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
                gvBandeja.DataSource = list;
                gvBandeja.DataBind();
            }
            catch (Exception ex)
            {
                logger.Error(ex.Message);
                logger.Error(ex.StackTrace);
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
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.ListPedidos("documentos/list", 10, "", "", -1,cboVendedor.SelectedValue,txtFechaIni.Text,txtFechaFin.Text);
            var list2 = Utility.DynamicSort1<DocumentosResult>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }

        
    }
}