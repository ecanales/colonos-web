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
    public class ManagerBandejaPrecios
    {
        private string urlbase = "";
        private Logger logger;
        public ManagerBandejaPrecios(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }

        public List<Bandeja> Listar(string bandejacode, short estado, short visible)
        {
            AgenteBandejas agente = new AgenteBandejas(urlbase, logger);
            var json = agente.ListBandejaEstado("bandejas", bandejacode, estado, visible);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<Bandeja>>(json);
                return list;
            }


            return new List<Bandeja>();
        }

        public List<DocumentoLineaBandejaPrecios> GetDetalle(string bandejacode, int docentry)
        {

            var bandeja = Get(bandejacode, docentry);

            List<DocumentoLineaBandejaPrecios> detalle = new List<DocumentoLineaBandejaPrecios>();

            //consultar pedido
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var pedido = mng.Consultar("documentos", docentry,10);
            if (pedido != null)
            {
                foreach (var i in pedido.Lineas)
                {
                    var item = new DocumentoLineaBandejaPrecios
                    {
                        DocEntry = i.DocEntry,
                        AnimalCode = i.AnimalCode,
                        CantidadSolicitada = i.CantidadSolicitada,
                        PrecioFinal = i.PrecioFinal,
                        Costo = i.Costo,
                        DocLinea = i.DocLinea,
                        LineaItem = i.LineaItem,
                        Margen = i.Margen,
                        ProdCode = i.ProdCode,
                        ProdNombre = i.ProdNombre,
                        Volumen = i.Volumen,
                        TotalSolicitado = i.TotalSolicitado,
                        PrecioUnitario = i.PrecioUnitario,
                        ValorSolicitado = 0,
                        ValorRegla = 0,
                        PrecioVolumen=i.PrecioVolumen,
                        MargenRegla=i.MargenRegla
                    };

                    var itembandeja = bandeja.Items.Find(x => x.DocEntry == i.DocEntry && x.DocLinea == i.DocLinea);
                    if (itembandeja != null)
                    {
                        item.ValorSolicitado = itembandeja.ValorSolicitado;
                        item.ValorRegla = itembandeja.ValorRegla;
                        item.MotivoIngreso = itembandeja.MotivoIngreso;
                    }
                    detalle.Add(item);
                }
            }

            return detalle;
        }

        public Bandeja Get(string bandejacode, int docentry)
        {

            AgenteBandejas agente = new AgenteBandejas(urlbase, logger);
            var json = agente.VerBandeja("bandejas", bandejacode, docentry);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            json = JsonConvert.SerializeObject(result.data);
            var bandeja = JsonConvert.DeserializeObject<Bandeja>(json);

            return bandeja;
        }
    }
}
