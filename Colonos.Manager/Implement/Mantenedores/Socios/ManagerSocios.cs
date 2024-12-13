using Colonos.AgenteEndPoint;
using Colonos.Entidades;
using Colonos.Entidades.Defontana;
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
    public class ManagerSocios
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerSocios(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<SociosResult> SocioSearch(string metodo, string palabras, string usuario)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.Search(metodo, palabras, usuario);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if(!result.error && result.statuscode== HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<SociosResult>>(json);
                return list;
            }
            return new List<SociosResult>();
        }

        public Socio SocioGet(string metodo, string socioCode)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.Get(metodo, socioCode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                Socio item = JsonConvert.DeserializeObject<Socio>(json);
                return item;
            }
            return new Socio();
        }

        public List<SCP11> SocioCuentaCorriente(string metodo, string socioCode)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.Get(metodo, socioCode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                List<SCP11> item = JsonConvert.DeserializeObject<List<SCP11>>(json);
                return item;
            }
            return new List<SCP11>();
        }

        public Socio GuardarArchivoCXC(string metodo, List<SCP11> archivos)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(archivos);
            json = agente.Guardar(metodo, json, true);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<Socio>(json);

                return item;
            }
            else
            {
                if (result != null && result.msg != null)
                {
                    logger.Error("se ha generado error al grabar cuenta corriente: {0}", result.msg);
                    throw new Exception(result.msg);
                }
                else
                {
                    logger.Error("No fue posible guardar el Socio, no hay conexión con el servidor");
                    throw new Exception("No fue posible guardar el cuenta corriente, no hay conexión con el servidor");
                }
            }
        }

        public Socio Guardar(string metodo, Socio socio, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(socio);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<Socio>(json);

                return item;
            }
            else
            {
                if (result != null && result.msg != null)
                {
                    logger.Error("se ha generado error al grabar el Socio: {0}", result.msg);
                    throw new Exception(result.msg);
                }
                else
                {
                    logger.Error("No fue posible guardar el Socio, no hay conexión con el servidor");
                    throw new Exception("No fue posible guardar el Socio, no hay conexión con el servidor");
                }
            }
        }


        public Socio GuardarClienteDF(string metodo, ClienteDF socio, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(socio);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = new Socio { RazonSocial = socio.name }; // JsonConvert.DeserializeObject<Socio>(json);

                return item;
            }
            else
            {
                if (result != null && result.msg != null)
                {
                    logger.Error("se ha generado error al grabar el Socio: {0}", result.msg);
                    throw new Exception(result.msg);
                }
                else
                {
                    logger.Error("No fue posible guardar el Socio, no hay conexión con el servidor");
                    throw new Exception("No fue posible guardar el Socio, no hay conexión con el servidor");
                }
            }
        }

        public List<TopFamilia> TopCliente(string metodo, string socioCode)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.TopFamiliaCliente(metodo, socioCode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<List<TopFamilia>>(json);
                return item;
            }
            return new List<TopFamilia>();
        }

        public List<TopVentas> TopVentas(string metodo, string socioCode)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.TopVentasCliente(metodo, socioCode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<List<TopVentas>>(json);
                return item;
            }
            return new List<TopVentas>();
        }

        public List<VentaSocio> Ventas12meses(string metodo, string socioCode)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.Ventas12meses(metodo, socioCode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<List<VentaSocio>>(json);
                return item;
            }
            return new List<VentaSocio>();
        }

        public List<TopFamilia> TopRubro(string metodo, string rubro)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.TopFamiliaRubro(metodo, rubro);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<List<TopFamilia>>(json);
                return item;
            }
            return new List<TopFamilia>();
        }

        public List<TopUltimosPrecios> TopUltimosPrecios(string metodo, string sociocode, string familiacode)
        {
            if (sociocode != "")
            {
                AgenteSocios agente = new AgenteSocios(urlbase, logger);
                var json = agente.TopUltimosPrecios(metodo, sociocode, familiacode);
                var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
                if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
                {
                    json = JsonConvert.SerializeObject(result.data);
                    var item = JsonConvert.DeserializeObject<List<TopUltimosPrecios>>(json);
                    return item;
                }
            }
            return new List<TopUltimosPrecios>();
        }

        public SocioPropiedades Propiedades(string metodo)
        {
            AgenteSocios agente = new AgenteSocios(urlbase, logger);
            var json = agente.Propiedades(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result !=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<SocioPropiedades>(json);
                return list;
            }
            return null;
        }
    }
}
