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
    public class ManagerLogistica
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerLogistica(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<Vehicle> ListVehiculos(string metodo)
        {
            AgenteLogistica agente = new AgenteLogistica(urlbase, logger);
            var json = agente.ListVehiculos(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<Vehicle>>(json);
                return list;
            }
            return new List<Vehicle>();
        }
    }
}
