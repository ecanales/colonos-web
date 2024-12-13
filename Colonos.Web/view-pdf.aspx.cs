using Colonos.AgenteEndPoint;
using Colonos.Entidades;
using Colonos.Manager;
using Microsoft.Reporting.WebForms;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class view_pdf : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                string pdfFilePath = Request.QueryString["file"];
                pdfViewer.Attributes["src"] = pdfFilePath;

                ////string docentry = Request.QueryString["docentry"];
                ////string origen = Request.QueryString["origen"];
                ////string sm = Request.QueryString["sm"];
                ////if (docentry != null && origen != null)
                ////{
                ////    if (sm != null && sm == "1")
                ////    {
                ////        ImprimirPicking(Convert.ToInt32(docentry), origen, true);
                ////    }
                ////    else
                ////    {
                ////        ImprimirPicking(Convert.ToInt32(docentry), origen);
                ////    }
                ////}
            }
        }

        #region Imprimir Picking -------------

        private void ImprimirPicking(int docentry, string origen)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            //ManagerReporting mng = new ManagerReporting(urlbase, logger);
            string pathDocumentos = Server.MapPath("~/Documentos");// AppContext.BaseDirectory;
            MemoryStream ms = null;// //PickingToledo(docentry, pathDocumentos);
            if(origen=="toledo")
            {
                ms = PickingToledo(docentry, pathDocumentos);
            }
            else if (origen == "produccion")
            {
                ms = PickingProduccion(docentry, pathDocumentos);
            }

            if (ms != null)
            {
                DownloadFile(ms, docentry);

            }
        }

        private void ImprimirPicking(int docentry, string origen, bool sm)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            //ManagerReporting mng = new ManagerReporting(urlbase, logger);
            string pathDocumentos = Server.MapPath("~/Documentos");// AppContext.BaseDirectory;
            MemoryStream ms = null;// //PickingToledo(docentry, pathDocumentos);
            ms = PickingToledoSM(docentry, pathDocumentos);

            if (ms != null)
            {
                DownloadFile(ms, docentry);
            }
        }

        public MemoryStream PickingProduccion(int docentry, string pathDocumentos)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick = GetPicking("documentos/picking/produccion", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-produccion");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public MemoryStream PickingToledoSM(int docentry, string pathDocumentos)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick = GetPicking("documentos/picking/produccion", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-toledo-sm");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public MemoryStream PickingToledo(int docentry, string pathDocumentos)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick = GetPicking("documentos/picking/toledo", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-toledo");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public Picking GetPicking(string metodo, int docentry)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.Picking(metodo, docentry);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Picking>(json);

                return doc;
            }
            var result2 = new MensajeReturn { msg = "" };
            result2 = result == null ? new MensajeReturn { msg = "" } : result;
            logger.Error("Agente Endpoint. Picking: {0}", result2.msg);
            return null;
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

                var productosA = det.GroupBy(u => u.ProdCode).ToList();
                foreach (var p in productosA)
                {
                    var productosB = det.FindAll(x => x.StockRe > 0 && x.CantidadSolicitada > 0 && x.ProdCode == p.Key.ToString());

                    foreach (var d in productosB)
                    {
                        Detalle.Add(d);
                    }
                    if (!productosB.Any())
                    {
                        var item = det.Find(x => x.ProdCode==p.Key);
                        //Detalle.Add(new Picking_Lineas
                        //{
                        //    DocLinea=item.DocLinea,
                        //    CantidadSolicitada = item.CantidadSolicitada,
                        //    ProdCode = item.ProdCode,
                        //    ProdNombre = item.ProdNombre
                        //});
                        Detalle.Add(item);
                    }
                }

                
                int i = 1;
                //foreach (var d in det.FindAll(x => x.StockRe>0 && x.CantidadSolicitada>0))
                //{
                //    Detalle.Add(d);
                //}

                

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
        public void DownloadFile(MemoryStream mstream, int DocNum)
        {
            Byte[] bytes = mstream.ToArray();

            Random random = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            string basePath = Server.MapPath("~");// AppContext.BaseDirectory;
            string folder = new string(Enumerable.Repeat(chars, 25).Select(s => s[random.Next(s.Length)]).ToArray());
            string salidaPath = String.Format("{0}files/{1}", basePath, folder);// Server.MapPath("~/files");// AppContext.BaseDirectory;
            string urlPathFile = String.Format("/files/{0}", folder);
            string filename = "picking-1010.pdf";
            string filepathName = salidaPath + "/" + filename.Replace(",", ".");

            if (!Directory.Exists(salidaPath))
            {
                Directory.CreateDirectory(salidaPath);
                File.SetAttributes(salidaPath, FileAttributes.Normal);
                logger.Info("Crea directorio: {0} ", salidaPath);
            }

            using (var Stream = new FileStream(filepathName, FileMode.Create))  //FileStream(strExeFilePath + "/" + filename.Replace(",","."), FileMode.Create))
            {
                Stream.Write(bytes, 0, bytes.Length);
                
            }

            var pdfFilePath = filepathName; // "https://openaccess.uoc.edu/bitstream/10609/148235/6/Manual%20de%20usuario.pdf";
            pdfViewer.Attributes["src"] = pdfFilePath;

            ////ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('/bandeja-toledo','mywindow','menubar=1);", true);
            ////HttpContext.Current.Response.Buffer = true;
            ////HttpContext.Current.Response.Expires = 0;
            ////HttpContext.Current.Response.Clear();
            ////HttpContext.Current.Response.ContentType = @".pdf, application/pdf";
            ////HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            ////HttpContext.Current.Response.AddHeader("Content-Disposition", "inline; filename=" + String.Format("Picking-{0}.pdf", DocNum));



            ////HttpContext.Current.Response.BinaryWrite(bytes);


            ////HttpContext.Current.Response.Flush();
            ////Context.ApplicationInstance.CompleteRequest();

        }
        #endregion
    }
}