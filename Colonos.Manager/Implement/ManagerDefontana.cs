using Colonos.AgenteDefontana;
using Colonos.Entidades.Defontana;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Manager
{
    

    public class ManagerDefontana
    {
        Logger logger;

        public ManagerDefontana(Logger _logger)
        {
            logger = _logger;
        }

        //public void ListarProductos()
        //{
        //    DefontanaAgente agDef = new DefontanaAgente();
        //    //List<ProductosDF> list = new List<ProductosDF>();
        //    //var list = new productListDF();

        //    for (int i =1; i < 37; i++)
        //    {
        //        var json = agDef.ListarProductos(i);
        //        var list = JsonConvert.DeserializeObject<productListDF>(json);
        //        Repo_JsonProductos repo = new Repo_JsonProductos();
        //        repo.Add(new EndPointDataAccess.JsonProductos { json = json });
        //    }
        //}

        public void ListarClientes()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            DefontanaAgente agDef = new DefontanaAgente();
            //List<ProductosDF> list = new List<ProductosDF>();
            //var list = new productListDF();
            
            ManagerSocios mng = new ManagerSocios(urlbase, logger);

            for (int i = 1; i < 30; i++)
            {
                var json = agDef.ListarClientes(i);

                var list = JsonConvert.DeserializeObject<ClienteListDF>(json);
                foreach(var c in list.clientList)
                {
                    try
                    {
                        mng.GuardarClienteDF("socios/addDF", c, true);
                        logger.Info("Socio: {0} {1}, {2}", c.fileID, c.name, "OK");
                        Debug.Print("Socio: {0} {1}, {2}", c.fileID, c.name, "OK");
                    }
                    catch(Exception ex)
                    {
                        logger.Error("Socio: {0} {1}, {2}", c.fileID, c.name, ex.Message);
                    }
                }
                //Repo_JsonClientes repo = new Repo_JsonClientes();
                //repo.Add(new EndPointDataAccess.JsonClientes { json = json });
            }
        }

        //public void ListarProveedores()
        //{
        //    DefontanaAgente agDef = new DefontanaAgente();
        //    //List<ProductosDF> list = new List<ProductosDF>();
        //    //var list = new productListDF();

        //    for (int i = 1; i < 30; i++)
        //    {
        //        var json = agDef.ListarProveedores(i);
        //        //var list = JsonConvert.DeserializeObject<productListDF>(json);
        //        Repo_JsonProveedores repo = new Repo_JsonProveedores();
        //        repo.Add(new EndPointDataAccess.JsonProveedores { json = json });
        //    }
        //}

        //public void ListarBodegas()
        //{
        //    DefontanaAgente agDef = new DefontanaAgente();
        //    //List<ProductosDF> list = new List<ProductosDF>();
        //    //var list = new productListDF();

        //    for (int i = 1; i < 10; i++)
        //    {
        //        var json = agDef.ListarBodegas(i);
        //        //var list = JsonConvert.DeserializeObject<productListDF>(json);
        //        Repo_JsonBodegas repo = new Repo_JsonBodegas();
        //        repo.Add(new EndPointDataAccess.JsonBodegas { json = json });
        //    }
        //}
    }
}
