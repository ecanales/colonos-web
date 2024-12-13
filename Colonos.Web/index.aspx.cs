using Colonos.Entidades;
using Colonos.Manager;
using Microsoft.Build.Tasks;
using Microsoft.Reporting.WebForms;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Warning = Microsoft.Reporting.WebForms.Warning;

namespace Colonos.Web
{
    public partial class index : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }


        protected void TestPicking(object sender, EventArgs e)
        {
            Logger logger = NLog.LogManager.GetLogger("loggerfile");
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            //Picking pick= mng.Picking("/documentos/picking/produccion", 2015);
            Picking pick = mng.Picking("/documentos/picking/toledo", 2038);

            if (pick != null)
            {
                string pathDocumentos = Server.MapPath("~/Documentos");// AppContext.BaseDirectory;
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-toledo");
                DownloadFile(ms, pick.DocEntry);
            }
        }

        public void DownloadFile(MemoryStream mstream, int DocNum)
        {
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.Expires = 0;
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = @".pdf, application/pdf";
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + String.Format("Cotizacion-{0}.pdf", DocNum));

            Byte[] bytes = mstream.ToArray();

            HttpContext.Current.Response.BinaryWrite(bytes);


            HttpContext.Current.Response.Flush();
            Context.ApplicationInstance.CompleteRequest();

        }

        public MemoryStream GeneraPDF(Picking pkg, List<Picking_Lineas> det, ref string filepath, bool conImagenes, Logger logger, string nombreReporte)
        {
            String v_mimetype;
            String v_encoding;
            String v_filename_extension;
            String[] v_streamids;
            Warning[] warnings;

            try
            {
                LocalReport reportViewer1 = new LocalReport();
                LocalReport objRDLC = new LocalReport();

                reportViewer1.ReportPath = String.Format("{0}\\{1}.rdlc", filepath, nombreReporte);


                logger.Info("reportViewer1.ReportPath: {0}", reportViewer1.ReportPath);
                reportViewer1.DataSources.Clear();

                List<Picking> Encabezado = new List<Picking>();
                List<Picking_Lineas> Detalle = new List<Picking_Lineas>();


                Encabezado.Add(pkg);
                int i = 1;
                foreach (var d in det)
                {
                    Detalle.Add(d);
                }

                reportViewer1.EnableExternalImages = true;
                reportViewer1.DataSources.Add(new ReportDataSource("Cabecera", Encabezado));
                reportViewer1.DataSources.Add(new ReportDataSource("Detalle", Detalle));



                objRDLC.DataSources.Clear();
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
                byte[] byteViewer = reportViewer1.Render("PDF", null, out v_mimetype, out v_encoding, out v_filename_extension, out v_streamids, out warnings);
                //string savePath = tempPath;

  
                MemoryStream stream = new MemoryStream();
                stream.Write(byteViewer, 0, byteViewer.Length);

                return stream;// tempPath;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                logger.Info("Error Generando PDF Message: {0}", e.Message);
                if (e.InnerException != null)
                {
                    logger.Info("Error Generando PDF InnerException: {0}", e.InnerException.Message);
                }

                return null;
            }
        }

        //protected void but1_Click(object sender, EventArgs e)
        //{
        //    MultiView1.ActiveViewIndex = 1;
        //}
        //protected void but2_Click(object sender, EventArgs e)
        //{
        //    MultiView1.ActiveViewIndex = 2;
        //}
        //protected void but3_Click(object sender, EventArgs e)
        //{
        //    MultiView1.ActiveViewIndex = 0;
        //}
        //protected void dl_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    txt1.Text = dl.SelectedItem.Text;
        //}

        protected void Descargarproductos(object sender, EventArgs e)
        {

            

            //ManagerOSCP mng = new ManagerOSCP();
            //mng.CargaClientesDireccionesDF();
            //mng.CargarProveedoresDF();
            //mng.CargarProveedoresDireccionesDF();


            //mng.CargaClientesDF();
            //mng.CargaClientesDireccionesDF();



            //ManagerOITM mng = new ManagerOITM();
            //mng.CargaProductosDF();

            //DataTable dt = new DataTable();
            //dt.Columns.Add("Sl");
            //dt.Columns.Add("data");
            //dt.Columns.Add("heading1");
            //dt.Columns.Add("heading2");
            //for (int i = 0; i < 150; i++)
            //{
            //    dt.Rows.Add(new object[] { i, 123 * i, 4567 * i, 2 * i, });
            //}

            //GridView1.DataSource = dt;
            //GridView1.DataBind();


            ManagerDefontana mng = new ManagerDefontana(logger);

            //mng.ListarProductos(); 
            mng.ListarClientes();
            //mng.ListarProveedores();
            //mng.ListarBodegas();
        }

        //protected void Button1_Click(object sender, EventArgs e)
        //{
        //    // Move to Tab 2
        //    TabContainer1.ActiveTab = TabContainer1.Tabs[1];
        //}

        //protected void btnLoop_Click(object sender, EventArgs e)
        //{
        //    AjaxControlToolkit.TabContainer container = (AjaxControlToolkit.TabContainer)TabContainer1;
        //    foreach (object obj in container.Controls)
        //    {
        //        if (obj is AjaxControlToolkit.TabPanel)
        //        {
        //            AjaxControlToolkit.TabPanel tabPanel = (AjaxControlToolkit.TabPanel)obj;
        //            foreach (object ctrl in tabPanel.Controls)
        //            {
        //                if (ctrl is Control)
        //                {
        //                    Control c = (Control)ctrl;
        //                    foreach (object innerCtrl in c.Controls)
        //                    {
        //                        if (innerCtrl is System.Web.UI.WebControls.TextBox)
        //                            Response.Write(((TextBox)innerCtrl).Text);
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}

        protected void ShowPopup(object sender, EventArgs e)
        {
            string title = "Greetings";
            string body = "Welcome to ASPSnippets.com";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal1();", true);
        }

    }
}