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

    public class AgenteBandejas
    {
        private string urlbase = "";
        private Logger logger;

        public AgenteBandejas(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public string ListBandejaEstado(string metedo, string bandeja, short estado, short visible)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}/{2}?estado={3}&visible={4}", urlbase, metedo, bandeja,estado, visible));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            IRestResponse response = client.Execute(request);

            Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string ListBandejaEstado(string metedo, string bandeja, string sociocode, int top = 0)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}/{2}?sociocode={3}&top={4}", urlbase, metedo, bandeja, sociocode, top));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            IRestResponse response = client.Execute(request);

            Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string VerBandeja(string metedo, string bandeja, int docentry)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}/{2}/{3}", urlbase, metedo, bandeja, docentry));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            IRestResponse response = client.Execute(request);

            Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string ActualizarBandeja(string metedo, string bandeja, int docentry, string json)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}/{2}/{3}", urlbase, metedo, bandeja, docentry));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.PATCH);
            request.AddParameter("application/json", json, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);

            Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }
    }
}
