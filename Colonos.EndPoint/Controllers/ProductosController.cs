using Colonos.EndPointManager;
using Colonos.Entidades;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Colonos.EndPoint.Controllers
{
    
    
    [RoutePrefix("api")]
    public class ProductosController : ApiController
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");

        [HttpGet]
        [Route("productos")]
        public IHttpActionResult List(HttpRequestMessage request)
        {
            logger.Info("request {0}", request.RequestUri);
            ManagerProductos mng = new ManagerProductos(logger);
            var list = mng.ListarCategorias();
            if (!list.error)
            {
                return Ok(list);
            }
            else
            {
                logger.Error("mensaje: {0}. Data: {1}", list.msg,list.data);
                return ResponseMessage(Request.CreateErrorResponse(HttpStatusCode.InternalServerError, list.msg));
            }
        }
    }
}
