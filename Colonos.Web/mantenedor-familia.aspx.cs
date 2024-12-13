using Colonos.Entidades;
using Colonos.Manager;
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
    public partial class mantenedor_familia : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Refresh();
            }
        }

        protected void Actualizar_Event(object sender, EventArgs e)
        {
            Refresh();
        }
        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDimFamilia mng = new ManagerDimFamilia(urlbase, logger);
            var list = mng.List("productos/dim/familia");

            if (list != null)
            {
                gvList.DataSource = list;
                gvList.Caption = String.Format("Registros encontrados: {0}", list.Count());
                gvList.DataBind();
            }
        }

        protected void Editar_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;


            Editar(row);
            popupFamilia.Show();
        }
        protected void Nuevo_Event(object sender, EventArgs e)
        {
            txtFamiliaCode.Text = "";
            txtFamiliaNombre.Text = "";
            txtMargen.Text = "";
            txtDescVolumen.Text = "";
            txtVolumen.Text = "";
            txtFactorPrecio.Text = "";
            popupFamilia.Show();
        }

        protected void Buscar_Event(object sender, EventArgs e)
        {
            if (txtBuscar.Text.Trim().Length > 0)
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDimFamilia mng = new ManagerDimFamilia(urlbase, logger);
                var url = String.Format("{0}?palabras={1}", "productos/dim/familia", txtBuscar.Text);
                var list = mng.List(url);

                if (list != null)
                {
                    gvList.DataSource = list;
                    gvList.Caption = String.Format("Registros encontrados: {0}", list.Count());
                    gvList.DataBind();
                }
            }
        }

        protected void Guardar_Event(object sender, EventArgs e)
        {
            Guardar();
            popupFamilia.Hide();
            Refresh();
        }

        protected void ClosePopup(object sender, EventArgs e)
        {
            popupFamilia.Hide();
        }

        private void Editar(GridViewRow row)
        {
            string animalcode = (row.FindControl("lblFamiliaCode") as Label).Text;
            string animalnombre = (row.FindControl("lblFamiliaNombre") as LinkButton).Text;
            string margen = (row.FindControl("lblMargen") as Label).Text;
            string descvolumen = (row.FindControl("lblDescVolumen") as Label).Text;
            string volumen = (row.FindControl("lblVolumen") as Label).Text;
            string factorprecio = (row.FindControl("lblFactorPrecio") as Label).Text;
            //string accdf = (row.FindControl("lblAccDF") as Label).Text;

            txtFamiliaCode.Text = animalcode;
            txtFamiliaNombre.Text = animalnombre;
            txtMargen.Text = margen.Replace("%", "").Replace(" ", "").Replace(",", ".");
            txtDescVolumen.Text = descvolumen.Replace("%", "").Replace(" ", "").Replace(",", ".");
            txtVolumen.Text = String.Format("{0:N0}", volumen).Replace(",", ".");
            txtFactorPrecio.Text = String.Format("{0:N2}", factorprecio).Replace(",", ".");
        }

        private void Guardar()
        {
            try
            {
                string animalcode = txtFamiliaCode.Text;
                string animalnombre = txtFamiliaNombre.Text;
                string margen = txtMargen.Text.Replace(".", ",");
                string descvolumen = txtDescVolumen.Text.Replace(".", ",");
                string volumen = txtVolumen.Text.Replace(".", ",");
                string factorprecio = txtFactorPrecio.Text.Replace(".", ",");


                ITM4 item = new ITM4
                {
                    
                    FamiliaNombre = animalnombre,
                    Margen = Convert.ToDecimal(margen) / 100,
                    DescVolumen = Convert.ToDecimal(descvolumen) / 100,
                    FactorPrecio = Convert.ToDecimal(factorprecio),
                    Volumen = Convert.ToDecimal(volumen),
                };

                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDimFamilia mng = new ManagerDimFamilia(urlbase, logger);
                var json = "";// JsonConvert.SerializeObject(item);
                if (txtFamiliaCode.Text.Length == 0)
                {
                    json = JsonConvert.SerializeObject(item);
                    mng.Add("productos/dim/familia", json, true);
                }
                else
                {
                    item.FamiliaCode = Convert.ToInt32(animalcode);
                    json = JsonConvert.SerializeObject(item);
                    mng.Modify("productos/dim/familia", json, false);
                }
            }
            catch (Exception ex)
            {
                logger.Error("Editar Animal", ex.Message);
                logger.Error("Editar Animal", ex.StackTrace);
            }
        }
    }
}