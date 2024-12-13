//using Colonos.EndPointDataAccess;
//using Colonos.EndPointDataAccess.Repositorios;
using Colonos.Entidades.Defontana;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Manager
{
    public class ManagerOSCP
    {
        //public void CargaClientesDF()
        //{
        //    Repo_JsonClientes repoDF = new Repo_JsonClientes();
        //    Repo_OSCP repo = new Repo_OSCP();
        //    var listDF = repoDF.List();
        //    int i = 1;
        //    int ii = listDF.Count();
        //    int j = 1;

        //    Debug.Print("CLIENTES");
        //    foreach (var it in listDF)
        //    {
        //        var listProdDF = JsonConvert.DeserializeObject<ClienteListDF>(it.json);
        //        int jj = listProdDF.clientList.Count();
        //        foreach (var p in listProdDF.clientList)
        //        {
        //            OSCP item = new OSCP {  SocioCode = String.Format("{0}C",p.legalCode.Replace(".","").Replace("\t", "")),
        //                RazonSocial=p.name,
        //                CondicionName=p.paymentID,
        //                CreditoAutorizado=0,
        //                CreditoUtiliado=0,
        //                RubroName=p.rubroId,
        //                SocioTipo="C",
        //                VendedorCode=p.sellerID,
        //                Giro=p.business,
        //                Rut=p.legalCode.Replace(".","").Replace("\t", ""),
        //                NombreFantasia=p.fantasyname
        //            };
        //            repo.Add(item);
        //            Debug.Print("item: {0} de {1}, registro:{2} de {3}", i, ii, j, jj);
        //            j += 1;
        //        }
        //        i += 1;
        //        j = 1;
        //    }

        //    Debug.Print("FIN");
        //}

        //public void CargaClientesDireccionesDF()
        //{
        //    Repo_JsonClientes repoDF = new Repo_JsonClientes();
        //    Repo_SCP1 repo = new Repo_SCP1();
        //    var listDF = repoDF.List();
        //    int i = 1;
        //    int ii = listDF.Count();
        //    int j = 1;

        //    Debug.Print("DIRECCIONES CLIENTE");
        //    foreach (var it in listDF)
        //    {
        //        var listProdDF = JsonConvert.DeserializeObject<ClienteListDF>(it.json);
        //        int jj = listProdDF.clientList.Count();
        //        foreach (var p in listProdDF.clientList)
        //        {
        //            SCP1 item = new SCP1
        //            {
        //                SocioCode = String.Format("{0}C", p.legalCode.Replace(".", "").Replace("\t","")),
        //                DireccionTipo="F",
        //                Calle=p.address.ToUpper(),
        //                ComunaNombre=p.district.ToUpper(),
        //                CiudadNombre = p.city.ToUpper(),
        //                RegionNombre = p.state.ToUpper(),
        //                PorDefecto=false,
        //                Observaciones="",
        //                HorarioAtencion=""
        //            };
        //            repo.Add(item);
        //            Debug.Print("item: {0} de {1}, registro:{2} de {3}", i, ii, j, jj);
        //            j += 1;
        //        }
        //        i += 1;
        //        j = 1;
        //    }

        //    Debug.Print("FIN");
        //}


        //public void CargarProveedoresDF()
        //{
        //    Repo_JsonProveedores repoDF = new Repo_JsonProveedores();
        //    Repo_OSCP repo = new Repo_OSCP();
        //    var listDF = repoDF.List();
        //    int i = 1;
        //    int ii = listDF.Count();
        //    int j = 1;

        //    Debug.Print("PROVEEDORES");
        //    foreach (var it in listDF)
        //    {
        //        var listProdDF = JsonConvert.DeserializeObject<ClienteListDF>(it.json);
        //        int jj = listProdDF.providersList.Count();
        //        foreach (var p in listProdDF.providersList)
        //        {
        //            OSCP item = new OSCP
        //            {
        //                SocioCode = String.Format("{0}P", p.legalCode.Replace(".", "").Replace("\t", "")),
        //                RazonSocial = p.name,
        //                CondicionName = p.paymentID,
        //                CreditoAutorizado = 0,
        //                CreditoUtiliado = 0,
        //                RubroName = p.rubroId,
        //                SocioTipo = "P",
        //                VendedorCode = p.sellerID,
        //                Giro = p.business,
        //                Rut = p.legalCode.Replace(".", "").Replace("\t", ""),
        //                NombreFantasia = p.fantasyname
        //            };
        //            repo.Add(item);
        //            Debug.Print("item: {0} de {1}, registro:{2} de {3}", i, ii, j, jj);
        //            j += 1;
        //        }
        //        i += 1;
        //        j = 1;
        //    }

        //    Debug.Print("FIN");
        //}

        //public void CargarProveedoresDireccionesDF()
        //{
        //    Repo_JsonProveedores repoDF = new Repo_JsonProveedores();
        //    Repo_SCP1 repo = new Repo_SCP1();
        //    var listDF = repoDF.List();
        //    int i = 1;
        //    int ii = listDF.Count();
        //    int j = 1;

        //    Debug.Print("DIRECCIONES PROVEEDOR");
        //    foreach (var it in listDF)
        //    {
        //        var listProdDF = JsonConvert.DeserializeObject<ClienteListDF>(it.json);
        //        int jj = listProdDF.providersList.Count();
        //        foreach (var p in listProdDF.providersList)
        //        {
        //            if(p.address==null)
        //            {
        //                p.address = "";
        //            }
        //            SCP1 item = new SCP1
        //            {
        //                SocioCode = String.Format("{0}P", p.legalCode.Replace(".", "").Replace("\t", "")),
        //                DireccionTipo = "F",
        //                Calle = p.address.ToUpper(),
        //                ComunaNombre = p.district.ToUpper(),
        //                CiudadNombre=p.city.ToUpper(),
        //                RegionNombre = p.state.ToUpper(),
        //                PorDefecto = false,
        //                Observaciones = "",
        //                HorarioAtencion = ""
        //            };
        //            repo.Add(item);
        //            Debug.Print("item: {0} de {1}, registro:{2} de {3}", i, ii, j, jj);
        //            j += 1;
        //        }
        //        i += 1;
        //        j = 1;
        //    }

        //    Debug.Print("FIN");
        //}
    }
}
