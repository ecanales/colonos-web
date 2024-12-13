using Colonos.Entidades;
using Colonos.Manager;
using Microsoft.Reporting.WebForms;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;

namespace Colonos.Web.Documentos
{
    public class ManagerReporting
    {
        private Logger logger;
        private string urlbase = "";
        public ManagerReporting(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }
        public MemoryStream PickingProduccion(int docentry, string pathDocumentos)
        {
            
            
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick= mng.Picking("/documentos/picking/produccion", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-produccion");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public MemoryStream PickingToledo(int docentry, string pathDocumentos)
        {


            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Picking pick = mng.Picking("/documentos/picking/toledo", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (pick != null)
            {
                var ms = GeneraPDF(pick, pick.Lineas, ref pathDocumentos, false, logger, "picking-toledo");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
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
    }
}