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
    public class ManagerInventario
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerInventario(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<ProductosResult> ProductoSearch(string metodo, string palabras, string sku="", string maestro="", string bodegacode="")
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Search(metodo, palabras, sku, maestro, bodegacode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<ProductosResult>>(json);
                return list;
            }
            return new List<ProductosResult>();
        }

        public List<ProductosResult> List(string metodo, string esdesglose)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.List(metodo, esdesglose);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<ProductosResult>>(json);
                return list;
            }
            return new List<ProductosResult>();
        }

        public List<ProductosResult> List(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.List(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<ProductosResult>>(json);
                return list;
            }
            return new List<ProductosResult>();
        }

        public ProductoPropiedades Propiedades(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Propiedades(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<ProductoPropiedades>(json);
                return list;
            }
            return new ProductoPropiedades();
        }

        public Producto Get(string metodo, string prodcode)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Get(metodo,prodcode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<Producto>(json);
                return item;
            }
            return new Producto();
        }

        public OITB GetStockBodega(string metodo, string prodcode, string bodegacode)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.GetStockBodega(metodo, prodcode, bodegacode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<OITB>(json);
                return item;
            }
            return new OITB();
        }


        public RecetaProducto Guardar(string metodo, RecetaProducto prod, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(prod);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<RecetaProducto>(json);
                return item;
            }
            throw new ArgumentException(result.msg);
        }

        public Producto Guardar(string metodo, Producto prod, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(prod);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<Producto>(json);
                return item;
            }
            throw new ArgumentException(result.msg);
            //return new Producto();
        }

        public List<OBOD> ListBodegas(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.ListBodegas(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if(result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<OBOD>>(json);
                return list;
            }
            return new List<OBOD>();
        }

        public string ActualizaStock(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Get(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null)
            {
                return result.msg;
            }
            return "servicio no disponible";
        }

        public string ActualizaCostos(string metodo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Get(metodo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null)
            {
                return result.msg;
            }
            return "servicio no disponible";

        }
        #region Recetas ********************************************************************

        public RecetasResult ListReceta(string metodo, string prodcode, string bodega)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.ListReceta(metodo, prodcode, bodega);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<RecetasResult>(json);
                return list;
            }
            return new RecetasResult();
        }

        public RecetaProducto GetReceta(string metodo, string prodcode)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Get(metodo, prodcode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<RecetaProducto>(json);
                return item;
            }
            return new RecetaProducto();
        }


        public RecetaProducto GuardarReceta(string metodo, RecetaProducto receta, bool nuevo)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(receta);
            json = agente.Guardar(metodo, json, nuevo);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<RecetaProducto>(json);
                return item;
            }
            return new RecetaProducto();
        }
        #endregion ********

        public RecetaProducto GetPrecioFijo(string metodo, string prodcode)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = agente.Get(metodo, prodcode);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var item = JsonConvert.DeserializeObject<RecetaProducto>(json);
                return item;
            }
            return new RecetaProducto();
        }

        #region Transacciones de Inventario ***
        public string AjusteInventario(string metodo, TransacciondeInventario ajuste)
        {
            AgenteProductos agente = new AgenteProductos(urlbase, logger);
            var json = JsonConvert.SerializeObject(ajuste);
            json = agente.AjusteInventario(metodo, json);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (!result.error && result.statuscode == HttpStatusCode.OK)
            {
                //json = JsonConvert.SerializeObject(result.data);
                //var item = JsonConvert.DeserializeObject<RecetaProducto>(json);
                return result.msg;
            }
            return "";
        }
        #endregion
    }
}
