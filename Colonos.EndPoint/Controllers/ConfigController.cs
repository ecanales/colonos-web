using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Colonos.EndPoint.Controllers
{
    [RoutePrefix("api")]
    public class ConfigController : ApiController
    {
        [HttpGet]
        [Route("config/familia")]
        public IHttpActionResult List(HttpRequestMessage request)
        {

            return Ok();
        }
    }
}
