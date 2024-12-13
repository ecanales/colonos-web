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
    public partial class bandeja_solicitudmp : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                Consultar();
            }
        }

        protected void Nuevo_Event(object sender, EventArgs e)
        {
            Nuevo();
        }

        protected void Consultar_Event(object sender, EventArgs e)
        {
            try
            {
                Consultar();
            }
            catch(Exception ex)
            {
                logger.Error("{0} Error: {1}", "Consultar Solicitud MP", ex.Message);
                logger.Error("{0} StackTrace: {1}", "Consultar Solicitud MP", ex.StackTrace);
                var mensaje = ex.Message;
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
            }
        }

        protected void VerPedido_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string docEntry = (row.FindControl("lblDocEntry") as Label).Text;
        }
        private void Nuevo()
        {
            Response.Redirect("/solicitud-mp.aspx");
        }

        private void Consultar()
        {
            try
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
                var list = mng.ListPedidos("documentos/list", 16, "", "", -1,"","","");
                gvBandeja.DataSource = list;
                gvBandeja.DataBind();
            }
            catch(Exception ex)
            {
                logger.Error("{0} Error: {1}", "Consultar Solicitud MP", ex.Message);
                logger.Error("{0} StackTrace: {1}", "Consultar Solicitud MP", ex.StackTrace);
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