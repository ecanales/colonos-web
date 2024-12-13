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
    public class ManagerDocumentos
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerDocumentos(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<DocumentosResult> Search(string metodo, string palabras, string vendedorcode, int doctipo, string usuario)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.Search(metodo, palabras, vendedorcode, doctipo, usuario);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<DocumentosResult>>(json);
                return list;
            }
            return new List<DocumentosResult>();
        }

        
        public List<DocumentosResult> List(string metodo, int doctipo, string estado = "", string estadooperativo = "", string bodegacode="", string vendedorcode = "", string fechaini = "", string fechafin = "")
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.List(metodo, doctipo,estado,estadooperativo, bodegacode,vendedorcode,fechaini, fechafin);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<DocumentosResult>>(json);
                return list;
            }
            logger.Error("metodo:{0}, bodegacode:{1}, doctipo:{2}", metodo, bodegacode, doctipo);
            logger.Error("{0}", result!=null ? result.msg : "");
            return new List<DocumentosResult>();
        }

        public List<DocumentosResult> ListPedidos(string metodo,  int doctipo, string estado, string estadooperativo, int pendiente, string usuario, string desde, string hasta)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            
                var json = agente.ListPedidos(metodo, doctipo, estado, estadooperativo, pendiente, usuario, desde, hasta);
                var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<DocumentosResult>>(json);
                //list = list.FindAll(x => x.TotalKilosPendientes > 0).ToList();

                //list = list.FindAll(x => x.TotalKilos > 0);
                return list;
            }
            if (result != null && result.msg != null)
            {
                logger.Error("Error Listando doctipo: {0}, {1}", doctipo, result.msg);
            }
            else
            {
                logger.Error("Error Listando doctipo: {0}", doctipo);
            }
            throw new Exception(result.msg);
            //return new List<DocumentosResult>();
        }

        public List<DocumentosResult> ListPicking(string metodo, string bodegacode, string estado)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.ListPicking(metodo, bodegacode, estado);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<DocumentosResult>>(json);
                return list;
            }
            return new List<DocumentosResult>();
        }

        public Documento GuardarEtiqueta(string metodo, Documento item)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = "";
            if (item.DocEntry > 0)
            {
                json = JsonConvert.SerializeObject(item, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
                json = agente.ActualizarEtiqueta(metodo, json);
                var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                return doc;
            }

            return item;
        }

        public Documento GuardarOrdendeCompra(string metodo, Documento item)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = "";
            if (item.DocEntry > 0)
            {
                json = JsonConvert.SerializeObject(item, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
                json = agente.ActualizarOrdendeCompra(metodo, json);
                var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                return doc;
            }

            return item;
        }

        public Documento Guardar(string metodo, Documento item)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = "";

            if (item.DocEntry > 0)
            {
                var docoriginal = this.Consultar("/documentos", item.DocEntry, Convert.ToInt32(item.DocTipo));
                item.FechaRegistro = docoriginal.FechaRegistro;
                item.DocFecha = docoriginal.DocFecha;
                json = JsonConvert.SerializeObject(item, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
                json = agente.Actualizar(metodo, json);
            }
            else
            {
                json = JsonConvert.SerializeObject(item, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
                json = agente.Guardar(metodo, json);
            }
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                return doc;
            }
            else
            {
                if (result != null && result.msg!=null)
                {
                    logger.Error("se ha generado error al grabar Transacción de inventario: {0}", result.msg);
                    throw new Exception(result.msg);
                }
                else
                {
                    logger.Error("No fue posible generar transacción");
                    throw new Exception("No fue posible generar transacción");
                }

            }
            //return null;
        }

        public DocumentoRuta Guardar(string metodo, DocumentoRuta item)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = "";

            if (item.DocEntry > 0)
            {
                var docoriginal = this.Consultar("documentos", item.DocEntry, item.DocTipo);
                item.FechaRegistro = docoriginal.FechaRegistro;
                item.DocFecha = docoriginal.DocFecha;
                json = JsonConvert.SerializeObject(item, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
                json = agente.Actualizar(metodo, json);
            }
            else
            {
                json = JsonConvert.SerializeObject(item, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
                json = agente.Guardar(metodo, json);
            }
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<DocumentoRuta>(json);
                return doc;
            }
            else
            {
                throw new Exception(result.msg);
            }
            //return null;
        }
        public Documento Actualizar(string metodo, Documento item)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = JsonConvert.SerializeObject(item, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
            json = agente.Actualizar(metodo, json);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                return doc;
            }
            
            throw new Exception(result.msg);
        }


        public Documento Actualizar(string metodo, List<Documento> items)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = JsonConvert.SerializeObject(items, Formatting.None, new JsonSerializerSettings() { NullValueHandling = NullValueHandling.Ignore });
            json = agente.Actualizar(metodo, json);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                return doc;
            }

            throw new Exception(result.msg);
        }

        public Documento Consultar(string metodo, int docentry, int doctipo)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.Get(metodo, docentry, doctipo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                
                return doc;
            }
            logger.Error("Agente Endpoint. ConsultaPedido: {0}", result.msg);
            return null;
        }

        public Picking Picking(string metodo, int docentry)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.Picking(metodo, docentry);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Picking>(json);

                return doc;
            }
            var result2 = new MensajeReturn { msg=""};
            result2 = result == null ? new MensajeReturn { msg = "" } : result;
            logger.Error("Agente Endpoint. Picking: {0}", result2.msg);
            return null;
        }

        

        public Documento ConsultarBase(string metodo, int baseentry, int doctipo)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.GetBase(metodo, baseentry, doctipo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if(result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                return doc;
            }
            logger.Error("Agente Endpoint. ConsultaPedido: {0}", result!=null ? result.msg : "result sin resultados");
            return null;
        }

        public Documento ConsultarBase(string metodo, int baseentry, int doctipo, int baselinea)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.GetBase(metodo, baseentry, doctipo, baselinea);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);
                return doc;
            }
            logger.Error("Agente Endpoint. ConsultaPedido: {0}", result != null ? result.msg : "result sin resultados");
            return null;
        }


        public DocumentoPropiedades Propiedades(string metodo, int doctipo)
        {
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.Propiedades(metodo, doctipo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<DocumentoPropiedades>(json);
                return list;
            }
            return null;
        }
    }
}
