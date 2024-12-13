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
    public partial class bandeja_rendicion : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
        }

        protected void ClosePopupBandeja(object sender, EventArgs e)
        {
            popupDetalleBandeja.Hide();
        }

        protected void Nuevo_Event(object sender, EventArgs e)
        {
            User us = (User)HttpContext.Current.Session["us"];
            if (us != null)
            {

                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                Documento doc = new Documento { DocEstado = "A", DocTipo = 18, UsuarioCode = us.Usuario };
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);

                try
                {
                    doc = mng.Guardar("documentos", doc);
                    var mensaje = "Corte Generado";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                    Refresh();

                }
                catch (Exception ex)
                {
                    logger.Error("{0} Error: {1}", "Guardar Solciitud de Produccion", ex.Message);
                    logger.Error("{0} StackTrace: {1}", "Guardar Solciitud de Produccion", ex.StackTrace);
                    var mensaje = ex.Message;
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                }
            }
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var list = mng.List("documentos/list", 18, "A", "", "PRODUCCION");
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
            Session["list"] = list;
        }

        protected void VerBandeja_Event(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string docentry = (row.FindControl("lblDocEntry") as LinkButton).Text;
                string doctipo = (row.FindControl("lblDocTipo") as Label).Text;
                CargaDetalleBandeja(Convert.ToInt32(docentry),  Convert.ToInt32(doctipo));
                popupDetalleBandeja.Show();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
            }
        }

        private void CargaDetalleBandeja(int docentry, int doctipo)
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
                //lblRazonSocion.Text = pedido.RazonSocial;
                //txtRazonSocial.Text = pedido.RazonSocial;
                //txtNumeroPedido.Text = pedido.BaseEntry == null ? pedido.DocEntry.ToString() : pedido.BaseEntry.ToString();
                //txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                //txtFechadeEntrega.Text = String.Format("{0:dd/MM/yyyy}", pedido.FechaEntrega);
                //txtVendedorPedido.Text = pedido.VendedorCode;
                //chkRetiraCliente.Checked = Convert.ToBoolean(pedido.RetiraCliente);
                if (pedido.Lineas.Any())
                {
                    var detalle = pedido.Lineas;
                    gvDetalle.DataSource = detalle;
                    gvDetalle.DataBind();
                    Session["detalle"] = detalle;
                }
                Calcular();
            }
        }

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string prodtipo = (e.Row.FindControl("lblProdTipo") as Label).Text;
                if (prodtipo == "Alternativo")
                {
                    (e.Row.FindControl("lblCantidadSolicitada") as Label).Visible = false;
                    for (var i = 0; i < e.Row.Cells.Count; i++)
                    {
                        e.Row.Cells[i].BackColor = System.Drawing.Color.Lavender;
                    }
                }
                else if (prodtipo == "Principal")
                {
                    //(e.Row.FindControl("lblCantidadReal") as Label).Visible = false;
                    (e.Row.FindControl("txtCantidadRendida") as TextBox).Visible = false;
                    var marcado=(e.Row.FindControl("lblCantidadReal") as Label).Text;
                    var terminado = (e.Row.FindControl("lblTerminado") as Label).Text;
                    if (terminado == "")
                        terminado = "0";

                    if (Convert.ToDecimal(marcado)!=Convert.ToDecimal(terminado))
                    {
                        (e.Row.FindControl("lblTerminado") as Label).ForeColor = System.Drawing.Color.Red;
                        (e.Row.FindControl("lblTerminado") as Label).BackColor = System.Drawing.Color.Khaki;
                    }
                    else
                    {
                        (e.Row.FindControl("lblTerminado") as Label).ForeColor = System.Drawing.Color.Black;
                        (e.Row.FindControl("lblTerminado") as Label).BackColor = System.Drawing.Color.Gold;
                    }
                    for (var i = 0; i < e.Row.Cells.Count; i++)
                    {
                        e.Row.Cells[i].BackColor = System.Drawing.Color.Gold;
                    }
                }
                else if (prodtipo == "Desglose")
                {
                    (e.Row.FindControl("lblCantidadSolicitada") as Label).Visible = false;
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


        protected void Calcular_Event(object sender, EventArgs e)
        {
            Calcular();
        }

        private void Calcular()
        {
            if (Session["detalle"] != null)
            {
                var detalle = (List<DocumentoLinea>)Session["detalle"];

                foreach (GridViewRow row in gvDetalle.Rows)
                {
                    var prodtipo = (row.FindControl("lblProdTipo") as Label).Text;
                    var docentry = (row.FindControl("lblDocEntry") as Label).Text;
                    var doclinea = (row.FindControl("lblDocLinea") as Label).Text;
                    var cantidadrendida = (row.FindControl("txtCantidadRendida") as TextBox).Text.Replace(".", ",").Trim();

                    if (prodtipo == "Alternativo" || prodtipo == "Desglose")
                    {
                        detalle.Find(x => x.DocEntry == Convert.ToInt32(docentry) && x.DocLinea == Convert.ToInt32(doclinea)).CantidadRendida = Convert.ToDecimal(cantidadrendida);
                    }
                }
                Session["detalle"] = detalle;

                var listprincipal = detalle.FindAll(x => x.ProdTipo == "Principal");
                foreach (var p in listprincipal)
                {
                    var list = detalle.FindAll(x => x.ProdCodeRef == p.ProdCodeRef);
                    decimal utilizado = 0;
                    decimal marcado = 0;
                    foreach (var d in list)
                    {
                        if (d.ProdTipo == "Alternativo")
                        {
                            utilizado += Convert.ToDecimal(d.CantidadRendida);
                            marcado += Convert.ToDecimal(d.CantidadReal);
                        }
                        if (d.ProdTipo == "Desglose")
                        {
                            utilizado -= Convert.ToDecimal(d.CantidadRendida);
                            marcado += Convert.ToDecimal(d.CantidadReal);
                        }
                    }
                    p.CantidadTerminada = utilizado;
                    p.CantidadReal = marcado;
                }
                gvDetalle.DataSource = detalle;
                gvDetalle.DataBind();
                Session["detalle"] = detalle;
            }


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
            var list = mng.List("documentos/list", 18, "A", "", "PRODUCCION");
            var list2 = Utility.DynamicSort1<DocumentosResult>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }
    }
}