using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
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
    public partial class confirmar_rutas : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");

        protected void Page_Load(object sender, EventArgs e)
        {
            this.MaintainScrollPositionOnPostBack = true;

            if (!IsPostBack)
            {
                Refresh();
            }
            
        }

        protected void Filtrar_Event(object sender, EventArgs e)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.List("documentos/list", 14, "A");
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string scenariotoken = (row.FindControl("lblscenario_token") as Label).Text;
            string ruta = (row.FindControl("lblDescripcion") as LinkButton).Text;
            lblRutaSeleccionada.Text = ruta;
            list = list.FindAll(x => x.scenario_token == scenariotoken);
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.List("documentos/list", 14, "A");
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();

            var listrut = mng.List("documentos/list", 15, "A");
            gvRutas.DataSource = listrut;
            gvRutas.DataBind();

            HttpContext.Current.Session["listdetallerutas"] = list;
            lblRutaSeleccionada.Text = "";
        }

        protected void ClosePopupBandeja(object sender, EventArgs e)
        {
            popupDetalleBandeja.Hide();
        }
        protected void VerBandeja_Event(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string docentry = (row.FindControl("lblDocEntry") as Label).Text;
                string razonsocial = (row.FindControl("lblCliente") as Label).Text;
                CargaDetalleBandeja(Convert.ToInt32(docentry), razonsocial);
                popupDetalleBandeja.Show();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.StackTrace);
            }
        }

        private void CargaDetalleBandeja(int docentry, string razonsocial)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            LimpiaBandeja();
            //consultar pedido
            var pedido = mng.Consultar("documentos", docentry, 14);
            if (pedido != null)
            {
                HiddenFieldDocentry.Value = docentry.ToString();
                lblRazonSocion.Text = pedido.RazonSocial;
                txtRazonSocial.Text = pedido.RazonSocial;
                txtNumeroPedido.Text = pedido.DocEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtFechadeEntrega.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                txtVendedorPedido.Text = pedido.VendedorCode;
                chkRetiraCliente.Checked = Convert.ToBoolean(pedido.RetiraCliente);
                txtNeto.Text = String.Format("{0:N0}", pedido.Neto);
                txtIVA.Text = String.Format("{0:N0}", pedido.Iva);
                txtTotal.Text = String.Format("{0:N0}", pedido.Total);

                if (pedido.Lineas.Any())
                {
                    //foreach (var l in pedido.Lineas)
                    //{
                    //    l.TotalReal = l.CantidadReal * l.PrecioFinal;
                    //}
                    //var detalle = pedido.Lineas.FindAll(x => x.CantidadReal > 0).ToList();
                    gvDetalle.DataSource = pedido.Lineas; // detalle;
                    gvDetalle.DataBind();
                }
            }
        }

        protected void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
        }

        protected void CheckAll(object sender, EventArgs e)
        {
            CheckBox chckheader = (CheckBox)gvBandeja.HeaderRow.FindControl("checkbox2");
            foreach (GridViewRow row in gvBandeja.Rows)
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

        private void LimpiaBandeja()
        {

            txtRazonSocial.Text = "";
            txtNumeroPedido.Text = "";
            txtFechaPedido.Text = "";
            txtVendedorPedido.Text = "";
            HiddenFieldDocentry.Value = "";
            gvDetalle.DataSource = null;
            gvDetalle.DataBind();

        }

        protected void gvRutas_Sorting(object sender, GridViewSortEventArgs e)
        {

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

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {

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
            var list = mng.List("documentos/list", 14, "A");
            var list2 = Utility.DynamicSort1<DocumentosResult>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["listdetallerutas"] == null)
            {
                return;
            }
            List<DocumentosResult> listGrilla = (List<DocumentosResult>)HttpContext.Current.Session["listdetallerutas"];
            if (listGrilla.Count > 0)
            {

                string nombrearcivo = String.Format("BandejaLogistica {0:dd-MM-yyyy HH.mm}.xls", DateTime.Now);
                Response.Clear();
                Response.Buffer = true;
                //Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.ContentType = "application/vnd.ms-excel";
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


        protected void CerrarRuta_Event(object sender, EventArgs e)
        {
            var listsel = CargaRutasSeleccionadas();
            if (listsel.Any())
            {
                LimpiaCierre();
                gvCerrarRutas.DataSource = listsel;
                gvCerrarRutas.DataBind();
                popupCerrarRuta.Show();
            }
            //var listsel = new List<DocumentosResult>();

            //foreach (GridViewRow row in gvBandeja.Rows)
            //{
            //    if ((row.FindControl("chkSeleccionado") as CheckBox).Checked)
            //    {
            //        string docentry = (row.FindControl("lblDocEntry") as Label).Text;
            //        string pedido = (row.FindControl("lblPedido") as LinkButton).Text;
            //        string factura = (row.FindControl("lblFolioDF") as Label).Text;
            //        string cliente = (row.FindControl("lblCliente") as Label).Text;

            //        var doc = new DocumentosResult { DocEntry = Convert.ToInt32(docentry), Pedido = Convert.ToInt32(pedido), FolioDF = Convert.ToInt32(factura), RazonSocial = cliente };
            //        if (doc != null)
            //        {
            //            listsel.Add(doc);
            //        }

            //        if(listsel.Any())
            //        {
            //            gvCerrarRutas.DataSource = listsel;
            //            gvCerrarRutas.DataBind();
            //            popupCerrarRuta.Show();
            //        }
            //    }
            //}
        }

        private List<DocumentosResult> CargaRutasSeleccionadas()
        {
            var listsel = new List<DocumentosResult>();

            foreach (GridViewRow row in gvBandeja.Rows)
            {
                if ((row.FindControl("chkSeleccionado") as CheckBox).Checked)
                {
                    string docentry = (row.FindControl("lblDocEntry") as Label).Text;
                    string pedido = (row.FindControl("lblPedido") as LinkButton).Text;
                    string factura = (row.FindControl("lblFolioDF") as Label).Text;
                    string cliente = (row.FindControl("lblCliente") as Label).Text;

                    var doc = new DocumentosResult { DocEntry = Convert.ToInt32(docentry), Pedido = Convert.ToInt32(pedido), FolioDF = Convert.ToInt32(factura), RazonSocial = cliente };
                    if (doc != null)
                    {
                        listsel.Add(doc);
                    }

                    //if (listsel.Any())
                    //{
                    //    gvCerrarRutas.DataSource = listsel;
                    //    gvCerrarRutas.DataBind();
                    //    popupCerrarRuta.Show();
                    //}
                }
            }
            return listsel;
        }

        protected void GeneraRCT_Event(object sender, EventArgs e)
        {
            var listsel = CargaRutasSeleccionadas();
            if (listsel.Any())
            {
                LimpiaCierre();
                gvCerrarRutasRCTRCC.DataSource = listsel;
                gvCerrarRutasRCTRCC.DataBind();
                btnCerrarRutaRCT.Visible = true;
                btnCerrarRutaRCC.Visible = false;
                popupCerrarRutaRCTRCC.Show();
            }
        }

        protected void GeneraRCC_Event(object sender, EventArgs e)
        {
            var listsel = CargaRutasSeleccionadas();
            if (listsel.Any())
            {
                LimpiaCierre();
                gvCerrarRutasRCTRCC.DataSource = listsel;
                gvCerrarRutasRCTRCC.DataBind();
                btnCerrarRutaRCT.Visible = false;
                btnCerrarRutaRCC.Visible = true;
                popupCerrarRutaRCTRCC.Show();
            }
        }

        protected void CerrarRutaOK(object sender, EventArgs e)
        {
            CerrarRutas(gvCerrarRutas,"SI");
            popupCerrarRuta.Hide();
        }
        protected void CerrarRutaNO(object sender, EventArgs e)
        {
            CerrarRutas(gvCerrarRutas, "NO");
            popupCerrarRuta.Hide();
        }

        protected void CerrarRutaRCT(object sender, EventArgs e)
        {
            if (txtCustodio.Text.Trim().Length > 0)
            {
                CerrarRutas(gvCerrarRutasRCTRCC, "NO", txtCustodio.Text, "RCT");
                popupCerrarRutaRCTRCC.Hide();
            }
        }

        protected void CerrarRutaRCC(object sender, EventArgs e)
        {
            if (txtCustodio.Text.Trim().Length > 0)
            {
                CerrarRutas(gvCerrarRutasRCTRCC, "NO", txtCustodio.Text, "RCC");
                popupCerrarRutaRCTRCC.Hide();
            }
        }

        protected void ClosePopupCerrarRTC(object sender, EventArgs e)
        {
            popupCerrarRutaRCTRCC.Hide();
        }

        private void LimpiaCierre()
        {
            txtObservacionesCierre.Text = "";
            txtCustodio.Text = "";
            txtObservacionesCierreCustodio.Text = "";
        }
        private void CerrarRutas(GridView gv, string rutaexistosa, string custodio = "", string tipocustodio="")
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            try
            {
                List<Documento> items = new List<Documento>();
                foreach (GridViewRow row in gv.Rows)
                {
                    string docentry = (row.FindControl("lblDocEntry") as Label).Text;
                    var olog = mng.Consultar("documentos", Convert.ToInt32(docentry), 14);
                    olog.RutaExitosa = rutaexistosa;
                    olog.Custodio = custodio.ToUpper();
                    olog.TipoCustodio = tipocustodio;
                    olog.ObservacionesCierre = tipocustodio == "" ? txtObservacionesCierre.Text.ToUpper() : txtObservacionesCierreCustodio.Text.ToUpper();
                    olog.DocEstado = "C";
                    items.Add(olog);
                    
                }

                if(items.Any())
                {
                    mng.Actualizar("documentos/sets", items);
                }

                var mensaje = "Ruta Actualizada";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert2","closeLoading();false", true);
                
                Refresh();
            }
            catch(Exception ex)
            {
                logger.Error("CerrarRutas: {0}", ex.Message);
                logger.Error("CerrarRutas: {0}", ex.StackTrace);
            }
        }
        protected void ClosePopupCerrar(object sender, EventArgs e)
        {
            popupCerrarRuta.Hide();
        }
        

        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for */
        }
    }
}