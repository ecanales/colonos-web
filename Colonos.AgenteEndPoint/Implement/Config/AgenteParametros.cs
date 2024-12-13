using NLog;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.AgenteEndPoint
{
    public class AgenteParametros
    {
        string urlbase = "";
        Logger logger;

        public AgenteParametros(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public string Get(string metedo)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}", urlbase, metedo));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);

            IRestResponse response = client.Execute(request);
            //Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string Guardar(string metedo, string json)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}", urlbase, metedo));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.PATCH);
            request.AddParameter("application/json", json, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }
    }
}
