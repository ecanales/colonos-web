using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.AgenteDefontana
{
    public class DefontanaAgente
    {

        public string ListarProductos(int pagina)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("https://replapi.defontana.com/api/Sale/GetProducts?status=0&itemsPerPage=250&pageNumber={0}", pagina));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            request.AddHeader("Authorization", "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1laWQiOiJBRDEyM0ZULUhHREY1Ni1LSTIzS0wtS0pUUDk4NzYtSEdUMTIiLCJ1bmlxdWVfbmFtZSI6ImNsaWVudC5sZWdhY3lAZGVmb250YW5hLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vYWNjZXNzY29udHJvbHNlcnZpY2UvMjAxMC8wNy9jbGFpbXMvaWRlbnRpdHlwcm92aWRlciI6IkFTUC5ORVQgSWRlbnRpdHkiLCJBc3BOZXQuSWRlbnRpdHkuU2VjdXJpdHlTdGFtcCI6IkdIVEQyMzQtS0xISjc4NjgtRkc0OTIzLUhKRzA4RlQ1NiIsImNvbXBhbnkiOiJHVkxJTUlUQURBIiwiY2xpZW50IjoiR1ZMSU1JVEFEQSIsIm9sZHNlcnZpY2UiOiJwbGF0aW51bSIsInVzZXIiOiJJTlRFR1JBQ0lPTiIsInNlc3Npb24iOiIxNzA3MTYwODgzIiwic2VydmljZSI6InBsYXRpbnVtIiwiY291bnRyeSI6IkNMIiwiY29tcGFueV9uYW1lIjoiU2VydmljaW9zIHkgUmVudGFzIEcuVi4gU3BBIiwiY29tcGFueV9jb3VudHJ5IjoiQ0wiLCJ1c2VyX25hbWUiOiJJTlRFR1JBQ0lPTiIsInJvbGVzUG9zIjoiW1widXN1YXJpb1wiLFwidXN1YXJpb2VycFwiXSIsInJ1dF91c3VhcmlvIjoiMTYuMDQxLjE2OS00IiwiaXNzIjoiaHR0cHM6Ly8qLmRlZm9udGFuYS5jb20iLCJhdWQiOiIwOTkxNTNjMjYyNTE0OWJjOGVjYjNlODVlMDNmMDAyMiIsImV4cCI6MTcwNzMzMzY4MywibmJmIjoxNzA3MTYwODgzfQ.xz-b9KvGI2qdKMisicmk47_EtKrHMHbpD3bW4GQq1qE");
            

            IRestResponse response = client.Execute(request);
            //Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string ListarClientes(int pagina)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("https://api.defontana.com/api/Sale/GetClients?itemsPerPage=250&pageNumber={0}&status=0", pagina));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            request.AddHeader("Authorization", "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1laWQiOiJBRDEyM0ZULUhHREY1Ni1LSTIzS0wtS0pUUDk4NzYtSEdUMTIiLCJ1bmlxdWVfbmFtZSI6ImNsaWVudC5sZWdhY3lAZGVmb250YW5hLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vYWNjZXNzY29udHJvbHNlcnZpY2UvMjAxMC8wNy9jbGFpbXMvaWRlbnRpdHlwcm92aWRlciI6IkFTUC5ORVQgSWRlbnRpdHkiLCJBc3BOZXQuSWRlbnRpdHkuU2VjdXJpdHlTdGFtcCI6IkdIVEQyMzQtS0xISjc4NjgtRkc0OTIzLUhKRzA4RlQ1NiIsImNvbXBhbnkiOiJHVkxJTUlUQURBIiwiY2xpZW50IjoiR1ZMSU1JVEFEQSIsIm9sZHNlcnZpY2UiOiJwbGF0aW51bSIsInVzZXIiOiJJTlRFR1JBQ0lPTiIsInNlc3Npb24iOiIxNzE0MjMyNzk3Iiwic2VydmljZSI6InBsYXRpbnVtIiwiY291bnRyeSI6IkNMIiwiY29tcGFueV9uYW1lIjoiU2VydmljaW9zIHkgUmVudGFzIEcuVi4gU3BBIiwiY29tcGFueV9jb3VudHJ5IjoiQ0wiLCJ1c2VyX25hbWUiOiJJTlRFR1JBQ0lPTiIsImV4cGlyYXRpb25fZGF0ZSI6MTcyMzE2MTYwMCwiY2xpZW50X2NvbmRpdGlvbiI6IlMiLCJyb2xlc1BvcyI6IltcInVzdWFyaW9cIixcInVzdWFyaW9lcnBcIl0iLCJydXRfdXN1YXJpbyI6IjE2LjA0MS4xNjktNCIsImlzcyI6Imh0dHBzOi8vKi5kZWZvbnRhbmEuY29tIiwiYXVkIjoiMDk5MTUzYzI2MjUxNDliYzhlY2IzZTg1ZTAzZjAwMjIiLCJleHAiOjE3NDU3Njg3OTcsIm5iZiI6MTcxNDIzMjc5N30.QzjcLQH9LGqzv-B5Hvxn-KB3Ncy3cdKusX7fO69ohp0");


            IRestResponse response = client.Execute(request);
            //Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string ListarProveedores(int pagina)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("https://replapi.defontana.com/api/PurchaseOrder/GetProviders?itemsPerPage=250&pageNumber={0}&status=0", pagina));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            request.AddHeader("Authorization", "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1laWQiOiJBRDEyM0ZULUhHREY1Ni1LSTIzS0wtS0pUUDk4NzYtSEdUMTIiLCJ1bmlxdWVfbmFtZSI6ImNsaWVudC5sZWdhY3lAZGVmb250YW5hLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vYWNjZXNzY29udHJvbHNlcnZpY2UvMjAxMC8wNy9jbGFpbXMvaWRlbnRpdHlwcm92aWRlciI6IkFTUC5ORVQgSWRlbnRpdHkiLCJBc3BOZXQuSWRlbnRpdHkuU2VjdXJpdHlTdGFtcCI6IkdIVEQyMzQtS0xISjc4NjgtRkc0OTIzLUhKRzA4RlQ1NiIsImNvbXBhbnkiOiJHVkxJTUlUQURBIiwiY2xpZW50IjoiR1ZMSU1JVEFEQSIsIm9sZHNlcnZpY2UiOiJwbGF0aW51bSIsInVzZXIiOiJJTlRFR1JBQ0lPTiIsInNlc3Npb24iOiIxNzA3MTYwODgzIiwic2VydmljZSI6InBsYXRpbnVtIiwiY291bnRyeSI6IkNMIiwiY29tcGFueV9uYW1lIjoiU2VydmljaW9zIHkgUmVudGFzIEcuVi4gU3BBIiwiY29tcGFueV9jb3VudHJ5IjoiQ0wiLCJ1c2VyX25hbWUiOiJJTlRFR1JBQ0lPTiIsInJvbGVzUG9zIjoiW1widXN1YXJpb1wiLFwidXN1YXJpb2VycFwiXSIsInJ1dF91c3VhcmlvIjoiMTYuMDQxLjE2OS00IiwiaXNzIjoiaHR0cHM6Ly8qLmRlZm9udGFuYS5jb20iLCJhdWQiOiIwOTkxNTNjMjYyNTE0OWJjOGVjYjNlODVlMDNmMDAyMiIsImV4cCI6MTcwNzMzMzY4MywibmJmIjoxNzA3MTYwODgzfQ.xz-b9KvGI2qdKMisicmk47_EtKrHMHbpD3bW4GQq1qE");


            IRestResponse response = client.Execute(request);
            //Console.WriteLine(response.Content);

            if (response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Created)
            {
                return response.Content;
            }
            return response.Content;
        }

        public string ListarBodegas(int pagina)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            var client = new RestClient(String.Format("https://replapi.defontana.com/api/Sale/GetStorages?itemsPerPage=250&pageNumber={0}", pagina));
            client.Timeout = -1;
            client.FollowRedirects = false;
            var request = new RestRequest(Method.GET);
            request.AddHeader("Authorization", "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1laWQiOiJBRDEyM0ZULUhHREY1Ni1LSTIzS0wtS0pUUDk4NzYtSEdUMTIiLCJ1bmlxdWVfbmFtZSI6ImNsaWVudC5sZWdhY3lAZGVmb250YW5hLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vYWNjZXNzY29udHJvbHNlcnZpY2UvMjAxMC8wNy9jbGFpbXMvaWRlbnRpdHlwcm92aWRlciI6IkFTUC5ORVQgSWRlbnRpdHkiLCJBc3BOZXQuSWRlbnRpdHkuU2VjdXJpdHlTdGFtcCI6IkdIVEQyMzQtS0xISjc4NjgtRkc0OTIzLUhKRzA4RlQ1NiIsImNvbXBhbnkiOiJHVkxJTUlUQURBIiwiY2xpZW50IjoiR1ZMSU1JVEFEQSIsIm9sZHNlcnZpY2UiOiJwbGF0aW51bSIsInVzZXIiOiJJTlRFR1JBQ0lPTiIsInNlc3Npb24iOiIxNzA3MTYwODgzIiwic2VydmljZSI6InBsYXRpbnVtIiwiY291bnRyeSI6IkNMIiwiY29tcGFueV9uYW1lIjoiU2VydmljaW9zIHkgUmVudGFzIEcuVi4gU3BBIiwiY29tcGFueV9jb3VudHJ5IjoiQ0wiLCJ1c2VyX25hbWUiOiJJTlRFR1JBQ0lPTiIsInJvbGVzUG9zIjoiW1widXN1YXJpb1wiLFwidXN1YXJpb2VycFwiXSIsInJ1dF91c3VhcmlvIjoiMTYuMDQxLjE2OS00IiwiaXNzIjoiaHR0cHM6Ly8qLmRlZm9udGFuYS5jb20iLCJhdWQiOiIwOTkxNTNjMjYyNTE0OWJjOGVjYjNlODVlMDNmMDAyMiIsImV4cCI6MTcwNzMzMzY4MywibmJmIjoxNzA3MTYwODgzfQ.xz-b9KvGI2qdKMisicmk47_EtKrHMHbpD3bW4GQq1qE");


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
