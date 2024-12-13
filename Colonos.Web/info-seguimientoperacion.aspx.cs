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
    public partial class info_seguimientoperacion : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtFechaFin.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtFechaIni.Text = DateTime.Now.AddDays(-10).ToString("yyyy-MM-dd");

                User us = (User)HttpContext.Current.Session["us"];
                if (us != null)
                {
                    CargarVendedores(us);
                }
                //Refresh();
            }
        }

        public void Refresh_Event(object sender, EventArgs e)
        {
            
            
            Refresh(cboVendedor.SelectedValue);
        }

        private void Refresh(string usuario)
        {
            
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            var mng = new ManagerInformes(urlbase, logger);
            var url = String.Format("informes/seguimientooperacion?usuario={0}&fechaini={1}&fechafin={2}", usuario, Convert.ToDateTime(txtFechaIni.Text).ToString("yyyMMdd"), Convert.ToDateTime(txtFechaFin.Text).ToString("yyyMMdd"));
            var list = mng.SeguimientoOperaciones(url);
            if(chkSoloAbiertos.Checked)
            {
                list = list.FindAll(x => x.DocEstado == "A").ToList();
            }
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
            Session["informesseguimientooperacion"] = list;
        }

        private void CargarVendedores(User us)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);
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

                if (us.IdGrupo.Equals("ADMINISTRADOR") || us.IdGrupo.Equals("GERENCIA") || us.IdGrupo.Equals("COBRANZA"))
                {
                    listoper.Add(new Entidades.User { Nombre = "(TODOS)", VendedorDF = "" });
                }
                if (listoper.Find(x => x.Usuario == us.Usuario) == null)
                {
                    listoper.Add(new Entidades.User { Nombre = us.Nombre,VendedorDF = us.VendedorDF });
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

        protected void gvBandeja_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState != DataControlRowState.Edit)
            {
                var backcolor= System.Drawing.Color.White;
                var valor = (e.Row.FindControl("lblCredito") as Label).Text;
                switch (valor)
                {
                    case "0":
                        backcolor = System.Drawing.Color.White;
                        break;
                    case "1":
                        backcolor = System.Drawing.Color.Orange;
                        break;
                    case "2":
                        backcolor = System.Drawing.Color.LightGreen;
                        break;
                }
                e.Row.Cells[6 + 5].BackColor = backcolor;
                backcolor = System.Drawing.Color.White;

                valor = (e.Row.FindControl("lblPrecio") as Label).Text;
                switch (valor)
                {
                    case "0":
                        backcolor = System.Drawing.Color.White;
                        break;
                    case "1":
                        backcolor = System.Drawing.Color.Orange;
                        break;
                    case "2":
                        backcolor = System.Drawing.Color.LightGreen;
                        break;
                }
                e.Row.Cells[7 + 5].BackColor = backcolor;
                backcolor = System.Drawing.Color.White;

                valor = (e.Row.FindControl("lblToledo") as Label).Text;
                switch (valor)
                {
                    case "0":
                        backcolor = System.Drawing.Color.White;
                        break;
                    case "1":
                        backcolor = System.Drawing.Color.Orange;
                        break;
                    case "2":
                        backcolor = System.Drawing.Color.LightGreen;
                        break;
                }
                e.Row.Cells[8 + 5].BackColor = backcolor;
                backcolor = System.Drawing.Color.White;

                valor = (e.Row.FindControl("lblProduccion") as Label).Text;
                switch (valor)
                {
                    case "0":
                        backcolor = System.Drawing.Color.White;
                        break;
                    case "1":
                        backcolor = System.Drawing.Color.Orange;
                        break;
                    case "2":
                        backcolor = System.Drawing.Color.LightGreen;
                        break;
                }
                e.Row.Cells[9+5].BackColor = backcolor;
                backcolor = System.Drawing.Color.White;

                valor = (e.Row.FindControl("lblFacturacion") as Label).Text;
                switch (valor)
                {
                    case "0":
                        backcolor = System.Drawing.Color.White;
                        break;
                    case "1":
                        backcolor = System.Drawing.Color.Orange;
                        break;
                    case "2":
                        backcolor = System.Drawing.Color.LightGreen;
                        break;
                }
                e.Row.Cells[10+5].BackColor = backcolor;
                backcolor = System.Drawing.Color.White;

                valor = (e.Row.FindControl("lblLogistica") as Label).Text;
                switch (valor)
                {
                    case "0":
                        backcolor = System.Drawing.Color.White;
                        break;
                    case "1":
                        backcolor = System.Drawing.Color.Orange;
                        break;
                    case "2":
                        backcolor = System.Drawing.Color.LightGreen;
                        break;
                }
                e.Row.Cells[11+5].BackColor = backcolor;
                backcolor = System.Drawing.Color.White;

                (e.Row.FindControl("lblCredito") as Label).ForeColor = System.Drawing.Color.Transparent;
                (e.Row.FindControl("lblPrecio") as Label).ForeColor = System.Drawing.Color.Transparent;
                (e.Row.FindControl("lblToledo") as Label).ForeColor = System.Drawing.Color.Transparent;
                (e.Row.FindControl("lblProduccion") as Label).ForeColor = System.Drawing.Color.Transparent;
                (e.Row.FindControl("lblFacturacion") as Label).ForeColor = System.Drawing.Color.Transparent;
                (e.Row.FindControl("lblLogistica") as Label).ForeColor = System.Drawing.Color.Transparent;
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

            var list = (List<SeguimientoOperacion>)Session["informesseguimientooperacion"];
            var list2 = Utility.DynamicSort1<SeguimientoOperacion>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }
    }
}