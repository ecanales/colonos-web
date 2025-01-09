using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using NLog;
using Org.BouncyCastle.Bcpg.OpenPgp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using System.Windows.Controls;
using System.Windows.Interop;

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

        private void CargaMotivos(int tipo)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDevolucion mng = new ManagerDevolucion(urlbase, logger);
            var list = mng.ListMotivos("devolucion/motivos");
            cboMotivo.DataSource = list.FindAll(x => x.TipoMotivo==tipo).ToList();
            cboMotivo.DataTextField = "Descripcion";
            cboMotivo.DataValueField = "IdMotivo";
            cboMotivo.DataBind();
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

        protected void ClosePopupCerrarResumen(object sender, EventArgs e)
        {
            popupResumenCierre.Hide();
            popupDetalleBandeja.Show();
        }
        protected void VerBandeja_Event(object sender, EventArgs e)
        {
            try
            {
                LimpiarBandeja();
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
                txtDocEntry.Text = pedido.DocEntry.ToString();
                txtFactura.Text = pedido.FolioDF.ToString();
                txtNumeroPedido.Text = pedido.BaseEntry.ToString();// .DocEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtFechadeEntrega.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                txtVendedorPedido.Text = pedido.UsuarioNombre; // .VendedorCode;
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

        private void CheckAllDet(bool valor)
        {
            foreach (GridViewRow row in gvDetalle.Rows)
            {
                CheckBox chckrw = (CheckBox)row.FindControl("chkSeleccionadoDet");
                chckrw.Checked = valor;
                if (valor)
                {
                    (row.FindControl("txtCantidad") as TextBox).Text = (row.FindControl("lblCantidad") as Label).Text;
                    (row.FindControl("txtCantidad") as TextBox).ReadOnly = true;
                    chckrw.Enabled = false;
                }
                else
                {
                    chckrw.Enabled = true;
                    (row.FindControl("txtCantidad") as TextBox).ReadOnly=false;
                }
            }
        }
        protected void CheckAllDet(object sender, EventArgs e)
        {
            CheckBox chckheader = (CheckBox)gvDetalle.HeaderRow.FindControl("checkbox2Det");
            foreach (GridViewRow row in gvDetalle.Rows)
            {
                CheckBox chckrw = (CheckBox)row.FindControl("chkSeleccionadoDet");
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


        private void LimpiarPopupCierre()
        {
            optEntregaTotal.Checked = false;
            //optRechazoParcial.Checked = false;
            //optNoEntregado.Checked=false;
            optOtraEntregaSI.Checked= false;
            optOtraEntregaNO.Checked = false;
            optPlanta.Checked=false;
            optTransporte.Checked=false;
            optCliente.Checked = false;
            txtObservacionesCierre.Text = "";
            txtCustodio.Text = "";
            txtObservacionesCierreCustodio.Text = "";
            pnlOpcionesEntrega.Visible = false;
            lblEntregaTotal.BackColor = System.Drawing.Color.Transparent;
            optEntregaTotal.BackColor = System.Drawing.Color.Transparent;
            //lblRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            //optRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            //lblNoEntregado.BackColor = System.Drawing.Color.Transparent;
            //optNoEntregado.BackColor = System.Drawing.Color.Transparent;
            lblOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;
            lblOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;
            lblPlanta.BackColor = System.Drawing.Color.Transparent;
            optPlanta.BackColor = System.Drawing.Color.Transparent;
            lblTransporte.BackColor = System.Drawing.Color.Transparent;
            optTransporte.BackColor = System.Drawing.Color.Transparent;
            lblCliente.BackColor = System.Drawing.Color.Transparent;
            optCliente.BackColor = System.Drawing.Color.Transparent;
        }

        protected void CerrarRuta_Event(object sender, EventArgs e)
        {
            var listsel = CargaRutasSeleccionadas();
            if (listsel.Any())
            {
                LimpiarPopupCierre();
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
            string tipoentrega = "";
            string rutaexitosa = "NO";
            string otraentrega = "";
            string tipocustodio = "";
            string obs = "";
            if(!optEntregaTotal.Checked)// && !optRechazoParcial.Checked && !optNoEntregado.Checked)
            {
                //debe elegir una opción de Entrega
                popupCerrarRuta.Focus();
                return;
            }
            else
            {
                if (optEntregaTotal.Checked)
                {
                    tipoentrega = "Total";
                    rutaexitosa = "SI";
                }
                //if (optRechazoParcial.Checked)
                //    tipoentrega = "Parcial";
                //if (optNoEntregado.Checked)
                //    tipoentrega = "NoEntregado";
            }
            if (!optEntregaTotal.Checked && !optOtraEntregaSI.Checked && !optOtraEntregaNO.Checked)
            {
                //debe elegir una opción de Otra Entrega
                return;
            }
            else
            {
                if (optOtraEntregaSI.Checked)
                    otraentrega = "SI";
                if (optOtraEntregaNO.Checked)
                    otraentrega = "NO";
            }
            if (!optEntregaTotal.Checked && !optPlanta.Checked && !optTransporte.Checked && !optCliente.Checked)
            {
                //debe elegir una opción de Custodio
                return;
            }
            else
            {
                if (optPlanta.Checked)
                    tipocustodio = "PLA";
                if (optTransporte.Checked)
                    tipocustodio = "RCT";
                if (optCliente.Checked)
                    tipocustodio = "RCC";
            }
            obs=txtObservacionesCierre.Text;
            CerrarRutas(gvCerrarRutas, rutaexitosa,tipoentrega,otraentrega,tipocustodio,"",obs);
            popupCerrarRuta.Hide();
        }
        protected void CerrarRutaNO(object sender, EventArgs e)
        {
            //CerrarRutas(gvCerrarRutas, "NO");
            //popupCerrarRuta.Hide();
        }

        protected void CerrarRutaRCT(object sender, EventArgs e)
        {
            //if (txtCustodio.Text.Trim().Length > 0)
            //{
            //    CerrarRutas(gvCerrarRutasRCTRCC, "NO", txtCustodio.Text, "RCT");
            //    popupCerrarRutaRCTRCC.Hide();
            //}
        }

        protected void CerrarRutaRCC(object sender, EventArgs e)
        {
            //if (txtCustodio.Text.Trim().Length > 0)
            //{
            //    CerrarRutas(gvCerrarRutasRCTRCC, "NO", txtCustodio.Text, "RCC");
            //    popupCerrarRutaRCTRCC.Hide();
            //}
        }

        protected void ClosePopupCerrarRTC(object sender, EventArgs e)
        {
            popupCerrarRutaRCTRCC.Hide();
        }

        private void LimpiaCierre()
        {
            
        }

        protected void ConfirmaCierreRutaError_Event(object sender, EventArgs e)
        {
            string rutaexitosa = "NO";
            string docentry = txtDocEntry.Text;
            string tipoproblema = txtTipoProblemaResumen.Text;
            string devolucion = txtDevolucionResumen.Text;
            string motivo = txtMotivoResumen.Text;
            string tipocustodio = txtCustodioResumen.Text;
            string otraentrega = txtVolveraEntregarResumen.Text;
            string obs = txtObservacionResumen.Text;
            CerrarRutaError(docentry, tipoproblema, devolucion, motivo, tipocustodio, otraentrega, obs, rutaexitosa);
        }
        protected void CierreRutaError_Event(object sender, EventArgs e)
        {
            string docentry = txtDocEntry.Text;
            string tipoproblema = "";
            string devolucion = ""; //tipoEntrega
            string motivo = "";
            string tipocustodio = "";
            string otraentrega = "";
            string obs = "";
            string rutaexitosa = "NO";

            //string tipoentrega = "";
            
            
            string custodio = "";
            

            if (!optRechazo.Checked && !optNoEntregado.Checked)
            {
                return;
            }
            else if (optRechazo.Checked)
            {
                tipoproblema = "Rechazo";
            }
            else if (optNoEntregado.Checked)
            {
                tipoproblema = "NoEntregado";
            }

            if (!optRechazoTotal.Checked && !optRechazoParcial.Checked)
            {
                return;
            }
            else if (optRechazoTotal.Checked)
            {
                devolucion = "Total";
            }
            else if (optRechazoParcial.Checked)
            {
                devolucion = "Parcial";
            }

            if(cboMotivo.Text=="")
            {
                return;
            }
            else
            {
                motivo = cboMotivo.SelectedItem.Text;
            }

            if (!optEntregaTotal.Checked && !optPlanta.Checked && !optTransporte.Checked && !optCliente.Checked)
            {
                //debe elegir una opción de Custodio
                return;
            }
            else
            {
                if (optPlanta.Checked)
                    tipocustodio = "PLA";
                if (optTransporte.Checked)
                    tipocustodio = "RCT";
                if (optCliente.Checked)
                    tipocustodio = "RCC";
            }

            if (optNoEntregado.Checked && !optOtraEntregaSI.Checked && !optOtraEntregaNO.Checked)
            {
                //debe elegir una opción de Otra Entrega
                return;
            }
            else
            {
                if (optOtraEntregaSI.Checked)
                    otraentrega = "SI";
                if (optOtraEntregaNO.Checked)
                    otraentrega = "NO";
            }

            obs = txtObservacionesRechazoNoEntregado.Text;
            txtTipoProblemaResumen.Text = tipoproblema;
            txtDevolucionResumen.Text = devolucion;
            txtMotivoResumen.Text = motivo; 
            txtCustodioResumen.Text = tipocustodio; 
            txtVolveraEntregarResumen.Text = otraentrega; 
            txtObservacionResumen.Text = obs;
            txtFacturaResumen.Text = txtFactura.Text;
            txtPedidoResumen.Text = txtNumeroPedido.Text;
            txtClienteResumen.Text = txtRazonSocial.Text;
            popupDetalleBandeja.Hide();
            //---------------------------------
            var odev=new Documento { Lineas=new List<DocumentoLinea>()};

            foreach (GridViewRow row in gvDetalle.Rows)
            {
                if ((row.FindControl("chkSeleccionadoDet") as CheckBox).Checked)
                {
                    string lineaitem = (row.FindControl("lblLineaItem") as Label).Text;
                    string prodcode = (row.FindControl("lblProdCode") as Label).Text;
                    string prodnombre = (row.FindControl("lblProdNombre") as Label).Text;
                    string preciofinal = (row.FindControl("lblPrecioFinal") as Label).Text.Replace("$", "").Replace(".", ",").Trim();
                    string cantidadsol = (row.FindControl("lblCantidad") as Label).Text.Replace("$", "").Replace(".", ",").Trim();
                    string cantidaddev = (row.FindControl("txtCantidad") as TextBox).Text.Replace("$", "").Replace(".", ",").Trim();

                    if (Convert.ToDecimal(cantidaddev) > Convert.ToDecimal(cantidadsol))
                    {
                        var mensaje = "Cantidad devuelta no puede ser mayor a lo solicitado";
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert2", "closeLoading();false", true);
                        return;
                    }
                    odev.Lineas.Add(new DocumentoLinea
                    {
                        ProdCode = prodcode,
                        ProdNombre = prodnombre,
                        PrecioFinal = Convert.ToDecimal(preciofinal),
                        CantidadSolicitada = Convert.ToDecimal(cantidaddev)
                    });
                }
            }
            gvResumen.DataSource = odev.Lineas;
            gvResumen.DataBind();
            //---------------------------------
            popupResumenCierre.Show();
            //CerrarRutaError(docentry, tipoproblema, devolucion, motivo, tipocustodio, otraentrega, obs, rutaexitosa);
        }

        private void LimpiarBandeja()
        {
            optRechazo.Checked = false;
            lblRechazo.BackColor = System.Drawing.Color.Transparent;
            optRechazo.BackColor = System.Drawing.Color.Transparent;

            optNoEntregado.Checked = false;
            lblNoEntregado.BackColor = System.Drawing.Color.Transparent;
            optNoEntregado.BackColor = System.Drawing.Color.Transparent;

            optRechazoTotal.Checked = false;
            lblRechazoTotal.BackColor = System.Drawing.Color.Transparent;
            optRechazoTotal.BackColor = System.Drawing.Color.Transparent;

            optRechazoParcial.Checked = false;
            lblRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            optRechazoParcial.BackColor = System.Drawing.Color.Transparent;

            cboMotivo.DataSource = null;
            cboMotivo.DataBind();
            cboMotivo.Items.Clear();

            optOtraEntregaNO.Checked = false;
            lblOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;

            optOtraEntregaSI.Checked = false;
            lblOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;

            optPlanta.Checked = false;
            lblPlanta.BackColor = System.Drawing.Color.Transparent;
            optPlanta.BackColor = System.Drawing.Color.Transparent;

            optTransporte.Checked = false;
            lblTransporte.BackColor = System.Drawing.Color.Transparent;
            optTransporte.BackColor = System.Drawing.Color.Transparent;

            optCliente.Checked = false;
            lblCliente.BackColor = System.Drawing.Color.Transparent;
            optCliente.BackColor = System.Drawing.Color.Transparent;

            txtObservacionesCierre.Text = "";
            txtObservacionesRechazoNoEntregado.Text = "";
        }
        private void CerrarRutaError(string docentry, string tipoproblema, string devolucion, string motivo, string tipocustodio, string otraentrega, string obs, string rutaexitosa)//string docentry, string rutaexistosa, string tipoentrega, string otraentrega, string tipocustodio, string custodio, string obs)
        {
            
            
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            try
            {
                List<Documento> items = new List<Documento>();
                var olog = mng.Consultar("documentos", Convert.ToInt32(docentry), 14);
                olog.TipoProblema = tipoproblema;
                olog.RutaExitosa = rutaexitosa;
                olog.TipoEntrega = devolucion;
                olog.Devolucion = devolucion;
                olog.Motivo = motivo;
                olog.Custodio = tipocustodio;
                olog.OtraEntrega = otraentrega;
                olog.TipoCustodio = tipocustodio;
                olog.ObservacionesCierre = obs.ToUpper();

                olog.DocEstado = "C";
                items.Add(olog);
                //crear doc custodio
                var ocus = new Documento();
                ocus.DocTipo = olog.TipoCustodio == "RCT" ? 4015 : olog.TipoCustodio == "RCC" ? 4016 : 0; // RCT=4015, RCC=4016
                ocus.DocEstado = "A";
                ocus.DocFecha = DateTime.Now.Date;
                ocus.Custodio = olog.Custodio;
                ocus.TipoCustodio = olog.TipoCustodio;
                ocus.ObservacionesCierre = olog.ObservacionesCierre;
                ocus.EstadoOperativo = "ING";
                ocus.BaseEntry = olog.BaseRuta;
                ocus.BaseTipo = 15; //ORUT
                ocus.FechaRegistro = DateTime.Now;
                ocus.UsuarioCode = olog.UsuarioCode;
                ocus.Version = olog.Version;
                ocus.UsuarioNombre = olog.UsuarioNombre;
                items.Add(ocus);
                //crear doc devolucion --------------------
                var odev = new Documento();
                odev.DocTipo = 19;
                odev.DocEstado = "A";
                odev.DocFecha = DateTime.Now.Date;
                odev.Custodio = olog.Custodio;
                odev.TipoCustodio = olog.TipoCustodio;
                odev.ObservacionesCierre = olog.ObservacionesCierre;
                odev.EstadoOperativo = "ING";
                odev.BaseEntry = olog.DocEntry;
                odev.BaseTipo = olog.DocTipo;
                odev.FechaRegistro = DateTime.Now;
                odev.UsuarioCode = olog.UsuarioCode;
                odev.Version = olog.Version;
                odev.UsuarioNombre = olog.UsuarioNombre;
                //----------------------------------------
                odev.TipoProblema = tipoproblema;
                odev.RutaExitosa = rutaexitosa;
                odev.TipoEntrega = devolucion;
                odev.Devolucion = devolucion;
                odev.Motivo = motivo;
                odev.Custodio = tipocustodio;
                odev.OtraEntrega = otraentrega;
                odev.TipoCustodio = tipocustodio;
                odev.ObservacionesCierre = obs.ToUpper();
                //----------------------------------------
                odev.Lineas = new List<DocumentoLinea>();

                foreach (GridViewRow row in gvDetalle.Rows)
                {
                    if ((row.FindControl("chkSeleccionadoDet") as CheckBox).Checked)
                    {
                        string lineaitem = (row.FindControl("lblLineaItem") as Label).Text;
                        string prodcode = (row.FindControl("lblProdCode") as Label).Text;
                        string prodnombre = (row.FindControl("lblProdNombre") as Label).Text;
                        string preciofinal = (row.FindControl("lblPrecioFinal") as Label).Text.Replace("$", "").Replace(".", ",").Trim();
                        string cantidadsol = (row.FindControl("lblCantidad") as Label).Text.Replace("$", "").Replace(".", ",").Trim();
                        string cantidaddev = (row.FindControl("txtCantidad") as TextBox).Text.Replace("$", "").Replace(".", ",").Trim();

                        if(Convert.ToDecimal(cantidaddev)> Convert.ToDecimal(cantidadsol))
                        {
                            var mensaje = "Cantidad devuelta no puede ser mayor a lo solicitado";
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append("alert('");
                            sb.Append(mensaje);
                            sb.Append("');");
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert2", "closeLoading();false", true);
                            return;
                        }
                        odev.Lineas.Add(new DocumentoLinea
                        {
                            ProdCode = prodcode,
                            LineaEstado = "A",
                            BaseEntry = olog.DocEntry,
                            BaseTipo = olog.DocTipo,
                            BaseLinea = Convert.ToInt32(lineaitem),
                            ProdNombre = prodnombre,
                            PrecioFinal = Convert.ToDecimal(preciofinal),
                            CantidadSolicitada = Convert.ToDecimal(cantidadsol),
                            CantidadEntregada = Convert.ToDecimal(cantidaddev)
                        });
                    }
                }
                if (odev.Lineas.Any())
                {
                    items.Add(odev);
                }
                else
                {
                    var mensaje = "Debe indicar los items que han sido entregados";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert2", "closeLoading();false", true);
                    return;
                }
                if (items.Any())
                {
                    mng.Actualizar("documentos/setserror", items);
                    var mensaje = "Ruta Actualizada";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert2", "closeLoading();false", true);
                    popupDetalleBandeja.Hide();
                }

                Refresh();
            }
            catch(Exception ex)
            {
                logger.Error("CerrarRutas: {0}", ex.Message);
                logger.Error("CerrarRutas: {0}", ex.StackTrace);
            }
}
        private void CerrarRutas(GridView gv, string rutaexistosa, string tipoentrega,string otraentrega, string tipocustodio,string custodio, string obs)
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
                    olog.TipoEntrega = tipoentrega;
                    olog.OtraEntrega = otraentrega;
                    olog.Custodio = custodio.ToUpper();
                    olog.TipoCustodio = tipocustodio;
                    olog.ObservacionesCierre = obs.ToUpper();
                    olog.DocEstado = "C";
                    items.Add(olog);
                    
                }

                if(items.Any())
                {
                    mng.Actualizar("documentos/sets", items);
                    var mensaje = "Ruta Actualizada";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert2", "closeLoading();false", true);
                }

                
                
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


        protected void optRechazo_CheckedChanged(object sender, EventArgs e)
        {
            optRechazoParcial.Enabled = true;
            optRechazoParcial.Checked = false;
            pnlSINO.Enabled = false;
            CheckAllDet(false);
            lblOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaNO.Checked = false;
            lblOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaSI.Checked = false;

            lblRechazo.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optRechazo.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            lblNoEntregado.BackColor = System.Drawing.Color.Transparent;
            optNoEntregado.BackColor = System.Drawing.Color.Transparent;
            CargaMotivos(1);
            popupDetalleBandeja.Show();
        }

        protected void optNoEntregado_CheckedChanged(object sender, EventArgs e)
        {
            optRechazoParcial.Enabled = false;
            optRechazoParcial.Checked = false;
            pnlSINO.Enabled = true;
            CheckAllDet(true);
            lblRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            optRechazoParcial.BackColor = System.Drawing.Color.Transparent;

            lblRechazo.BackColor = System.Drawing.Color.Transparent;
            optRechazo.BackColor = System.Drawing.Color.Transparent;
            lblNoEntregado.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optNoEntregado.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");

            CargaMotivos(2);
            popupDetalleBandeja.Show();
        }

        protected void optRechazoTotal_CheckedChanged(object sender, EventArgs e)
        {
            CheckAllDet(true);
            lblRechazoTotal.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optRechazoTotal.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            lblRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            optRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            popupDetalleBandeja.Show();
        }
        protected void optRechazoParcial_CheckedChanged(object sender, EventArgs e)
        {
            CheckAllDet(false);
            lblRechazoTotal.BackColor = System.Drawing.Color.Transparent;
            optRechazoTotal.BackColor = System.Drawing.Color.Transparent;
            lblRechazoParcial.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optRechazoParcial.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd"); 
            popupDetalleBandeja.Show();
        }


        protected void optEntregaTotal_CheckedChanged(object sender, EventArgs e)
        {
            lblEntregaTotal.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optEntregaTotal.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            //lblRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            //optRechazoParcial.BackColor = System.Drawing.Color.Transparent;
            //lblNoEntregado.BackColor = System.Drawing.Color.Transparent;
            //optNoEntregado.BackColor = System.Drawing.Color.Transparent;
            popupCerrarRuta.Show();
        }

        

       

        protected void optOtraEntregaSI_CheckedChanged(object sender, EventArgs e)
        {
            lblOtraEntregaSI.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optOtraEntregaSI.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            lblOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaNO.BackColor = System.Drawing.Color.Transparent;
            popupDetalleBandeja.Show();
        }

        protected void optOtraEntregaNO_CheckedChanged(object sender, EventArgs e)
        {
            lblOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;
            optOtraEntregaSI.BackColor = System.Drawing.Color.Transparent;
            lblOtraEntregaNO.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optOtraEntregaNO.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            popupDetalleBandeja.Show();
        }

        protected void optPlata_CheckedChanged(object sender, EventArgs e)
        {
            lblPlanta.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optPlanta.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            lblTransporte.BackColor = System.Drawing.Color.Transparent;
            optTransporte.BackColor = System.Drawing.Color.Transparent;
            lblCliente.BackColor = System.Drawing.Color.Transparent;
            optCliente.BackColor = System.Drawing.Color.Transparent;
            popupDetalleBandeja.Show();
        }

        protected void optTransporte_CheckedChanged(object sender, EventArgs e)
        {
            lblPlanta.BackColor = System.Drawing.Color.Transparent;
            optPlanta.BackColor = System.Drawing.Color.Transparent;
            lblTransporte.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd"); 
            optTransporte.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd"); 
            lblCliente.BackColor = System.Drawing.Color.Transparent;
            optCliente.BackColor = System.Drawing.Color.Transparent;
            popupDetalleBandeja.Show();
        }

        protected void optCliente_CheckedChanged(object sender, EventArgs e)
        {
            lblPlanta.BackColor = System.Drawing.Color.Transparent;
            optPlanta.BackColor = System.Drawing.Color.Transparent;
            lblTransporte.BackColor = System.Drawing.Color.Transparent;
            optTransporte.BackColor = System.Drawing.Color.Transparent;
            lblCliente.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            optCliente.BackColor = System.Drawing.ColorTranslator.FromHtml("#0d6efd");
            popupDetalleBandeja.Show();
        }
    }
}