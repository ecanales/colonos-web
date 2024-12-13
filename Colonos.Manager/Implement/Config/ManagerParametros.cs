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
    public class ManagerParametros
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerParametros(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        
        public ParametrosGenerales Get(string metodo)
        {
            var agente = new AgenteParametros(urlbase, logger);
            var json = agente.Get(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var param = JsonConvert.DeserializeObject<ParametrosGenerales>(json);
                return param;
            }
            return new ParametrosGenerales();
        }

        public ParametrosGenerales Modify(string metodo, string item)
        {
            
            var agente = new AgenteParametros(urlbase, logger);
            var json = agente.Guardar(metodo, item);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var param = JsonConvert.DeserializeObject<ParametrosGenerales>(json);
                return param;
            }
            return new ParametrosGenerales();
        }
    }
}
