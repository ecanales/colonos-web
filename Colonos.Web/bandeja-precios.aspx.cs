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
    public partial class bandeja_precios : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Refresh();
            }
        }

        protected void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerBandejaPrecios mng = new ManagerBandejaPrecios(urlbase, logger);
            var list = mng.Listar("PREC", 0, 1);
            lblTotalRegistrosBandeja.Text = String.Format("{0}", list.Count);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
        }

        protected void VerBandeja_Event(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string docentry = (row.FindControl("lblPedido") as LinkButton).Text;
                string bandejacode = (row.FindControl("lblBandejaCode") as Label).Text;
                string razonsocial = (row.FindControl("lblCliente") as Label).Text; 
                CargaDetalleBandeja(Convert.ToInt32(docentry), bandejacode, razonsocial);
                popupDetalleBandeja.Show();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
            }
        }

        private void LimpiaBandeja()
        {

            lblRazonSocial.Text = "";
            txtNumeroPedido.Text = "";
            txtFechaPedido.Text = "";
            txtCondicionPedido.Text = "";
            txtNetoPedido.Text = "";
            txtVendedorPedido.Text = "";
            txtMargen.Text = "";
            txtComentarios.Text = "";
            HiddenFieldDocentry.Value = "";
            gvDetalle.DataSource = null;
            gvDetalle.DataBind();
        }
        private void CargaDetalleBandeja(int docentry, string bandejacode, string razonsocial)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            LimpiaBandeja();
            //consultar pedido
            var pedido = mng.Consultar("documentos", docentry,10);
            if (pedido != null)
            {
                HiddenFieldDocentry.Value = docentry.ToString();
                lblRazonSocial.Text = pedido.RazonSocial;
                txtNumeroPedido.Text = pedido.DocEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtCondicionPedido.Text = pedido.CondicionNombre;
                txtNetoPedido.Text = String.Format("{0:C0}", pedido.Neto);
                txtVendedorPedido.Text = pedido.VendedorCode;
                txtMargen.Text = String.Format("{0:P1}", pedido.Margen);

                //consultar bandeja
                ManagerBandejaPrecios mngBan = new ManagerBandejaPrecios(urlbase, logger);
                var bandeja = mngBan.Get(bandejacode, docentry);
                if (bandeja.Items.Any())
                {
                    var detalle=mngBan.GetDetalle(bandejacode, docentry);
                    gvDetalle.DataSource = detalle;
                    gvDetalle.DataBind();
                }

                //conusulta socio
                ManagerSocios mngSoc = new ManagerSocios(urlbase, logger);
                var cliente = mngSoc.SocioGet("socios", pedido.SocioCode);
                var ventas12m = mngSoc.Ventas12meses("socios/ventas12m", pedido.SocioCode);
                if (ventas12m.Any())
                {
                    gVentas12m.DataSource = ventas12m;
                    gVentas12m.DataBind();
                }
                else
                {
                    gVentas12m.DataSource = new List<VentaSocio>();
                    gVentas12m.DataBind();
                }
            }
        }

        protected void ClosePopupBandeja(object sender, EventArgs e)
        {
            popupDetalleBandeja.Hide();
        }

        private void AprobarRechazarBandeja(bool estado)
        {
            int docentry = Convert.ToInt32(HiddenFieldDocentry.Value);
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            //obtener bandeja actual
            ManagerBandejaCredito mng = new ManagerBandejaCredito(urlbase, logger);
            var bandeja = mng.Get("bandejas", "PREC", docentry);
            if (bandeja != null)
            {
                bandeja.Estado = true;
                bandeja.Autorizado = estado;
                bandeja.FechaAproRech = DateTime.Now;
                bandeja.MotivoRech = txtComentarios.Text;
                bandeja.UsuarioCodeAproRech = "Admin";
                foreach (var b in bandeja.Items)
                {
                    b.Autorizado = estado;
                    b.Estado = true;
                    b.FechaAutorizado = bandeja.FechaAproRech;
                    b.MotivoRechazo = bandeja.MotivoRech;
                    b.UsuarioCodeAutoriza = bandeja.UsuarioCodeAproRech;
                }
                mng.Modify("bandejas", "PREC", docentry, bandeja);
            }

            popupDetalleBandeja.Hide();
            Refresh();
        }

        protected void AprobarBandeja_Event(object sender, EventArgs e)
        {
            if (HiddenFieldDocentry.Value == "")
            {
                return;
            }
            if (txtComentarios.Text.Trim().Length > 0)
            {
                AprobarRechazarBandeja(true);
            }
            else
            {
                txtComentarios.Focus();
                popupDetalleBandeja.Show();
            }
        }

        protected void RechazarBandeja_Event(object sender, EventArgs e)
        {
            if (HiddenFieldDocentry.Value == "")
            {
                return;
            }
            if (txtComentarios.Text.Trim().Length > 0)
            {
                AprobarRechazarBandeja(false);
            }
            else
            {
                txtComentarios.Focus();
                popupDetalleBandeja.Show();
            }
        }

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState != DataControlRowState.Edit)
            {
                
                var causa= (e.Row.FindControl("lblMotivoIngreso") as Label).Text;
                if (causa != "")
                {
                    var valorregla = (e.Row.FindControl("lblValorRegla") as Label).Text;
                    if (valorregla != "")
                    {
                        if (Convert.ToDecimal(valorregla) <= 1)
                        {
                            (e.Row.FindControl("lblValorRegla") as Label).Text = String.Format("{0:P1}", Convert.ToDecimal(valorregla));
                        }
                        else if (Convert.ToDecimal(valorregla) > 1)
                        {
                            (e.Row.FindControl("lblValorRegla") as Label).Text = String.Format("{0:C0}", Convert.ToDecimal(valorregla));
                        }
                        for (int c = 1; c < e.Row.Cells.Count; c++)
                        {
                            e.Row.Cells[c].ForeColor = System.Drawing.Color.IndianRed;
                            e.Row.Cells[c].BackColor = System.Drawing.Color.LightYellow;
                        }
                    }
                }
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
            ManagerBandejaPrecios mng = new ManagerBandejaPrecios(urlbase, logger);
            var list = mng.Listar("PREC", 0, 1);

            var list2 = Utility.DynamicSort1<Bandeja>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }
    }
}