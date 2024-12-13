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
    public class ManagerDimAnimal
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerDimAnimal(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public ITM5 Add(string metodo, string json, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            json = agente.Guardar(metodo,json,nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<ITM5>(json);
                return list;
            }
            logger.Error("Error Add Animal", result.msg);
            return new ITM5();
        }

        public ITM5 Modify(string metodo, string json, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<ITM5>(result.data);
                return list;
            }
            logger.Error("Error Add Animal", result.msg);
            return new ITM5();
        }

        public List<ITM5> List(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.List(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<ITM5>>(json);
                return list;
            }
            return new List<ITM5>();
        }
    }
}
