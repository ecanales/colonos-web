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
    public class ManagerDevolucion
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerDevolucion(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<Motivo> ListMotivos(string metodo)
        {
            AgenteDevolucion agente = new AgenteDevolucion(urlbase, logger);
            var json = agente.ListMotivos(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<Motivo>>(json);
                return list;
            }
            return new List<Motivo>();
        }
    }
}
