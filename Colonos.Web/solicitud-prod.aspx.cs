using Colonos.Entidades;
using Colonos.Manager;
using Colonos.Web.Models;
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
    public partial class solicitud_prod : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        ProduccionCart carro;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Nuevo();
            }
        }

        protected void gvDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
        {


        }

        protected void Cargaprod(object sender, EventArgs e)
        {
            if (txtPalabrasProducto.Text.Length > 0)
            {
                string palabras = txtPalabrasProducto.Text;
                if (palabras.Trim().Length > 0)
                {
                    string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                    ManagerInventario mng = new ManagerInventario(urlbase, logger);
                    var list = mng.ProductoSearch("productos/search", palabras,"","","PRODUCCION");

                    if (list != null)
                    {
                        list = list.FindAll(x => x.Tipo=="B").ToList().OrderByDescending(x => x.TieneReceta).ToList();
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
        protected void gvResultado_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                var tienereceta= (e.Row.FindControl("lblTieneReceta") as Label).Text;
                if (tienereceta == "N")
                {
                    for (int c = 1; c < e.Row.Cells.Count; c++)
                    {
                        e.Row.Cells[c].ForeColor = System.Drawing.Color.DarkGray;
                        //e.Row.Cells[c].BackColor = System.Drawing.Color.LightYellow;
                    }
                }
            }
        }
        protected void ClosePopupBusquedaProductos(object sender, EventArgs e)
        {
            popupBusquedaProductos.Hide();
        }
        protected void AddProductoSeleccionado(object sender, EventArgs e)
        {
            carro = new ProduccionCart();//.Instance;

            foreach (GridViewRow row in gvResultado.Rows)
            {

                if ((row.FindControl("chkSeleccionado") as CheckBox).Checked)
                {
                    //------------------------------------------------------
                    string tipo = (row.FindControl("lblTipo") as Label).Text;
                    string prodcode = (row.FindControl("lblProdCode") as Label).Text;
                    string descripcion = (row.FindControl("lblDescripcion") as Label).Text;
                    string disponible = (row.FindControl("lblDisponible") as Label).Text;
                    string cantidad = (row.FindControl("txtCantidad") as TextBox).Text.Replace("$", "").Replace(".", "").Trim();
                    string marca = (row.FindControl("lblMarcaNombre") as Label).Text;
                    string marcacode = (row.FindControl("lblMarcaCode") as Label).Text;
                    string preciounitario = (row.FindControl("lblPrecioUnitario") as Label).Text.Replace("$", "").Replace(".", "").Trim();
                    string preciovolumen = (row.FindControl("lblPrecioVolumen") as Label).Text.Replace("$", "").Replace(".", "").Trim();
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
                    string factorprecio = (row.FindControl("lblFactorprecio") as Label).Text.Replace(".", "").Replace("$", "").Trim();
                    string descuentovolumen = (row.FindControl("lblDescVolumen") as Label).Text.Replace(".", "").Replace("$", "").Trim(); ;
                    string margenregla = (row.FindControl("lblMargenRegla") as Label).Text.Replace(".", "").Replace("$", "").Trim(); ;
                    string refigracioncode = (row.FindControl("lblRefrigeraCode") as Label).Text;
                    string familiacode = (row.FindControl("lblFamiliaCode") as Label).Text;
                    string familianombre = (row.FindControl("lblFamiliaNombre") as Label).Text;
                    string formantovtanombre = (row.FindControl("lblFrmtoVentaNombre") as Label).Text;

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
                        MarcaNombre = marca,
                        MarcaCode = Convert.ToInt32(marcacode == "" ? "0" : marcacode),
                        Precio = Convert.ToDecimal(preciounitario),
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
                        CantidadAntarior = 0
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

                }
            }


            //carro.AddItem(new CartItem { ProdCode = "sss", ProdNombre = "sdsasdadas", Cantidad = 10, Precio = 10, Total = 100 });
            gvDetalle.DataSource = carro.Items;
            gvDetalle.DataBind();

            popupBusquedaProductos.Hide();

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

        protected void Guardar_Event(object sender, EventArgs e)
        {

            ProduccionCart carro = new ProduccionCart();// ProduccionCart.Instance;
            var dirSelect = 0;


            if (carro.Items.Any())
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);

                Documento doc;
                if (carro.DocEntry == 0)
                {
                    doc = new Documento();
                    doc.DocEntry = carro.DocEntry;
                    doc.SocioCode = "78991080-4C";
                    doc.RazonSocial = "SERVICIOS Y RENTAS GV SpA";
                    doc.DireccionCode = dirSelect;
                    doc.DocTipo = 3010;
                    doc.Neto = carro.Neto;
                    doc.Iva = carro.Iva;
                    doc.Total = carro.Total;
                    doc.EstadoOperativo = "ING";
                    doc.UsuarioNombre = "Admin";
                    doc.UsuarioCode = "0";
                    doc.Version = "V0.0.1";
                    doc.Lineas = new List<DocumentoLinea>();
                    doc.DocFecha = DateTime.Now.Date;
                    doc.FechaRegistro = DateTime.Now;
                    doc.FechaEntrega = DateTime.Now;
                    doc.DocEstado = "A";
                    doc.Costo = carro.Costo;
                    doc.Margen = carro.Margen;
                }
                else
                {
                    doc = mng.Consultar("documentos", carro.DocEntry, 3010);
                    doc.Neto = carro.Neto;
                    doc.Iva = carro.Iva;
                    doc.Total = carro.Total;
                    doc.DireccionCode = dirSelect;
                    doc.Lineas = new List<DocumentoLinea>();
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
                        logger.Error("{0} Error: {1}", "Guardar Solciitud de Produccion", ex.Message);
                        logger.Error("{0} StackTrace: {1}", "Guardar Solciitud de Produccion", ex.StackTrace);
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
                    var mensaje = "Solciitud de Produccion no puede ser modificado. Ya está en Preparación";
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("alert('");
                    sb.Append(mensaje);
                    sb.Append("');");
                    ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);

                    ConsultaPedido(doc.DocEntry);
                }
            }
        }

        protected void EliminarSeleccionados_Event(object sender, EventArgs e)
        {
            //ProduccionCart carro = ProduccionCart.Instance;
            carro = new ProduccionCart();
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

        }

        private void ConsultaPedido(int docentry)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerDocumentos mng = new ManagerDocumentos(urlbase, logger);
            var pedido = mng.Consultar("documentos", docentry, 3010);
            if (pedido != null)
            {
                btnGuardar.Visible = true;
                if (pedido.DocEstado == "C" || pedido.EstadoOperativo != "ING")
                {
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
                if (item != null && item.SocioCode != null)
                {
                    SocioPropiedades prop = mngcli.Propiedades("socios/propiedades");
                    btnGuardar.Visible = true;
                    btnGuardar.Enabled = true;
                    if (pedido.EstadoOperativo == "NUL")
                    {
                        btnGuardar.Visible = false;
                        btnGuardar.Enabled = false;
                    }

                }

                HttpContext.Current.Session["ProduccionCart"] = null;
                //ProduccionCart carro = ProduccionCart.Instance;
                carro = new ProduccionCart();
                carro.Clear();
                carro.Costo = pedido.Costo;
                carro.Neto = Convert.ToInt32(pedido.Neto);
                carro.Margen = pedido.Margen;
                carro.Iva = Convert.ToInt32(pedido.Iva);
                carro.Total = Convert.ToInt32(pedido.Total);
                carro.DocEntry = pedido.DocEntry;
                foreach (var i in pedido.Lineas)
                {
                    carro.AddItem(new CartItem
                    {
                        Cantidad = Convert.ToDecimal(i.CantidadSolicitada),
                        Costo = Convert.ToDecimal(i.Costo),
                        DocLinea = i.DocLinea,
                        LineaItem = i.LineaItem,
                        Margen = Convert.ToDecimal(i.Margen),
                        Precio = Convert.ToDecimal(i.PrecioFinal),
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
                        FrmtoVentaNombre = i.FrmtoVentaNombre,
                        OrigenCode = i.OrigenCode,
                        OrigenNombre = i.OrigenNombre,
                        CantidadAntarior = Convert.ToDecimal(i.SolicitadoAnterior)
                    });
                }
                lblNumeroPedido.Text = pedido.DocEntry.ToString();
                gvDetalle.DataSource = carro.Items;
                gvDetalle.DataBind();
                carro.Totalizar();
                carro.SaveInstance(carro);

                if (pedido.EstadoOperativo == "NUL")
                {
                    var mensaje = "Solicitud está Nula, no puede ser modificado";
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
            //ProduccionCart carro = ProduccionCart.Instance;
            ProduccionCart carro = new ProduccionCart();
            carro.Clear();
            gvDetalle.DataSource = carro.Items;
            gvDetalle.DataBind();
            btnGuardar.Visible = true;
            btnGuardar.Enabled = true;

        }
        protected void Nuevo_Event(object sender, EventArgs e)
        {
            Nuevo();
        }
    }
}