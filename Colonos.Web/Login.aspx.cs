using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using Newtonsoft.Json;
using Colonos.Entidades;
using Colonos.Manager;
using NLog;

namespace Colonos.Web
{
    public partial class Login : System.Web.UI.Page
    {
        Logger logger;

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        private bool ValidateUser(string userName, string passWord)
        {

            if (userName == "admin" && passWord == "admin")
            {
                return true;
            }
            return false;
        }

        protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
        {
            bool Autenticado = false;
            Autenticado = LoginCorrecto(Login1.UserName, Login1.Password);
            e.Authenticated = Autenticado;

            if (Autenticado)
            {
                HttpContext.Current.Session["User"] = User;

                HttpContext.Current.Session["usuario"] = Login1.UserName;

                //string UrlBase = ConfigurationManager.AppSettings.Get("UrlBase");
                //AgenteBack agente = new AgenteBack();
                //GetVariantes variantes = agente.ListVariantesEditables(UrlBase, "inventario/editables");
                //HttpContext.Current.Session["Editables"] = variantes.variantes;

                FormsAuthentication.RedirectFromLoginPage(Login1.UserName, Login1.RememberMeSet);
            }

        }


        private bool LoginCorrecto(string UserName, string Password)
        {
            //return ValidateUser(UserName, Password);
            ////return true;
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);

            User lg = new User
            {
                Usuario = UserName,
                Clave = Password,
                password = Password 
            };
            string UrlBase = ConfigurationManager.AppSettings.Get("UrlBase");
            string json = JsonConvert.SerializeObject(lg, Formatting.Indented);
            //DatosBrowser datosBrowser = new DatosBrowser
            //{
            //    Browser = Request.Browser.Browser,
            //    Platform = Request.Browser.Platform,
            //    Version = Request.Browser.Version,
            //};

            string jsonBrowser = "";// JsonConvert.SerializeObject(datosBrowser, Formatting.Indented);
            LoginOut o = mng.Login(json, UrlBase, jsonBrowser);

            if (o.Success)
            {

                User us = mng.GetUsuario_Login(o.Usuario, UrlBase);
                if (us.Usuario != null)
                {
                    HttpContext.Current.Session["us"] = us;
                    return true;
                }

            }

            return false;



        }
    }
}