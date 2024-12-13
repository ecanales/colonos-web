using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class bandeja_facturacion : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Refresh();
            }
        }

        protected void Buscar_Menu(object sender, EventArgs e)
        {
            if(Session["listFacturacion"]!=null)
            {
                var list = (List<DocumentosResult>)Session["listFacturacion"];
                if(list!=null && list.Any() && txtBuscar.Text.Trim().Length>0)
                {
                    try
                    {
                        var docentry = Convert.ToInt32(txtBuscar.Text.Trim());
                        list = list.FindAll(x => x.DocEntry == docentry).ToList();
                        gvBandeja.DataSource = list;
                        gvBandeja.DataBind();
                    }
                    catch
                    {
                        Console.WriteLine("No es numerico");
                    }
                }
            }
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.ListPedidos("documentos/list",10,"A","PREP",1,"","","");
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
            Session["listFacturacion"] = list;
        }

        protected void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
        }

        protected void ActualizarOC_Event(object sender, EventArgs e)
        {
            var actualizado= ActualizarOC();
            chkActualizarOC.Checked = false;
            if(actualizado)
            {
                var mensaje = String.Format("Orden de Compra Actualziada");// "Factura Guardada";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
            }
        }

        private bool ActualizarOC()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var doc = mng.Consultar("documentos", Convert.ToInt32(HiddenFieldDocentry.Value), Convert.ToInt32(HiddenFieldDocTipo.Value));
            if (doc != null && doc.EstadoOperativo != "NUL" && chkActualizarOC.Checked)
            {
                doc.Observaciones = txtOrdendeCompra.Text;
                doc = mng.GuardarOrdendeCompra("documentos/ordendecompra", doc);
                return true;
            }
            return false;
        }

        protected void VerBandeja_Event(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string docentry = (row.FindControl("lblDocEntry") as LinkButton).Text;
                string razonsocial = (row.FindControl("lblCliente") as Label).Text;
                CargaDetalleBandeja(Convert.ToInt32(docentry), razonsocial);
                chkConfirmar.Checked = false;
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
            var pedido = mng.Consultar("documentos", docentry, 10);
            if (pedido != null)
            {
                HiddenFieldDocentry.Value = docentry.ToString();
                HiddenFieldDocTipo.Value = pedido.DocTipo.ToString();
                lblRazonSocial.Text = pedido.RazonSocial;
                txtRazonSocial.Text = pedido.RazonSocial;
                txtNumeroPedido.Text = pedido.DocEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtFechadeEntrega.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                txtVendedorPedido.Text = pedido.VendedorCode;
                chkRetiraCliente.Checked = Convert.ToBoolean(pedido.RetiraCliente);
                txtOrdendeCompra.Text = pedido.Observaciones;
                if (pedido.Lineas.Any())
                {
                    foreach(var l in pedido.Lineas)
                    {
                        l.TotalReal = l.CantidadReal * l.PrecioFinal;
                    }
                    var detalle = pedido.Lineas;//.FindAll(x => x.CantidadReal>0).ToList();
                    gvDetalle.DataSource = detalle;
                    gvDetalle.DataBind();
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
            HiddenFieldDocTipo.Value = "";
            txtOrdendeCompra.Text = "";
            gvDetalle.DataSource = null;
            gvDetalle.DataBind();

        }

        protected void ClosePopupBandeja(object sender, EventArgs e)
        {
            popupDetalleBandeja.Hide();
        }

        protected void gvBandeja_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState != DataControlRowState.Edit)
            {

                var completado = (e.Row.FindControl("lblCompletado") as Label).Text;
                if (completado.Replace("%", "").Trim() != "")
                {
                    var valor = Convert.ToInt16(completado.Replace("%", "").Trim());
                    if (valor > 100)
                        valor = 100;
                    switch (valor)
                    {
                        case 100:
                            foreach (TableCell c in e.Row.Cells)
                            {
                                c.BackColor = System.Drawing.Color.LightGreen;
                            }
                            break;
                        case short n when (n < 100 && n >= 1):
                            foreach (TableCell c in e.Row.Cells)
                            {
                                c.BackColor = System.Drawing.Color.LightYellow;
                            }
                            break;
                    }
                    
                }
            }
        }

        protected void Generar_Event(object sender, EventArgs e)
        {
            try
            {
                if (!chkConfirmar.Checked)
                {
                    var mensaje = "Debe confirmar la emisión de la factura";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                    chkConfirmar.Focus();
                    return;
                }

                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
                var doc = mng.Consultar("documentos", Convert.ToInt32(HiddenFieldDocentry.Value), 10);
                if (doc != null && doc.EstadoOperativo != "NUL")
                {
                    Documento fac = new Documento();
                    fac.DocEstado = "A";
                    fac.DocTipo = 12;
                    fac.EstadoOperativo = "ING";
                    fac.DocFecha = DateTime.Now.Date;
                    fac.SocioCode = doc.SocioCode;
                    fac.RazonSocial = doc.RazonSocial;
                    fac.VendedorCode = doc.VendedorCode;
                    fac.UsuarioCode = doc.UsuarioCode;
                    fac.UsuarioNombre = doc.UsuarioNombre;
                    fac.FechaRegistro = DateTime.Now;
                    fac.Version = doc.Version;
                    fac.BaseEntry = doc.DocEntry;
                    fac.BaseTipo = doc.DocTipo;
                    fac.RetiraCliente = doc.RetiraCliente;
                    //fac.CondicionCode = doc.CondicionCode;
                    fac.FechaEntrega = doc.FechaEntrega;
                    fac.DireccionCode = doc.DireccionCode;
                    fac.CondicionDF = doc.CondicionDF;
                    fac.Observaciones = doc.Observaciones; //es el numero de orden de compra del cliente

                    fac.Lineas = new List<DocumentoLinea>();
                    ManagerInventario mngInv = new ManagerInventario(urlbase, logger);

                    fac.Neto = fac.Neto ?? 0;

                    foreach (var l in doc.Lineas)
                    {
                        if (l.CantidadReal > 0 && l.CantidadReal>0)
                        {
                            var prod = mngInv.Get("productos", l.ProdCode);
                            
                            fac.Neto += l.CantidadReal * l.PrecioFinal;

                            fac.Lineas.Add(new DocumentoLinea
                            {
                                BaseEntry = l.DocEntry,
                                BaseLinea = l.DocLinea,
                                BaseTipo = l.DocTipo,
                                CantidadSolicitada = l.CantidadReal,
                                ProdCode = l.ProdCode,
                                ProdNombre = l.ProdNombre,
                                MarcaNombre = l.MarcaNombre,
                                RefrigeraNombre = l.RefrigeraNombre,
                                OrigenNombre = l.OrigenNombre,
                                BodegaCode = l.BodegaCode,
                                CantidadEntregada = l.CantidadReal,
                                TieneReceta = prod.TieneReceta,
                                Medida = l.Medida,
                                PrecioFinal = l.PrecioFinal,
                                AnimalCode = prod.AnimalCode,
                                DocTipo = fac.DocTipo,
                                TotalReal=l.PrecioFinal * l.CantidadReal,
                                TotalSolicitado= l.PrecioFinal * l.CantidadReal,
                                Margen =l.Margen,
                                TipoCode=l.TipoCode,
                                Costo=l.Costo
                                
                            });
                        }
                    }

                    fac.Neto =Convert.ToDecimal(Math.Round(Convert.ToDouble(fac.Neto), 0));
                    fac.Iva= fac.Neto * Convert.ToDecimal(0.19);
                    fac.Total = fac.Neto + fac.Iva;

                    if (fac.Lineas.Any())
                    {
                        fac = mng.Guardar("documentos", fac);
                        if (fac != null)
                        {
                            var mensaje = String.Format("Factura generada en Defontana: {0}", fac.FolioDF);// "Factura Guardada";
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append("alert('");
                            sb.Append(mensaje);
                            sb.Append("');");
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                            popupDetalleBandeja.Hide();
                            Refresh();
                        }
                    }
                    else
                    {
                        var mensaje = String.Format("No hay items disponibles para facturar {0}", ":/");// "Factura Guardada";
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                    }
                }
            }
            catch (Exception ex)
            {
                var mensaje = String.Format("Se ha generado el siguiente error: \\n {0}", ex.Message);
                logger.Error("Generar Factura. Se ha generado el siguiente error: \\n {0}", ex.Message);
                logger.Error("Generar Factura. : \\n {0}", ex.StackTrace);
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                popupDetalleBandeja.Hide();
                Refresh();
            }
        }

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState != DataControlRowState.Edit)
            {

                var lineaestado = (e.Row.FindControl("lblLineaEstado") as Label).Text;
                if (lineaestado == "C")
                {
                    foreach (TableCell c in e.Row.Cells)
                    {
                        c.BackColor = System.Drawing.Color.DarkGray;
                    }
                }
            }
        }

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

        private const string ASCENDING = "ASC";
        private const string DESCENDING = "DESC";
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
            //  You can cache the DataTable for improving performance
            //LoadGrid();


            //---------------------
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.ListPedidos("documentos/list", 10, "A", "PREP", 1,"","","");

            var list2=Utility.DynamicSort1<DocumentosResult>(list,sortExpression,direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();
            //---------------------
            //DataTable dt = gv1.DataSource as DataTable;
            //DataView dv = new DataView(dt);
            //dv.Sort = sortExpression + direction;

            // = sortExpression + direction;

            //gv1.DataSource = dv;
            //gv1.DataBind();

        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["listFacturacion"] == null)
            {
                return;
            }
            List<DocumentosResult> listGrilla = (List<DocumentosResult>)HttpContext.Current.Session["listFacturacion"];
            if (listGrilla.Count > 0)
            {

                string nombrearcivo = String.Format("BandejaFacturacion {0:dd-MM-yyyy HH.mm}.xls", DateTime.Now);
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