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
    public class ManagerDimFamilia
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerDimFamilia(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public ITM4 Add(string metodo, string json, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<ITM4>(json);
                return list;
            }
            logger.Error("Error Add Familia", result.msg);
            return new ITM4();
        }

        public ITM4 Modify(string metodo, string json, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if(result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<ITM4>(result.data);
                return list;
            }
            if (result != null && result.msg != null)
            {
                logger.Error("Error Add Familia", result.msg);
            }
            else
            {
                logger.Error("Error Add Familia", result);
            }
            return new ITM4();
        }

        public List<ITM4> List(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.List(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<ITM4>>(json);
                return list;
            }
            logger.Error("Error Add Familia", result.msg);
            return new List<ITM4>();
        }
    }
}
