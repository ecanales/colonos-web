using Colonos.Entidades;
using Colonos.Manager;
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
    public partial class info_pedidosdeldia : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtFecha.Text = DateTime.Now.ToString("yyyy-MM-dd");
                Refresh(txtFecha.Text);
            }
        }

        public void Refresh_Event(object sender, EventArgs e)
        {
            Refresh(txtFecha.Text);
        }

        private void Refresh(string fecha)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            var mng = new ManagerInformes(urlbase, logger);
            var url = String.Format("informes/resumenpedidosdeldia");
            var list = mng.PedidosDelDia(url, Convert.ToDateTime(fecha));
            gvResumenVendedor.DataSource = list.resumendia;
            gvResumenVendedor.DataBind();
            gvTopClientes.DataSource = list.velumenesdeldia;
            gvTopClientes.DataBind();
            //gvPorHoraEjecutivo.DataSource = list.pedidosporhoraejecutivo;
            //gvPorHoraEjecutivo.DataBind();
            gvPorHoraArea.DataSource = list.pedidosporhoraarea;
            gvPorHoraArea.DataBind();
            gvEntregasCamara.DataSource = list.pedidosencurso.FindAll(x => x.Bodega == "Camara").ToList();
            gvEntregasCamara.DataBind();

            gvEntregasProduccion.DataSource = list.pedidosencurso.FindAll(x => x.Bodega == "Produccion").ToList();
            gvEntregasProduccion.DataBind();
            //Session["informesseguimientooperacion"] = list;
        }

        protected void gvResumenVendedor_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                List<InfoPedidos_Diario_Vendedor> det = (List<InfoPedidos_Diario_Vendedor>)gvResumenVendedor.DataSource;
                decimal totalPedidos = 0;
                decimal totalkilos = 0;
                decimal totalPromedio = 0;
                decimal totalPorhora = 0;
                foreach (var d in det)
                {
                    totalPedidos += Convert.ToDecimal(d.Pedidos);
                    totalkilos += Convert.ToDecimal(d.Kilos);
                    totalPromedio += Convert.ToDecimal(d.KilosPromedio);
                    totalPorhora += Convert.ToDecimal(d.PedidosporHora);
                }
                e.Row.Cells[1].Text = String.Format("{0:N0}", totalPedidos);
                e.Row.Cells[2].Text = String.Format("{0:N0}", totalkilos);
                e.Row.Cells[3].Text = String.Format("{0:N0}", totalPromedio);
                e.Row.Cells[4].Text = String.Format("{0:N0}", totalPorhora);
            }
        }

        protected void gvPorHoraArea_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                List<InfoPedidos_AreaPorHora> det = (List<InfoPedidos_AreaPorHora>)gvPorHoraArea.DataSource;
                decimal totalPedidos = 0;
                decimal totalPorhora = 0;
                foreach (var d in det)
                {
                    totalPedidos += Convert.ToDecimal(d.Pedidos);
                    totalPorhora += Convert.ToDecimal(d.PedidosporHora);
                }
                e.Row.Cells[1].Text = String.Format("{0:N0}", totalPedidos);
                e.Row.Cells[2].Text = String.Format("{0:N0}", totalPorhora);
            }
        }

        protected void gvEntregasCamara_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                List<InfoPedidos_Entregas> det = (List<InfoPedidos_Entregas>)gvEntregasCamara.DataSource;
                decimal totalPedidos = 0;
                decimal totalAyer = 0;
                decimal totalHoy = 0;
                decimal totalMañana = 0;
                foreach (var d in det)
                {
                    totalAyer += Convert.ToDecimal(d.Ayer);
                    totalHoy += Convert.ToDecimal(d.Hoy);
                    totalMañana += Convert.ToDecimal(d.Mañana);
                    totalPedidos += Convert.ToDecimal(d.Pedidos);
                    
                }
                e.Row.Cells[2].Text = String.Format("{0:N0}", totalAyer);
                e.Row.Cells[3].Text = String.Format("{0:N0}", totalHoy);
                e.Row.Cells[4].Text = String.Format("{0:N0}", totalMañana);
                e.Row.Cells[5].Text = String.Format("{0:N0}", totalPedidos);
            }
        }

        protected void gvEntregasProduccion_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                List<InfoPedidos_Entregas> det = (List<InfoPedidos_Entregas>)gvEntregasProduccion.DataSource;
                decimal totalPedidos = 0;
                decimal totalAyer = 0;
                decimal totalHoy = 0;
                decimal totalMañana = 0;
                foreach (var d in det)
                {
                    totalAyer += Convert.ToDecimal(d.Ayer);
                    totalHoy += Convert.ToDecimal(d.Hoy);
                    totalMañana += Convert.ToDecimal(d.Mañana);
                    totalPedidos += Convert.ToDecimal(d.Pedidos);

                }
                e.Row.Cells[2].Text = String.Format("{0:N0}", totalAyer);
                e.Row.Cells[3].Text = String.Format("{0:N0}", totalHoy);
                e.Row.Cells[4].Text = String.Format("{0:N0}", totalMañana);
                e.Row.Cells[5].Text = String.Format("{0:N0}", totalPedidos);
            }
        }
    }
}