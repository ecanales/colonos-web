using Colonos.Entidades;
using Newtonsoft.Json;
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
    public class AgenteDocumentos
    {
        private string urlbase = "";
        private Logger logger;

        public AgenteDocumentos(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }
        public string Guardar(string metodo, string json)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}", urlbase, metodo));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.POST);
            request.AddParameter("application/json", json, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);
            
            Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string Actualizar(string metodo, string json)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}", urlbase, metodo));
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

        public string ActualizarEtiqueta(string metodo, string json)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}", urlbase, metodo));
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


        public string ActualizarOrdendeCompra(string metodo, string json)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}", urlbase, metodo));
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
            logger.Error(response.Content);
            return response.Content;
        }

        public string Get(string metodo, int docentry, int doctipo)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}/{2}?doctipo={3}", urlbase, metodo, docentry, doctipo));
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

        public string GetBase(string metodo, int baseentry, int doctipo)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}/{2}?doctipo={3}", urlbase, metodo, baseentry, doctipo));
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

        public string GetBase(string metodo, int baseentry, int doctipo, int baselinea)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}/{2}?doctipo={3}&baselinea={4}", urlbase, metodo, baseentry, doctipo, baselinea));
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
        public string Search(string metodo, string palabras, string vendedorcode, int doctipo, string usuario)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}?palabras={2}&vendedorcode={3}&doctipo={4}&usuario={5}", urlbase, metodo, palabras, vendedorcode, doctipo, usuario));
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

        public string List(string metodo, int doctipo, string estado = "", string estadooperativo = "", string bodegacode = "", string vendedorcode = "", string fechaini = "", string fechafin = "")
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}?bodegacode={2}&doctipo={3}&estado={4}&estadooperativo={5}&vendedorcode={6}&fechaini={7}&fechafin={8}", 
                urlbase, metodo, bodegacode, doctipo, estado, estadooperativo, vendedorcode, fechaini, fechafin));
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

        public string ListPedidos(string metodo, int doctipo, string estado, string estadooperativo, int pendiente, string usuario, string desde, string hasta)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}?doctipo={2}&estado={3}&estadooperativo={4}&pendiente={5}&vendedorcode={6}&desde={7}&hasta={8}", urlbase, metodo, doctipo, estado, estadooperativo, pendiente, usuario, desde, hasta));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            IRestResponse response = client.Execute(request);

            Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            MensajeReturn msg = new MensajeReturn { error=true,count=0,statuscode=response.StatusCode,msg=response.ErrorMessage};
            
            return JsonConvert.SerializeObject(msg);
        }

        public string ListPicking(string metodo, string bodegacode, string estado)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}?bodegacode={2}&estado={3}", urlbase, metodo, bodegacode, estado));
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

        public string Picking(string metodo, int docentry)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}?docentry={2}", urlbase, metodo, docentry));
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

        public string Propiedades(string metodo, int doctipo)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}?doctipo={2}", urlbase, metodo, doctipo));
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
    }
}
