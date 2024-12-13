using Colonos.Entidades;
using Colonos.Manager;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class Principal : System.Web.UI.MasterPage
    {
        Logger logger;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Page.User.Identity.IsAuthenticated)
            {
                if (HttpContext.Current.Session["usuario"] == null)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerUsuario mng = new ManagerUsuario(urlbase, logger);
                    User us = mng.GetUsuario_Login(this.Page.User.Identity.Name, urlbase);
                    if (us.Usuario != null)
                    {
                        HttpContext.Current.Session["us"] = us;
                    }
                    else
                    {
                        HttpContext.Current.Response.Redirect("/login.aspx", false);
                    }
                }

                if (!IsPostBack)
                {
                    if (HttpContext.Current.Session["us"] != null)
                    {
                        User us = (User)HttpContext.Current.Session["us"];
                        if (us != null)
                        {
                            lblNombreUsuario.Text = us.Nombre;
                            lblGrupo.Text = us.grupo;
                            GenerarMenu(us.IdGrupo);
                        }
                        else
                        {
                            HttpContext.Current.Response.Redirect("/login.aspx", false);
                        }
                    }
                }
            }
            else
            {
                HttpContext.Current.Response.Redirect("/login.aspx", false);
            }
        }

        protected void Logout_Event(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            HttpContext.Current.Session["us"] = null;
            HttpContext.Current.Session["usuario"] = null;
            HttpContext.Current.Response.Redirect("/login.aspx", false);
        }

        private void GenerarMenu(string idgrupo)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);


            List<GrupoAccesos> listroot = mng.GrupoAccesosList(urlbase, idgrupo);
            List<GrupoAccesos> list = mng.GrupoAccesosList(urlbase, idgrupo);

            var cm = list.FindAll(x => x.IdSubMenuA == null);
            string mnuItem = "";
            string menu = "";
            string accesodirecto = "";
            string btnItem = "";

            if (cm != null)
            {
                foreach (var m in cm)
                {
                    if (Convert.ToBoolean(m.Acceso))
                    {
                        if (listroot.FindAll(x => x.IdMenu == m.IdMenu && x.IdSubMenuA != null && x.Acceso == true).Any())
                        {
                            mnuItem = @"<li id='nav{0}' class='toggle accordion-toggle'>
                                <span class='icon-plus'></span>
                                <a class='menu-link' href='#'>{1}</a>
                            </li>";

                            mnuItem = String.Format(mnuItem, m.IdMenu, m.CaptionMenu);
                            menu += mnuItem;

                            mnuItem = "";

                            mnuItem += @"<ul class='menu-submenu accordion-content'>";
                            foreach (var i in listroot.FindAll(x => x.IdMenu == m.IdMenu && x.IdSubMenuA != null && x.Acceso == true))
                            {
                                mnuItem += @"<li style='padding: 5px;'><a href='{0}' id='mnu{1}' previewlistener='true'><i class='fas fa-circle fa-xs'></i><span style='padding-left: 10px;'>{2}</span></a></li>";
                                mnuItem = String.Format(mnuItem, i.Url, i.IdSubMenuA, i.CaptionSubMenuA);
                                btnItem = "";
                                switch(i.keySubMenuA)
                                {
                                    case "itemInfoSeguimientoOperación":
                                    case "itemConsultadeStock":
                                    case "itemPedidodeVentas":
                                    case "itemBandejaCredito":
                                    case "itemBandejaPrecios":
                                    case "itemBandejaToledo":
                                    case "itemMarcarToledo":
                                    case "itemBandejaProduccion":
                                    case "itemMarcarProduccion":
                                    case "itemGenerarFacturas":
                                    case "itemBandejaLogistica":
                                    case "itemConfirmarRutas":
                                        btnItem = @"<li>
                                            <a id='btn{0}' href='{1}'>
                                            <div><i class='{2} font-size-x-large'></i></div>
                                            <div class='font-size-small'>{3}</div></a>
                                            </li>";
                                        btnItem = String.Format(btnItem, i.IdSubMenuA, i.Url,i.icon, i.CaptionSubMenuA);
                                        break;
                                }
                                accesodirecto += btnItem;
                            }
                            mnuItem += @"</ul>";
                            menu += mnuItem;
                        }
                    }
                }
            }

            //mnuItem = @"<li id='nav0' class='toggle accordion-toggle'>
            //    <span class='icon-plus'></span>
            //    <a class='menu-link' href='#'>Ventas</a>
            //</li>
            //<ul class='menu-submenu accordion-content'>
            //    <li style='padding: 5px;'><a href='bandeja-pedidos.aspx' id='mnu1' previewlistener='true'><i class='fas fa-circle fa-xs'></i><span style='padding-left: 10px;'>Opcion 1</span></a></li>
            //    <li style='padding: 5px;'><a href='bandeja-pedidos.aspx' id='mnu2' previewlistener='true'><i class='fas fa-circle fa-xs'></i><span style='padding-left: 10px;'>Opcion 2</span></a></li>
            //</ul>";
            lblMenu.Text = menu;
            lblAccesoDirecto.Text = accesodirecto;

            /*
            <li id='nav0' class='toggle accordion-toggle'>
                <span class='icon-plus'></span>
                <a class='menu-link' href='#'>Ventas</a>
            </li>
            <ul class='menu-submenu accordion-content'>
                <li style='padding: 5px;'><asp:LinkButton ID='mnu1' runat='server' PostBackUrl='venta-pedido.aspx?nuevo=SI'><i class='fas fa-circle fa-xs p-1'></i>Dashboard de Ventas</asp:LinkButton></li>
                <li style='padding: 5px;'><asp:LinkButton ID='mnu2' runat='server' PostBackUrl='venta-pedido.aspx?nuevo=SI'><i class='fas fa-circle fa-xs p-1'></i>Generar Pedido de Venta</asp:LinkButton></li>
            </ul>
            */
        }
        protected void OnMenuItemDataBound_Click(object sender, EventArgs e)
        {
            
        }

    }
}