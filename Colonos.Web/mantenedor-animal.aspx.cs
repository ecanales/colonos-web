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
    public partial class mantenedor_animal : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Refresh();
            }
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDimAnimal mng = new ManagerDimAnimal(urlbase, logger);
            var list = mng.List("productos/dim/animal");

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
            popupAnimal.Show();
        }
        protected void Nuevo_Event(object sender, EventArgs e)
        {

        }

        protected void Buscar_Event(object sender, EventArgs e)
        {

        }

        protected void Guardar_Event(object sender, EventArgs e)
        {
            Guardar();
            popupAnimal.Hide();
            Refresh();
        }

        protected void ClosePopup(object sender, EventArgs e)
        {
            popupAnimal.Hide();
        }

        private void Editar(GridViewRow row)
        {
            string animalcode = (row.FindControl("lblAnimalCode") as Label).Text;
            string animalnombre = (row.FindControl("lblAnimalNombre") as LinkButton).Text;
            string margen = (row.FindControl("lblMargen") as Label).Text;
            string descvolumen = (row.FindControl("lblDescVolumen") as Label).Text;
            string volumen = (row.FindControl("lblVolumen") as Label).Text;
            string factorprecio = (row.FindControl("lblFactorPrecio") as Label).Text;
            string accdf = (row.FindControl("lblAccDF") as Label).Text;

            txtAnimalCode.Text = animalcode;
            txtAnimalNombre.Text = animalnombre;
            txtMargen.Text = margen.Replace("%","").Replace(" ","").Replace(",",".");
            txtDescVolumen.Text = descvolumen.Replace("%", "").Replace(" ", "").Replace(",", ".");
            txtVolumen.Text = String.Format("{0:N0}", volumen).Replace(",", ".");
            txtFactorPrecio.Text = String.Format("{0:N2}", factorprecio).Replace(",", ".");
            txtAccDF.Text = accdf;
        }

        private void Guardar()
        {
            try
            {
                string animalcode = txtAnimalCode.Text;
                string animalnombre = txtAnimalNombre.Text;
                string margen = txtMargen.Text.Replace(".", ",");
                string descvolumen = txtDescVolumen.Text.Replace(".", ",");
                string volumen = txtVolumen.Text.Replace(".", ",");
                string factorprecio = txtFactorPrecio.Text.Replace(".", ",");
                string accdf = txtAccDF.Text;


                ITM5 item = new ITM5
                {
                    AnimalCode = Convert.ToInt32(animalcode),
                    AnimalNombre = animalnombre,
                    Margen = Convert.ToDecimal(margen)/100,
                    DescVolumen = Convert.ToDecimal(descvolumen)/100,
                    FactorPrecio = Convert.ToDecimal(factorprecio),
                    Volumen = Convert.ToDecimal(volumen),
                    AccDF = accdf
                };

                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDimAnimal mng = new ManagerDimAnimal(urlbase, logger);
                var json = JsonConvert.SerializeObject(item);
                if (txtAnimalCode.Text.Length == 0)
                {
                    mng.Add("productos/dim/animal", json, true);
                }
                else
                {
                    mng.Modify("productos/dim/animal", json, false);
                }
            }
            catch(Exception ex)
            {
                logger.Error("Editar Animal", ex.Message);
                logger.Error("Editar Animal", ex.StackTrace);
            }
        }
    }
}