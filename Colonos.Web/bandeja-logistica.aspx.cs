using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class bandeja_logistica : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarVehiculos();
                Refresh();
                TotalItems.Text = "0";
                TotalItems.Visible = false;
                var listsel = (List<DocumentosResult>)HttpContext.Current.Session["listseleccionados"];
                if (listsel==null)
                {
                    TotalItems.Visible = false;
                    HttpContext.Current.Session["listseleccionados"] = null;
                }
                else if (listsel.Count>0)
                {
                    TotalItems.Text = listsel.Count.ToString();
                    TotalItems.Visible = true;
                }
                else
                {
                    TotalItems.Visible = false;
                    HttpContext.Current.Session["listseleccionados"] = null;
                }

            }
            //btnEnviar.Attributes["onchange"] = "GuardarArchivo(this)";
            //ClientScript.RegisterStartupScript(this.GetType(), "alert", "ShowPopup();", true);

        }

        private void CargarVehiculos()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerLogistica mng = new ManagerLogistica(urlbase, logger);
            var list = mng.ListVehiculos("vehiculos");
            cboVehiculo.DataSource = list;
            cboVehiculo.DataTextField = "code";
            cboVehiculo.DataValueField = "code";
            cboVehiculo.DataBind();
            cboVehiculo.SelectedValue = "";
        }
        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.List("documentos/list", 12, "A");
            list = list.FindAll(x => x.EstadoOperativo != "RUTA").ToList();
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();

            gvSeleccionados.DataSource = new List<DocumentosResult>();
            gvSeleccionados.DataBind();

            TotalItems.Text = "";
            TotalItems.Visible = false;

            HttpContext.Current.Session["listfacturas"] = list;
            HttpContext.Current.Session["listseleccionados"] = null;
            
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

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                List<DocumentoLinea> det = (List<DocumentoLinea>)gvDetalle.DataSource;
                decimal totalReal = 0;
                decimal totalkilos = 0;
                foreach (var d in det)
                {
                    totalReal += Convert.ToDecimal(d.TotalReal);
                    totalkilos += Convert.ToDecimal(d.CantidadSolicitada);
                }
                e.Row.Cells[6].Text = String.Format("{0:N2}", totalkilos);
                e.Row.Cells[9].Text = String.Format("{0:N2}", totalReal);
            }
        }
        protected void gvSeleccionados_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                List<DocumentosResult> det = (List<DocumentosResult>)gvSeleccionados.DataSource;
                decimal totalReal = 0;
                foreach (var d in det)
                {
                    totalReal += Convert.ToDecimal(d.TotalKilos);
                }
                e.Row.Cells[3].Text = String.Format("{0:N2}", totalReal);
            }

        }

        protected void ClosePopupBandeja(object sender, EventArgs e)
        {
            popupDetalleBandeja.Hide();
        }

        private void CargaDetalleBandeja(int docentry, string razonsocial)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            LimpiaBandeja();
            //consultar pedido
            var pedido = mng.Consultar("documentos", docentry, 12);
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
                txtNeto.Text =String.Format("{0:N0}", pedido.Neto);
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

        protected void ClosePopupCerrarRTC(object sender, EventArgs e)
        {
            popupCerrarRutaRCTRCC.Hide();
        }

        protected void CargaDetalleRCTRCC_Evnet(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string docentry = (row.FindControl("lblBaseEntryCustodio") as Label).Text;
                string razonsocial = (row.FindControl("lblCliente") as Label).Text;
                string factura = (row.FindControl("lblFolioDF") as Label).Text;
                string pedido = (row.FindControl("lblPedido") as LinkButton).Text;

                razonsocial = String.Format(" Pedido: {0} \n Factura: {1} \n Cliente: {2}", pedido, factura, razonsocial);
                CargaDetalleRCTRCC(Convert.ToInt32(docentry), razonsocial);
                //popupDetalleBandeja.Show();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.StackTrace);
            }
        }

        private void CargaDetalleRCTRCC(int docentry, string razonsocial)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            LimpiaBandeja();
            //consultar pedido
            var pedido = mng.Consultar("documentos", docentry, 4015);
            if (pedido != null)
            {

                txtCustodio.Text = pedido.Custodio;
                txtObservacionesCierreCustodio.Text = String.Format("{0} \n {1}",razonsocial, pedido.ObservacionesCierre);

                if (pedido.Lineas!=null && pedido.Lineas.Any())
                {
                    //foreach (var l in pedido.Lineas)
                    //{
                    //    l.TotalReal = l.CantidadReal * l.PrecioFinal;
                    //}
                    //var detalle = pedido.Lineas.FindAll(x => x.CantidadReal > 0).ToList();
                    gvDetalle.DataSource = pedido.Lineas; // detalle;
                    gvDetalle.DataBind();
                }
                popupCerrarRutaRCTRCC.Show();
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

        protected void CheckAllSel(object sender, EventArgs e)
        {
            CheckBox chckheader = (CheckBox)gvSeleccionados.HeaderRow.FindControl("checkboxSel");
            foreach (GridViewRow row in gvSeleccionados.Rows)
            {
                CheckBox chckrw = (CheckBox)row.FindControl("chkSeleccionadoSel");
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

        protected void Asignar_Event(object sender, EventArgs e)
        {
            
            var list=(List<DocumentosResult>)HttpContext.Current.Session["listfacturas"];

            List<DocumentosResult> listsel;

            if (HttpContext.Current.Session["listseleccionados"] == null)
            {
                listsel = new List<DocumentosResult>();
            }
            else
            {
                listsel = (List<DocumentosResult>)HttpContext.Current.Session["listseleccionados"];
            }

            if (list != null && list.Count > 0)
            {
                foreach (GridViewRow row in gvBandeja.Rows)
                {
                    if ((row.FindControl("chkSeleccionado") as CheckBox).Checked && (row.FindControl("lblRetiraCliente") as Label).Text=="")
                    {
                        string docentry = (row.FindControl("lblDocEntry") as Label).Text;
                        var doc = list.Find(x => x.DocEntry == Convert.ToInt32(docentry));
                        if (doc != null)
                        {
                            listsel.Add(doc);
                            list.Remove(doc);
                        }
                    }
                }
            }
            else
            {
                list = new List<DocumentosResult>();
            }
            gvSeleccionados.DataSource = listsel;
            gvSeleccionados.DataBind();
            TotalItems.Text = listsel.Count.ToString();

            cboVehiculo.SelectedValue = "";

            HttpContext.Current.Session["listfacturas"] = list;
            HttpContext.Current.Session["listseleccionados"] = listsel;

            if (listsel.Count == 0)
            {
                TotalItems.Visible = false;
                HttpContext.Current.Session["listseleccionados"] = null;
            }
            else
            {
                TotalItems.Visible = true;
            }
            
            if(list.Count==0)
            {
                HttpContext.Current.Session["listfacturas"] = null;
            }

            gvBandeja.DataSource = list;
            gvBandeja.DataBind();

            
        }
        protected void Enviar_Event(object sender, EventArgs e)
        {
            //int milliseconds = 2000;
            //Thread.Sleep(milliseconds);
            if(cboVehiculo.SelectedValue=="")
            {
                var mensaje = "Debe indicar un Vehículo";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                cboVehiculo.Focus();
                return;
            }
            try
            {
                //enviar a crear OLOG, ORUT y Ruta DrivIn
                var listsel = (List<DocumentosResult>)HttpContext.Current.Session["listseleccionados"];
                if (listsel != null && listsel.Any())
                {
                    User us = (User)HttpContext.Current.Session["us"];
                    DocumentoRuta ruta = new DocumentoRuta();
                    ruta.Vehiculo = cboVehiculo.SelectedValue;
                    ruta.DocFecha = DateTime.Now.Date;
                    ruta.FechaRegistro = DateTime.Now;
                    ruta.descripcion = String.Format("{0:dd-MM-yyyy} {1}", ruta.DocFecha, ruta.Vehiculo);
                    ruta.schema_name = "";
                    ruta.DocTipo = 15;
                    ruta.DocEstado = "A";
                    ruta.EstadoOperativo = "ING";
                    ruta.Version = "V0.0.1";
                    ruta.UsuarioCode = us.Usuario;
                    ruta.UsuarioNombre = us.Nombre;
                    ruta.clients = new List<Documento>();

                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
                    foreach (var s in listsel)
                    {
                        Documento doc = mng.Consultar("documentos", s.DocEntry, 12);
                        ruta.clients.Add(doc);
                    }

                    ruta = mng.Guardar("documentos", ruta);
                    if (ruta != null)
                    {
                        var mensaje = String.Format("Ruta Guardada: {0}",ruta.descripcion);
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                        Refresh();
                    }
                }
            }
            catch (Exception ex)
            {
                var mensaje = String.Format("Se ha generado el siguiente error: \\n {0}", ex.Message);
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
            }
        }
        protected void Borrar_Event(object sender, EventArgs e)
        {
            //int milliseconds = 2000;
            //Thread.Sleep(milliseconds);
            //ClientScript.RegisterStartupScript(this.GetType(), "alert", "ShowPopup();", true);

            var listsel = (List<DocumentosResult>)HttpContext.Current.Session["listseleccionados"];

            List<DocumentosResult> list;
            if(HttpContext.Current.Session["listfacturas"] ==null)
            {
                list = new List<DocumentosResult>();
            }
            else
            {
                list = (List<DocumentosResult>)HttpContext.Current.Session["listfacturas"];
            }

            if (listsel!=null && listsel.Count > 0)
            {
                foreach (GridViewRow row in gvSeleccionados.Rows)
                {
                    if ((row.FindControl("chkSeleccionadoSel") as CheckBox).Checked)
                    {
                        string docentry = (row.FindControl("lblDocEntry") as Label).Text;
                        var doc = listsel.Find(x => x.DocEntry == Convert.ToInt32(docentry));
                        if (doc != null)
                        {
                            list.Add(doc);
                            listsel.Remove(doc);
                        }
                    }
                }
            }
            else
            {
                listsel = new List<DocumentosResult>();
            }

            HttpContext.Current.Session["listfacturas"] = list;
            HttpContext.Current.Session["listseleccionados"] = listsel;

            
            gvSeleccionados.DataSource = listsel;
            gvSeleccionados.DataBind();
            TotalItems.Text = listsel.Count.ToString();
            if (listsel.Count == 0)
            {
                TotalItems.Visible = false;
                HttpContext.Current.Session["listseleccionados"] = null;
            }
            else
            {
                TotalItems.Visible = true;
            }

            if (list.Count == 0)
            {
                HttpContext.Current.Session["listseleccionados"] = null;
            }

            gvBandeja.DataSource = list;
            gvBandeja.DataBind();

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
            var list = mng.List("documentos/list", 12, "A");
            list = list.FindAll(x => x.EstadoOperativo != "RUTA").ToList();
            var list2 = Utility.DynamicSort1<DocumentosResult>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["listfacturas"] == null)
            {
                return;
            }
            List<DocumentosResult> listGrilla = (List<DocumentosResult>)HttpContext.Current.Session["listfacturas"];
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

        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for */
        }
    }
}