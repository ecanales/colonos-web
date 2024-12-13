using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using Colonos.Web.Documentos;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class bandeja_produccion : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargaOperadores();
                Refresh();
            }
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.List("documentos/list", 3010,"A","", "PRODUCCION");
            
            if (chkSoloEtiquetados.Checked)
            {
                list = list.FindAll(x => x.Etiquetado == chkSoloEtiquetados.Checked).ToList();
            }
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
            HttpContext.Current.Session["bandejaproduccion"] = list;
        }

        protected void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
        }

        protected void Nuevo_Event(object sender, EventArgs e)
        {
            Nuevo();
        }

        private void Nuevo()
        {
            Response.Redirect("/solicitud-prod.aspx");
        }

        protected void VerBandeja_Event(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string docentry = (row.FindControl("lblDocEntry") as Label).Text;
                string razonsocial = (row.FindControl("lblCliente") as Label).Text;
                string doctipo = (row.FindControl("lblDocTipo") as Label).Text;
                CargaDetalleBandeja(Convert.ToInt32(docentry), razonsocial, Convert.ToInt32(doctipo));
                popupDetalleBandeja.Show();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
            }
        }

        private void CargaDetalleBandeja(int docentry, string razonsocial, int doctipo)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            LimpiaBandeja();
            //consultar pedido
            var pedido = mng.Consultar("documentos", docentry, doctipo);
            if (pedido != null)
            {
                HiddenFieldDocentry.Value = pedido.DocEntry.ToString();
                HiddenFieldDocTipo.Value = pedido.DocTipo.ToString();
                lblRazonSocion.Text = pedido.RazonSocial;
                txtRazonSocial.Text = pedido.RazonSocial;
                txtNumeroPedido.Text = pedido.BaseEntry == null ? pedido.DocEntry.ToString() : pedido.BaseEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtFechadeEntrega.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                txtVendedorPedido.Text = pedido.VendedorCode;
                chkRetiraCliente.Checked = Convert.ToBoolean(pedido.RetiraCliente);
                cboOperadores.SelectedValue = pedido.UsuarioCodeResponsable;
                chkEtiquetar.Checked = Convert.ToBoolean(pedido.Etiquetado);
                txtGlosaEtiqueta.Text = pedido.Etiqueta;

                if (pedido.Lineas.Any())
                {
                    var detalle = pedido.Lineas;
                    gvDetalle.DataSource = detalle;
                    gvDetalle.DataBind();
                }
            }
        }

        private void CargaOperadores()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);
            var prop = mng.ListUsuarios("usuarios/list", "CALIDAD", "OPERADOR-PROD");
            if (prop != null && prop.Any())
            {
                var json = JsonConvert.SerializeObject(prop);
                var list = JsonConvert.DeserializeObject<List<User>>(json);

                var listoper = new List<User>();

                listoper.Add(new User { Usuario = "", Nombre = "" });

                foreach (var o in list)
                {
                    listoper.Add(o);
                }

                cboOperadores.DataSource = listoper.OrderBy(x => x.Nombre).ToList();
                cboOperadores.DataTextField = "Nombre";
                cboOperadores.DataValueField = "Usuario";
                cboOperadores.DataBind();
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

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var pend = (e.Row.FindControl("txtCantidad") as Label).Text;
                var lineaestado = (e.Row.FindControl("lblLineaEstado") as Label).Text;

                if (pend == "")
                    pend = "0";


                if (Convert.ToDecimal(pend) == 0 || lineaestado == "C")
                {
                    e.Row.Cells[0].Enabled = false;
                    for (int i = 0; i < e.Row.Cells.Count; i++)
                    {
                        //e.Row.Cells[i].BackColor = System.Drawing.Color.Gainsboro;
                        //e.Row.Cells[i].ForeColor = System.Drawing.Color.Gray;
                        e.Row.Cells[i].BackColor = System.Drawing.Color.DarkGray;
                    }
                }
            }

        }

        protected void Etiquetar_Event(object sender, EventArgs e)
        {
            if (chkEtiquetar.Checked && txtGlosaEtiqueta.Text.Trim().Length == 0)
            {
                var mensaje = "Debe indicar un comentario";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                txtGlosaEtiqueta.Focus();
                return;
            }
            try
            {
                var ok = Etiquetar();
                var mensaje = "";
                if (ok)
                {
                    mensaje = "Orden Actualizada";
                }
                else
                {
                    mensaje = "Orden No pudo ser actualizada";
                }

                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                popupDetalleBandeja.Hide();
                Refresh();
                return;
            }
            catch (Exception ex)
            {
                logger.Error("bandeja toledo, actualizando etiqueta: {0}", ex.Message);
                logger.Error("bandeja toledo, actualizando etiqueta: {0}", ex.StackTrace);
                var mensaje = ex.Message;
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                return;
            }

        }

        private bool Etiquetar()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var doc = mng.Consultar("documentos", Convert.ToInt32(HiddenFieldDocentry.Value), Convert.ToInt32(HiddenFieldDocTipo.Value));
            if (doc != null && doc.EstadoOperativo != "NUL")
            {
                doc.Etiquetado = chkEtiquetar.Checked;
                doc.Etiqueta = txtGlosaEtiqueta.Text;
                doc = mng.GuardarEtiqueta("documentos/etiqueta", doc);
                return true;
            }
            return false;
        }
        protected void Asignar_Event(object sender, EventArgs e)
        {
            try
            {
                if (cboOperadores.SelectedValue == "")
                {
                    var mensaje = "Debe indicar un operador";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                    return;
                }

                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
                var doc = mng.Consultar("documentos", Convert.ToInt32(HiddenFieldDocentry.Value), Convert.ToInt32(HiddenFieldDocTipo.Value));
                if (doc != null && doc.EstadoOperativo != "NUL")
                {
                    Documento docpk = new Documento();
                    docpk.DocEstado = "A";
                    docpk.DocTipo = 2010;
                    docpk.DocFecha = DateTime.Now.Date;
                    docpk.SocioCode = doc.SocioCode;
                    docpk.RazonSocial = doc.RazonSocial;
                    docpk.VendedorCode = doc.VendedorCode;
                    docpk.UsuarioCode = doc.UsuarioCode;
                    docpk.UsuarioNombre = doc.UsuarioNombre;
                    docpk.UsuarioCodeResponsable = cboOperadores.SelectedValue;
                    docpk.FechaRegistro = DateTime.Now;
                    docpk.Version = doc.Version;
                    docpk.BaseEntry = doc.DocEntry;
                    docpk.BaseTipo = doc.DocTipo;
                    docpk.RetiraCliente = doc.RetiraCliente;
                    docpk.UsuarioResponsable = cboOperadores.SelectedItem.Text;
                    docpk.FechaEntrega = doc.FechaEntrega;
                    docpk.Iva = doc.Iva;
                    docpk.Neto = doc.Neto;
                    docpk.Total = doc.Total;

                    docpk.Lineas = new List<DocumentoLinea>();
                    ManagerInventario mngInv = new ManagerInventario(urlbase, logger);

                    foreach (var l in doc.Lineas)
                    {
                        if (l.CantidadPendiente > 0 && l.LineaEstado == "A")
                        {
                            var prod = mngInv.Get("productos", l.ProdCode);

                            docpk.Lineas.Add(new DocumentoLinea
                            {
                                BaseEntry = l.DocEntry,
                                BaseLinea = l.DocLinea,
                                BaseTipo = doc.DocTipo,
                                CantidadSolicitada = l.CantidadPendiente,
                                ProdCode = l.ProdCode,
                                ProdNombre = l.ProdNombre,
                                MarcaNombre = l.MarcaNombre,
                                RefrigeraNombre = l.RefrigeraNombre,
                                OrigenNombre = l.OrigenNombre,
                                BodegaCode = l.BodegaCode,
                                CantidadPendiente = l.CantidadPendiente,
                                TieneReceta = prod.TieneReceta,
                                RefrigeraCode = l.RefrigeraCode,
                                MarcaCode = l.MarcaCode,
                                ProdTipo = l.ProdTipo,
                                TipoCode = l.TipoCode,
                            });
                        }
                    }

                    docpk = mng.Guardar("documentos", docpk);
                    if (docpk != null)
                    {
                        var mensaje = "Picking Guardado";
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                        
                        popupDetalleBandeja.Hide();
                        //ImprimirPicking(docpk.DocEntry);
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

        protected void ClosePopupBandeja(object sender, EventArgs e)
        {
            popupDetalleBandeja.Hide();
        }

        #region Imprimir Picking -------------

        private void ImprimirPicking(int docentry)
        {
            //Response.Redirect("/view-pdf?docentry=" + docentry.ToString());
            //HttpContext.Current.Response.Write(String.Format("<script language='javascript'>window.open('{0}','_newtab');</script>", "/view-pdf?docentry=" + docentry.ToString()));
            HttpContext.Current.Response.Write(String.Format("<script language='javascript'>window.open('{0}','_blank');</script>", String.Format("/view-pdf?docentry={0}&origen={1}", docentry.ToString(), "produccion")));
        }
        //public void DownloadFile(MemoryStream mstream, int DocNum)
        //{
        //    HttpContext.Current.Response.Buffer = true;
        //    HttpContext.Current.Response.Expires = 0;
        //    HttpContext.Current.Response.Clear();
        //    HttpContext.Current.Response.ContentType = @".pdf, application/pdf";
        //    HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
        //    HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + String.Format("Picking-{0}.pdf", DocNum));

        //    Byte[] bytes = mstream.ToArray();

        //    HttpContext.Current.Response.BinaryWrite(bytes);


        //    HttpContext.Current.Response.Flush();
        //    Context.ApplicationInstance.CompleteRequest();

        //}
        #endregion

        protected void CerrarItem_Event(object sender, EventArgs e)
        {
            try
            {
                var ok = CerrarItem();
                var mensaje = "";
                if (ok)
                {
                    mensaje = "Orden Actualizada";
                }
                else
                {
                    mensaje = "Orden No pudo ser actualizada";
                }

                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                popupDetalleBandeja.Hide();
                Refresh();
                return;
            }
            catch (Exception ex)
            {
                logger.Error("bandeja toledo, actualizando estado item: {0}", ex.Message);
                logger.Error("bandeja toledo, actualizando estado item: {0}", ex.StackTrace);
                var mensaje = ex.Message;
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                return;
            }
        }

        private bool CerrarItem()
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var doc = mng.Consultar("documentos", Convert.ToInt32(HiddenFieldDocentry.Value), Convert.ToInt32(HiddenFieldDocTipo.Value));
            if (doc != null && doc.DocEstado != "C")
            {
                bool existenitemseleccionados = false;
                foreach (GridViewRow row in gvDetalle.Rows)
                {
                    if ((row.FindControl("chkSelItem") as CheckBox).Checked && (row.FindControl("lblLineaEstado") as Label).Text == "A")
                    {
                        var lineaitem = Convert.ToInt32((row.FindControl("lblLineaItem") as Label).Text);
                        var item = doc.Lineas.Find(x => x.LineaItem == lineaitem);
                        if (item != null)
                        {
                            item.LineaEstado = "C";
                            existenitemseleccionados = true;
                        }

                    }
                }
                if (existenitemseleccionados)
                {
                    doc = mng.GuardarEtiqueta("documentos/estadoitem", doc);
                    return true;
                }
            }

            return false;
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

        protected void gvBandeja_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var etiquetado = (e.Row.FindControl("chkEtiquetado") as CheckBox).Checked;
                if (etiquetado)
                {
                    for (int i = 0; i < e.Row.Cells.Count; i++)
                    {
                        e.Row.Cells[i].BackColor = System.Drawing.Color.LightYellow;
                    }
                }
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
            var list = mng.List("documentos/list", 3010, "A", "", "PRODUCCION");
            var list2 = Utility.DynamicSort1<DocumentosResult>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["bandejaproduccion"] == null)
            {
                return;
            }
            List<DocumentosResult> listGrilla = (List<DocumentosResult>)HttpContext.Current.Session["bandejaproduccion"];
            if (listGrilla.Count > 0)
            {

                string nombrearcivo = String.Format("BandejaProduccion {0:dd-MM-yyyy HH.mm}.xls", DateTime.Now);
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