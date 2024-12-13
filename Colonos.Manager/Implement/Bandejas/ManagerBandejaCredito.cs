using Colonos.AgenteEndPoint;
using Colonos.Entidades;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Manager
{
    public class ManagerBandejaCredito
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerBandejaCredito(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<Bandeja> Listar(string metodo, string bandejacode, short estado, short visible)
        {
            AgenteBandejas agente = new AgenteBandejas(urlbase, logger);
            var json = agente.ListBandejaEstado(metodo, bandejacode, estado, visible);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<Bandeja>>(json);
                return list;
            }
            

            return new List<Bandeja>();
        }

        public List<Bandeja> Listar(string metodo, string bandejacode, string sociocode, short top = 0)
        {
            AgenteBandejas agente = new AgenteBandejas(urlbase, logger);
            var json = agente.ListBandejaEstado(metodo, bandejacode,sociocode, top);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<Bandeja>>(json);
                return list;
            }


            return new List<Bandeja>();
        }

        public Bandeja Get(string metodo, string bandejacode, int docentry)
        {

            AgenteBandejas agente = new AgenteBandejas(urlbase, logger);
            var json= agente.VerBandeja(metodo, bandejacode,docentry);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null)
            {
                json = JsonConvert.SerializeObject(result.data);
                if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
                {
                    var bandeja = JsonConvert.DeserializeObject<Bandeja>(json);
                    return bandeja;
                }
            }
            return null;
        }

        public Bandeja Modify(string metodo, string bandejacode, int docentry, Bandeja bandeja)
        {
            AgenteBandejas agente = new AgenteBandejas(urlbase, logger);
            var json = JsonConvert.SerializeObject(bandeja);
            json=agente.ActualizarBandeja(metodo, bandejacode, docentry, json);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            json = JsonConvert.SerializeObject(result.data);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                bandeja = JsonConvert.DeserializeObject<Bandeja>(json);
                return bandeja;
            }

            return new Bandeja();
        }

        public void Delete(string bandejacode, int docentry)
        {


            
        }
    }
}
