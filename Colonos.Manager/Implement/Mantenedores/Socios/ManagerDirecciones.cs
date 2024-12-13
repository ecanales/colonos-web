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
    public class ManagerDirecciones
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerDirecciones(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public Direccion Get(string metodo, int direccioncode)
        {
            var agente = new AgenteDirecciones(urlbase, logger);
            var json = agente.Get(metodo, direccioncode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<Direccion>(json);
                return item;
            }
            return new Direccion();
        }
    }
}
