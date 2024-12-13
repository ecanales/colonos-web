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
    public class ManagerPrecioFijos
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerPrecioFijos(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<ListaPrecioFijo> List(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.List(metodo, "");
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<ListaPrecioFijo>>(json);
                return list;
            }
            return new List<ListaPrecioFijo>();
        }

        public ListaPrecioFijo Get(string metodo, string listacode)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Get(metodo, listacode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<ListaPrecioFijo>(json);
                return item;
            }
            return new ListaPrecioFijo();
        }


        public ListaPrecioFijo Delete(string metodo, string listacode)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Delete(metodo, listacode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<ListaPrecioFijo>(json);
                return item;
            }
            return new ListaPrecioFijo();
        }
        public ListaPrecioFijo Guardar(string metodo, ListaPrecioFijo lista , bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(lista);
            json = agente.Guardar(metodo, json, nuevo); // es nuevo
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<ListaPrecioFijo>(json);
                return item;
            }
            return new ListaPrecioFijo();
        }
    }
}
