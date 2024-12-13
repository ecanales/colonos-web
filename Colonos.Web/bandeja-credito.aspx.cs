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
    public partial class bandeja_credito : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
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
            ManagerBandejaCredito mng = new ManagerBandejaCredito(urlbase, logger);
            var list = mng.Listar("bandejas","CRED", 0,1);
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
                string bandejacode= (row.FindControl("lblBandejaCode") as Label).Text;
                string razonsocial= (row.FindControl("lblCliente") as Label).Text; ;
                CargaDetalleBandeja(Convert.ToInt32(docentry), bandejacode, razonsocial);
                

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
            }
        }

        private void LimpiaBandeja()
        {

            lblRazonSocion.Text = "";
            txtNumeroPedido.Text = "";
            txtFechaPedido.Text = "";
            txtCondicionPedido.Text = "";
            txtNetoPedido.Text = "";
            txtVendedorPedido.Text = "";
            txtMargen.Text = "";
            txtComentarios.Text = "";
            HiddenFieldDocentry.Value = "";
            txtCausa.Text = "";
            txtEstadoCliente.Text = "";
            txtCondicion.Text = "";
            txtCupo.Text = "";
            txtUtilizado.Text = "";
            txtDisponible.Text = "";
            gvDetalle.DataSource = null;
            gvDetalle.DataBind();
        }

        protected void gvHistorialAprobacion_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState != DataControlRowState.Edit)
            {
                var autorizado = (e.Row.FindControl("lblAutorizado") as Label).Text;
                if(autorizado.ToUpper()=="FALSE")
                {
                    e.Row.Cells[0].ForeColor = System.Drawing.Color.Red;
                    e.Row.Cells[1].ForeColor = System.Drawing.Color.Red;
                    e.Row.Cells[2].ForeColor = System.Drawing.Color.Red;
                }

            }
        }
        private void CargaDetalleBandeja(int docentry, string bandejacode, string razonsocial)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);

            HiddenFieldDocentry.Value = docentry.ToString();
            //consultar pedido
            var pedido= mng.Consultar("documentos", docentry,10);
            if (pedido != null)
            {
                lblRazonSocion.Text = pedido.RazonSocial;
                txtNumeroPedido.Text = pedido.DocEntry.ToString();
                txtFechaPedido.Text = String.Format("{0:dd/MM/yyyy}", pedido.DocFecha);
                txtCondicionPedido.Text = pedido.CondicionNombre;
                txtNetoPedido.Text =String.Format("{0:C0}", pedido.Neto);
                txtVendedorPedido.Text = pedido.VendedorCode;
                txtMargen.Text = String.Format("{0:P1}", pedido.Margen);
                gvDetalle.DataSource = pedido.Lineas;
                gvDetalle.DataBind();

                //consultar bandeja
                ManagerBandejaCredito mngBan = new ManagerBandejaCredito(urlbase, logger);
                var bandeja = mngBan.Get("bandejas", bandejacode, docentry);
                if (bandeja.Items.Any())
                {
                    txtCausa.Text = bandeja.Items[0].MotivoIngreso;
                }
                txtComentarios.Text = "";
                //conusulta socio
                ManagerSocios mngSoc = new ManagerSocios(urlbase, logger);
                var cliente = mngSoc.SocioGet("socios", pedido.SocioCode);
                txtEstadoCliente.Text = cliente.EstadoOperativo;
                txtCondicion.Text = cliente.CondicionName;
                txtCupo.Text = String.Format("{0:C0}", cliente.CreditoAutorizado);
                
                

                var cuenta = mngSoc.SocioCuentaCorriente(String.Format("socios/cuenta", pedido.SocioCode), pedido.SocioCode);
                gvCuentaCorriente.DataSource = cuenta;
                gvCuentaCorriente.DataBind();

                decimal saldo = 0;

                if (cuenta.Any())
                {
                    foreach(var r in cuenta)
                    {
                        saldo += Convert.ToDecimal(r.V91 + r.V90 + r.V60 + r.V30);
                    }
                }
                cliente.CreditoUtiliado = saldo;
                txtDisponible.Text = String.Format("{0:C0}", cliente.CreditoAutorizado - cliente.CreditoUtiliado);
                txtUtilizado.Text = String.Format("{0:C0}", cliente.CreditoUtiliado);

                if (cliente.Archivos.Any())
                {
                    gvDicom.DataSource = cliente.Archivos;
                    gvDicom.DataBind();
                    Session["Archivos"] = cliente.Archivos;
                }
                else
                {
                    gvDicom.DataSource = new List<Adjunto>();
                    gvDicom.DataBind();
                    Session["Archivos"] = null;
                }

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

                ManagerBandejaCredito mngban = new ManagerBandejaCredito(urlbase, logger);
                var list = mngban.Listar("bandejas", "CRED", pedido.SocioCode,10);
                gvHistorialAprobacion.DataSource = list.OrderByDescending(o => o.FechaAproRech);
                gvHistorialAprobacion.DataBind();
                popupDetalleBandeja.Show();
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
            var bandeja = mng.Get("bandejas", "CRED", docentry);
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
                mng.Modify("bandejas", "CRED", docentry, bandeja);
            }


            if (chkEnviaraEspecial.Checked && estado)
            {
                ManagerDocumentos mngV = new ManagerDocumentos(urlbase, logger);
                var ped = mngV.Consultar("documentos", docentry,10);
                ped.AutorizacionEspecial = true;
                ped.AutorizadoEspecial = false;
                var json = JsonConvert.SerializeObject(ped);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                mngV.Actualizar("documentos", doc);
            }

            popupDetalleBandeja.Hide();
            Refresh();
        }
        protected void AprobarBandeja_Event(object sender, EventArgs e)
        {
            if(HiddenFieldDocentry.Value=="")
            {
                return;
            }
            if(txtComentarios.Text.Trim().Length>0)
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
            ManagerBandejaCredito mng = new ManagerBandejaCredito(urlbase, logger);
            var list = mng.Listar("bandejas", "CRED", 0, 1);
            var list2 = Utility.DynamicSort1<Bandeja>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }
    }
}