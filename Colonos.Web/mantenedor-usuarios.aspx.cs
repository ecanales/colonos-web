using Colonos.Entidades;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class mantenedor_usuarios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private void CargaGrilla()
        {
            //AgenteBack agente = new AgenteBack();
            //string UrlBase = ConfigurationManager.AppSettings.Get("UrlBase");
            //List<User> list = agente.ListUsuarios(UrlBase);
            //gvResultado.DataSource = list;
            //gvResultado.DataBind();
        }
    }
}