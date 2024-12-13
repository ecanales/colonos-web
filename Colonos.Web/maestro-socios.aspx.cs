using Colonos.Entidades;
using Colonos.Manager;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class maestro_socios : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargaPropiedades();
                InicializaFormulario();
            }
        }

        private void InicializaFormulario()
        {

            txtSocioNombre.Text = "";
            txtRut.Text = "";
            txtNombreFantasia.Text = "";
            txtGiro.Text = "";
            txtSocioCodigo.Text = "";
            txtSocioCodigo.ReadOnly = false;
            txtSocioCodigo.Enabled = true;
            txtclientFileDF.Text = "";
            txtCreditoAutorizado.Text = "0";
            txtCreditoUtilizado.Text = "0";
            txtCreditoMaximo.Text = "0";
            cboVendedor.SelectedValue = "";

            gvDicom.DataSource = new List<Adjunto>();
            gvDicom.DataBind();
            Session["Archivos"] = null;

            gvHistorialBandeja.DataSource = new List<Bandeja>();
            gvHistorialBandeja.DataBind();

            gvDirecciones.DataSource = new List<Direccion>();
            gvDirecciones.DataBind();
            Session["Direcciones"] = null;

            gvContactos.DataSource = new List<Contacto>();
            gvContactos.DataBind();
            Session["Contactos"] = null;
        }
        
        protected void ClosePopupAddFile(object sender, EventArgs e)
        {
            popupAddFile.Hide();
        }

        protected void AgregarDicom(object sender, EventArgs e)
        {
            popupAddFile.Show();
        }

        protected void EliminarArchivo_Event(object sender, EventArgs e)
        {
            try
            {
                var listarch = (List<Adjunto>)Session["Archivos"];
                if (listarch != null)
                {
                    LinkButton btn = (LinkButton)sender;
                    GridViewRow row = (GridViewRow)btn.NamingContainer;

                    string id = (row.FindControl("lblIdArchivo") as Label).Text;
                    var file = listarch.Find(x => x.Id == Convert.ToInt32(id));
                    if (file != null)
                    {
                        listarch.Remove(file);
                    }
                }
                gvDicom.DataSource = listarch;
                gvDicom.DataBind();
                Session["Archivos"] = listarch;
            }
            catch(Exception ex)
            {
                logger.Error("Error eliminando archivo del el socio: {0}", ex.Message);
            }
                
        }
        protected void GuardarArchivo(object sender, EventArgs e)
        {
            if(fileUploadPopup.HasFile && fileUploadPopup.FileBytes.Length <=(10 * 1024 *1024))
            {
                var basepath = Server.MapPath("~/Adjuntos");
                var baseLink = "~/Adjuntos";
                var pathcliente = txtSocioCodigo.Text;
                var pathArchivo = String.Format("{0}/{1}", basepath, pathcliente);
                baseLink = String.Format("{0}/{1}", baseLink, pathcliente);

                if (!Directory.Exists(pathArchivo))
                {
                    Directory.CreateDirectory(pathArchivo);
                }
                var nombreArchivo = fileUploadPopup.FileName;
                pathArchivo = String.Format("{0}/{1}", pathArchivo, nombreArchivo);
                baseLink = String.Format("{0}/{1}", baseLink, nombreArchivo);

                byte[] bytes= fileUploadPopup.FileBytes;
                using (var stm = new FileStream(pathArchivo, FileMode.Create))
                {
                    stm.Write(bytes, 0, bytes.Length);
                    Adjunto adj = new Adjunto
                    {
                        NombreArchivo=nombreArchivo,
                        SocioCode=txtSocioCodigo.Text,
                        Ruta=baseLink,
                    };

                    var listarch= (List<Adjunto>)Session["Archivos"];
                    if (listarch == null)
                        listarch = new List<Adjunto>();

                    listarch.Add(adj);

                    gvDicom.DataSource = listarch;
                    gvDicom.DataBind();
                    Session["Archivos"] = listarch;
                    popupAddFile.Hide();
                }
            }
        }

        protected void ClosePopup(object sender, EventArgs e)
        {
            popupBusquedaClientes.Hide();
        }

        protected void ClosePopupDireccion(object sender, EventArgs e)
        {
            popupDireccionCliente.Hide();
        }

        protected void AgregarDireccion(object sender, EventArgs e)
        {
            if (txtSocioCodigo.Text != "")
            {
                txtDireccionCode.Text = "";
                txtDireccionCode.Enabled = false;
                //cboDirecciontipo.Text = "";
                cboDirecciontipo.Enabled = true;
                txtSocioCodigoDir.Text = txtSocioCodigo.Text;
                txtCalle.Text = "";
                txtNumero.Text = "";
                //cboComuna.Text = "";
                //cboCiudad.Text = "";
                //cboRegion.Text = "";
                txtEmailDriveIn.Text = "";
                txtVentana_Inicio.Text = "";
                txtVentana_Termino.Text = "";
                txtLongitud.Text = "";
                txtLatitud.Text = "";
                txtObservaciones.Text = "";
                //cboSubZona.Text = "";
                popupDireccionCliente.Show();
            }
        }

        protected void EliminarDireccion(object sender, EventArgs e)
        {
            var listdir = (List<Direccion>)Session["Direcciones"];
            if (listdir == null)
                listdir = new List<Direccion>();

            var dir = new Direccion();
            dir = listdir.Find(x => x.DireccionCode == Convert.ToInt32(txtDireccionCode.Text));
            listdir.Remove(dir);
            gvDirecciones.DataSource = listdir;
            gvDirecciones.DataBind();
            Session["Direcciones"] = listdir;
            popupDireccionCliente.Hide();
        }

        protected void EditarDireccion(string sociocodigo, int direccioncode)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDirecciones mng = new ManagerDirecciones(urlbase, logger);
            var url = String.Format("socios/{0}/direcciones", sociocodigo);
            try
            {
                if (Session["Direcciones"] != null)
                {

                    var listDir = (List<Direccion>)Session["Direcciones"];
                    if (listDir.Any())
                    {
                        var item = listDir.Find(x => x.DireccionCode == direccioncode); //  mng.Get(url, direccioncode);
                        if (item != null)
                        {
                            txtDireccionCode.Text = item.DireccionCode.ToString();
                            txtDireccionCode.Enabled = false;
                            cboDirecciontipo.SelectedValue = item.DireccionTipo;
                            cboDirecciontipo.Enabled = false;
                            txtSocioCodigoDir.Text = item.SocioCode;
                            txtCalle.Text = item.Calle;
                            txtNumero.Text = item.Numero;

                            if (item.Ventana_Inicio == "")
                                item.Ventana_Inicio = "00:00";
                            if (item.Ventana_Termino == "")
                                item.Ventana_Termino = "00:00";
                            txtEmailDriveIn.Text = item.EmailDriveIn;
                            txtVentana_Inicio.Text = String.Format("{0:HH:mm}", Convert.ToDateTime(item.Ventana_Inicio));
                            txtVentana_Termino.Text = String.Format("{0:HH:mm}", Convert.ToDateTime(item.Ventana_Termino));
                            txtLongitud.Text = item.Longitud.ToString();
                            txtLatitud.Text = item.Latitud.ToString();
                            try
                            {
                                try { cboSubZona.SelectedValue = item.SubZona; } catch { }
                                try { cboComuna.SelectedValue = item.ComunaNombre.ToString(); }catch { }
                                try { cboCiudad.SelectedValue = item.CiudadNombre.ToString(); } catch { }
                                try { cboRegion.SelectedValue = item.RegionCode.ToString(); } catch { }
                            }
                            catch(Exception ex)
                            {
                                logger.Error("EditarDireccion: {0}, cliente: {1}, error: {2}", direccioncode, sociocodigo , ex.Message);
                            }
                            txtObservaciones.Text = item.Observaciones;

                            popupDireccionCliente.Show();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("EditarDireccion: {0}, cliente: {1}, error: {2}", direccioncode, sociocodigo, ex.Message);
            }
            
        }

        protected void AceptarDireccion(object sender, EventArgs e)
        {
            var listdir = (List<Direccion>)Session["Direcciones"];
            if (listdir == null)
                listdir = new List<Direccion>();

            if (txtLatitud.Text == "")
                txtLatitud.Text = "0";
            if (txtLongitud.Text == "")
                txtLongitud.Text = "0";

            Direccion dir;
            if (txtDireccionCode.Text.Length == 0)
            {
                dir = new Direccion();
                //DireccionCode = txtDireccionCode.Text,
                dir.DireccionTipo = cboDirecciontipo.SelectedValue;
                dir.Calle = txtCalle.Text;
                dir.Numero = txtNumero.Text;
                dir.CiudadNombre = cboCiudad.SelectedValue;
                dir.ComunaNombre = cboComuna.SelectedValue;
                dir.EmailDriveIn = txtEmailDriveIn.Text;
                dir.Observaciones = txtObservaciones.Text;
                dir.RegionCode = Convert.ToInt32(cboRegion.SelectedValue);
                dir.SocioCode = txtSocioCodigoDir.Text;
                dir.Ventana_Inicio = txtVentana_Inicio.Text;
                dir.Ventana_Termino = txtVentana_Termino.Text;
                dir.SubZona = cboSubZona.SelectedValue;
                dir.Latitud = Convert.ToDecimal(txtLatitud.Text);
                dir.Longitud = Convert.ToDecimal(txtLongitud.Text);
                dir.PorDefecto = false;
                listdir.Add(dir);
            }
            else
            {
                

                dir = listdir.Find(x => x.DireccionCode == Convert.ToInt32(txtDireccionCode.Text));
                dir.Calle = txtCalle.Text;
                dir.Numero = txtNumero.Text;
                dir.CiudadNombre = cboCiudad.SelectedValue;
                dir.ComunaNombre = cboComuna.SelectedValue;
                dir.EmailDriveIn = txtEmailDriveIn.Text;
                dir.Observaciones = txtObservaciones.Text;
                dir.RegionCode = Convert.ToInt32(cboRegion.SelectedValue);
                dir.SocioCode = txtSocioCodigoDir.Text;
                dir.Ventana_Inicio = txtVentana_Inicio.Text;
                dir.Ventana_Termino = txtVentana_Termino.Text;
                dir.SubZona = cboSubZona.SelectedValue;
                try
                {
                    dir.Latitud = Convert.ToDecimal(txtLatitud.Text);
                }
                catch
                {
                    dir.Latitud = 0;
                }
                try
                {
                    dir.Longitud = Convert.ToDecimal(txtLongitud.Text);
                }
                catch
                {
                    dir.Longitud = 0;
                }
            }

            gvDirecciones.DataSource = listdir;
            gvDirecciones.DataBind();
            Session["Direcciones"] = listdir;
            popupDireccionCliente.Hide();
        }

        protected void EditarDireccion_Event(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string direccionCode = (row.FindControl("lblDireccionCode") as Label).Text;
                string socioCode = (row.FindControl("lblSocioCode") as Label).Text;

                EditarDireccion(socioCode, Convert.ToInt32(direccionCode));
                

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "VerBandeja_Event", ex.Message);
            }
            
        }

        protected void Guardar_Event(object sender, EventArgs e)
        {
            try
            {
                var cred = Convert.ToDecimal(txtCreditoAutorizado.Text.Replace("$", "").Replace(".", ""));
            }
            catch
            {
                txtCreditoAutorizado.Focus();
                return;
            }
            try
            {
                var cred = Convert.ToDecimal(txtCreditoMaximo.Text.Replace("$", "").Replace(".", ""));
            }
            catch
            {
                txtCreditoMaximo.Focus();
                return;
            }

            try
            {
                //var cond=Convert.ToInt32(cboCondicion.SelectedValue);
                var cond = cboCondicion.SelectedValue;
            }
            catch
            {
                cboCondicion.Focus();
                return;
            }
            if(txtRut.Text.Trim().Length==0 || txtSocioNombre.Text.Trim().Length==0)
            {
                txtRut.Focus();
                return;
            }
            if(txtclientFileDF.Text.Trim().Length==0)
            {
                txtclientFileDF.Focus();
                return;
            }
            if(cboVendedor.Text.ToString()=="")
            {
                cboVendedor.Focus();
                return;
            }

            if(txtclientFileDF.Text.Trim().Length==0)
            {
                txtclientFileDF.Focus();
                return;
            }

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerSocios mng = new ManagerSocios(urlbase, logger);
            var item = mng.SocioGet("socios", txtSocioCodigo.Text);
            bool registronuevo = true;
            if (item == null || item.SocioCode != null) //cliente existente
            {
                item = new Socio();
                item.SocioCode = txtSocioCodigo.Text;
                item.clientFileDF= txtclientFileDF.Text;
                registronuevo = false;
            }
            item.Rut = txtRut.Text;
            item.RazonSocial = txtSocioNombre.Text;
            item.MatrizSocio = cboMatrizSocio.SelectedValue;
            //item.CondicionCode = Convert.ToInt32(cboCondicion.SelectedValue);
            item.CondicionDF = cboCondicion.SelectedValue;
            item.CondicionName = cboCondicion.SelectedItem.Text;
            item.CreditoAutorizado = Convert.ToDecimal(txtCreditoAutorizado.Text.Replace("$","").Replace(".",""));
            item.CreditoMaximo = Convert.ToDecimal(txtCreditoMaximo.Text.Replace("$", "").Replace(".", ""));
            //item.CreditoUtiliado = txtCreditoUtilizado.Text;
            item.EstadoOperativo = cboEstadoOperativo.SelectedValue;
            item.Giro = txtGiro.Text;
            if (cboRubro.SelectedValue != "")
            {
                item.RubroCode = Convert.ToInt32(cboRubro.SelectedValue);
                item.RubroName = cboRubro.SelectedItem.Text;
            }
            
            item.NombreFantasia = txtNombreFantasia.Text;
            item.SocioTipo = cboTipo.SelectedValue;
            item.VendedorCode = cboVendedor.SelectedValue;
            item.Direcciones = new List<Direccion>();
            item.Contactos = new List<Contacto>();
            item.Archivos = new List<Adjunto>();
            item.Direcciones= (List<Direccion>)Session["Direcciones"];
            item.Contactos = (List<Contacto>)Session["Contactos"];
            item.Archivos = (List<Adjunto>)Session["Archivos"];
            //La propiedad Activo se maneja con el Estado Operativo del cliente, no aplica propiedad Activo, se deja oculta
            //item.Activo = chkActivo.Checked ? "S" : "N";
            try
            {
                var soc= mng.Guardar("socios", item, registronuevo);
                var mensaje = "Socio Guardado";
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                ConsultaCliente(soc.SocioCode);
            }
            catch(Exception ex)
            {
                logger.Error("{0} Error: {1}", "Guardar Socio", ex.Message);
                logger.Error("{0} StackTrace: {1}", "Guardar Socio", ex.StackTrace);
                var mensaje = ex.Message;
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
            }

        }

        protected void Nuevo_Event(object sender, EventArgs e)
        {
            //limpiar formulario

            txtSocioCodigo.Text = "";
            txtSocioCodigo.ReadOnly = false;
            txtSocioNombre.Text = "";
            txtGiro.Text = "";
        }

        protected void SelectCliente(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string cardCode = (row.FindControl("lblCardCode") as LinkButton).Text;
                txtSocioCodigo.Text = cardCode;
                ConsultaCliente(cardCode);
                popupBusquedaClientes.Hide();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "Select Cliente", ex.Message);

                var mensaje = ex.Message;
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                InicializaFormulario();
            }
        }

        private void ConsultaCliente(string socioCode)
        {
            InicializaFormulario();
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerSocios mng = new ManagerSocios(urlbase, logger);
            Socio item = mng.SocioGet("socios", socioCode);
            gvHistorialBandeja.DataSource = new List<Bandeja>();
            gvHistorialBandeja.DataBind();

            if (item != null && item.SocioCode != null)
            {
                txtSocioNombre.Text = item.RazonSocial;
                txtRut.Text = item.Rut;
                txtNombreFantasia.Text = item.NombreFantasia;
                txtGiro.Text=item.Giro;
                txtSocioCodigo.Text = item.SocioCode;
                txtSocioCodigo.ReadOnly=true;
                txtSocioCodigo.Enabled = false;
                txtclientFileDF.Text = item.clientFileDF;
                txtCreditoAutorizado.Text = String.Format("{0:N0}", item.CreditoAutorizado);
                txtCreditoUtilizado.Text = String.Format("{0:N0}", item.CreditoUtiliado);
                if (item.CreditoMaximo == null)
                    item.CreditoMaximo = item.CreditoAutorizado;
                txtCreditoMaximo.Text = String.Format("{0:N0}", item.CreditoMaximo);
                //cboCondicion.SelectedValue = item.CondicionCode.ToString();
                cboCondicion.SelectedValue = item.CondicionDF; // .ToString();
                cboEstadoOperativo.SelectedValue = item.EstadoOperativo.ToString();
                //chkActivo.Checked=item.
                try
                {
                    if (item.VendedorCode != null && item.VendedorCode.Length > 0)
                    {
                        cboVendedor.SelectedValue = item.VendedorCode.ToString();
                    }
                }
                catch(Exception ex)
                {
                    logger.Error("Error, cboVendedor.SelectedValue: {0} ", item.VendedorCode);
                    logger.Error("Error, {0} ", ex.Message);
                }
                cboTipo.SelectedValue = item.SocioTipo.ToString();
                cboTipo.Enabled = false;
                cboRubro.SelectedValue=item.RubroCode.ToString();
                cboMatrizSocio.SelectedValue = item.MatrizSocio;
                
                if (item.Contactos.Any())
                {
                    gvContactos.DataSource = item.Contactos;
                    gvContactos.DataBind();
                    Session["Contactos"] = item.Contactos;
                }
                else
                {
                    gvContactos.DataSource = new List<Contacto>();
                    gvContactos.DataBind();
                    Session["Contactos"] = null;
                }
                if (item.Direcciones.Any())
                {
                    gvDirecciones.DataSource = item.Direcciones; 
                    gvDirecciones.DataBind();
                    Session["Direcciones"] = item.Direcciones;
                }
                else
                {
                    gvDirecciones.DataSource = new List<Direccion>();
                    gvDirecciones.DataBind();
                    Session["Direcciones"] = null;
                }
                if (item.Archivos.Any())
                {
                    gvDicom.DataSource = item.Archivos;
                    gvDicom.DataBind();
                    Session["Archivos"] = item.Archivos;
                }
                else
                {
                    gvDicom.DataSource = new List<Adjunto>();
                    gvDicom.DataBind();
                    Session["Archivos"] = null;
                }

                
                ManagerBandejaCredito mngband = new ManagerBandejaCredito(urlbase, logger);
                var listbandeja=mngband.Listar("bandejas", "CRED",item.SocioCode);
                gvHistorialBandeja.DataSource = listbandeja;
                gvHistorialBandeja.DataBind();

                //
                if (item.Historial.Any())
                {
                    gvHistorialModifcaciones.DataSource = item.Historial;
                    gvHistorialModifcaciones.DataBind();
                }
                else
                {
                    gvHistorialModifcaciones.DataSource = new List<HistorialModificaciones>();
                    gvHistorialModifcaciones.DataBind();
                }
            }
        }
        private void CargaPropiedades()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerSocios mng = new ManagerSocios(urlbase, logger);
            var prop = mng.Propiedades("socios/propiedades");
            if (prop != null)
            {
                var json = JsonConvert.SerializeObject(prop.condicion);
                var scp3 = JsonConvert.DeserializeObject<List<SCP12>>(json);
                cboCondicion.DataSource = scp3;
                cboCondicion.DataTextField = "name";
                cboCondicion.DataValueField = "code";
                cboCondicion.DataBind();

                json = JsonConvert.SerializeObject(prop.rubro);
                var scp5 = JsonConvert.DeserializeObject<List<SCP5>>(json);
                cboRubro.DataSource = scp5;
                cboRubro.DataTextField = "RubroNombre";
                cboRubro.DataValueField = "RubroCode";
                cboRubro.DataBind();

                json = JsonConvert.SerializeObject(prop.estadosoperativo);
                var scp7 = JsonConvert.DeserializeObject<List<SCP7>>(json);
                cboEstadoOperativo.DataSource = scp7;
                cboEstadoOperativo.DataTextField = "Descripcion";
                cboEstadoOperativo.DataValueField = "EstadoOperativo";
                cboEstadoOperativo.DataBind();

                json = JsonConvert.SerializeObject(prop.matriz);
                var scp9 = JsonConvert.DeserializeObject<List<SCP9>>(json);
                cboMatrizSocio.DataSource = scp9;
                cboMatrizSocio.DataTextField = "MatrizNombre";
                cboMatrizSocio.DataValueField = "MatrizCode";
                cboMatrizSocio.DataBind();

                json = JsonConvert.SerializeObject(prop.tiposocio);
                var scp6 = JsonConvert.DeserializeObject<List<SCP6>>(json);
                cboTipo.DataSource = scp6;
                cboTipo.DataTextField = "SocioTipoNombre";
                cboTipo.DataValueField = "SocioTipo";
                cboTipo.DataBind();

                json = JsonConvert.SerializeObject(prop.vendedores);
                var oven = JsonConvert.DeserializeObject<List<OVEN>>(json);
                cboVendedor.DataSource = oven;
                cboVendedor.DataTextField = "Nombre";
                cboVendedor.DataValueField = "VendedorCode";
                cboVendedor.DataBind();

                json = JsonConvert.SerializeObject(prop.comunas);
                var com = JsonConvert.DeserializeObject<List<OCOM>>(json);
                cboComuna.DataSource = com;
                cboComuna.DataTextField = "ComunaNombre";
                cboComuna.DataValueField = "ComunaNombre";
                cboComuna.DataBind();

                json = JsonConvert.SerializeObject(prop.ciudades);
                var ciu = JsonConvert.DeserializeObject<List<OCIU>>(json);
                cboCiudad.DataSource = ciu;
                cboCiudad.DataTextField = "CiudadNombre";
                cboCiudad.DataValueField = "CiudadNombre";
                cboCiudad.DataBind();

                json = JsonConvert.SerializeObject(prop.regiones);
                var reg = JsonConvert.DeserializeObject<List<OREG>>(json);
                cboRegion.DataSource = reg;
                cboRegion.DataTextField = "RegionNombre";
                cboRegion.DataValueField = "RegionCode";
                cboRegion.DataBind();

                json = JsonConvert.SerializeObject(prop.tipocontacto);
                var tcont = JsonConvert.DeserializeObject<List<SCP8>>(json);
                cboTipoContacto.DataSource = tcont;
                cboTipoContacto.DataTextField = "ContactoTipoNombre";
                cboTipoContacto.DataValueField = "ContactoTipo";
                cboTipoContacto.DataBind();

                json = JsonConvert.SerializeObject(prop.subzona);
                var subzona = JsonConvert.DeserializeObject<List<ZON1>>(json);
                subzona.Add(new ZON1 { Zona="",SubZona=""});
                cboSubZona.DataSource = subzona;
                cboSubZona.DataTextField = "SubZona";
                cboSubZona.DataValueField = "SubZona";
                cboSubZona.DataBind();

            }
        }

        protected void AgregarContacto(object sender, EventArgs e)
        {
            if (txtSocioCodigo.Text != "")
            {
                txtContactoCode.Text = "";
                txtSocioCodeCont.Text = txtSocioCodigo.Text;
                cboTipoContacto.Enabled = true;
                txtNombreCont.Text = "";
                txtEmailCont.Text = "";
                txtCelular.Text = "";
                txtTelefono.Text = "";
                popupContactoCliente.Show();
            }
        }
        protected void ClosePopupContacto(object sender, EventArgs e)
        {
            popupContactoCliente.Hide();
        }
        protected void AceptarContacto(object sender, EventArgs e)
        {
            var listcon = (List<Contacto>)Session["Contactos"];
            if (listcon == null)
                listcon = new List<Contacto>();

            Contacto cont;
            if(txtContactoCode.Text.Length==0)
            {
                cont = new Contacto();
                cont.ContactoTipo = cboTipoContacto.SelectedValue;
                cont.SocioCode = txtSocioCodeCont.Text;
                cont.Nombre = txtNombreCont.Text;
                cont.Email = txtEmailCont.Text;
                cont.Celular = txtCelular.Text;
                cont.Telefono = txtTelefono.Text;
                listcon.Add(cont);
            }
            else
            {
                cont = listcon.Find(x => x.ContactoCode == Convert.ToInt32(txtContactoCode.Text));
                cont.ContactoTipo = cboTipoContacto.SelectedValue;
                cont.SocioCode = txtSocioCodeCont.Text;
                cont.Nombre = txtNombreCont.Text;
                cont.Email = txtEmailCont.Text;
                cont.Celular = txtCelular.Text;
                cont.Telefono = txtTelefono.Text;
            }
            gvContactos.DataSource = listcon;
            gvContactos.DataBind();
            Session["Contactos"] = listcon;
            
            popupContactoCliente.Hide();
        }

        protected void EditarContacto_Event(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string contactoCode = (row.FindControl("lblContactoCode") as Label).Text;
                string socioCode = (row.FindControl("lblSocioCode") as Label).Text;

                EditarContacto(socioCode, Convert.ToInt32(contactoCode));


            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "EditarContacto_Event", ex.Message);
                var mensaje = ex.Message;
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("alert('");
                sb.Append(mensaje);
                sb.Append("');");
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
            }
        }

        private void EditarContacto(string sociocode, int contactocode)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerContactos mng = new ManagerContactos(urlbase, logger);
            var url = String.Format("socios/{0}/contactos", sociocode);
            if (Session["Contactos"] != null)
            {
                var listCont = (List<Contacto>)Session["Contactos"];
                if (listCont.Any())
                {
                    var item = listCont.Find(x => x.ContactoCode == contactocode); // mng.Get(url, contactocode);
                    if (item != null)
                    {
                        txtContactoCode.Text = item.ContactoCode.ToString();
                        txtSocioCodeCont.Text = item.SocioCode;
                        cboTipoContacto.Enabled = true;
                        cboTipoContacto.SelectedValue = item.ContactoTipo;
                        txtNombreCont.Text = item.Nombre;
                        txtEmailCont.Text = item.Email;
                        txtCelular.Text = item.Celular;
                        txtTelefono.Text = item.Telefono;
                        popupContactoCliente.Show();
                    }
                }
            }
        }
        protected void Buscar_Event(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["usuario"] == null)
            {
                HttpContext.Current.Response.Redirect("/login.aspx", false);
            }
            if (HttpContext.Current.Session["us"] != null)
            {
                User us = (User)HttpContext.Current.Session["us"];
                if (us != null)
                {
                    txtPalabras.Text = txtBuscar.Text;
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerSocios mng = new ManagerSocios(urlbase, logger);
                    var list = mng.SocioSearch("socios/search", txtBuscar.Text, us.Usuario);
                    gvClientes.DataSource = list;
                    gvClientes.DataBind();
                    popupBusquedaClientes.Show();
                }
            }
        }

        protected void BuscarPopop_Event(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["usuario"] == null)
            {
                HttpContext.Current.Response.Redirect("/login.aspx", false);
            }
            if (HttpContext.Current.Session["us"] != null)
            {
                User us = (User)HttpContext.Current.Session["us"];
                if (us != null)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerSocios mng = new ManagerSocios(urlbase, logger);
                    var list = mng.SocioSearch("socios/search", txtPalabras.Text, "");
                    gvClientes.DataSource = list;
                    gvClientes.DataBind();
                    popupBusquedaClientes.Show();
                }
            }
        }
    }
}