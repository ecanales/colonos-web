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
    public class ManagerInformes
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerInformes(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<ControlPrecio> ControlPrecios(string metodo)
        {
            var agente = new AgenteInformes(urlbase, logger);
            var json = agente.ControlPrecios(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<ControlPrecio>>(json);
                return list;
            }
            logger.Error("Error Procesar informe control precios", result.msg);
            return new List<ControlPrecio>();
        }

        public List<SeguimientoOperacion> SeguimientoOperaciones(string metodo)
        {
            var agente = new AgenteInformes(urlbase, logger);
            var json = agente.ControlPrecios(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<SeguimientoOperacion>>(json);
                return list;
            }
            logger.Error("Error Procesar informe seguimiento pedidos", result.msg);
            return new List<SeguimientoOperacion>();
        }

        public InfoPedidos PedidosDelDia(string metodo, DateTime fecha)
        {
            var agente = new AgenteInformes(urlbase, logger);
            var json = agente.PedidosDelDia(metodo, fecha);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<InfoPedidos> (json);
                return list;
            }
            logger.Error("Error Procesar informe pedidos del día", result.msg);
            return new InfoPedidos();
        }

    }
}
