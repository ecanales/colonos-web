using ClosedXML.Excel;
using Colonos.AgenteEndPoint;
using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using Colonos.Web.Documentos;
using Microsoft.Reporting.WebForms;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace Colonos.Web
{
    public partial class bandeja_toledo : System.Web.UI.Page
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
            //var list = mng.List("documentos/list", "TOLEDO", 2010);
            var list = mng.List("documentos/list", 10,"A","PREP", "TOLEDO");
            //list = list.FindAll(x => x.Completado < 1 && x.Etiquetado == chkSoloEtiquetados.Checked).ToList();
            list = list.FindAll(x => x.CompletadoTol < 1).ToList();
            if(chkSoloEtiquetados.Checked)
            {
                list = list.FindAll(x => x.Etiquetado == chkSoloEtiquetados.Checked).ToList();
            }    

            lblTotalRegistrosBandeja.Text= String.Format("{0}", list.Count);
            gvBandeja.DataSource = list.OrderByDescending(x => x.Etiquetado);
            gvBandeja.DataBind();

            HttpContext.Current.Session["bandejatoledo"] = list;

            //list = mng.List("documentos/list", 16, "A", "", "TOLEDO");
            //list = list.FindAll(x => x.Completado < 1 ).ToList();

            
            //gvBandejamp.DataSource = list;
            //gvBandejamp.DataBind();
        }

        protected void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
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
                txtRazonSocial.Text = pedido.RazonSocial;
                txtNumeroPedido.Text = pedido.BaseEntry==null ? pedido.DocEntry.ToString() : pedido.BaseEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtFechadeEntrega.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                txtVendedorPedido.Text = pedido.VendedorNombre;
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
            
            var prop = mng.ListUsuarios("usuarios/list","CALIDAD", "CAMARA");
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

                prop = mng.ListUsuarios("usuarios/list", "OPERADOR-PROD", "OPERADOR-PROD");
                if (prop != null && prop.Any())
                {
                    json = JsonConvert.SerializeObject(prop);
                    list = JsonConvert.DeserializeObject<List<User>>(json);
                    foreach (var o in list)
                    {
                        listoper.Add(o);
                    }
                }

                cboOperadores.DataSource = listoper.OrderBy(x => x.Nombre);
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
                var pendiente = (e.Row.FindControl("txtCantidad") as Label).Text;
                var yamarcado = (e.Row.FindControl("lblCantidadReal") as Label).Text;
                var lineaestado = (e.Row.FindControl("lblLineaEstado") as Label).Text;
                var enproduccion = (e.Row.FindControl("lblEnProduccion") as Label).Text;

                if (pendiente == "")
                    pendiente = "0";

                if (yamarcado == "")
                    yamarcado = "0";


                if (Convert.ToDecimal(pendiente) ==0 || lineaestado=="C" || enproduccion == "S" || (Convert.ToDecimal(pendiente) - Convert.ToDecimal(yamarcado) <=0))
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
            catch(Exception ex)
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
                //Simular procesamiento de datos
                //System.Threading.Thread.Sleep(1000); // Simula un retraso de 2 segundos
                if (cboOperadores.SelectedValue == "")
                {
                    var mensaje = "Debe indicar un Responsable";
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

                    docpk.Lineas = new List<DocumentoLinea>();
                    ManagerInventario mngInv = new ManagerInventario(urlbase, logger);

                    foreach (var l in doc.Lineas)
                    {
                        if ((l.CantidadPendiente - l.CantidadReal) > 0 && l.LineaEstado=="A")
                        {
                            if (l.EnProduccion != "S")
                            {
                                var prod = mngInv.Get("productos", l.ProdCode);

                                docpk.Lineas.Add(new DocumentoLinea
                                {
                                    BaseEntry = l.DocEntry,
                                    BaseLinea = l.DocLinea,
                                    BaseTipo = l.DocTipo,
                                    DocTipo = Convert.ToInt32(docpk.DocTipo),
                                    CantidadSolicitada = l.CantidadPendiente - l.CantidadReal,
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
                        if (docpk.BaseTipo==16)
                        {
                            ImprimirPickingSM(docpk.DocEntry);
                        }
                        else
                        {
                            ImprimirPicking(docpk.DocEntry);
                        }
                        Refresh();
                    }
                }
            }
            catch(Exception ex)
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


        
        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["bandejatoledo"] == null)
            {
                return;
            }
            List<DocumentosResult> listGrilla = (List<DocumentosResult>)HttpContext.Current.Session["bandejatoledo"];
            if (listGrilla.Count > 0)
            {

                string nombrearcivo = String.Format("BandejaToledo {0:dd-MM-yyyy HH.mm}.xls", DateTime.Now);
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

        #region Imprimir Picking -------------

        private void ImprimirPicking(int docentry)
        {
            //HttpContext.Current.Response.Write(String.Format("<script language='javascript'>window.open('{0}','_blank');</script>", String.Format("/view-pdf?docentry={0}&origen={1}", docentry.ToString(), "toledo")));
        }

        private void ImprimirPickingSM(int docentry)
        {
            //HttpContext.Current.Response.Write(String.Format("<script language='javascript'>window.open('{0}','_blank');</script>", String.Format("/view-pdf?docentry={0}&origen={1}&sm=1", docentry.ToString(), "toledo")));
        }

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
            if (doc != null && doc.EstadoOperativo != "NUL")
            {
                //doc.Etiquetado = chkEtiquetar.Checked;
                //doc.Etiqueta = txtGlosaEtiqueta.Text;
                //doc = mng.GuardarEtiqueta("documentos/etiqueta", doc);
                //return true;

                bool existenitemseleccionados = false;
                foreach (GridViewRow row in gvDetalle.Rows)
                {
                    if ((row.FindControl("chkSelItem") as CheckBox).Checked && (row.FindControl("lblLineaEstado") as Label).Text=="A")
                    {
                        var lineaitem = Convert.ToInt32((row.FindControl("lblLineaItem") as Label).Text);
                        var item = doc.Lineas.Find(x => x.LineaItem == lineaitem);
                        if(item!=null)
                        {
                            item.LineaEstado = "C";
                            existenitemseleccionados = true;
                        }

                    }
                }
                if(existenitemseleccionados)
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
            var list = mng.List("documentos/list", 10, "A", "PREP", "TOLEDO");
            //list = list.FindAll(x => x.CompletadoTol < 1 && x.Etiquetado == chkSoloEtiquetados.Checked).ToList();
            list = list.FindAll(x => x.CompletadoTol < 1).ToList();
            if (chkSoloEtiquetados.Checked)
            {
                list = list.FindAll(x => x.Etiquetado == chkSoloEtiquetados.Checked).ToList();
            }

            var list2 = Utility.DynamicSort1<DocumentosResult>(list, sortExpression, direction);
            HttpContext.Current.Session["bandeja-toledo"] = list2;
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }

        #endregion

        #region ****** INI ORDEN PRODUCCION OPDC *********
        protected void PrepararOrdeProduccion_Event(object sender, EventArgs e)
        {
            //popup
            PrepararOrdeProduccion();

            popupDetalleBandeja.Hide();
            popupDetalleOrdenProd.Show();

        }

        private void PrepararOrdeProduccion()
        {
            //obtener orden de venta
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var pedido = mng.Consultar("documentos", Convert.ToInt32(HiddenFieldDocentry.Value), Convert.ToInt32(HiddenFieldDocTipo.Value));
            var mngconfig = new ManagerParametros(urlbase, logger);
            var config = mngconfig.Get("parametros");

            if (pedido != null && pedido.EstadoOperativo != "NUL" && pedido.DocEstado == "A")
            {
                Documento opdc = new Documento
                {
                    BaseEntry = pedido.BaseEntry,
                    BaseTipo = pedido.BaseTipo,
                    DocEstado = "A",
                    DocTipo = 3010,
                    DocFecha = pedido.DocFecha,
                    SocioCode = pedido.SocioCode,
                    RazonSocial = pedido.RazonSocial,
                    VendedorCode = pedido.VendedorCode,
                    UsuarioCode = pedido.UsuarioCode,
                    Neto = pedido.Neto,
                    Iva = pedido.Iva,
                    Total = pedido.Total,
                    FechaRegistro = Convert.ToDateTime(pedido.FechaRegistro),
                    FechaIngresoPrep = Convert.ToDateTime(pedido.FechaRegistro),
                    Version = pedido.Version,
                    UsuarioNombre = pedido.UsuarioNombre,
                    BodegaCode = config.BodegaProduccion,
                    FechaEntrega = pedido.FechaEntrega,
                    RetiraCliente = pedido.RetiraCliente,
                    Lineas = new List<DocumentoLinea>(),
                    DireccionCode = pedido.DireccionCode,
                    CondicionCode = pedido.CondicionCode
                };

                txtRazonSocialProd.Text = pedido.RazonSocial;
                txtNumeroPedidoProd.Text = pedido.BaseEntry == null ? pedido.DocEntry.ToString() : pedido.BaseEntry.ToString();
                txtFechaPedidoProd.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtFechadeEntregaProd.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                txtVendedorPedidoProd.Text = pedido.VendedorNombre; // .VendedorCode;
                chkRetiraClienteProd.Checked = Convert.ToBoolean(pedido.RetiraCliente);

                //generar detalle -----------
                var listProduccion = new List<DocumentoLinea>();

                foreach (var i in pedido.Lineas)
                {
                    if (true)
                    {
                        

                        if (i.TipoCode == "B")
                        {
                            //var i = pedido.Lineas.Find(x => x.ProdCode == i.ProdCode && x.DocLinea == Convert.ToInt32(i.DocLinea));

                            if (true)
                            {
                                decimal enviaraproduccion = Convert.ToDecimal(i.CantidadSolicitada) - (Convert.ToDecimal(i.CantidadReal) + Convert.ToDecimal(i.CantidadEntregada));

                                if (enviaraproduccion > 0)
                                {
                                    opdc.Lineas.Add(new DocumentoLinea
                                    {
                                        BaseEntry = i.BaseEntry,
                                        BaseLinea = i.BaseLinea,
                                        BaseTipo = i.BaseTipo,
                                        DocTipo = opdc.DocTipo,

                                        CantidadPendiente = Convert.ToDecimal(enviaraproduccion),
                                        CantidadReal = i.CantidadReal, // 0,
                                        CantidadSolicitada = Convert.ToDecimal(i.CantidadSolicitada),
                                        TotalSolicitado = Convert.ToDecimal(i.PrecioFinal) * i.CantidadSolicitada,
                                        TotalReal = 0,
                                        BodegaCode = config.BodegaProduccion,

                                        Descuento = Convert.ToDecimal(i.Descuento),
                                        FechaConfirma = i.FechaConfirma,
                                        LineaEstado = "A", // i.LineaEstado,
                                        PrecioFinal = Convert.ToDecimal(i.PrecioFinal),
                                        PrecioUnitario = Convert.ToDecimal(i.PrecioUnitario),
                                        PrecioVolumen = Convert.ToDecimal(i.PrecioVolumen),
                                        Disponible = 0,

                                        FactorPrecio = Convert.ToDecimal(i.FactorPrecio),
                                        ProdCode = i.ProdCode,
                                        ProdNombre = i.ProdNombre,
                                        UsuarioCodeConfirma = i.UsuarioCodeConfirma,
                                        FamiliaCode = i.FamiliaCode,
                                        AnimalCode = i.AnimalCode,
                                        Costo = i.Costo,
                                        FormatoVtaCode = i.FormatoVtaCode,
                                        Margen = i.Margen,
                                        Medida = i.Medida,
                                        TipoCode = i.TipoCode,
                                        LineaItem = i.LineaItem,
                                        Volumen = i.Volumen,

                                        MargenRegla = i.MargenRegla,
                                        AnimalNombre = i.AnimalNombre,
                                        FamiliaNombre = i.FamiliaNombre,
                                        FrmtoVentaNombre = i.FrmtoVentaNombre,
                                        MarcaCode = i.MarcaCode,
                                        MarcaNombre = i.MarcaNombre,
                                        OrigenCode = i.OrigenCode,
                                        OrigenNombre = i.OrigenNombre,
                                        RefrigeraCode = i.RefrigeraCode,
                                        RefrigeraNombre = i.RefrigeraNombre,
                                        SolicitadoAnterior = 0,
                                        CantidadEntregada = 0,
                                        Completado = 0,
                                        StockActual=i.StockActual

                                    });
                                }
                            }
                        }
                    }
                }


                //if (opdc.Lineas.Any())
                //{
                    gvDetalleOrdenProd.DataSource = opdc.Lineas;
                    gvDetalleOrdenProd.DataBind();
                //}
            }
        }

        protected void gvDetalleOrdenProd_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }

        protected void GenerarOrdenProduccion_Event(object sender, EventArgs e)
        {
            GenerarOrdenProduccion();
        }

        private void GenerarOrdenProduccion()
        {
            //obtener orden de venta
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var pedido = mng.Consultar("documentos", Convert.ToInt32(HiddenFieldDocentry.Value), Convert.ToInt32(HiddenFieldDocTipo.Value));
            var mngconfig = new ManagerParametros(urlbase, logger);
            var config = mngconfig.Get("parametros");

            if (pedido != null && pedido.EstadoOperativo != "NUL" && pedido.DocEstado == "A")
            {
                Documento opdc = new Documento
                {
                    BaseEntry = pedido.DocEntry,
                    BaseTipo = pedido.DocTipo,
                    DocEstado = "A",
                    DocTipo = 3010,
                    DocFecha = pedido.DocFecha,
                    SocioCode = pedido.SocioCode,
                    RazonSocial = pedido.RazonSocial,
                    VendedorCode = pedido.VendedorCode,
                    UsuarioCode = pedido.UsuarioCode,
                    Neto = pedido.Neto,
                    Iva = pedido.Iva,
                    Total = pedido.Total,
                    FechaRegistro = Convert.ToDateTime(pedido.FechaRegistro),
                    FechaIngresoPrep = Convert.ToDateTime(pedido.FechaRegistro),
                    Version = pedido.Version,
                    UsuarioNombre = pedido.UsuarioNombre,
                    BodegaCode = config.BodegaProduccion,
                    FechaEntrega = pedido.FechaEntrega,
                    RetiraCliente = pedido.RetiraCliente,
                    Lineas = new List<DocumentoLinea>(),
                    DireccionCode = pedido.DireccionCode,
                    CondicionCode = pedido.CondicionCode
                };
                //generar detalle -----------
                var listProduccion = new List<DocumentoLinea>();
                var seguir = true;

                foreach (GridViewRow row in gvDetalleOrdenProd.Rows)
                {
                    if ((row.FindControl("chkSelItem") as CheckBox).Checked)
                    {
                        var tipoprod = (row.FindControl("lblTipoCode") as Label).Text;
                        var prodcode = (row.FindControl("lblProdCode") as Label).Text;
                        var lieaitem = (row.FindControl("lblLineaItem") as Label).Text;
                        var solicitado = (row.FindControl("lblSolicitado") as Label).Text;
                        var cantiadadenviar = (row.FindControl("txtCantidadEnviar") as TextBox).Text.Replace(".", ",");

                        

                        if (tipoprod == "B")
                        {
                            if (Convert.ToDecimal(cantiadadenviar) > Convert.ToDecimal(solicitado))
                            {
                                var mensaje = "Cantidad a enviar no puede superar lo solicitado";
                                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                                sb.Append("alert('");
                                sb.Append(mensaje);
                                sb.Append("');");
                                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                                seguir = false;
                                break;
                            }
                            var i = pedido.Lineas.Find(x => x.ProdCode == prodcode && x.LineaItem == Convert.ToInt32(lieaitem));

                            if (i != null)
                            {
                                decimal enviaraproduccion = Convert.ToDecimal(cantiadadenviar);

                                if (enviaraproduccion > 0)
                                {
                                    opdc.Lineas.Add(new DocumentoLinea
                                    {
                                        BaseEntry = i.DocEntry,
                                        BaseLinea = i.DocLinea,
                                        BaseTipo = i.DocTipo,
                                        DocTipo = opdc.DocTipo,

                                        CantidadPendiente = Convert.ToDecimal(enviaraproduccion),
                                        CantidadReal = 0,
                                        CantidadSolicitada = Convert.ToDecimal(enviaraproduccion),
                                        TotalSolicitado = Convert.ToDecimal(i.PrecioFinal) * enviaraproduccion,
                                        TotalReal = 0,
                                        BodegaCode = config.BodegaProduccion,

                                        Descuento = Convert.ToDecimal(i.Descuento),
                                        FechaConfirma = i.FechaConfirma,
                                        LineaEstado = "A", // i.LineaEstado,
                                        PrecioFinal = Convert.ToDecimal(i.PrecioFinal),
                                        PrecioUnitario = Convert.ToDecimal(i.PrecioUnitario),
                                        PrecioVolumen = Convert.ToDecimal(i.PrecioVolumen),
                                        Disponible = 0,

                                        FactorPrecio = Convert.ToDecimal(i.FactorPrecio),
                                        ProdCode = i.ProdCode,
                                        ProdNombre = i.ProdNombre,
                                        UsuarioCodeConfirma = i.UsuarioCodeConfirma,
                                        FamiliaCode = i.FamiliaCode,
                                        AnimalCode = i.AnimalCode,
                                        Costo = i.Costo,
                                        FormatoVtaCode = i.FormatoVtaCode,
                                        Margen = i.Margen,
                                        Medida = i.Medida,
                                        TipoCode = i.TipoCode,
                                        LineaItem = i.LineaItem,
                                        Volumen = i.Volumen,

                                        MargenRegla = i.MargenRegla,
                                        AnimalNombre = i.AnimalNombre,
                                        FamiliaNombre = i.FamiliaNombre,
                                        FrmtoVentaNombre = i.FrmtoVentaNombre,
                                        MarcaCode = i.MarcaCode,
                                        MarcaNombre = i.MarcaNombre,
                                        OrigenCode = i.OrigenCode,
                                        OrigenNombre = i.OrigenNombre,
                                        RefrigeraCode = i.RefrigeraCode,
                                        RefrigeraNombre = i.RefrigeraNombre,
                                        SolicitadoAnterior = 0,
                                        CantidadEntregada = 0,
                                        Completado = 0

                                    });
                                }
                            }
                        }
                    }
                }


                if (opdc.Lineas.Any() && seguir)
                {
                    try
                    {
                        opdc = mng.Guardar("documentos", opdc);
                        if (opdc != null)
                        {
                            var mensaje = "Orden de Produccion Guardado";
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append("alert('");
                            sb.Append(mensaje);
                            sb.Append("');");
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                            popupDetalleOrdenProd.Hide();
                            Refresh();
                        }
                    }
                    catch (Exception ex)
                    {
                        logger.Error("{0} Error: {1}", "Guardar Orden de Produccion", ex.Message);
                        logger.Error("{0} StackTrace: {1}", "Orden de Produccion", ex.StackTrace);
                        var mensaje = ex.Message;
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                    }
                }
            }
        }
        protected void ClosePopupOrdenProd(object sender, EventArgs e)
        {
            popupDetalleOrdenProd.Hide();
        }

        #endregion *** FIN ORDEN PRODUCCION OPDC *********
    }
}