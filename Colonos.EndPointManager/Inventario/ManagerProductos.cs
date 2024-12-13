using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Colonos.EndPointDataAccess;
using Colonos.EndPointDataAccess.Repositorios;
using Colonos.Entidades;
using Colonos.Entidades.Inventario;
using Newtonsoft.Json;
using NLog;

namespace Colonos.EndPointManager
{
    public class ManagerProductos
    {
        Logger logger;
        public ManagerProductos(Logger _logger)
        {
            logger = _logger;
        }
        public List<Producto> ListarProductos()
        {
            Repo_OITM repo = new Repo_OITM(logger);

            var list = repo.List();
            var result = JsonConvert.DeserializeObject<List<Producto>>(list);
            return result;
        }

        public MensajeReturn ListarCategorias()
        {
            try
            {
                Repo_ITM2 repo = new Repo_ITM2();

                var list = repo.List();
                MensajeReturn msg = new MensajeReturn();
                msg.error = false;
                msg.msg = "Listado Categorías";
                msg.data = JsonConvert.DeserializeObject<List<Categorias>>(list);
                return msg;
            }
            catch(Exception ex)
            {
                MensajeReturn msg = new MensajeReturn();
                msg.error = true;
                msg.msg = ex.Message;
                msg.data = ex.StackTrace;
                if(ex.InnerException!=null)
                {
                    msg.data += JsonConvert.SerializeObject(ex);
                }
                
                return msg;
            }
        }
    }
}
