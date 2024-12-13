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
    public class AgenteUsuario
    {
        string urlbase = "";
        Logger logger;

        public AgenteUsuario(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public string ListUsuarios(string metedo, string idgrupo, string idgrupo2="")
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}{1}?idgrupo={2}&idgrupo2={3}", urlbase, metedo, idgrupo, idgrupo2));
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

        
        public string GrupoList(string metedo)
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

        public string ConfigMenuList(string urlBase)
        {
            var client = new RestClient(String.Format("{0}system/users/accesos/menu", urlBase));
            var request = new RestRequest(Method.GET);
            request.AddHeader("Content-Type", "application/json");
            IRestResponse response = client.Execute(request);
            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string GrupoAccesosList(string urlBase, string idgrupo)
        {
            var client = new RestClient(String.Format("{0}system/users/accesos/{1}", urlBase, idgrupo));
            var request = new RestRequest(Method.GET);
            request.AddHeader("Content-Type", "application/json");
            IRestResponse response = client.Execute(request);
            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public void AddGrupoAcceso(string urlBase, string json)
        {
            var client = new RestClient(String.Format("{0}system/grupos/addacceso", urlBase));
            var request = new RestRequest(Method.POST);
            request.AddHeader("Content-Type", "application/json");
            request.AddParameter("application/json", json, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);

        }

        public string Login(string json, string urlBase, string jsonBrowser)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("{0}system/login", urlBase));
            var request = new RestRequest(Method.POST);
            request.AddHeader("Content-Type", "application/json");
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(jsonBrowser);
            var jsonBrowser64 = System.Convert.ToBase64String(plainTextBytes);
            request.AddHeader("browser", jsonBrowser64);
            request.AddParameter("application/json", json, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);
            if (response.StatusCode == HttpStatusCode.OK)
            {
                //GetLoginOut login = JsonConvert.DeserializeObject<GetLoginOut>(response.Content);
                return response.Content;
            }
            return response.Content;
        }

        public string GetUsuario_Login(string IdUsuario, string urlBase)
        {
            var client = new RestClient(String.Format("{0}system/login/{1}", urlBase, IdUsuario));
            var request = new RestRequest(Method.GET);
            request.AddHeader("Content-Type", "application/json");
            IRestResponse response = client.Execute(request);
            if (response.StatusCode == HttpStatusCode.OK)
            {
                //GetUsuarios us = JsonConvert.DeserializeObject<GetUsuarios>(response.Content);
                return response.Content;
            }
            return response.Content;
        }
    }
}
