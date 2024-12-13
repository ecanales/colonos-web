using Colonos.Entidades;
using Colonos.Manager;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class mantenedor_grupos : System.Web.UI.Page
    {
        string urlbase = "";
        Logger logger;

        bool cargandoArbol = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargaGrilla();
            }

        }

        private void CargaGrilla()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);
            var list = mng.GrupoList("system/grupos");
            
            gvResultado.DataSource = list;
            gvResultado.DataBind();
        }

        protected void Guardar(object sender, EventArgs e)
        {
            char[] delimiterChars = { ',' };

            if (!cargandoArbol && txtIdGrupo.Text.Trim().Length > 0)
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerUsuario mng = new ManagerUsuario(urlbase, logger);

                string lIdGr;
                sysGrupoAccesos customAcceso = null;

                lIdGr = txtIdGrupo.Text;
                foreach (TreeNode n in tvwDirectorio.Nodes)
                {

                    string[] split = n.Target.ToString().Split(delimiterChars);


                    customAcceso = new sysGrupoAccesos();


                    int i = 1;
                    foreach (string sValor in split)
                    {
                        if (sValor.Trim() != "")
                        {
                            switch (i)
                            {
                                case 1:
                                    //customAcceso.FK_MenuMain = Convert.ToInt16(sValor);
                                    customAcceso.FK_MenuMain = Convert.ToInt16(sValor);
                                    break;
                                case 2:
                                    //customAcceso.FK_MenuSubA = Convert.ToInt16(sValor);
                                    customAcceso.FK_MenuSubA = Convert.ToInt16(sValor);
                                    break;
                            }
                        }
                        i += 1;
                    }
                    customAcceso.FK_Grupo = lIdGr;
                    customAcceso.Acceso = n.Checked;


                    if (customAcceso != null)
                    {
                        //Repo_sysGrupos repoGrupos =new Repo_sysGrupos();
                        //repoGrupos.AddAcceso(customAcceso);
                        string json = JsonConvert.SerializeObject(customAcceso, Formatting.Indented);
                        mng.AddGrupoAcceso(urlbase, json);
                    }

                    foreach (TreeNode c in n.ChildNodes)
                    {
                        string[] split2 = c.Target.ToString().Split(delimiterChars);
                        customAcceso = new sysGrupoAccesos();

                        i = 1;
                        foreach (string sValor in split2)
                        {
                            if (sValor.Trim() != "")
                            {
                                switch (i)
                                {
                                    case 1:
                                        //customAcceso.FK_MenuMain = Convert.ToInt16(sValor);
                                        customAcceso.FK_MenuMain = Convert.ToInt16(sValor);
                                        break;
                                    case 2:
                                        //customAcceso.FK_MenuSubA = Convert.ToInt16(sValor);
                                        customAcceso.FK_MenuSubA = Convert.ToInt16(sValor);
                                        break;
                                }
                            }
                            i += 1;
                        }
                        customAcceso.FK_Grupo = lIdGr;
                        customAcceso.Acceso = c.Checked;


                        if (customAcceso != null)
                        {
                            //Repo_sysGrupos repoGrupos = new Repo_sysGrupos();
                            //repoGrupos.AddAcceso(customAcceso);
                            string json = JsonConvert.SerializeObject(customAcceso, Formatting.Indented);
                            mng.AddGrupoAcceso(urlbase, json);
                        }
                    }
                }

            }
        }

        protected void ClosePopupEditar(object sender, EventArgs e)
        {

        }

        protected void Editar(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);


            txtIdGrupo.Text = string.Empty;
            txtIdGrupo.ReadOnly = true;
            txtDescripcion.Text = string.Empty;

            if (btn.ID != "cmdNuevo")
            {
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                string IdGrupo = (row.FindControl("lblIdGrupo") as Label).Text;
                string Descripcion = (row.FindControl("lblDescripcion") as LinkButton).Text;

                txtIdGrupo.Text = IdGrupo;
                txtIdGrupo.ReadOnly = true;
                txtDescripcion.Text = Descripcion;

                CargaManu(IdGrupo);
            }


            popupEditar.Show();
        }
        private void CargaManu(string idgrupo)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerUsuario mng = new ManagerUsuario(urlbase, logger);

            
            List<GrupoAccesos> _AccesosGrupoList = mng.GrupoAccesosList(urlbase, idgrupo);
            //List<GrupoAccesos> _itemAccesoGrupo = agente.ConfigMenuList(UrlBase);

            GrupoAccesos _itemAccesoGrupo;
            string nodeAnterior = "";

            cargandoArbol = true;
            tvwDirectorio.Nodes.Clear();
            List<GrupoAccesos> listRootMenu = mng.ConfigMenuList(urlbase);

            foreach (var m in listRootMenu)
            {
                TreeNode currNode = new TreeNode();


                if (nodeAnterior != m.keyMenu)
                {


                    TreeNode nodeTitle;
                    nodeTitle = new TreeNode();
                    nodeTitle.Text = m.CaptionMenu;
                    nodeTitle.ShowCheckBox = true;
                    nodeTitle.Checked = true;
                    nodeTitle.Target = String.Format("{0},{1},{2}", m.IdMenu, 0, 0);
                    nodeTitle.SelectAction = TreeNodeSelectAction.None;
                    _itemAccesoGrupo = _AccesosGrupoList.Find(x => x.IdMenu.Equals(m.IdMenu) && x.IdSubMenuA == null);
                    if (_itemAccesoGrupo != null)
                    {
                        if (_itemAccesoGrupo.Acceso != null && Convert.ToBoolean(_itemAccesoGrupo.Acceso))
                        {
                            nodeTitle.Checked = true;
                        }
                    }


                    tvwDirectorio.Nodes.Add(nodeTitle);

                    List<GrupoAccesos> listSubMenu = listRootMenu.FindAll(x => x.keyMenu == m.keyMenu);

                    if (listSubMenu.Count > 0)
                    {
                        foreach (var chid in listSubMenu)
                        {
                            TreeNode nodeChild1;
                            nodeChild1 = new TreeNode();
                            nodeChild1.Text = chid.CaptionSubMenuA;
                            nodeChild1.ShowCheckBox = true;
                            nodeChild1.Checked = false;
                            nodeChild1.Target = String.Format("{0},{1},{2}", chid.IdMenu, chid.IdSubMenuA, 0);
                            nodeChild1.SelectAction = TreeNodeSelectAction.None;
                            _itemAccesoGrupo = _AccesosGrupoList.Find(x => x.IdMenu.Equals(chid.IdMenu) && x.IdSubMenuA.Equals(chid.IdSubMenuA));
                            if (_itemAccesoGrupo != null)
                            {
                                if (_itemAccesoGrupo.Acceso != null && Convert.ToBoolean(_itemAccesoGrupo.Acceso))
                                {
                                    nodeChild1.Checked = true;
                                }
                            }
                            nodeTitle.ChildNodes.Add(nodeChild1);
                        }

                    }

                }
                nodeAnterior = m.keyMenu;


            }

            for (int i = 0; i <= tvwDirectorio.Nodes.Count - 1; i++)
            {
                tvwDirectorio.Nodes[i].ExpandAll();
            }
            cargandoArbol = false;


        }
    }
}