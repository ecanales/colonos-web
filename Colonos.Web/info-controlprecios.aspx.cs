using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Content.Utilidades;
using FastMember;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class info_controlprecios : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Refresh();
            }
        }

        public void Refresh_Event(object sender, EventArgs e)
        {
            Refresh();
        }

        private void Refresh()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            var mng = new ManagerInformes(urlbase, logger);
            var url = "informes/controlprecios";
            var list = mng.ControlPrecios(url);
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
            Session["listcontrolprecios"] = list;
            CargaCombosFiltros();
            
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

        protected void FiltarCombos(object sender, EventArgs e)
        {
            var idfamilia = cboFamilia.SelectedValue;
            var idorigen = cboOrigen.SelectedValue;
            var idmarca = cboMarca.SelectedValue;
            var solostock = chkSoloconStock.Checked;
            var list = (List<ControlPrecio>)HttpContext.Current.Session["listcontrolprecios"];
            if(list!=null)
            {
                list = Convert.ToInt32(idfamilia) != 0 ? list.FindAll(x => x.FamiliaCode == Convert.ToInt32(idfamilia)).ToList() : list;
                list = Convert.ToInt32(idorigen) != 0 ? list.FindAll(x => x.OrigenCode == Convert.ToInt32(idorigen)).ToList() : list;
                list = Convert.ToInt32(idmarca) != 0 ? list.FindAll(x => x.MarcaCode == Convert.ToInt32(idmarca)).ToList() : list;
                list = chkSoloconStock.Checked ? list.FindAll(x => x.Stock>0).ToList() : list;
            }
            gvBandeja.DataSource = list;
            gvBandeja.DataBind();
        }

        private void CargaCombosFiltros()
        {
            //-----------------------------------------
            var list = (List<ControlPrecio>)HttpContext.Current.Session["listcontrolprecios"];

            var groupedFamiliaList = list.GroupBy(u => u.FamiliaCode).Select(x => new { FamiliaCode = x.Key, FamiliaNombre = x.FirstOrDefault().FamiliaNombre });
            groupedFamiliaList = groupedFamiliaList.OrderBy(x => x.FamiliaNombre).ToList();

            var listFamilias = new List<ITM4>();
            listFamilias.Add(new ITM4 { FamiliaCode = 0, FamiliaNombre = "(TODOS)" });
            foreach (var o in groupedFamiliaList)
            {
                listFamilias.Add(new ITM4 { FamiliaCode = o.FamiliaCode, FamiliaNombre = o.FamiliaNombre });
            }
            cboFamilia.DataSource = listFamilias;
            cboFamilia.DataValueField = "FamiliaCode";
            cboFamilia.DataTextField = "FamiliaNombre";
            cboFamilia.DataBind();


            var groupedOrigenList = list.GroupBy(u => u.OrigenCode).Select(x => new { OrigenCode = x.Key, OrigenNombre = x.FirstOrDefault().OrigenNombre });
            groupedOrigenList = groupedOrigenList.OrderBy(x => x.OrigenNombre);

            var listOrigen = new List<ITM10>();
            listOrigen.Add(new ITM10 { OrigenCode = 0, OrigenNombre = "(TODOS)" });
            foreach (var o in groupedOrigenList)
            {
                listOrigen.Add(new ITM10 { OrigenCode = o.OrigenCode, OrigenNombre = o.OrigenNombre });
            }
            cboOrigen.DataSource = listOrigen;
            cboOrigen.DataValueField = "OrigenCode";
            cboOrigen.DataTextField = "OrigenNombre";
            cboOrigen.DataBind();

            var groupedMarcaList = list.GroupBy(u => u.MarcaCode).Select(x => new { MarcaCode = x.Key, MarcaNombre = x.FirstOrDefault().MarcaNombre });
            groupedMarcaList = groupedMarcaList.OrderBy(x => x.MarcaNombre).ToList();

            var listMarca = new List<ITM9>();
            listMarca.Add(new ITM9 { MarcaCode = 0, MarcaNombre = "(TODOS)" });
            foreach (var o in groupedMarcaList)
            {
                listMarca.Add(new ITM9 { MarcaCode = o.MarcaCode, MarcaNombre = o.MarcaNombre });
            }
            cboMarca.DataSource = listMarca;
            cboMarca.DataValueField = "MarcaCode";
            cboMarca.DataTextField = "MarcaNombre";
            cboMarca.DataBind();
            //-----------------------------------------
        }

        private void SortGridView(string sortExpression, string direction)
        {
            //string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            //var mng = new ManagerInformes(urlbase, logger);
            //var url = "informes/controlprecios";
            //var list = mng.ControlPrecios(url);

            var list = (List<ControlPrecio>)Session["listcontrolprecios"];
            var list2 = Utility.DynamicSort1<ControlPrecio>(list, sortExpression, direction);
            gvBandeja.DataSource = list2;
            gvBandeja.DataBind();

        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["listcontrolprecios"] == null)
            {
                return;
            }
            List<ControlPrecio> listGrilla = (List<ControlPrecio>)HttpContext.Current.Session["listcontrolprecios"];
            if (listGrilla.Count > 0)
            {

                string nombrearcivo = String.Format("InfoControlPrecios {0:dd-MM-yyyy}.xls", DateTime.Now.Date);
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;filename=" + nombrearcivo);
                Response.Charset = "";
                this.EnableViewState = false;

                System.IO.StringWriter sw = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htw = new System.Web.UI.HtmlTextWriter(sw);


                gvBandejaExport.DataSource = listGrilla;
                gvBandejaExport.DataBind();
                htw.AddAttribute("charset", "UTF-8");
                htw.RenderBeginTag(HtmlTextWriterTag.Meta);

                gvBandejaExport.RenderControl(htw);
                htw.RenderEndTag();
                Response.Write(sw.ToString());

                Response.End();
            }



        }
        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for */
        }
    }
}