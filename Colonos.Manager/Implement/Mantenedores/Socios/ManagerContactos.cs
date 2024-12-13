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
    public class ManagerContactos
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerContactos(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public Contacto Get(string metodo, int direccioncode)
        {
            var agente = new AgenteContactos(urlbase, logger);
            var json = agente.Get(metodo, direccioncode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<Contacto>(json);
                return item;
            }
            return new Contacto();
        }
    }
}
