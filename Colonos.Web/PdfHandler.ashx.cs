using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace Colonos.Web
{
    /// <summary>
    /// Descripción breve de PdfHandler
    /// </summary>
    public class PdfHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {// Simulación de la obtención del MemoryStream del PDF
            MemoryStream pdfStream = GetPdfStream();

            context.Response.ContentType = "application/pdf";
            context.Response.AddHeader("content-disposition", "inline; filename=example.pdf");
            context.Response.Buffer = true;
            context.Response.Clear();
            context.Response.OutputStream.Write(pdfStream.ToArray(), 0, (int)pdfStream.Length);
            context.Response.OutputStream.Flush();
            context.Response.End();
        }

        private MemoryStream GetPdfStream()
        {
            // Aquí puedes cargar tu MemoryStream real. Este es solo un ejemplo de simulación.
            MemoryStream memoryStream = new MemoryStream();
            using (FileStream fileStream = File.OpenRead(HttpContext.Current.Server.MapPath("~/path/to/your/file.pdf")))
            {
                fileStream.CopyTo(memoryStream);
            }
            memoryStream.Position = 0; // Resetear la posición del stream
            return memoryStream;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}