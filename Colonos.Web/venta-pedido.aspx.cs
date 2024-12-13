using Colonos.AgenteEndPoint;
using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Models;
using Microsoft.Reporting.WebForms;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class venta_pedido : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        ShoppingCart carro;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string nuevo = Request.QueryString["nuevo"];
                string docentry = Request.QueryString["docentry"];
                if (nuevo==null)
                {
                    nuevo = "NO";
                }
                if (docentry == null)
                {
                    docentry = "0";
                }

                if (nuevo=="SI")
                {
                    Nuevo();
                }
                else if(docentry!="0")
                {
                    try
                    {
                        int docentryvalor = Convert.ToInt32(docentry);
                        ConsultaPedido(docentryvalor);
                    }
                    catch
                    {

                    }
                }


                //carro = new ShoppingCart();// ShoppingCart.Instance;
                gvDetalle.DataSource = carro.Items;
                gvDetalle.DataBind();

                mviewMain.SetActiveView(ClienteView);

            }
        }

        protected void LoadBuscarCliente(object sender, EventArgs e)
        {
            popupBusquedaClientes.Show();
        }

        private void ConsultaCliente(string socioCode)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerSocios mng = new ManagerSocios(urlbase, logger);
            var item = mng.SocioGet("socios", socioCode);
            if(item!=null && item.SocioCode!=null)
            {
                SocioPropiedades prop= mng.Propiedades("socios/propiedades");
                //List<CondiciondePago> listcond = new List<CondiciondePago>();
                List<SCP12> listcond = new List<SCP12>();// JsonConvert.DeserializeObject<List<SCP12>>(JsonConvert.SerializeObject(prop.condicion));
                                                         ////agregar a todos condicion contado
                List<SCP12>  list12 = JsonConvert.DeserializeObject<List<SCP12>>(JsonConvert.SerializeObject(prop.condicion));
                listcond.Add(list12.Find(x => x.name == "CONTADO"));
                //listcond.Add(new CondiciondePago { CondicionCode = 2, CondicionNombre = "CONTADO", Dias = 0, Orden = 1 });

                foreach (var p in list12)
                {
                    if (p.code == item.CondicionDF && item.CondicionDF != "CONTADO")
                    {
                        listcond.Add(p);
                        break;
                    }
                }
                txtFechaEntrega.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now);
                txtFechaEntrega.Enabled = false;
                txtSocioName.Text = item.RazonSocial;
                txtRut.Text = item.Rut;
                lblClienteBar.Text = item.RazonSocial;
                txtReferencia.Text = "";

                if (item.VendedorCode.Length > 0)
                {
                    cboVendedor.DataSource = prop.vendedores;
                    cboVendedor.DataValueField = "VendedorCode";
                    cboVendedor.DataTextField = "Nombre";
                    cboVendedor.DataBind();
                    cboVendedor.SelectedValue = item.VendedorCode;
                    cboVendedor.BackColor = System.Drawing.Color.White;
                    lblVendedorBar.Text = cboVendedor.SelectedItem.Text;
                }
                else
                {
                    cboVendedor.BackColor = System.Drawing.Color.Khaki;
                }
                //txtVendedor.Text = item.VendedorCode;
                txtEstadoCliente.Text = item.EstadoOperativo;
                txtEstadoCliente.Font.Bold = true;
                txtEstadoCliente.ForeColor = System.Drawing.Color.Green;
                txtEstadoCliente.BackColor = System.Drawing.Color.White;
                switch (txtEstadoCliente.Text)
                {
                    case "MOROSIDAD":
                    case "BLOQUEO":
                    case "BETADO":
                    case "INACTIVO":
                        txtEstadoCliente.BackColor = System.Drawing.Color.Red;
                        txtEstadoCliente.ForeColor = System.Drawing.Color.White;
                        txtEstadoCliente.Font.Bold = true;
                        break;

                }
                
                txtRubro.Text = item.RubroName;
                //txtCondicion.Text = item.CondicionName;
                cboCondicion.DataSource = listcond;
                cboCondicion.DataTextField = "name";
                cboCondicion.DataValueField = "code";
                cboCondicion.DataBind();
                cboCondicion.SelectedValue = item.CondicionDF;

                if (item.Contactos.Any())
                {
                    cboContactos.DataSource = item.Contactos;
                    cboContactos.DataTextField = "Nombre";
                    cboContactos.DataValueField = "ContactoCode";
                    cboContactos.DataBind();
                }
                if (item.Direcciones.Any())
                {
                    gvDirecciones.DataSource = item.Direcciones.FindAll(x => x.DireccionTipo == "D"); //solo direccion de despacho
                    gvDirecciones.DataBind();
                }

                var list = mng.TopCliente("socios",item.SocioCode);
                gvTopCliente.DataSource = list;
                gvTopCliente.DataBind();

                list = mng.TopRubro("socios", item.SocioCode);
                gvTopRubro.DataSource = list;
                gvTopRubro.DataBind();

                var listventas = mng.TopVentas("socios", item.SocioCode);
                gvVentas.DataSource = listventas;
                gvVentas.DataBind();
            }
        }
        protected void SelectCliente(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string cardCode = (row.FindControl("lblCardCode") as LinkButton).Text;
                txtSocioCode.Text = cardCode;
                ConsultaCliente(cardCode);
                popupBusquedaClientes.Hide();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error:{1}", "Select Cliente", ex.Message);
            }
        }

        

        protected void BusquedaClientes(object sender, EventArgs e)
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
                    var list = mng.SocioSearch("socios/search", txtPalabras.Text, us.Usuario);
                    list = list.FindAll(x => x.SocioTipoNombre == "CLIENTE").ToList();
                    gvClientes.DataSource = list;
                    gvClientes.DataBind();
                    popupBusquedaClientes.Show();
                }
            }
            
        }

        protected void ClosePopupBusquedaCliente(object sender, EventArgs e)
        {
            popupBusquedaClientes.Hide();
        }

        protected void ClosePopupBusquedaProductos(object sender, EventArgs e)
        {
            popupBusquedaProductos.Hide();
        }

        protected void Cargaprod(object sender, EventArgs e)
        {
            if (txtPalabrasProducto.Text.Length > 0)
            {
                string palabras = txtPalabrasProducto.Text;
                if (palabras.Trim().Length > 0)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerInventario mng=new ManagerInventario(urlbase, logger);
                    var list = mng.ProductoSearch("productos/search", palabras);

                    if (list != null)
                    {
                        //list = list.FindAll(x => x.Activo == "S").ToList();
                        if(chkSoloProductosB.Checked)
                        {
                            list = list.FindAll(x => x.Tipo == "B").ToList();
                        }
                        gvResultado.DataSource = list;
                        gvResultado.Caption = String.Format("Registros encontrados: {0}", list.Count());
                        gvResultado.DataBind();
                        HttpContext.Current.Session["palabrabusqueda"] = txtPalabrasProducto.Text;
                        HttpContext.Current.Session["BusquedaProductos"] = list;
                    }
                }
            }
        }

        protected void BusquedaProductos_Event(object sender, EventArgs e)
        {
            popupBusquedaProductos.Show();
        }

        protected void ActualizarCarro(object sender, EventArgs e)
        {
            //ShoppingCart carro = ShoppingCart.Instance;
            //ShoppingCart carro = new ShoppingCart();
            carro = new ShoppingCart();
            carro = carro.GetInstance();

            foreach (GridViewRow row in gvDetalle.Rows)
            {
                (row.FindControl("txtCantidad") as TextBox).Text = (row.FindControl("txtCantidad") as TextBox).Text.Replace(".", ",");
                string costo = (row.FindControl("lblCosto") as Label).Text.Replace("$", "").Replace(".", "").Trim();
                string prodcode = (row.FindControl("lblProdCode") as Label).Text;
                string cantidad = (row.FindControl("txtCantidad") as TextBox).Text.Replace("$", "").Replace(".", ",").Trim();
                string preciofinal = (row.FindControl("txtPrecio") as TextBox).Text.Replace("$", "").Replace(".", ",").Trim();
                int total =Convert.ToInt32( Math.Round(Convert.ToDecimal(cantidad) * Convert.ToDecimal(preciofinal),0));
                decimal margen = Convert.ToDecimal(costo) == 0 || Convert.ToDecimal(preciofinal) == 0 ? 0 : Math.Round((Convert.ToDecimal(preciofinal) - Convert.ToDecimal(costo)) / Convert.ToDecimal(preciofinal),4);
                //actualizar grilla ----
                (row.FindControl("txtTotal") as Label).Text =String.Format("{0:C0}", total);
                (row.FindControl("lblMargen") as Label).Text = String.Format("{0:P1}", margen);

                if (carro.Items.Find(x => x.DocLinea.ToString() == (row.FindControl("lblDocLinea") as Label).Text && x.ProdCode == prodcode) != null)
                {
                    carro.Items.Find(x => x.DocLinea.ToString() == (row.FindControl("lblDocLinea") as Label).Text && x.ProdCode == prodcode).Precio = Convert.ToDecimal(preciofinal);
                    carro.Items.Find(x => x.DocLinea.ToString() == (row.FindControl("lblDocLinea") as Label).Text && x.ProdCode == prodcode).Cantidad = Convert.ToDecimal(cantidad);
                    carro.Items.Find(x => x.DocLinea.ToString() == (row.FindControl("lblDocLinea") as Label).Text && x.ProdCode == prodcode).Total = total;
                }
            }
            carro.Totalizar();
            carro.SaveInstance(carro);

            txtNeto.Text = String.Format("{0:C0}", carro.Neto);
            txtIva.Text = String.Format("{0:C0}", carro.Iva);
            txtTotal.Text = String.Format("{0:C0}", carro.Total);

            txtNetoDetalle.Text = String.Format("{0:C0}", carro.Neto);
            if (carro.Neto == 0)
                txtMagenDetalle.Text = String.Format("{0:P1}", 0);
            else
                txtMagenDetalle.Text = String.Format("{0:P1}", (carro.Neto - carro.Costo) / carro.Neto);
        }

        protected void AddProductoSeleccionado(object sender, EventArgs e)
        {
            //ShoppingCart carro = ShoppingCart.Instance;
            //ShoppingCart carro = new ShoppingCart();
            carro = new ShoppingCart();
            carro = carro.GetInstance();

            foreach (GridViewRow row in gvResultado.Rows)
            {
                
                if ((row.FindControl("chkSeleccionado") as CheckBox).Checked)
                {
                    //------------------------------------------------------
                    string tipo = (row.FindControl("lblTipo") as Label).Text;
                    string prodcode = (row.FindControl("lblProdCode") as Label).Text;
                    string descripcion = (row.FindControl("lblDescripcion") as Label).Text;
                    string disponible = (row.FindControl("lblDisponible") as Label).Text; 
                    string cantidad = (row.FindControl("txtCantidad") as TextBox).Text.Replace("$", "").Replace(".", ",").Trim();
                    string marca = (row.FindControl("lblMarcaNombre") as Label).Text;
                    string marcacode = (row.FindControl("lblMarcaCode") as Label).Text;
                    string preciounitario = (row.FindControl("lblPrecioUnitario") as Label).Text.Replace("$","").Replace(".","").Trim();
                    string preciovolumen = (row.FindControl("lblPrecioVolumen") as Label).Text.Replace("$", "").Replace(".", "").Trim();
                    string preciofijo = (row.FindControl("lblPrecioFijo") as Label).Text.Replace("$", "").Replace(".", "").Trim();
                    string refigracion = (row.FindControl("lblRefrigeraNombre") as Label).Text;
                    string frmtoVenta = (row.FindControl("lblFrmtoVenta") as Label).Text;
                    string medida = (row.FindControl("lblMedidaNombre") as Label).Text;
                    string origen = (row.FindControl("lblOrigenNombre") as Label).Text;
                    string origencode = (row.FindControl("lblOrigenCode") as Label).Text;
                    string costo = (row.FindControl("lblCosto") as Label).Text;
                    string volumen = (row.FindControl("lblVolumen") as Label).Text;
                    
                    string animalcode = (row.FindControl("lblAnimalCode") as Label).Text;
                    string animalnombre = (row.FindControl("lblAnimalNombre") as Label).Text;
                    string formatocode = (row.FindControl("lblFormatoCode") as Label).Text;
                    string formatovtacode = (row.FindControl("lblFormatoVtaCode") as Label).Text;
                    string bodegacode = (row.FindControl("lblBodegaCode") as Label).Text;
                    string factorprecio = (row.FindControl("lblFactorprecio") as Label).Text.Replace(".","").Replace("$","").Trim();
                    string descuentovolumen = (row.FindControl("lblDescVolumen") as Label).Text.Replace(".", "").Replace("$", "").Trim(); ;
                    string margenregla = (row.FindControl("lblMargenRegla") as Label).Text.Replace(".", "").Replace("$", "").Trim(); ;
                    string refigracioncode = (row.FindControl("lblRefrigeraCode") as Label).Text;
                    string familiacode = (row.FindControl("lblFamiliaCode") as Label).Text;
                    string familianombre = (row.FindControl("lblFamiliaNombre") as Label).Text;
                    string formantovtanombre = (row.FindControl("lblFrmtoVentaNombre") as Label).Text;

                    string stocktoledo = (row.FindControl("lblStockToledo") as Label).Text;
                    string asignadotoledo = (row.FindControl("lblAsignadoToledo") as Label).Text;


                    if (cantidad == "") cantidad = "1";
                    if (origencode == "") origencode = "0";

                    CartItem item = new CartItem
                    {
                        ProdCode = prodcode,
                        ProdNombre = descripcion,
                        Cantidad = Convert.ToDecimal(cantidad),
                        PrecioUnitario = Convert.ToDecimal(preciounitario),
                        PrecioVolumen = Convert.ToDecimal(preciovolumen),
                        Disponible = Convert.ToDecimal(disponible),
                        StockToledo= Convert.ToDecimal(stocktoledo),
                        AsignadoToledo = Convert.ToDecimal(asignadotoledo),
                        MarcaNombre = marca,
                        MarcaCode = Convert.ToInt32(marcacode == "" ? "0" : marcacode),
                        Precio = 0, //Convert.ToDecimal(preciounitario),
                        RefrigeraCode = Convert.ToInt32(refigracioncode == "" ? "0" : refigracioncode),
                        RefrigeraNombre = refigracion,
                        Tipo = tipo,
                        Total = Convert.ToDecimal(cantidad) * Convert.ToDecimal(preciounitario),
                        MedidaNombre = medida,
                        FrmtoVenta = frmtoVenta,
                        Origen = origen,
                        Costo = Convert.ToDecimal(costo),
                        Volumen = Convert.ToDecimal(volumen),
                        FactorPrecio = Convert.ToDecimal(factorprecio),
                        AnimalCode = Convert.ToInt32(animalcode == "" ? "0" : animalcode),
                        AnimalNombre = animalnombre,
                        BodegaCode = bodegacode,
                        FamiliaCode = Convert.ToInt32(familiacode == "" ? "0" : familiacode),
                        FamiliaNombre = familianombre,
                        FormatoVtaCode = Convert.ToInt32(formatovtacode == "" ? "0" : formatovtacode),
                        Margen = 0,
                        MargenRegla = Convert.ToDecimal(margenregla),
                        OrigenCode = Convert.ToInt32(origencode == "" ? "0" : origencode),
                        OrigenNombre = origen,
                        FrmtoVentaNombre = formantovtanombre,
                        CantidadAntarior = 0,
                        PrecioFijo= Convert.ToDecimal(preciofijo)
                    };

                    CartItem i = carro.Items.Find(x => x.ProdCode == item.ProdCode);
                    if (i != null)
                    {
                        carro.Items.Find(x => x.ProdCode == i.ProdCode).Cantidad += Convert.ToDecimal(cantidad);
                    }
                    else
                    {

                        if (carro.Items.Count() > 0)
                        {
                            item.LineaItem = carro.Items.ToList().Max(x => x.LineaItem) + 1;
                            item.DocLinea = carro.Items.Count() + 1;
                        }
                        else
                        {
                            item.DocLinea = 1;
                            item.LineaItem = 1;
                        }

                        carro.AddItem(item);
                    }

                    carro.Totalizar();
                    carro.SaveInstance(carro);
                    txtNeto.Text = String.Format("{0:C0}", carro.Neto);
                    txtIva.Text = String.Format("{0:C0}", carro.Iva);
                    txtTotal.Text = String.Format("{0:C0}", carro.Total);

                    txtNetoDetalle.Text = String.Format("{0:C0}", carro.Neto);
                    if (carro.Neto == 0)
                        txtMagenDetalle.Text = String.Format("{0:P1}", 0);
                    else
                        txtMagenDetalle.Text = String.Format("{0:P1}", (carro.Neto - carro.Costo) / carro.Neto);
                }
            }


            //carro.AddItem(new CartItem { ProdCode = "sss", ProdNombre = "sdsasdadas", Cantidad = 10, Precio = 10, Total = 100 });
            gvDetalle.DataSource = carro.Items;
            gvDetalle.DataBind();

            popupBusquedaProductos.Hide();

        }

        protected void gvResultado_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState != DataControlRowState.Edit)
            {
                var tipo = (e.Row.FindControl("lblTipo") as Label).Text;
                var tienereceta = (e.Row.FindControl("lblTieneReceta") as Label).Text;
                var precio= (e.Row.FindControl("lblPrecioUnitario") as Label).Text.Replace("$","").Replace(".","").Trim();

                var stock = (e.Row.FindControl("lblStockToledo") as Label).Text.Replace(".","").Trim();

                if (stock == "")
                    stock = "0";
                if(Convert.ToDecimal(stock)>0)
                {
                    foreach (TableCell c in e.Row.Cells)
                    {
                        c.BackColor = System.Drawing.Color.LightGreen;
                    }
                }
                if (tipo=="B" && tienereceta=="N")
                {
                    e.Row.Cells[0].Enabled = false;
                    e.Row.Cells[3].ForeColor = System.Drawing.Color.Red;
                }

                if (precio == "0")
                {
                    e.Row.Cells[0].Enabled = false;
                }

            }
        }


        protected void CheckAllProductos(object sender, EventArgs e)
        {
            CheckBox chckheader = (CheckBox)gvResultado.HeaderRow.FindControl("checkbox2");
            foreach (GridViewRow row in gvResultado.Rows)
            {
                CheckBox chckrw = (CheckBox)row.FindControl("chkSeleccionado");
                if (chckheader.Checked == true)
                {
                    chckrw.Checked = true;

                }
                else
                {
                    chckrw.Checked = false;
                }

            }
        }



        protected void LinkButton_Command(object sender, CommandEventArgs e)
        {
            switch ((string)e.CommandName)
            {
                case "Cliente":
                    mviewMain.SetActiveView(ClienteView);
                    ActualizarCarro(sender, e);
                    break;
                case "Detalle":
                    mviewMain.SetActiveView(DetalleView);
                    ActualizarCarro(sender, e);
                    break;
                case "Direccion":
                    mviewMain.SetActiveView(DireccionView);
                    ActualizarCarro(sender, e);
                    break;
            }

        }

        protected void Guardar_Event(object sender, EventArgs e)
        {
            
            
            
            User us = (User)HttpContext.Current.Session["us"];
            if (us != null)
            {


                //ShoppingCart carro = ShoppingCart.Instance;
                //ShoppingCart carro = new ShoppingCart();
                carro = new ShoppingCart();
                carro = carro.GetInstance();

                var dirSelect = 0;
                foreach (GridViewRow row in gvDirecciones.Rows)
                {
                    var sel = (row.FindControl("chkSelDireccion") as CheckBox).Checked;
                    if (sel)
                    {
                        var dircod = (row.FindControl("lblDireccionCode") as Label).Text;
                        dirSelect = Convert.ToInt32(dircod);
                        break;
                    }
                }

                if (carro.Items.Any() && (dirSelect > 0 || chkRetiraCliente.Checked) && txtSocioCode.Text.Length > 0)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);

                    if (txtNeto.Text.Trim() == "")
                    {
                        txtNeto.Text = "0";
                    }
                    Documento doc;
                    if (carro.DocEntry == 0)
                    {
                        if (!chkFechadeEntrega.Checked)
                        {
                            var mensaje = "Debe indicar una fecha de Entrega";
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append("alert('");
                            sb.Append(mensaje);
                            sb.Append("');");
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                            chkFechadeEntrega.Focus();
                            return;
                        }

                        doc = new Documento();
                        doc.DocEntry = carro.DocEntry;
                        doc.SocioCode = txtSocioCode.Text;
                        doc.RazonSocial = txtSocioName.Text;
                        //doc.CondicionCode = Convert.ToInt32(cboCondicion.SelectedValue);// txtCondicion.Text;
                        doc.CondicionDF = cboCondicion.SelectedValue;
                        doc.ContactoCode = cboContactos.SelectedValue == "" ? 0 : Convert.ToInt32(cboContactos.SelectedValue);
                        doc.CondicionNombre = cboCondicion.SelectedItem.Text;
                        doc.DireccionCode = dirSelect;
                        doc.DocTipo = 10;
                        doc.Neto = carro.Neto;
                        doc.Iva = carro.Iva;
                        doc.Total = carro.Total;
                        doc.EstadoOperativo = "ING";
                        doc.EstadoCliente = txtEstadoCliente.Text;
                        doc.Observaciones = txtReferencia.Text;
                        doc.UsuarioNombre = us.Usuario;
                        doc.UsuarioCode = "0";
                        doc.Version = "V0.0.1";
                        doc.Lineas = new List<DocumentoLinea>();
                        doc.DocFecha = DateTime.Now.Date;
                        doc.FechaRegistro = DateTime.Now;
                        doc.DocEstado = "A";
                        doc.VendedorCode = cboVendedor.SelectedValue;// txtVendedor.Text;
                        doc.VendedorNombre = cboVendedor.SelectedItem.Text;
                        doc.FechaEntrega = Convert.ToDateTime(txtFechaEntrega.Text);
                        doc.RetiraCliente = chkRetiraCliente.Checked;
                        doc.Costo = carro.Costo;
                        doc.Margen = carro.Margen;
                        doc.Instrucciones = txtInstrucciones.Text;
                    }
                    else
                    {
                        doc = mng.Consultar("documentos", carro.DocEntry, 10);
                        doc.Neto = carro.Neto;
                        doc.Iva = carro.Iva;
                        doc.Total = carro.Total;
                        doc.Margen = carro.Margen;
                        doc.Observaciones = txtReferencia.Text;
                        doc.Instrucciones = txtInstrucciones.Text;
                        doc.FechaEntrega = Convert.ToDateTime(txtFechaEntrega.Text);
                        doc.RetiraCliente = chkRetiraCliente.Checked;
                        doc.DireccionCode = dirSelect;
                        doc.Lineas = new List<DocumentoLinea>();
                        //doc.CondicionCode = Convert.ToInt32(cboCondicion.SelectedValue);// txtCondicion.Text;
                    }
                    foreach (var i in carro.Items)
                    {
                        DocumentoLinea item = new DocumentoLinea
                        {
                            DocEntry = carro.DocEntry,
                            DocTipo = doc.DocTipo,
                            CantidadSolicitada = i.Cantidad,
                            PrecioFinal = i.Precio,
                            CantidadPendiente = i.Cantidad,
                            CantidadReal = 0,
                            Costo = i.Costo,
                            Descuento = 0,
                            FamiliaCode = i.FamiliaCode,
                            AnimalCode = i.AnimalCode,
                            LineaEstado = "A",
                            Margen = i.Margen,
                            PrecioUnitario = i.PrecioUnitario,
                            ProdCode = i.ProdCode,
                            ProdNombre = i.ProdNombre,
                            TipoCode = i.Tipo,
                            Medida = i.MedidaNombre,
                            LineaItem = i.LineaItem,
                            TotalSolicitado = i.Total,
                            Volumen = i.Volumen,
                            PrecioVolumen = i.PrecioVolumen,
                            DocLinea = i.DocLinea,
                            Disponible = i.Disponible,
                            FactorPrecio = i.FactorPrecio,
                            MargenRegla = i.MargenRegla,
                            FormatoVtaCode = i.FormatoVtaCode,
                            BodegaCode = i.BodegaCode,
                            RefrigeraCode = i.RefrigeraCode,
                            MarcaCode = i.MarcaCode,
                            FrmtoVentaNombre = i.FrmtoVenta,
                            MarcaNombre = i.MarcaNombre,
                            OrigenCode = i.OrigenCode,
                            OrigenNombre = i.OrigenNombre,
                            RefrigeraNombre = i.RefrigeraNombre,
                            AnimalNombre = i.AnimalNombre,
                            FamiliaNombre = i.FamiliaNombre,
                            SolicitadoAnterior = i.CantidadAntarior,

                        };
                        doc.Lineas.Add(item);
                    }

                    if (doc.EstadoOperativo == "ING")
                    {
                        try
                        {

                            doc = mng.Guardar("documentos", doc);

                            if (doc != null)
                            {


                                //txtNumero.Text = doc.DocEntry.ToString();
                                //carro.DocEntry = doc.DocEntry;
                                //txtFecha.Text = doc.DocFecha.ToString("yyyy-MM-dd");
                                //txtEstado.Text = doc.EstadoOperativo.ToString();
                                var mensaje = "Pedido Guardado";
                                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                                sb.Append("alert('");
                                sb.Append(mensaje);
                                sb.Append("');");
                                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                                ConsultaPedido(doc.DocEntry);

                            }
                        }
                        catch (Exception ex)
                        {
                            logger.Error("{0} Error: {1}", "Guardar Pedido", ex.Message);
                            logger.Error("{0} StackTrace: {1}", "Guardar Pedido", ex.StackTrace);
                            var mensaje = ex.Message;
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append("alert('");
                            sb.Append(mensaje);
                            sb.Append("');");
                            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                        }
                    }
                    else
                    {
                        var mensaje = "Pedido no puede ser modificado. Ya está en Preparación";
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(mensaje);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                        ConsultaPedido(doc.DocEntry);
                    }
                }
                else
                {
                    var mensaje = "Debe indicar una dirección o Retira cliente";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                    chkFechadeEntrega.Focus();
                    return;
                }
            }
        }

        protected void EliminarSeleccionados_Event(object sender, EventArgs e)
        {
            //ShoppingCart carro = ShoppingCart.Instance;
            //ShoppingCart carro = new ShoppingCart();
            carro = new ShoppingCart();
            carro = carro.GetInstance();
            foreach (GridViewRow row in gvDetalle.Rows)
            {
                if ((row.FindControl("chkSelItem") as CheckBox).Checked)
                {
                    var prodcode = (row.FindControl("lblProdCode") as Label).Text;
                    var doclinea = Convert.ToInt32((row.FindControl("lblDocLinea") as Label).Text);
                    var lineaitem = Convert.ToInt32((row.FindControl("lblLineaItem") as Label).Text);

                    
                    var item = carro.Items.Find(x => x.ProdCode == prodcode && x.DocLinea == doclinea && x.LineaItem == lineaitem);
                    carro.Items.Remove(item);
                }
            }

            gvDetalle.DataSource = carro.Items;
            gvDetalle.DataBind();
            carro.Totalizar();
            carro.SaveInstance(carro);

            txtNeto.Text = String.Format("{0:C0}", carro.Neto);
            txtIva.Text = String.Format("{0:C0}", carro.Iva);
            txtTotal.Text = String.Format("{0:C0}", carro.Total);

            txtNetoDetalle.Text = String.Format("{0:C0}", carro.Neto);
            if(carro.Neto==0)
                txtMagenDetalle.Text = String.Format("{0:P1}", 0);
            else
                txtMagenDetalle.Text = String.Format("{0:P1}", (carro.Neto- carro.Costo)/ carro.Neto);
        }

        
        protected void BuscarPedidoNav_Event(object sender, EventArgs e)
        {
            //txtPalabrasPupup.Text = txtBuscar.Text;
            //string vendedorcode = "";
            //BusquedaPedidos(txtPalabrasPupup.Text, vendedorcode);
        }

        private void BusquedaPedidos(string palabras, string vendedorcode, string usuario)
        {
            if (palabras.Trim().Length > 0)
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
                var list = mng.Search("documentos/search", palabras, vendedorcode,10, usuario); //indicar vendedorcode segun el perfil de usuario
                gvPedidos.DataSource = list;
                gvPedidos.DataBind();
            }
            popupBusquedaPedidos.Show();
        }

        protected void ClosePopupBusquedaPedidos(object sender, EventArgs e)
        {
            txtPalabrasPupup.Text = "";
            gvPedidos.DataSource = null;
            gvPedidos.DataBind();
            popupBusquedaPedidos.Hide();
        }

        protected void SelectPedido(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                GridViewRow row = (GridViewRow)btn.NamingContainer;

                string docEntry = (row.FindControl("lblDocEntry") as LinkButton).Text;
                txtNumero.Text = docEntry;
                lblNumeroPedido.Text = docEntry;
                ConsultaPedido(Convert.ToInt32(docEntry));
                popupBusquedaClientes.Hide();

            }
            catch (Exception ex)
            {
                logger.Error("{0} Error: {1}", "Select Pedido", ex.Message);
                logger.Error("{0} StackTrace: {1}", "Select Pedido", ex.StackTrace);
            }
        }

        protected void BuscarPedido_Event(object sender, EventArgs e)
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
                    string vendedorcode = "";
                    BusquedaPedidos(txtPalabrasPupup.Text, vendedorcode, us.Usuario);
                }
            }
            //popupBusquedaPedidos.Show();
        }

        protected void gvBandeja_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }

        private void ConsultaPedido(int docentry)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var pedido = mng.Consultar("documentos", docentry,10);
            if(pedido!=null)
            {
                btnGuardar.Visible = true;
                btnClonar.Visible = true;
                if (pedido.DocEstado=="C" || pedido.EstadoOperativo!="ING")
                {
                    //btnGuardar.Visible = false;
                    //btnGuardar.Attributes.Add("visibility", "hidden");
                    //UpdatePanel2.Update();

                    //
                    ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "SetOcultarguardar", "SetOcultarguardar();", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "SetOcultarclonar", "SetOcultarclonar();", true);
                    //
                }

                //consulta datos del cliente
                ManagerSocios mngcli = new ManagerSocios(urlbase, logger);
                
                var item = mngcli.SocioGet("socios", pedido.SocioCode);
                SocioPropiedades prop = mngcli.Propiedades("socios/propiedades");

                if (item != null && item.SocioCode != null)
                {
                    
                    //List<CondiciondePago> listcond = new List<CondiciondePago>();
                    List<SCP12> listcond = new List<SCP12>();
                    foreach (var p in prop.condicion)
                    {
                        var cp = JsonConvert.DeserializeObject<SCP12>(JsonConvert.SerializeObject(p));
                        if (cp.code == pedido.CondicionDF)
                        {
                            
                            //listcond.Add(new CondiciondePago { CondicionCode = p.CondicionCode, CondicionNombre = p.CondicionNombre, Dias = p.Dias, Orden = p.Orden });
                            listcond.Add(cp);
                            cboCondicion.DataSource = listcond;
                            cboCondicion.DataTextField = "name";
                            cboCondicion.DataValueField = "code";
                            cboCondicion.DataBind();
                            break;
                        }
                    }
                    txtSocioName.Text = item.RazonSocial;
                    txtRut.Text = item.Rut;
                    txtEstadoCliente.Text = item.EstadoOperativo;
                    lblClienteBar.Text = item.RazonSocial;
                    switch (txtEstadoCliente.Text)
                    {
                        case "MOROSIDAD":
                        case "BLOQUEO":
                        case "BETADO":
                        case "INACTIVO":
                            txtEstadoCliente.BackColor = System.Drawing.Color.Red;
                            txtEstadoCliente.ForeColor = System.Drawing.Color.White;
                            txtEstadoCliente.Font.Bold = true;
                            break;
                    }
                    txtEstadoCliente.Font.Bold = true;
                    txtEstado.BackColor = System.Drawing.Color.White;
                    txtEstado.ForeColor = System.Drawing.Color.Black;
                    txtMotivoRechazo.BackColor = System.Drawing.Color.White;
                    txtMotivoRechazo.ForeColor = System.Drawing.Color.Black;
                    btnGuardar.Visible = true;
                    btnGuardar.Enabled = true;
                    if (pedido.EstadoOperativo=="NUL")
                    {
                        txtEstado.BackColor = System.Drawing.Color.Red;
                        txtEstado.ForeColor=System.Drawing.Color.White;
                        txtMotivoRechazo.BackColor = System.Drawing.Color.Red;
                        txtMotivoRechazo.ForeColor = System.Drawing.Color.White;
                        btnGuardar.Visible = false;
                        btnGuardar.Enabled = false;
                    }
                    txtRubro.Text = item.RubroName;
                    //txtCondicion.Text = item.CondicionName;
                    


                    if (item.Contactos.Any())
                    {
                        cboContactos.DataSource = item.Contactos;
                        cboContactos.DataTextField = "Nombre";
                        cboContactos.DataValueField = "ContactoCode";
                        if (pedido.ContactoCode != null && pedido.ContactoCode != 0)
                        {
                            cboContactos.SelectedValue = pedido.ContactoCode.ToString();
                        }
                        cboContactos.DataBind();
                    }
                    if (item.Direcciones.Any())
                    {
                        gvDirecciones.DataSource = item.Direcciones.FindAll(x => x.DireccionTipo == "D"); //solo direccion de despacho
                        gvDirecciones.DataBind();
                        txtFechaEntrega.Text = String.Format("{0:yyyy-MM-dd}", pedido.FechaEntrega);
                        txtFechaEntrega.Enabled = false;
                        if (!Convert.ToBoolean(pedido.RetiraCliente))
                        {
                            
                            foreach (GridViewRow row in gvDirecciones.Rows)
                            {
                                string dir = (row.FindControl("lblDireccionCode") as Label).Text;
                                if (dir == pedido.DireccionCode.ToString())
                                {
                                    (row.FindControl("chkSelDireccion") as CheckBox).Checked = true;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            chkRetiraCliente.Checked = true;
                            //txtFechaEntrega.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now);
                        }
                    }

                    var list = mngcli.TopCliente("socios", item.SocioCode);
                    gvTopCliente.DataSource = list;
                    gvTopCliente.DataBind();

                    list = mngcli.TopRubro("socios", item.SocioCode);
                    gvTopRubro.DataSource = list;
                    gvTopRubro.DataBind();

                    var listventas = mngcli.TopVentas("socios", item.SocioCode);
                    gvVentas.DataSource = listventas;
                    gvVentas.DataBind();

                    if(pedido.Historial!=null && pedido.Historial.Any())
                    {
                        gvHistorial.DataSource = pedido.Historial;
                        gvHistorial.DataBind();
                    }
                    
                }

                //HttpContext.Current.Session["ShoppingCart"] = null;
                //ShoppingCart carro = ShoppingCart.Instance;
                //ShoppingCart carro = new ShoppingCart();
                carro = new ShoppingCart();
                carro.Clear();
                carro.Costo = pedido.Costo;
                carro.Neto =Convert.ToInt32(pedido.Neto);
                carro.Margen = pedido.Margen;
                carro.Iva = Convert.ToInt32(pedido.Iva);
                carro.Total = Convert.ToInt32(pedido.Total);
                carro.DocEntry = pedido.DocEntry;
                foreach (var i in pedido.Lineas)
                {
                    carro.AddItem(new CartItem
                    {
                        Cantidad = Math.Round(Convert.ToDecimal(i.CantidadSolicitada),0),
                        Costo = Convert.ToDecimal(i.Costo),
                        DocLinea = i.DocLinea,
                        LineaItem = i.LineaItem,
                        Margen = Convert.ToDecimal(i.Margen),
                        Precio = Math.Round(Convert.ToDecimal(i.PrecioFinal),0),
                        PrecioUnitario = Convert.ToDecimal(i.PrecioUnitario),
                        PrecioVolumen = Convert.ToDecimal(i.PrecioVolumen),
                        ProdCode = i.ProdCode,
                        ProdNombre = i.ProdNombre,
                        Tipo = i.TipoCode,
                        Total = Convert.ToDecimal(i.TotalSolicitado),
                        MedidaNombre = i.Medida,
                        Volumen = Convert.ToDecimal(i.Volumen),
                        RefrigeraCode = Convert.ToInt32(i.RefrigeraCode),
                        AnimalCode = Convert.ToInt32(i.AnimalCode),
                        BodegaCode = i.BodegaCode,
                        FactorPrecio = Convert.ToDecimal(i.FactorPrecio),
                        FamiliaCode = Convert.ToInt32(i.FamiliaCode),
                        FormatoVtaCode = Convert.ToInt32(i.FormatoVtaCode),
                        MargenRegla = Convert.ToDecimal(i.MargenRegla),
                        Disponible = Convert.ToDecimal(i.Disponible),
                        MarcaNombre = i.MarcaNombre,
                        MarcaCode = i.MarcaCode,
                        FrmtoVenta = i.FrmtoVentaNombre,
                        Origen = i.OrigenNombre,
                        RefrigeraNombre = i.RefrigeraNombre,
                        AnimalNombre = i.AnimalNombre,
                        FamiliaNombre = i.FamiliaNombre,
                        FrmtoVentaNombre=i.FrmtoVentaNombre,
                        OrigenCode=i.OrigenCode,
                        OrigenNombre=i.OrigenNombre,
                        CantidadAntarior= Convert.ToDecimal(i.SolicitadoAnterior)
                    }) ;
                }
                txtNumero.Text = pedido.DocEntry.ToString();
                lblNumeroPedido.Text = pedido.DocEntry.ToString();
                txtNeto.Text = String.Format("{0:C0}", carro.Neto);
                txtIva.Text = String.Format("{0:C0}", carro.Iva);
                txtTotal.Text = String.Format("{0:C0}", carro.Total);
                txtMagenDetalle.Text = String.Format("{0:P1}", carro.Margen);
                txtEstado.Text = pedido.EstadoOperativo;
                txtEstadoCliente.Text = pedido.EstadoCliente;
                txtFecha.Text =String.Format("{0:yyyy-MM-dd}",  pedido.DocFecha);
                chkRetiraCliente.Checked = Convert.ToBoolean(pedido.RetiraCliente);
                txtSocioCode.Text = pedido.SocioCode;
                txtSocioName.Text = pedido.RazonSocial;
                txtReferencia.Text = pedido.Observaciones;

                cboVendedor.DataSource = prop.vendedores;
                cboVendedor.DataTextField = "Nombre";
                cboVendedor.DataValueField = "VendedorCode";
                cboVendedor.DataBind();
                cboVendedor.SelectedValue = pedido.VendedorCode;
                lblVendedorBar.Text = cboVendedor.SelectedItem.Text;

                //txtVendedor.Text = pedido.VendedorNombre;// .VendedorCode;

                txtNetoDetalle.Text = txtNeto.Text;
                txtMotivoRechazo.Text = pedido.MotivoRechazo;
                txtInstrucciones.Text = pedido.Instrucciones;
                gvDetalle.DataSource = carro.Items;
                gvDetalle.DataBind();

                carro.Totalizar();
                carro.SaveInstance(carro);   
                //cargar direcciones y seleccionar si corresponde

                //ActualizarCarro(new object() , new EventArgs());

                popupBusquedaPedidos.Hide();

                if (pedido.EstadoOperativo == "NUL")
                {
                    var mensaje = "Pedido está Nulo, no puede ser modificado";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                }
            }
        }

        private void Nuevo()
        {
            //ShoppingCart carro = ShoppingCart.Instance;
            //ShoppingCart carro = new ShoppingCart();
            carro = new ShoppingCart();
            carro.Clear();
            gvDetalle.DataSource = carro.Items;
            gvDetalle.DataBind();
            gvDirecciones.DataSource = null;
            gvDirecciones.DataBind();
            gvVentas.DataSource = null;
            gvVentas.DataBind();
            cboCondicion.DataSource = null;
            cboCondicion.DataBind();
            txtFecha.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now);
            txtSocioCode.Text = "";
            txtSocioName.Text = "";
            txtReferencia.Text = "";
            //txtVendedor.Text = "";
            cboVendedor.Text = "";
            txtNetoDetalle.Text ="";
            txtSocioName.Text = "";
            txtRut.Text = "";
            txtNumero.Text = "";
            lblNumeroPedido.Text = "";
            txtEstado.Text = "";
            txtMotivoRechazo.Text = "";
            txtNeto.Text = "";
            txtIva.Text = "";
            txtTotal.Text = "";
            txtNetoDetalle.Text = "";
            txtMagenDetalle.Text = "";
            txtEstadoCliente.Text = "";
            gvTopCliente.DataSource = null;
            gvTopCliente.DataBind();
            gvTopRubro.DataSource = null;
            gvTopRubro.DataBind();
            txtEstado.BackColor = System.Drawing.Color.White;
            txtEstado.ForeColor = System.Drawing.Color.Black;
            txtMotivoRechazo.BackColor = System.Drawing.Color.White;
            txtMotivoRechazo.ForeColor = System.Drawing.Color.Black;
            btnGuardar.Visible = true;
            btnGuardar.Enabled = true;
            txtRubro.Text = "";
            cboContactos.DataSource = null;
            cboContactos.Items.Clear();
            cboContactos.DataBind();
            cboCondicion.DataSource = null;
            cboCondicion.Items.Clear();
            cboCondicion.DataBind();
            chkRetiraCliente.Checked = false;
            txtFechaEntrega.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now);
            txtSocioCode.Focus();
        }
        protected void Nuevo_Event(object sender, EventArgs e)
        {
            Nuevo();
        }

        private void Clonar()
        {
            //ShoppingCart carro = ShoppingCart.Instance;
            //ShoppingCart carro = new ShoppingCart();
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            carro = new ShoppingCart();
            carro = carro.GetInstance();

            carro.DocEntry = 0;

            //volver a cargar datos del cliente
            ConsultaCliente(txtSocioCode.Text);
            int linea = 1;
            foreach(var i in carro.Items)
            {
                var oitb = mng.GetStockBodega("productos/stock", i.ProdCode, i.BodegaCode);
                i.DocLinea = linea;
                i.Disponible = Convert.ToDecimal(oitb.Stock) - Math.Abs(Convert.ToDecimal(oitb.Asignado));
                linea++;
            }
            txtNumero.Text = "";
            lblNumeroPedido.Text = "";
            btnGuardar.Visible = true;
            btnGuardar.Enabled = true;
            txtEstado.BackColor = System.Drawing.Color.White;
            txtEstado.ForeColor = System.Drawing.Color.Black;
            txtEstado.Text = "";
            txtReferencia.Text = "";
            txtFecha.Text = String.Format("{0:yyyy-MM-dd}", DateTime.Now);
            txtMotivoRechazo.BackColor = System.Drawing.Color.White;
            txtMotivoRechazo.ForeColor = System.Drawing.Color.Black;
            txtMotivoRechazo.Text = "";
            gvHistorial.DataSource = new List<HistorialDoc>();
            gvHistorial.DataBind();
            navpedido.Attributes.Add("style", "background-color:#86b7fe;");

            //cargar carro en grilla
            gvDetalle.DataSource = carro.Items;
            gvDetalle.DataBind();
        }
        protected void Clonar_Event(object sender, EventArgs e)
        {
            if (txtNumero.Text == "")
            {
                return;
            }
            else
            {
                Clonar();
            }
            
        }

        protected void UltimosPrecios_Event(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;

            string prodcode = (row.FindControl("lblProdCode") as Label).Text;
            string familiacode = (row.FindControl("lblFamiliaCode") as Label).Text;
            string familia = (row.FindControl("lblFamiliaNombre") as Label).Text;
            string sociocode = txtSocioCode.Text;

            //ShoppingCart carro = ShoppingCart.Instance;
            //ShoppingCart carro = new ShoppingCart();

            //foreach (var i in carro.Items)
            //{
            //    if(i.ProdCode==prodcode)
            //    {
            //        familiacode = i.FamiliaCode.ToString();
            //        break;
            //    }
            //}
            if (familiacode.Trim().Length ==0)
                familiacode = "0";

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerSocios mng = new ManagerSocios(urlbase, logger);
            var list=mng.TopUltimosPrecios("socios", sociocode,familiacode);
            gvUltimosPrecios.DataSource = list;
            gvUltimosPrecios.DataBind();
            lblFamiliaTitulo.Text = familia;
            popupUltimosPrecios.Show();
        }

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {


        }

        protected void SincronizarDirecciones_Event(object sender, EventArgs e)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerSocios mng = new ManagerSocios(urlbase, logger);
            var item = mng.SocioGet("socios", txtSocioCode.Text);
            if (item != null && item.SocioCode != null)
            {
                if (item.Direcciones.Any())
                {
                    gvDirecciones.DataSource = item.Direcciones.FindAll(x => x.DireccionTipo == "D"); //solo direccion de despacho
                    gvDirecciones.DataBind();
                }
            }
        }

        protected void ImprimirPedido_Event(object sender, EventArgs e)
        {
            if(txtNumero.Text=="")
            {
                return;
            }
            //Simular procesamiento de datos
            System.Threading.Thread.Sleep(5000); // Simula un retraso de 5 segundos

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var pedido = mng.Consultar("documentos", Convert.ToInt32(txtNumero.Text), 10);
            if(pedido!=null)
            {
                try
                {
                    ImprimirPedidoPDF(Convert.ToInt32(txtNumero.Text));

                }
                catch (Exception ex)
                {
                    logger.Error("{0}", ex.Message);
                    logger.Error("{0}", ex.StackTrace);
                }
            }
        }

        private void ImprimirPedidoPDF(int docentry)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            string pathDocumentos = Server.MapPath("~/Documentos");
            MemoryStream ms = null;
            ms = ImprimirPedido(docentry, pathDocumentos);
            if (ms != null)
            {
                DownloadFile(ms, docentry);
            }
        }

        public void DownloadFile(MemoryStream mstream, int DocNum)
        {
            Byte[] bytes = mstream.ToArray();

            Random random = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            string basePath = Server.MapPath("~");// AppContext.BaseDirectory;
            string folder = new string(Enumerable.Repeat(chars, 25).Select(s => s[random.Next(s.Length)]).ToArray());
            string salidaPath = String.Format("{0}files/{1}", basePath, folder);// Server.MapPath("~/files");// AppContext.BaseDirectory;
            string urlPathFile = String.Format("/files/{0}", folder);
            string filename = String.Format("OrdendeVenta-{0}.pdf", DocNum);
            string filepathName = salidaPath + "/" + filename.Replace(",", ".");
            urlPathFile = urlPathFile + "/" + filename.Replace(",", ".");

            if (!Directory.Exists(salidaPath))
            {
                Directory.CreateDirectory(salidaPath);
                File.SetAttributes(salidaPath, FileAttributes.Normal);
                logger.Info("Crea directorio: {0} ", salidaPath);
            }

            using (var Stream = new FileStream(filepathName, FileMode.Create))  //FileStream(strExeFilePath + "/" + filename.Replace(",","."), FileMode.Create))
            {
                Stream.Write(bytes, 0, bytes.Length);

            }

            string script = String.Format("openPdfPopup('{0}');true;", urlPathFile);
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "script", script, true);

        }
        public MemoryStream ImprimirPedido(int docentry, string pathDocumentos)
        {

            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            Documento doc = GetPedido("documentos/", docentry);
            //Picking pick = mng.Picking("/documentos/picking/toledo", docentry);

            if (doc != null)
            {
                var ms = GeneraPDF(doc, doc.Lineas, ref pathDocumentos, false, logger, "pedido-de-venta");
                return ms;
                //DownloadFile(ms, pick.DocEntry);
            }
            return null;
        }

        public Documento GetPedido(string metodo, int docentry)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            AgenteDocumentos agente = new AgenteDocumentos(urlbase, logger);
            var json = agente.Get(metodo, docentry, 10);
            var result = JsonConvert.DeserializeObject<MensajeReturn>(json);
            if (result != null && !result.error && result.statuscode == HttpStatusCode.OK)
            {
                json = JsonConvert.SerializeObject(result.data);
                var doc = JsonConvert.DeserializeObject<Documento>(json);

                return doc;
            }
            var result2 = new MensajeReturn { msg = "" };
            result2 = result == null ? new MensajeReturn { msg = "" } : result;
            logger.Error("Agente Endpoint. Picking: {0}", result2.msg);
            return null;
        }

        public MemoryStream GeneraPDF(Documento pkg, List<DocumentoLinea> det, ref string filepath, bool conImagenes, Logger logger, string nombreReporte)
        {
            String v_mimetype;
            String v_encoding;
            String v_filename_extension;
            String[] v_streamids;
            Warning[] warnings;

            try
            {
                LocalReport reportViewer1 = new LocalReport();
                LocalReport objRDLC = new LocalReport();

                reportViewer1.ReportPath = String.Format("{0}\\{1}.rdlc", filepath, nombreReporte);


                logger.Info("reportViewer1.ReportPath: {0}", reportViewer1.ReportPath);
                reportViewer1.DataSources.Clear();

                List<Documento> Encabezado = new List<Documento>();
                List<DocumentoLinea> Detalle = new List<DocumentoLinea>();

                Encabezado.Add(pkg);
                Detalle = det;

                reportViewer1.EnableExternalImages = true;
                reportViewer1.DataSources.Add(new ReportDataSource("Cabecera", Encabezado));
                reportViewer1.DataSources.Add(new ReportDataSource("Detalle", Detalle));

                objRDLC.DataSources.Clear();
                ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
                byte[] byteViewer = reportViewer1.Render("PDF", null, out v_mimetype, out v_encoding, out v_filename_extension, out v_streamids, out warnings);
                //string savePath = tempPath;


                MemoryStream stream = new MemoryStream();
                stream.Write(byteViewer, 0, byteViewer.Length);

                return stream;// tempPath;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                logger.Info("Error Generando PDF Message: {0}", e.Message);
                if (e.InnerException != null)
                {
                    logger.Info("Error Generando PDF InnerException: {0}", e.InnerException.Message);
                }

                return null;
            }
        }

        protected void chkFechadeEntrega_OnCheckedChanged(object sender, EventArgs e)
        {
            if (chkFechadeEntrega.Checked)
            {
                txtFechaEntrega.Enabled = true;
                txtFechaEntrega.Focus();
            }
            else
            {
                txtFechaEntrega.Enabled = false;
            }
        }
        protected void ClosePopupUltimosPrecios(object sender, EventArgs e)
        {
            popupUltimosPrecios.Hide();
        }
    }
}