using Colonos.AgenteEndPoint;
using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using Microsoft.Reporting.WebForms;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class confirmar_picking : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                string bodegapicking = Request.QueryString["bodegapicking"];
                if(bodegapicking == null)
                {
                    bodegapicking = "";
                }
                lblTitulo.Text = String.Format("Confirmar Picking - Marcado {0}", bodegapicking);
                CargaCombos(bodegapicking);
                Refresh();
            }
        }

        protected void FiltrarOperador_Event(object sender, EventArgs e)
        {
            if (Session["bandejaconfirma"] != null )
            {
                var list = (List<DocumentosResult>)Session["bandejaconfirma"];
                if (cboOperadores.SelectedValue != "")
                {
                    list = list.FindAll(x => x.UsuarioResponsable == cboOperadores.SelectedValue);
                }
                gvBandeja.DataSource = list;
                gvBandeja.DataBind();

                //HttpContext.Current.Session["bandejaconfirma"] = list;
            }
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.ListPicking("documentos/listpicking", cboBodegas.SelectedValue, "A");
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();

            HttpContext.Current.Session["bandejaconfirma"] = list;
            //Session["listpicking"] = list;

            var groupedCustomerList = list.GroupBy(u => u.UsuarioResponsable).ToList();
            
            var listOperadores = new List<User>();
            listOperadores.Add(new User { Usuario = "", Nombre = "(TODOS)" });
            foreach (var o in groupedCustomerList)
            {
                listOperadores.Add(new User { Usuario = o.Key, Nombre = o.Key });
            }
            cboOperadores.DataSource = listOperadores;
            cboOperadores.DataValueField = "Usuario";
            cboOperadores.DataTextField = "Nombre";
            cboOperadores.DataBind();

            
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

                string docentry = (row.FindControl("lblDocEntry") as LinkButton).Text;
                string razonsocial = (row.FindControl("lblCliente") as Label).Text;
                string basetipo = (row.FindControl("lblBaseTipo") as Label).Text;
                CargaDetalleBandeja(Convert.ToInt32(docentry), razonsocial, basetipo);
                popupDetalleBandeja.Show();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
            }
        }

        private void CargaDetalleBandeja(int docentry, string razonsocial, string basetipo)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            LimpiaBandeja();
            //consultar pedido
            var picking = mng.Consultar("documentos", docentry, 2010);
            var pedido = mng.Consultar("documentos", Convert.ToInt32(picking.BaseEntry), Convert.ToInt32(picking.BaseTipo));
            if (picking != null && pedido != null)
            {
                HiddenFieldDocentry.Value = docentry.ToString();
                lblRazonSocial.Text = pedido.RazonSocial;
                txtRazonSocial.Text = pedido.RazonSocial;
                txtNumeroPedido.Text = pedido.DocEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtFechadeEntrega.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                txtVendedorPedido.Text = pedido.VendedorCode;
                chkRetiraCliente.Checked = Convert.ToBoolean(pedido.RetiraCliente);
                txtResponsable.Text = picking.UsuarioResponsable;
                txtDocEntryPicking.Text = docentry.ToString();

                ViewState["basetipo"] = basetipo;

                if (picking.Lineas.Any())
                {
                    var detalle = picking.Lineas;
                    gvDetalle.DataSource = detalle;
                    gvDetalle.DataBind();
                    HttpContext.Current.Session["detallepk"] = detalle;
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
            chkConfirmar.Checked = false;
            gvDetalle.DataSource = null;
            gvDetalle.DataBind();
        }

        private void CargaCombos(string bodegapicking)
        {
            if (bodegapicking != "")
            {
                if (HttpContext.Current.Session["bodegas"] == null)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerInventario mng = new ManagerInventario(urlbase, logger);
                    var bodegas = mng.ListBodegas("productos/bodegas");
                    HttpContext.Current.Session["bodegas"] = bodegas;
                }
                var list = (List<OBOD>)HttpContext.Current.Session["bodegas"];
                if(list.Count==0)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerInventario mng = new ManagerInventario(urlbase, logger);
                    var bodegas = mng.ListBodegas("productos/bodegas");
                    HttpContext.Current.Session["bodegas"] = bodegas;
                    list = (List<OBOD>)HttpContext.Current.Session["bodegas"];
                }
                cboBodegas.DataSource = list;
                cboBodegas.DataValueField = "BodegaCode";
                cboBodegas.DataTextField = "BodegaNombre";
                cboBodegas.DataBind();
                cboBodegas.SelectedValue = bodegapicking;
                cboBodegas.Enabled = false;
            }
        }

        protected void gvDesglose_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //string bodegacode = (e.Row.FindControl("lblBodegaCode") as Label).Text;
                //DropDownList cboBodegaCode = e.Row.FindControl("cboBodegaCode") as DropDownList;
                //if (HttpContext.Current.Session["bodegas"] == null)
                //{
                //    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                //    ManagerInventario mng = new ManagerInventario(urlbase, logger);
                //    var bodegas = mng.ListBodegas("productos/bodegas");
                //    HttpContext.Current.Session["bodegas"] = bodegas;
                //}
                //var list = (List<OBOD>)HttpContext.Current.Session["bodegas"];
                //cboBodegaCode.DataSource = list;
                //cboBodegaCode.DataValueField = "BodegaCode";
                //cboBodegaCode.DataTextField = "BodegaNombre";
                //cboBodegaCode.DataBind();
                //cboBodegaCode.SelectedValue = bodegacode;


                string prodtipo = (e.Row.FindControl("lblProdTipoDesglose") as Label).Text;
                if (prodtipo == "Alternativo")
                {
                    for (var i=0;i< e.Row.Cells.Count;i++)
                    {
                        e.Row.Cells[i].BackColor = System.Drawing.Color.LemonChiffon;
                        //e.Row.Cells[i].ForeColor = System.Drawing.Color.Black;
                    }
                }else if (prodtipo == "Principal")
                {
                    (e.Row.FindControl("txtCantidadRealDesglose") as TextBox).Visible = false;
                }
            }
        }
        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (ViewState["basetipo"] != null)
            {
                var basetipo = ViewState["basetipo"].ToString();

                if (e.Row.RowType == DataControlRowType.Header)
                {
                    if (basetipo == "16" || basetipo == "3010")
                        e.Row.Cells[17].Visible = false;
                    if (basetipo == "10" || basetipo == "3010")
                        e.Row.Cells[18].Visible = false;
                    //if (cboBodegas.SelectedValue == "PRODUCCION")
                    //    e.Row.Cells[16+1].Visible = false;
                    //if (cboBodegas.SelectedValue == "TOLEDO")
                    //    e.Row.Cells[17+1].Visible = false;
                }

                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    if (basetipo == "10" || basetipo == "3010" ) //25-09-2024: marcado toledo y produccion se hace directamente, solo toledo se debe indicar la cantidad de cajas
                    {
                        (e.Row.FindControl("lblCantidadReal") as TextBox).Enabled = true;
                        if (basetipo == "10")
                            (e.Row.FindControl("lblCajas") as TextBox).Enabled = true;
                        if (basetipo == "3010")
                            e.Row.Cells[17].Visible = false;

                        (e.Row.FindControl("lblDesglose") as LinkButton).Visible = false;
                        e.Row.Cells[18].Visible = false;
                    }
                    else if (basetipo == "16") //25-09-2024: marcado desglose para OPV se aplicara en nuevo formilario, solo de indican las cantidades marcadas del producto preparado
                    {
                        (e.Row.FindControl("lblCantidadReal") as TextBox).Enabled = false;
                        (e.Row.FindControl("lblCajas") as TextBox).Enabled = false;
                        (e.Row.FindControl("lblCajas") as TextBox).Visible = false;
                        e.Row.Cells[16 + 1].Visible = false;
                        (e.Row.FindControl("lblCantidadReal") as TextBox).BorderStyle = BorderStyle.None;
                        (e.Row.FindControl("lblDesglose") as LinkButton).Visible = true;
                    }

                    //if (cboBodegas.SelectedValue == "TOLEDO")
                    //{
                    //    (e.Row.FindControl("lblCantidadReal") as TextBox).Enabled = true;
                    //    (e.Row.FindControl("lblCajas") as TextBox).Enabled = true;
                    //    (e.Row.FindControl("lblDesglose") as LinkButton).Visible = false;
                    //    e.Row.Cells[17 + 1].Visible = false;
                    //}
                    //else if (cboBodegas.SelectedValue == "PRODUCCION")
                    //{
                    //    (e.Row.FindControl("lblCantidadReal") as TextBox).Enabled = false;
                    //    (e.Row.FindControl("lblCajas") as TextBox).Enabled = false;
                    //    (e.Row.FindControl("lblCajas") as TextBox).Visible = false;
                    //    e.Row.Cells[16 + 1].Visible = false;
                    //    (e.Row.FindControl("lblCantidadReal") as TextBox).BorderStyle = BorderStyle.None;
                    //    (e.Row.FindControl("lblDesglose") as LinkButton).Visible = true;
                    //}
                }
            }
        }

        protected void ClosePopupBandeja(object sender, EventArgs e)
        {
            popupDetalleBandeja.Hide();
        }

        protected void Guardar_Event(object sender, EventArgs e)
        {
            
            // Simular procesamiento de datos
            //System.Threading.Thread.Sleep(5000); // Simula un retraso de 5 segundos
            bool seguir = true;
            Guardar(false, ref seguir);
            if (seguir)
            {
                popupDetalleBandeja.Hide();
                Refresh();
            }
        }

        private void Guardar(bool confirmado, ref bool seguir)
                {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            int docentrypkg = Convert.ToInt32(HiddenFieldDocentry.Value);
            var pkg = mng.Consultar("documentos", docentrypkg, 2010);
            try
            {
                
                foreach (GridViewRow row in gvDetalle.Rows)
                {
                    string docentry = (row.FindControl("lblDocEntry") as Label).Text;
                    string doclinea = (row.FindControl("lblDocLinea") as Label).Text;
                    string cantidadsolicitada = (row.FindControl("lblCantidad") as Label).Text;
                    string bodegacode = (row.FindControl("lblBodegaCode") as Label).Text;
                    string cantidadreal = (row.FindControl("lblCantidadReal") as TextBox).Text.Replace(".", ",");
                    string stockactual = (row.FindControl("lblStockActual") as Label).Text.Replace(".", "");
                    string cajas = (row.FindControl("lblCajas") as TextBox).Text;

                    if (cantidadreal == "")
                        cantidadreal = "0";

                    if (cajas == "")
                        cajas = "0";

                    if(Convert.ToDecimal(cantidadreal)>0 && Convert.ToInt32(cajas)==0 && bodegacode!="PRODUCCION")
                    {
                        (row.FindControl("lblCajas") as TextBox).BackColor = System.Drawing.Color.Red;
                        (row.FindControl("lblCajas") as TextBox).ForeColor = System.Drawing.Color.White;

                        var mensaje = "Debe indicar cantidad de cajas";
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                        seguir = false;
                        

                        return;
                    }

                    /*
                    
                    */

                    pkg.Lineas.Find(x => x.DocLinea == Convert.ToInt32(doclinea) && x.DocEntry == Convert.ToInt32(docentry)).CantidadReal = Convert.ToDecimal(cantidadreal);
                    if (confirmado)
                        pkg.Lineas.Find(x => x.DocLinea == Convert.ToInt32(doclinea) && x.DocEntry == Convert.ToInt32(docentry)).BodegaCode = bodegacode;


                    if (cantidadsolicitada == "")
                        cantidadsolicitada = "0";

                    
                    if (cantidadsolicitada != "0")
                    {
                        decimal completado = Convert.ToDecimal(cantidadsolicitada) == 0 ? 1 : Convert.ToDecimal(cantidadreal) / Convert.ToDecimal(cantidadsolicitada);
                        decimal diferencia = Convert.ToDecimal(cantidadsolicitada) - Convert.ToDecimal(cantidadreal);
                        decimal kilosporcaja = Convert.ToInt32(cajas) == 0 ? 1 : Convert.ToDecimal(cantidadreal) / Convert.ToInt32(cajas);
                        decimal tolerancia = Convert.ToDecimal(cantidadsolicitada) == 0 ? 0 : diferencia / Convert.ToDecimal(cantidadsolicitada);

                        
                        decimal toleranciapermitida = Convert.ToDecimal(ConfigurationManager.AppSettings.Get("tolerancia")); //Convert.ToDecimal("0,5");

                        decimal valortolerancia = toleranciapermitida * Convert.ToDecimal(cantidadsolicitada);

                        if (Convert.ToDecimal(stockactual) < Convert.ToDecimal(cantidadreal) && bodegacode != "PRODUCCION")
                        {
                            var mensaje = "Cantidad marcada sobrepasa stock disponible";
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append("alert('");
                            sb.Append(mensaje);
                            sb.Append("');");
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                            seguir = false;
                            return;
                        }
                        else if (Convert.ToDecimal(diferencia) < 0 && Math.Abs(diferencia)>valortolerancia) //if(Convert.ToDecimal(cantidadreal) > 0 )
                        {
                            (row.FindControl("lblCantidadReal") as TextBox).BackColor = System.Drawing.Color.Red;
                            (row.FindControl("lblCantidadReal") as TextBox).ForeColor = System.Drawing.Color.White;

                            var mensaje = "Cantidad marcada no permitida";
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append("alert('");
                            sb.Append(mensaje);
                            sb.Append("');");
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                            
                            seguir = false;
                            return;
                        }
                        else if ((tolerancia <= toleranciapermitida && tolerancia >= 0) || (tolerancia >= toleranciapermitida * -1 && tolerancia < 0))
                        {
                            completado = 1;
                        }
                        if (seguir)
                        {
                            pkg.Lineas.Find(x => x.DocLinea == Convert.ToInt32(doclinea) && x.DocEntry == Convert.ToInt32(docentry)).Completado = completado;
                            pkg.Lineas.Find(x => x.DocLinea == Convert.ToInt32(doclinea) && x.DocEntry == Convert.ToInt32(docentry)).Cajas = Convert.ToInt32(cajas);
                            pkg.Lineas.Find(x => x.DocLinea == Convert.ToInt32(doclinea) && x.DocEntry == Convert.ToInt32(docentry)).KilosPorCaja = kilosporcaja;
                            pkg.Lineas.Find(x => x.DocLinea == Convert.ToInt32(doclinea) && x.DocEntry == Convert.ToInt32(docentry)).Diferencia = diferencia;
                            pkg.Lineas.Find(x => x.DocLinea == Convert.ToInt32(doclinea) && x.DocEntry == Convert.ToInt32(docentry)).Tolerancia = tolerancia;


                            pkg.Completado = pkg.Completado ?? 0;
                            pkg.Completado += completado;
                        }
                    }

                }
                if (seguir)
                {
                    if (confirmado)
                    {
                        pkg.DocEstado = "C";
                    }

                    pkg.Completado = pkg.Completado / pkg.Lineas.Count();
                    try
                    {
                        mng.Actualizar("documentos", pkg);
                        popupDetalleBandeja.Hide();
                        Refresh();
                    }
                    catch (Exception ex)
                    {
                        var mensaje = ex.Message.Replace("#", "").Replace("\n", "");
                        logger.Error("se ha generado un error al cerrar picking:{0}, {1}", pkg.DocEntry, ex.Message);
                        logger.Error("picking:{0}, {1}", pkg.DocEntry, ex.StackTrace);
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                    }
                }
                //popupDetalleBandeja.Show();
            }
            catch (Exception ex)
            {
                var mensaje = ex.Message.Replace("#", "").Replace("\n", "");
                logger.Error("se ha generado un error al cerrar picking:{0}, {1}", pkg.DocEntry, ex.Message);
                logger.Error("picking:{0}, {1}", pkg.DocEntry, ex.StackTrace);
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

            }
        }

        protected void Confirmar_Event(object sender, EventArgs e)
        {
            if (!chkConfirmar.Checked)
            {
                var mensaje = "Debe confirmar cierre del picking";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                return;
            }
            bool seguir = true;
            Guardar(true, ref seguir);
        }

        protected void VerDesglose_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string docentry = (row.FindControl("lblDocEntry") as Label).Text;
            string doclinea = (row.FindControl("lblDocLinea") as Label).Text;
            string prodcode = (row.FindControl("lblProdCode") as Label).Text;
            string prodnombre = (row.FindControl("lblProdNombre") as Label).Text;
            string tipocode = (row.FindControl("lblTipoCode") as Label).Text;
            string cantidadsolicitada = (row.FindControl("lblCantidad") as Label).Text;
            string cantidadreal = (row.FindControl("lblCantidadReal") as TextBox).Text;
            string bodegacode = (row.FindControl("lblBodegaCode") as Label).Text;
            string tienereceta = (row.FindControl("lblTieneReceta") as Label).Text;
            string marca = (row.FindControl("lblMarcaNombre") as Label).Text;
            string refrigeracion = (row.FindControl("lblRefrigeraNombre") as Label).Text;
            string formatovta = (row.FindControl("lblFrmtoVentaNombre") as Label).Text;
            string stockactual= (row.FindControl("lblStockActual") as Label).Text;

            if (stockactual.Trim().Length == 0)
                stockactual = "0";
            
            Label1.Text = String.Format("{0}", bodegacode);
            lblProducto.Text = String.Format("{0}", prodnombre);
            txtProdCodeDesglose.Text = prodcode;
            txtClienteDesglose.Text = lblRazonSocial.Text;
            txtNumeroPedidoDesglose.Text = txtNumeroPedido.Text;
            txtVendedorDesglose.Text = txtVendedorPedido.Text;
            txtFormatoDesglose.Text = formatovta;
            txtRefrigeracionDesglose.Text = refrigeracion;
            txtMarcaDesglose.Text = marca;

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mngInv = new ManagerInventario(urlbase, logger);

            //consultar si desglose ya existe, usar baseentry
            var baseentry = docentry;
            ManagerDocumentos mngdoc = new ManagerDocumentos(urlbase, logger);
            var doc = mngdoc.ConsultarBase("documentos/base/linea", Convert.ToInt32(baseentry),2110,Convert.ToInt32(doclinea));
            if (doc != null && doc.Lineas.Any() && doc.Lineas.FindAll(x => x.BaseLinea.ToString()==doclinea).Any())
            {
                foreach(var d in doc.Lineas)
                {
                    d.LineaEstado = doc.DocEstado;
                }
                gvDesglose.DataSource = doc.Lineas;
                gvDesglose.DataBind();
            }
            else
            {
                //agregar item del picking
                var list = new List<DocumentoLinea>();
                list.Add(new DocumentoLinea
                {
                    ProdCode = prodcode,
                    ProdNombre = prodnombre,
                    CantidadSolicitada = Convert.ToDecimal(cantidadsolicitada),
                    CantidadReal = Convert.ToDecimal(cantidadreal),
                    BodegaCode = bodegacode == "TOLEDO" ? "PRODUCCION" : "TOLEDO", //bodegacode, //El producto principal siempre va a TOLEDO
                    BaseEntry = Convert.ToInt32(docentry),
                    BaseLinea = Convert.ToInt32(doclinea),
                    ProdTipo = "Principal",
                    TipoCode = tipocode,
                    StockActual = Convert.ToDecimal(stockactual)
                });

                //consultar si producto tiene receta ----
                if (tienereceta=="S")
                {
                    var receta = mngInv.ListReceta("recetas", prodcode, bodegacode);
                    if(receta!=null && receta.Lineas!=null  && receta.Lineas.Any())
                    {
                        var prodcoderefglosa = "";
                        foreach (var r in receta.Lineas.FindAll(x =>x.Stock>0).ToList())
                        {
                            prodcoderefglosa = r.ProdCodeRef;

                            list.Add(new DocumentoLinea
                            {
                                ProdCode = r.ProdCodeRef,
                                ProdNombre = r.ProdNombreRef,
                                CantidadSolicitada = 0,
                                CantidadReal = 0,
                                BodegaCode = bodegacode,
                                BaseEntry = Convert.ToInt32(docentry),
                                BaseLinea = Convert.ToInt32(doclinea),
                                ProdTipo = "Alternativo",
                                ProdCodeRefGlosa = prodcoderefglosa,
                                TipoCode = r.TipoCode,
                                StockActual = r.Stock
                            });

                            var basetipo = ViewState["basetipo"].ToString();
                            if (basetipo == "10" || basetipo == "3010")
                            {
                                //17-09-2024: ya no se marcan los productos desglose, se realizaran en nuevo formulario de rendición ---
                                ////agregar desglose por cada producto alternativo ----
                                //var listdesglose = mngInv.List("productos/desglose", "S");
                                //if (listdesglose.Any())
                                //{
                                //    foreach (var p in listdesglose)
                                //    {
                                //        list.Add(new DocumentoLinea
                                //        {
                                //            ProdCode = p.ProdCode,
                                //            ProdNombre = p.ProdNombre,
                                //            CantidadSolicitada = 0,
                                //            CantidadReal = 0,
                                //            BodegaCode = bodegacode,
                                //            BaseEntry = Convert.ToInt32(docentry),
                                //            BaseLinea = Convert.ToInt32(doclinea),
                                //            ProdTipo = "Desglose",
                                //            ProdCodeRefGlosa = prodcoderefglosa
                                //        });
                                //    }
                                //}
                                ////---------------------------------------------------
                            }
                        }
                    }
                }
                //---------------------------------------





                gvDesglose.DataSource = list;
                gvDesglose.DataBind();
            }

            popupDetalleBandeja.Hide();
            popupDesglose.Show();
        }

        protected void ClosePopupDesglose(object sender, EventArgs e)
        {
            
            popupDesglose.Hide();
            popupDetalleBandeja.Show();
        }
        protected void GuardarDesglose_Event(object sender, EventArgs e)
        {
            var listdetalle = (List<DocumentoLinea>)HttpContext.Current.Session["detallepk"];
            var listdesglose = new List<DocumentoLinea>();
            string docentry = "";
            string doclinea = "";
            string baseentry = "";
            string baselinea = "";
            string prodcoderefglosa = "";

            foreach (GridViewRow row in gvDesglose.Rows)
            {
                docentry = (row.FindControl("lblDocEntryDesglose") as Label).Text;
                doclinea = (row.FindControl("lblDocLineaDesglose") as Label).Text;
                baseentry = (row.FindControl("lblBaseEntryDesglose") as Label).Text;
                baselinea = (row.FindControl("lblBaseLineaDesglose") as Label).Text;
                prodcoderefglosa= (row.FindControl("lblProdCodeRefGlosa") as Label).Text; 

                string prodcode = (row.FindControl("lblProdCodeDesglose") as Label).Text;
                string prodnombre = (row.FindControl("lblProdNombreDesglose") as Label).Text;
                string cantidadsolicitada = (row.FindControl("lblCantidadDesglose") as Label).Text;
                string cantidadreal = (row.FindControl("txtCantidadRealDesglose") as TextBox).Text;
                string cajas = (row.FindControl("txtCajasDesglose") as TextBox).Text;

                try
                {
                    cantidadreal = Convert.ToDecimal(cantidadreal.Replace(".", ",")).ToString();
                }
                catch
                {
                    cantidadreal = "0";
                }

                if (cajas=="")
                { 
                    cajas = "0"; 
                }
                string prodtipo = (row.FindControl("lblProdTipoDesglose") as Label).Text;
                //DropDownList cboBodegaCode = row.FindControl("cboBodegaCode") as DropDownList;
                //string bodegacode = cboBodegaCode.SelectedValue;
                Label lblBodegaCode = row.FindControl("lblBodegaCodeDesglose") as Label;
                string bodegacode = lblBodegaCode.Text;



                //--------------------------------------------
                docentry = docentry == "" ? "0" : docentry;
                doclinea = doclinea == "" ? "0" : doclinea;
                baseentry = baseentry == "" ? "0" : baseentry;
                baselinea = baselinea == "" ? "0" : baselinea;

                listdesglose.Add(new DocumentoLinea
                {
                    DocEntry = Convert.ToInt32(docentry),
                    DocLinea = Convert.ToInt32(doclinea),
                    BaseEntry = Convert.ToInt32(baseentry),
                    BaseLinea = Convert.ToInt32(baselinea),
                    ProdCode = prodcode,
                    ProdNombre = prodnombre,
                    CantidadSolicitada = Convert.ToDecimal(cantidadsolicitada),
                    CantidadReal = Convert.ToDecimal(cantidadreal),
                    BodegaCode = bodegacode,
                    ProdTipo = prodtipo,
                    Cajas = Convert.ToInt32(cajas),
                    ProdCodeRefGlosa = prodcoderefglosa
                });
                //--------------------------------------------

            }

            var docdesglose = new Documento {
                DocEntry = Convert.ToInt32(docentry),
                DocTipo = 2110,
                DocEstado = "A",
                DocFecha = DateTime.Now.Date,
                FechaRegistro = DateTime.Now,
                UsuarioCode = "0",
                UsuarioNombre = "Admin",
                Version = "V1.0.0",
                BaseEntry = Convert.ToInt32(baseentry),
                BaseLinea = Convert.ToInt32(baselinea),
                Lineas = listdesglose
            };
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);



            mng.Guardar("documentos", docdesglose);

            decimal cantidadrealprod = 0;
            int cajasrealprod = 0;
            
            foreach (var d in docdesglose.Lineas)
            {
                try
                {
                    d.CantidadReal = Convert.ToDecimal(d.CantidadReal.ToString().Replace(".", ","));
                }
                catch
                {
                    d.CantidadReal = 0;
                }

                switch (d.ProdTipo)
                {
                    case "Principal":
                        cajasrealprod += d.Cajas ?? 0;
                        cantidadrealprod += d.CantidadReal ?? 0;
                        break;
                    case "Alternativo":
                        cantidadrealprod += d.CantidadReal ?? 0;
                        break;
                    case "Desglose":
                        cantidadrealprod -= d.CantidadReal ?? 0;
                        break;
                }
            }

            
            listdetalle.Find(x => x.ProdCode == txtProdCodeDesglose.Text).CantidadReal = cantidadrealprod;

            listdetalle.Find(x => x.ProdCode == txtProdCodeDesglose.Text).Cajas = cajasrealprod;
            if (cboBodegas.SelectedValue != "PRODUCCION")
                listdetalle.Find(x => x.ProdCode == txtProdCodeDesglose.Text).BodegaCode = docdesglose.Lineas.Find(x => x.ProdCode==txtProdCodeDesglose.Text).BodegaCode;
            

            gvDetalle.DataSource = listdetalle;
            gvDetalle.DataBind();
            HttpContext.Current.Session["detallepk"] = listdetalle;
            popupDesglose.Hide();
            popupDetalleBandeja.Show();
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
            var list = mng.ListPicking("documentos/listpicking", cboBodegas.SelectedValue, "A");
            var list2 = Utility.DynamicSort1<DocumentosResult>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }

        protected void ImprimirPicking_Event(object sender, EventArgs e)
        {
            //Simular procesamiento de datos
            System.Threading.Thread.Sleep(5000); // Simula un retraso de 5 segundos

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            LimpiaBandeja();
            //consultar pedido
            var picking = mng.Consultar("documentos", Convert.ToInt32(txtDocEntryPicking.Text), 2010);
            var pedido = mng.Consultar("documentos", Convert.ToInt32(picking.BaseEntry), Convert.ToInt32(picking.BaseTipo));
            if (picking != null && pedido != null)
            {
                string sesm = picking.BaseTipo == 16 ? "1" : "0";
                try
                {
                    GenerarPicking(Convert.ToInt32(txtDocEntryPicking.Text), cboBodegas.SelectedValue.ToLower(), sesm);
                    popupDetalleBandeja.Hide();
                }
                catch(Exception ex)
                {
                    logger.Error("{0}", ex.Message);
                    logger.Error("{0}", ex.StackTrace);
                }
                ////if (picking.BaseTipo == 16)
                ////{
                ////    ImprimirPickingSM(Convert.ToInt32(txtDocEntryPicking.Text));
                ////}
                ////else
                ////{
                ////    ImprimirPicking(Convert.ToInt32(txtDocEntryPicking.Text));
                ////}
            }

            



        }

        private void GenerarPicking(int docentry, string origen, string sm)
        {
            
            if (docentry != null && origen != null)
            {
                if (sm != null && sm == "1")
                {
                    ImprimirPickingPDF(Convert.ToInt32(docentry), origen, true);
                }
                else
                {
                    ImprimirPickingPDF(Convert.ToInt32(docentry), origen);
                }
            }
        }

        private void ImprimirPickingPDF(int docentry, string origen)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            //ManagerReporting mng = new ManagerReporting(urlbase, logger);
            string pathDocumentos = Server.MapPath("~/Documentos");// AppContext.BaseDirectory;
            MemoryStream ms = null;// //PickingToledo(docentry, pathDocumentos);
            if (origen == "toledo")
            {
                ms = PickingToledo(docentry, pathDocumentos);
            }
            else if (origen == "produccion")
            {
                ms = PickingProduccion(docentry, pathDocumentos);
            }

            if (ms != null)
            {
                DownloadFile(ms, docentry);

            }
        }

        private void ImprimirPickingPDF(int docentry, string origen, bool sm)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            //ManagerReporting mng = new ManagerReporting(urlbase, logger);
            string pathDocumentos = Server.MapPath("~/Documentos");// AppContext.BaseDirectory;
            MemoryStream ms = null;// //PickingToledo(docentry, pathDocumentos);
            ms = PickingToledoSM(docentry, pathDocumentos);

            if (ms != null)
            {
                DownloadFile(ms, docentry);
            }
        }

        public MemoryStream PickingProduccion(int docentry, string pathDocumentos)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick = GetPicking("documentos/picking/produccion", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                //var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-produccion");
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-produccion-orizontal");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public void DownloadFile(MemoryStream mstream, int DocNum)
        {
            Byte[] bytes = mstream.ToArray();

            Random random = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            string basePath = Server.MapPath("~");// AppContext.BaseDirectory;
            string folder = new string(Enumerable.Repeat(chars, 25).Select(s => s[random.Next(s.Length)]).ToArray());
            string salidaPath = String.Format("{0}files/{1}", basePath, folder);// Server.MapPath("~/files");// AppContext.BaseDirectory;
            string urlPathFile = String.Format("/files/{0}", folder);
            string filename = "picking-1010.pdf";
            string filepathName = salidaPath + "/" + filename.Replace(",", ".");
            urlPathFile = urlPathFile + "/" + filename.Replace(",", ".");

            if (!Directory.Exists(salidaPath))
            {
                Directory.CreateDirectory(salidaPath);
                File.SetAttributes(salidaPath, FileAttributes.Normal);
                logger.Info("Crea directorio: {0} ", salidaPath);
            }

            using (var Stream = new FileStream(filepathName, FileMode.Create))  //FileStream(strExeFilePath + "/" + filename.Replace(",","."), FileMode.Create))
            {
                Stream.Write(bytes, 0, bytes.Length);

            }

            string script = String.Format("openPdfPopup('{0}');true;", urlPathFile);
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "script", script, true);

            //ClientScript.RegisterStartupScript(this.GetType(), "callFunction", script, true);



            //HttpContext.Current.Response.Redirect(String.Format("view-pdf.aspx?file={0}", urlPathFile), true);


            ////ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('/bandeja-toledo','mywindow','menubar=1);", true);
            ////HttpContext.Current.Response.Buffer = true;
            ////HttpContext.Current.Response.Expires = 0;
            ////HttpContext.Current.Response.Clear();
            ////HttpContext.Current.Response.ContentType = @".pdf, application/pdf";
            ////HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            ////HttpContext.Current.Response.AddHeader("Content-Disposition", "inline; filename=" + String.Format("Picking-{0}.pdf", DocNum));



            ////HttpContext.Current.Response.BinaryWrite(bytes);


            ////HttpContext.Current.Response.Flush();
            ////Context.ApplicationInstance.CompleteRequest();

        }
        public MemoryStream PickingToledoSM(int docentry, string pathDocumentos)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick = GetPicking("documentos/picking/produccion", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-toledo-sm");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public MemoryStream PickingToledo(int docentry, string pathDocumentos)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick = GetPicking("documentos/picking/toledo", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-toledo");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public Picking GetPicking(string metodo, int docentry)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.Picking(metodo, docentry);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Picking>(json);

                return doc;
            }
            var result2 = new MensajeReturn { msg = "" };
            result2 = result == null ? new MensajeReturn { msg = "" } : result;
            logger.Error("Agente Endpoint. Picking: {0}", result2.msg);
            return null;
        }


        public MemoryStream GeneraPDF(Picking pkg, List<Picking_Lineas> det, ref string filepath, bool conImagenes, Logger logger, string nombreReporte)
        {
            String v_mimetype;
            String v_encoding;
            String v_filename_extension;
            String[] v_streamids;
            Warning[] warnings;

            try
            {
                LocalReport reportViewer1 = new LocalReport();
                LocalReport objRDLC = new LocalReport();

                reportViewer1.ReportPath = String.Format("{0}\\{1}.rdlc", filepath, nombreReporte);


                logger.Info("reportViewer1.ReportPath: {0}", reportViewer1.ReportPath);
                reportViewer1.DataSources.Clear();

                List<Picking> Encabezado = new List<Picking>();
                List<Picking_Lineas> Detalle = new List<Picking_Lineas>();

                Encabezado.Add(pkg);

                var productosA = det.GroupBy(u => u.ProdCode).ToList();
                foreach (var p in productosA)
                {
                    var productosB = det.FindAll(x => x.StockRe > 0 && x.CantidadSolicitada > 0 && x.ProdCode == p.Key.ToString());

                    foreach (var d in productosB)
                    {
                        Detalle.Add(d);
                    }
                    if (!productosB.Any())
                    {
                        var item = det.Find(x => x.ProdCode == p.Key);
                        //Detalle.Add(new Picking_Lineas
                        //{
                        //    DocLinea=item.DocLinea,
                        //    CantidadSolicitada = item.CantidadSolicitada,
                        //    ProdCode = item.ProdCode,
                        //    ProdNombre = item.ProdNombre
                        //});
                        Detalle.Add(item);
                    }
                }


                int i = 1;
                //foreach (var d in det.FindAll(x => x.StockRe>0 && x.CantidadSolicitada>0))
                //{
                //    Detalle.Add(d);
                //}



                reportViewer1.EnableExternalImages = true;
                reportViewer1.DataSources.Add(new ReportDataSource("Cabecera", Encabezado));
                reportViewer1.DataSources.Add(new ReportDataSource("Detalle", Detalle));



                objRDLC.DataSources.Clear();
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
                byte[] byteViewer = reportViewer1.Render("PDF", null, out v_mimetype, out v_encoding, out v_filename_extension, out v_streamids, out warnings);
                //string savePath = tempPath;


                MemoryStream stream = new MemoryStream();
                stream.Write(byteViewer, 0, byteViewer.Length);

                return stream;// tempPath;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                logger.Info("Error Generando PDF Message: {0}", e.Message);
                if (e.InnerException != null)
                {
                    logger.Info("Error Generando PDF InnerException: {0}", e.InnerException.Message);
                }

                return null;
            }
        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["bandejaconfirma"] == null)
            {
                return;
            }
            List<DocumentosResult> listGrilla = (List<DocumentosResult>)HttpContext.Current.Session["bandejaconfirma"];
            if (listGrilla.Count > 0)
            {

                string nombrearcivo = String.Format("Bandejacomfirma{1} {0:dd-MM-yyyy HH.mm}.xls", DateTime.Now, cboBodegas.SelectedItem.Text);
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

        /// <summary>
        /// ///////////////////////////////////////////////
        /// </summary>
        /// <param name="docentry"></param>
        private void ImprimirPicking(int docentry)
        {
            


            HttpContext.Current.Response.Redirect(String.Format("view-pdf.aspx?docentry={0}&origen={1}", docentry, cboBodegas.SelectedValue.ToLower()), true);
        }

        private void ImprimirPickingSM(int docentry)
        {
            //HttpContext.Current.Response.Write(String.Format("<script language='javascript'>window.open('{0}','_blank');</script>", String.Format("/view-pdf?docentry={0}&origen={1}&sm=1", docentry.ToString(), cboBodegas.SelectedValue.ToLower())));
            HttpContext.Current.Response.Redirect(String.Format("view-pdf.aspx?docentry={0}&origen={1}&sm=1", docentry, cboBodegas.SelectedValue.ToLower()), true);
        }
    }
}