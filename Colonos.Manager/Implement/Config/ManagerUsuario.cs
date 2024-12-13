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
    public class ManagerUsuario
    {
        string urlbase = "";
        Logger logger;
        public ManagerUsuario(string _urlbase, Logger _logger)
        {
            logger = _logger;
            urlbase = _urlbase;
        }
        public List<User> ListUsuarios(string metodo, string idgrupo, string idgrupo2="")
        {
            AgenteUsuario agente = new AgenteUsuario(urlbase, logger);
            var json = agente.ListUsuarios(metodo, idgrupo,idgrupo2);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result!=null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<User>>(json);
                return list;
            }
            return new List<User>();
        }

        public List<Grupo> GrupoList(string metodo)
        {
            AgenteUsuario agente = new AgenteUsuario(urlbase, logger);
            var json = agente.GrupoList(metodo);
            //var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (json!="[]")
            {
                //json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<Grupo>>(json);
                return list;
            }
            return new List<Grupo>();
        }

        
        public List<GrupoAccesos> ConfigMenuList(string metodo)
        {
            AgenteUsuario agente = new AgenteUsuario(urlbase, logger);
            var json = agente.ConfigMenuList(metodo);
            //var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (json!="[]")
            {
                //json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<GrupoAccesos>>(json);
                return list;
            }
            return new List<GrupoAccesos>();
        }

        public List<GrupoAccesos> GrupoAccesosList(string metodo, string idgrupo)
        {
            AgenteUsuario agente = new AgenteUsuario(urlbase, logger);
            var json = agente.GrupoAccesosList(metodo, idgrupo);
            //var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (json!="[]")
            {
                //json = JsonConvert.SerializeObject(result.data);
                var list = JsonConvert.DeserializeObject<List<GrupoAccesos>>(json);
                return list;
            }
            return new List<GrupoAccesos>();
        }

        public void AddGrupoAcceso(string urlBase, string json)
        {
            AgenteUsuario agente = new AgenteUsuario(urlbase, logger);
            agente.AddGrupoAcceso(urlBase, json);
        }

        public LoginOut Login(string json, string urlBase, string jsonBrowser)
        {
            AgenteUsuario agente = new AgenteUsuario(urlbase, logger);
            json = agente.Login(json, urlBase, jsonBrowser);
            GetLoginOut login = JsonConvert.DeserializeObject<GetLoginOut>(json);
            if (login!=null && login.login!=null && login.login.Success)
            {
                return login.login;
            }
            return new LoginOut();
        }

        public User GetUsuario_Login(string IdUsuario, string urlBase)
        {
            AgenteUsuario agente = new AgenteUsuario(urlbase, logger);
            var json = agente.GetUsuario_Login(IdUsuario,  urlBase);
            GetUsuarios us = JsonConvert.DeserializeObject<GetUsuarios>(json);
            if (us!=null)
            {
                return us.usuario;
            }
            return new User();
        }
    }
}
