<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="venta-pedido.aspx.cs" Inherits="Colonos.Web.venta_pedido" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function openPdfPopup(pdfUrl) {
            console.log("dentro de openPdfPopup");
            var popup = window.open('view-pdf.aspx?file=' + encodeURIComponent(pdfUrl), 'PDF Viewer', 'width=850,height=600');
            popup.focus();
        }
    </script>

    <script>
        function SetActivaBotonActualizar() {
            console.log("llamada a SetActivaBotonActualizar");
            document.getElementById('ContentPlaceHolder1_btnActualizar').style.backgroundColor = "greenyellow";
            document.getElementById('ContentPlaceHolder1_btnActualizar').style.color = "black";
            document.getElementById("ContentPlaceHolder1_lnkb_BookCategories").disabled = true;
            console.log("1000");
            //var descargapdf = document.getElementById('MainContent_cmdDescargaPDF');
            var clonar = document.getElementById('ContentPlaceHolder1_btnClonar');
            console.log("1001");
            var guardar = document.getElementById('ContentPlaceHolder1_btnGuardar');
            console.log("1002");
            
            //if (descargapdf != null) {
            //    console.log("dentro de if");
            //    document.getElementById('MainContent_cmdDescargaPDF').style.display = "none";
            //}
            if (clonar != null) {
                console.log("dentro de clonar");
                document.getElementById('ContentPlaceHolder1_btnClonar').style.display = "none";
                console.log("1003");
            }
            if (guardar != null) {
                console.log("dentro de guardar");
                document.getElementById('ContentPlaceHolder1_btnGuardar').style.display = "none";
                console.log("1004");
            }
            console.log("1005");
        }
        function SetOcultarguardar() {
            console.log("llamada a SetOcultarguardar");
            //var descargapdf = document.getElementById('MainContent_cmdDescargaPDF');
            //var enviar = document.getElementById('MainContent_cmdEnviar');
            var btn = document.getElementById('ContentPlaceHolder1_btnGuardar');
            //if (descargapdf != null) {
            //    console.log("dentro de if");
            //    document.getElementById('MainContent_cmdDescargaPDF').style.display = "none";
            //}
            //if (enviar != null) {
            //    console.log("dentro de if2");
            //    document.getElementById('MainContent_cmdEnviar').style.display = "none";
            //}
            if (btn != null) {
                console.log("dentro de if3");
                document.getElementById('ContentPlaceHolder1_btnGuardar').style.display = "none";
            }
            return true;
        }
        function SetOcultarclonar() {
            console.log("llamada a SetOcultarclonar");
            var btn = document.getElementById('ContentPlaceHolder1_btnClonar');
            if (btn != null) {
                console.log("dentro de if3");
                document.getElementById('ContentPlaceHolder1_btnClonar').style.display = "none";
            }
            return true;
        }
    </script>

    <div>
        <!-- INI POPUP BUSQUEDA CLIENTES -->
        <asp:Panel ID="pnlBusquedaClientes" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1000px;">
            <div class="window-ficha-modal-sm">
                <div class="card-detail-window">
                    <asp:UpdatePanel runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvClientes" />
                            <asp:PostBackTrigger ControlID="LinkButton4" />
                            <asp:PostBackTrigger ControlID="txtPalabras" />
                            <asp:PostBackTrigger ControlID="cmdBuscar" />
                            <asp:PostBackTrigger ControlID="txtSocioCode" />
                            <%--<asp:PostBackTrigger ControlID="btnBuscar" />--%>
                        </Triggers>
                        <ContentTemplate>
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title">
                                        <asp:Label ID="Label28" runat="server" Text="Búsqueda de Clientes"></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton4" CssClass="btn-close" runat="server" TabIndex="-1" OnClick="ClosePopupBusquedaCliente"></asp:LinkButton>
                                </div>
                                <div class="modal-header">
                                    <div style="margin-left: auto; margin-right: auto; width: 90%;">
                                        <asp:TextBox ID="TextBox2" runat="server" TabIndex="-1" Visible="false"></asp:TextBox>
                                        <asp:Panel DefaultButton="cmdBuscar" runat="server">
                                            <div id="custom-search-input" style="border-width: 1px; border-color: gray;">
                                                <div class="input-group col-md-12">
                                                    <asp:TextBox ID="txtPalabras" CssClass="form-control input-lg" TabIndex="-1" placeholder="Rut o Nombre..." runat="server"></asp:TextBox>
                                                    <span class="input-group-btn">
                                                        <asp:LinkButton ID="cmdBuscar" runat="server" CssClass="btn btn-lg btn-secondary btn-busqueda"  TabIndex="-1" OnClick="BusquedaClientes"><i class="fa fa-search fa-md"></i></asp:LinkButton>
                                                    </span>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <asp:GridView ID="gvClientes" runat="server"
                                        CssClass="table table-sm table-bordered table-hover header-grid"
                                        HeaderStyle-CssClass="header-grid-small"
                                        RowStyle-CssClass="row-grid"
                                        AutoGenerateColumns="false"
                                        BorderStyle="None">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Código" HeaderStyle-Width="10%">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblCardCode" runat="server" OnClick="SelectCliente" Text='<%# Eval("SocioCode") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Razón Social" HeaderStyle-Width="45%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCardName" runat="server" Text='<%# Eval("RazonSocial") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="45%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Condición" HeaderStyle-Width="15%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSlpName" runat="server" Text='<%# Eval("CondicionNombre") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Tipo" HeaderStyle-Width="15%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblListName" runat="server" Text='<%# Eval("SocioTipoNombre") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Vendedor" HeaderStyle-Width="15%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblVendedor" runat="server" Text='<%# Eval("Vendedor") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <i class="fas fa-exclamation-circle fa-2x"></i>
                                            <span style="font-size: 25px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                                <div class="modal-footer">
                                    <div class="row w-100">
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>
        <!-- FIN POPUP BUSQUEDA CLIENTES -->
        
        <!-- INI POPUP BUSQUEDA PRODUCTOS -->
        <asp:Panel ID="pnlBusquedaProductos" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel5">
                                        <span>Busqueda Productos</span>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton11" CssClass="btn-close" runat="server" OnClick="ClosePopupBusquedaProductos"></asp:LinkButton>
                                </div>
                                <div class="modal-header">
                                    <div style="margin-left: auto; margin-right: auto; width: 90%;">
                                        <asp:Panel DefaultButton="btnBuscarProductos" runat="server">
                                            <div class="col-md-6 mx-auto">
                                                <span class="btn btn-nav">
                                                    <asp:CheckBox ID="chkSoloProductosB" Text="" runat="server"/><label style="margin-left:5px;" >Solo Productos B</label>
                                                </span>
                                                <div id="custom-search-input2">
                                                    <div class="input-group col-md-12">
                                                        <asp:TextBox ID="txtPalabrasProducto" CssClass="form-control input-lg foco" placeholder="¿qué estas buscando?..." runat="server"></asp:TextBox>
                                                        <span class="input-group-btn">
                                                            <asp:LinkButton ID="btnBuscarProductos" runat="server" CssClass="btn btn-lg btn-secondary btn-busqueda" OnClick="Cargaprod"><i class="fa fa-search fa-md"></i></asp:LinkButton>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </div>
                                <%--</div>--%>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row justify-content-end mb-2">
                                        <div class="col-sm-2">
                                            <asp:LinkButton ID="btnAgregar" runat="server" CssClass="btn btn-sm btn-danger float-end" OnClick="AddProductoSeleccionado">Agregar <i class="fas fa-external-link-alt"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                    <div class="row" style="height: 50vh;overflow: auto;">
                                        <asp:GridView ID="gvResultado" runat="server"
                                            AutoGenerateColumns="False"
                                            AllowPaging="false"
                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                            HeaderStyle-CssClass="header-grid-small headfijo fw-bold"
                                            RowStyle-CssClass="row-grid"
                                            Caption=""
                                            CaptionAlign="Top"
                                            AllowSorting="true"
                                            OnRowDataBound="gvResultado_RowDataBound">
                                            <Columns>
                                                <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"><HeaderTemplate><asp:CheckBox ID="checkbox2" AutoPostBack="true" OnCheckedChanged="CheckAllProductos" runat="server" /></HeaderTemplate><ItemTemplate><asp:CheckBox ID="chkSeleccionado" runat="server" /></ItemTemplate><ItemStyle Width="2%" HorizontalAlign="Left"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Candidad" Visible="false" ><ItemTemplate><asp:TextBox ID="txtCantidad" runat="server" CssClass="w-100 text-end" Text="0" ></asp:TextBox></ItemTemplate><ItemStyle Width="2%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Tipo"><ItemTemplate><asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo")%>' /></ItemTemplate><ItemStyle Width="2%" HorizontalAlign="Center"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Tiene Receta" Visible="false"><ItemTemplate><asp:Label ID="lblTieneReceta" runat="server" Text='<%# Eval("TieneReceta")%>' /></ItemTemplate><ItemStyle Width="2%" HorizontalAlign="Center"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Stock Toledo"><ItemTemplate><asp:Label ID="lblStockToledo" runat="server" Text='<%# Eval("StockToledo","{0:N0}")%>' /></ItemTemplate><ItemStyle Width="5%" HorizontalAlign="Right"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Asignado Toledo"><ItemTemplate><asp:Label ID="lblAsignadoToledo" runat="server" Text='<%# Eval("AsignadoToledo","{0:N0}")%>' /></ItemTemplate><ItemStyle Width="5%" HorizontalAlign="Right"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Disponible Receta" Visible="false"><ItemTemplate><asp:Label ID="lblDisponibleReceta" runat="server" Text='<%# Eval("DisponibleReceta","{0:N2}")%>' /></ItemTemplate><ItemStyle Width="5%" HorizontalAlign="Right"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="SKU" ItemStyle-HorizontalAlign="center"><ItemTemplate><asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode")%>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Descripción"><ItemTemplate><asp:Label ID="lblDescripcion" runat="server" Text='<%# Eval("ProdNombre")%>' /></ItemTemplate><ItemStyle Width="23%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Marca"><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre")%>' /></ItemTemplate><ItemStyle Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Origen"><ItemTemplate><asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre")%>' /></ItemTemplate><ItemStyle Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Medida" Visible="false"><ItemTemplate><asp:Label ID="lblMedidaNombre" runat="server" Text='<%# Eval("MedidaNombre")%>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Formato" Visible="true"><ItemTemplate><asp:Label ID="lblFrmtoVenta" runat="server" Text='<%# Eval("FormatoNombre")%>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Refrigeración" ><ItemTemplate><asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre")%>' /></ItemTemplate><ItemStyle Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Formato Venta" Visible="true"><ItemTemplate><asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Disponible"><ItemTemplate><asp:Label ID="lblDisponible" runat="server" Text='<%# Eval("Disponible","{0:N2}")%>' /></ItemTemplate><ItemStyle Width="8%" HorizontalAlign="Right"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Precio <br/> Normal" HeaderStyle-HorizontalAlign="Right"><ItemTemplate><asp:Label ID="lblPrecioUnitario" runat="server" Width="60" Text='<%# Eval("PrecioUnitario","{0:C0}")%>' /></ItemTemplate><ItemStyle Width="5%" HorizontalAlign="Right"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Precio <br/> Volumen" HeaderStyle-HorizontalAlign="Right"><ItemTemplate><asp:Label ID="lblPrecioVolumen" runat="server" Width="60" Text='<%# Eval("PrecioVolumen","{0:C0}")%>' /></ItemTemplate><ItemStyle Width="5%" HorizontalAlign="Right"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Precio <br/> Fijo" HeaderStyle-HorizontalAlign="Right"><ItemTemplate><asp:Label ID="lblPrecioFijo" runat="server" Width="60" Text='<%# Eval("PrecioFijo","{0:C0}")%>' /></ItemTemplate><ItemStyle Width="5%" HorizontalAlign="Right"></ItemStyle>                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="RefrigeracionRefrigeraCode" Visible="false" ><ItemTemplate><asp:Label ID="lblRefrigeraCode" runat="server" Text='<%# Eval("RefrigeraCode")%>' /></ItemTemplate><ItemStyle Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Bodega" Visible="false"><ItemTemplate><asp:Label ID="lblBodegaCode" runat="server" Text='<%# Eval("BodegaCode")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Costo" Visible="false"><ItemTemplate><asp:Label ID="lblCosto" runat="server" Text='<%# Eval("Costo")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Volumen" Visible="false"><ItemTemplate><asp:Label ID="lblVolumen" runat="server" Text='<%# Eval("Volumen")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="AnimalCode" Visible="false"><ItemTemplate><asp:Label ID="lblAnimalCode" runat="server" Text='<%# Eval("AnimalCode")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="AnimalNombre" Visible="false"><ItemTemplate><asp:Label ID="lblAnimalNombre" runat="server" Text='<%# Eval("AnimalNombre")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="FamiliaCode" Visible="false"><ItemTemplate><asp:Label ID="lblFamiliaCode" runat="server" Text='<%# Eval("FamiliaCode")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="FamiliaNombre" Visible="false"><ItemTemplate><asp:Label ID="lblFamiliaNombre" runat="server" Text='<%# Eval("FamiliaNombre")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="MarcaCode" Visible="false"><ItemTemplate><asp:Label ID="lblMarcaCode" runat="server" Text='<%# Eval("MarcaCode")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="FormatoCode" Visible="false"><ItemTemplate><asp:Label ID="lblFormatoCode" runat="server" Text='<%# Eval("FormatoCode")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="FormatoVtaCode" Visible="false"><ItemTemplate><asp:Label ID="lblFormatoVtaCode" runat="server" Text='<%# Eval("FormatoVtaCode")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                
                                                <asp:TemplateField HeaderText="Factorprecio" Visible="false"><ItemTemplate><asp:Label ID="lblFactorprecio" runat="server" Text='<%# Eval("Factorprecio")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="DescVolumen" Visible="false"><ItemTemplate><asp:Label ID="lblDescVolumen" runat="server" Text='<%# Eval("DescVolumen")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="MargenRegla" Visible="false"><ItemTemplate><asp:Label ID="lblMargenRegla" runat="server" Width="80" Text='<%# Eval("Margen")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="OrigenCode" Visible="false"><ItemTemplate><asp:Label ID="lblOrigenCode" runat="server" Width="80" Text='<%# Eval("OrigenCode")%>' /></ItemTemplate><ItemStyle Width="5%"></ItemStyle></asp:TemplateField>
                                                
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <i class="fas fa-exclamation-circle fa-lg"></i>
                                                <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                            </EmptyDataTemplate>
                                    </asp:GridView>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <asp:Button ID="Button1" CssClass="btn btn-secondary btn-sm" runat="server" OnClick="ClosePopupBusquedaProductos" Text="Cerrar" />

                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
        <!-- FIN POPUP BUSQUEDA PRODUCTOS -->

        <!-- INI POPUP BUSQUEDA PEDIDOS -->
        <asp:Panel ID="pnlBusquedaPedidos" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1000px;">
            <div class="window-ficha-modal-sm">
                <div class="card-detail-window">
                    <asp:UpdatePanel runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvPedidos" />
                            <asp:PostBackTrigger ControlID="txtPalabrasPupup" />
                            <%--<asp:PostBackTrigger ControlID="btnBuscar" />--%>
                            <asp:PostBackTrigger ControlID="txtSocioCode" />
                            <asp:PostBackTrigger ControlID="btnBuscarPedidoPupup" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title">
                                        <asp:Label ID="Label1" runat="server" Text="Búsqueda Pedidos de Venta"></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="brnClosePupupPedidos" CssClass="btn-close" runat="server" TabIndex="-1" OnClick="ClosePopupBusquedaPedidos"></asp:LinkButton>
                                </div>
                                <div class="modal-header">
                                    <div style="margin-left: auto; margin-right: auto; width: 90%;">
                                        <asp:TextBox ID="TextBox1" runat="server" TabIndex="-1" Visible="false"></asp:TextBox>
                                        <asp:Panel DefaultButton="btnBuscarPedidoPupup" runat="server">
                                            <div id="custom-search-inputp1" style="border-width: 1px; border-color: gray;">
                                                <div class="input-group col-md-12">
                                                    <asp:TextBox ID="txtPalabrasPupup" CssClass="form-control input-lg" TabIndex="-1" placeholder="Buscar..." runat="server"></asp:TextBox>
                                                    <span class="input-group-btn">
                                                        <asp:LinkButton ID="btnBuscarPedidoPupup" runat="server" CssClass="btn btn-lg btn-secondary btn-busqueda"  TabIndex="-1" OnClick="BuscarPedido_Event"><i class="fa fa-search fa-md"></i></asp:LinkButton>
                                                    </span>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <asp:GridView ID="gvPedidos" runat="server"
                                        CssClass="table table-sm table-bordered table-hover header-grid"
                                        HeaderStyle-CssClass="header-grid-small"
                                        RowStyle-CssClass="row-grid"
                                        AutoGenerateColumns="false"
                                        BorderStyle="None">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Numero">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblDocEntry" runat="server" OnClick="SelectPedido" Text='<%# Eval("DocEntry") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Id Cliente">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSocioCode" runat="server" Text='<%# Eval("SocioCode") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Razón Social">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCardName" runat="server" Text='<%# Eval("RazonSocial") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="45%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Estado">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDocEstado" runat="server" Text='<%# Eval("DocEstado") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Neto" >
                                                <ItemTemplate>
                                                    <asp:Label ID="lblNeto" runat="server" Text='<%# Eval("Neto","{0:C0}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Estado Operativo">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEstadoOperativo" runat="server" Text='<%# Eval("EstadoOperativo") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Vendedor">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorCode") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <i class="fas fa-exclamation-circle fa-2x"></i>
                                            <span style="font-size: 25px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                                <div class="modal-footer">
                                    <div class="row w-100">
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>
        <!-- FIN POPUP BUSQUEDA PEDIDOS -->

        <!-- INI POPUP ULTIMOS PRECIOS -->
        <asp:Panel ID="pnlUltimosPrecios" runat="server" TabIndex="-1" Style="display: none; width: 50%; max-width: 550px;">
            <div class="window-ficha-modal-sm">
                <div class="card-detail-window">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title">
                                        <asp:Label ID="Label2" runat="server" CssClass="d-block" Text="Ultimos Precios Familia-Cliente"></asp:Label>
                                        <asp:Label ID="lblFamiliaTitulo" runat="server" ForeColor="PaleGoldenrod" CssClass="d-block" Text=""></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton1" CssClass="btn-close" runat="server" TabIndex="-1" OnClick="ClosePopupUltimosPrecios"></asp:LinkButton>
                                </div>
                                <div class="modal-header">
                                    
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 500px;">
                                    <asp:GridView ID="gvUltimosPrecios" runat="server"
                                        CssClass="table table-sm table-bordered table-hover header-grid"
                                        HeaderStyle-CssClass="header-grid-small"
                                        RowStyle-CssClass="row-grid"
                                        AutoGenerateColumns="false"
                                        BorderStyle="None">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Familia" Visible="false"><ItemTemplate><asp:Label ID="lblFamilia" runat="server" Text='<%# Eval("Familia") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                            <asp:TemplateField HeaderText="Origen"><ItemTemplate><asp:Label ID="lblOrigen" runat="server" Text='<%# Eval("Origen") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                            <asp:TemplateField HeaderText="Marca"><ItemTemplate><asp:Label ID="lblMarca" runat="server" Text='<%# Eval("Marca") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                            <asp:TemplateField HeaderText="TipoDoc"><ItemTemplate><asp:Label ID="lblTipoDoc" runat="server" Text='<%# Eval("TipoDoc") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                            <asp:TemplateField HeaderText="Fecha"><ItemTemplate><asp:Label ID="lblFecha" runat="server" Text='<%# Eval("Fecha","{0:dd/MM/yyyy}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                            <asp:TemplateField HeaderText="Cantidad"><ItemTemplate><asp:Label ID="lblCantidad" runat="server" Text='<%# Eval("Cantidad","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                            <asp:TemplateField HeaderText="Precio"><ItemTemplate><asp:Label ID="lblPrecio" runat="server" Text='<%# Eval("Precio","{0:C0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                        </Columns><EmptyDataTemplate><i class="fas fa-exclamation-circle fa-2x"></i><span style="font-size: 25px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span></EmptyDataTemplate></asp:GridView>
                                </div>
                                <div class="modal-footer">
                                    <div class="row w-100">
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>
        <!-- FIN POPUP ULTIMOS PRECIOS -->
        <div class="container-fluid">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="chkFechadeEntrega" />
                </Triggers>
                <ContentTemplate>
                    <div class="loading-overlay" id="loadingOverlay" style="z-index:50001;">
                        <div class="loading-spinner"></div>
                    </div>
                    <div class="card card-top" >
                        <div class="card-header fw-bold font-size-xx-large">
                            Pedido de Venta
                        </div>
                        <div class="card-body overflow-auto">
                            <nav id="navpedido" runat="server" class="navbar navbar-expand-lg navbar-light nav-toolbar" style="height: 55px;z-index:5000;">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse" id="mynavbar">
                                        <ul class="navbar-nav">
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnNuevo" CssClass="btn btn-nav" runat="server" Visible="false" OnClick="Nuevo_Event"><i class="far fa-file p-1"></i>Nuevo</asp:LinkButton>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnGuardar" CssClass="btn btn-nav" runat="server" OnClientClick="showLoading()" OnClick="Guardar_Event"><i class="far fa-save p-1"></i>Guardar</asp:LinkButton>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnClonar" CssClass="btn btn-nav" runat="server" OnClick="Clonar_Event"><i class="far fa-copy p-1"></i>Clonar</asp:LinkButton>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnImprimir" CssClass="btn btn-nav" OnClientClick="showLoading()"   OnClick="ImprimirPedido_Event" runat="server"><i class="fas fa-print p-1"></i>Imprimir</asp:LinkButton>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="float-end">
                                        <h5 style="color:#a30d2b; margin-right:10px;">Pedido:<asp:Label ID="lblNumeroPedido" CssClass="p-1"  ForeColor="#a30d2b" runat="server" Text=""></asp:Label></h5>
                                    </div>
                                </div>
                            </nav>
                            <div class="row navbar navbar-expand-lg navbar-light nav-toolbar m-0 p-0" style="background-color:cornsilk;">
                                <div class="col-sm-6 p-2 text-truncate">
                                    <asp:Label ID="lblClienteBar" runat="server" CssClass="font-size-large" ForeColor="#a9202c" Text=""></asp:Label>
                                </div>
                                <div class="col-sm-6 p-2 text-truncate">
                                    <asp:Label ID="lblVendedorBar" runat="server" CssClass="font-size-large" ForeColor="#a9202c" Text=""></asp:Label>
                                </div>
                            </div>
                            <asp:MultiView ID="mviewMain" runat="Server" ActiveViewIndex="0">
                                <asp:View ID="ClienteView" runat="Server">
                                    <asp:Panel ID="panelNavigatonView1" runat="server" CssClass="TabContainer">
                                        <asp:Label ID="labOne" runat="Server" CssClass="TabItemActive" Text="Datos Cliente" />
                                        <asp:LinkButton ID="lnkb_DefaultBook" CssClass="TabItemInactive" Text="Detalle Productos" runat="Server" OnCommand="LinkButton_Command" CommandName="Detalle" />
                                        <asp:LinkButton ID="lnkb_DefaultCategories" CssClass="TabItemInactive" Text="Dirección de Entrega" runat="server" OnCommand="LinkButton_Command" CommandName="Direccion" />
                                    </asp:Panel>
                                    <asp:Panel ID="panelView1" runat="server" CssClass="ContentPanel">
                                        <div class="row mb-2">
                                            <div class="col-sm-4">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Código</span>
                                                    <asp:TextBox ID="txtSocioCode" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                    <asp:LinkButton ID="btnBuscarClientes" CssClass="input-group-text" runat="server" OnClick="LoadBuscarCliente" ><i class="fas fa-search"></i></asp:LinkButton>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Razón Social</span>
                                                    <asp:TextBox ID="txtSocioName" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Estado Cliente</span>
                                                    <asp:TextBox ID="txtEstadoCliente" runat="server" ReadOnly="true" Font-Bold="true" CssClass="form-control text-center"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Rut</span>
                                                    <asp:TextBox ID="txtRut" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Condición Pago</span>
                                                    <asp:DropDownList ID="cboCondicion" CssClass="form-select" runat="server"></asp:DropDownList>
                                                </div>
                                                
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Contacto</span>
                                                    <asp:DropDownList ID="cboContactos" CssClass="form-select" runat="server"></asp:DropDownList>
                                                    <asp:LinkButton ID="cboVerContactos" CssClass="input-group-text" runat="server"><i class="far fa-eye"></i></asp:LinkButton>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Rubro</span>
                                                    <asp:TextBox ID="txtRubro" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-sm-4">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Número</span>
                                                    <asp:TextBox ID="txtNumero" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Fecha</span>
                                                    <asp:TextBox ID="txtFecha" runat="server" ReadOnly="true" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Estado</span>
                                                    <asp:TextBox ID="txtEstado" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <asp:TextBox ID="txtMotivoRechazo" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" >Vendedor</span>
                                                    <%--<asp:TextBox ID="txtVendedor" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>--%>
                                                    <asp:DropDownList ID="cboVendedor" CssClass="form-select" BackColor="White" Enabled="false" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">Neto</span>
                                                    <asp:TextBox ID="txtNetoDetalle" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                </div>
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption">OC Cliente</span>
                                                    <asp:TextBox ID="txtReferencia" runat="server" CssClass="form-control"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-sm-4">
                                                <div class="card max-height-topem">
                                                    <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                        Historial del Pedido
                                                    </div>
                                                    <div class="card-body overflow-auto">
                                                        <asp:GridView ID="gvHistorial"
                                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                                            runat="server" 
                                                            AutoGenerateColumns="false"
                                                            RowStyle-CssClass="row-grid"
                                                            HeaderStyle-CssClass="header-grid-small"
                                                            >
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Fecha">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblFechaRegistro" runat="server" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" Width="30%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Tipo">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Left" Width="40%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Estado">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblEstado" runat="server" Text='<%# Eval("Estado") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Numero">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblNumero" runat="server" Text='<%# Eval("Numero") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" Width="20%"></ItemStyle>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <PagerStyle CssClass="pagination-ys" />
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <div class="card max-height-topem">
                                                    <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                    Top 10 Productos del Cliente
                                                    </div>
                                                    <div class="card-body overflow-y-auto">
                                                        <asp:GridView ID="gvTopCliente"
                                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                                            runat="server" 
                                                            AutoGenerateColumns="false"
                                                            RowStyle-CssClass="row-grid"
                                                            HeaderStyle-CssClass="header-grid-small"
                                                            >
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Ranking">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblRanking" runat="server" Text='<%# Eval("Ranking") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Familia">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblFamilia" runat="server" Text='<%# Eval("FamiliaNombre") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Left" Width="60%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Kilos">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblKilos" runat="server" Text='<%# Eval("Kilos","{0:N2}") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Right" Width="30%"></ItemStyle>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <PagerStyle CssClass="pagination-ys" />
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-4">
                                                <div class="card max-height-topem">
                                                    <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                        Ultimas Ventas
                                                    </div>
                                                    <div class="card-body overflow-auto">
                                                        <asp:GridView ID="gvVentas"
                                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                                            runat="server" 
                                                            AutoGenerateColumns="false"
                                                            RowStyle-CssClass="row-grid"
                                                            HeaderStyle-CssClass="header-grid-small"
                                                            >
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Numero">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Fecha">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblDocFecha" runat="server" Text='<%# Eval("DocFecha","{0:dd/MM/yyyy}") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" Width="25%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Días">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblDias" runat="server" Text='<%# Eval("Dias") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Neto">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblNeto" runat="server" Text='<%#Eval("Neto","{0:C0}") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Right" Width="25%"></ItemStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Estado">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblEstadoOperativo" runat="server" Text='<%# Eval("EstadoOperativo") %>' />
                                                                    </ItemTemplate>
                                                                    <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <PagerStyle CssClass="pagination-ys" />
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </asp:View>

                                <asp:View ID="DetalleView" runat="Server">
                                    <asp:Panel ID="panelNavigatonView2" runat="server" CssClass="TabContainer">
                                        <asp:LinkButton ID="lnkb_BookCustomer" runat="Server"  CssClass="TabItemInactive" Text="Datos Cliente" OnCommand="LinkButton_Command" CommandName="Cliente" />
                                        <asp:Label ID="Label3" runat="Server" CssClass="TabItemActive" Text="Detalle Productos" />
                                        <asp:LinkButton ID="lnkb_BookCategories" runat="server" CssClass="TabItemInactive" Text="Dirección de Entrega" OnCommand="LinkButton_Command" CommandName="Direccion" />
                                    </asp:Panel>
                                    <asp:Panel ID="panelView2" runat="server" CssClass="ContentPanel">
                                        <div>
                                            <div class="row mb-1">
                                                <div class="col-sm-1">
                                                    <asp:LinkButton ID="btnAddProducto" runat="server" CssClass="btn btn-sm btn-outline-dark w-100 p-1" OnClick="BusquedaProductos_Event">Agregar Productos</asp:LinkButton>
                                                </div>
                                                <div class="col-sm-1">
                                                    <asp:LinkButton ID="btnEliminar" runat="server" CssClass="btn btn-sm btn-outline-dark w-100 p-1" OnClick="EliminarSeleccionados_Event">Eliminar Selección</asp:LinkButton>
                                                </div>
                                                <div class="col-sm-10">
                                                    <asp:LinkButton ID="btnActualizar" runat="server" CssClass="btn btn-sm btn-secondary float-end p-1" OnClick="ActualizarCarro">Actualizar</asp:LinkButton>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <div style="max-height: 350px;overflow: auto;">
                                                        <asp:GridView ID="gvDetalle"
                                                        CssClass="table table-sm table-bordered table-hover header-grid"
                                                        AutoGenerateColumns="False"
                                                        runat="server" 
                                                        AllowPaging="false" 
                                                        RowStyle-CssClass="row-grid"
                                                        HeaderStyle-CssClass="header-grid-small headfijo"
                                                        OnRowDataBound="gvDetalle_RowDataBound"
                                                        >
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="*" HeaderStyle-CssClass="" HeaderStyle-HorizontalAlign="Center"><ItemTemplate><asp:CheckBox ID="chkSelItem" runat="server" /></ItemTemplate>             <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="DocLinea" HeaderStyle-CssClass="" Visible="false"><ItemTemplate>         <asp:Label ID="lblDocLinea" runat="server" Text='<%# Eval("DocLinea") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="LineaItem" HeaderStyle-CssClass="" Visible="false"><ItemTemplate>         <asp:Label ID="lblLineaItem" runat="server" Text='<%# Eval("LineaItem") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Tipo" HeaderStyle-CssClass=""><ItemTemplate>         <asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombre" runat="server" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Medida" HeaderStyle-CssClass="" Visible="false"><ItemTemplate>       <asp:Label ID="lblMedida" runat="server" Text='<%# Eval("MedidaNombre") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Left" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Stock Toledo" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="lblStockToledo" runat="server" Text='<%# Eval("StockToledo","{0:N2}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Asignado Toledo" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="lblAsignadoToledo" runat="server" Text='<%# Eval("AsignadoToledo","{0:N2}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Disponible" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="lblDisponible" runat="server" Text='<%# Eval("Disponible","{0:N2}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="3%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Marca" HeaderStyle-CssClass=""><ItemTemplate>        <asp:Label ID="lblMarca" runat="server" Text='<%# Eval("MarcaNombre")%>' /></ItemTemplate>                     <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Origen" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="lblOrigen" runat="server" Text='<%# Eval("Origen")%>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Formato Venta" HeaderStyle-CssClass="" Visible="false"><ItemTemplate>   <asp:Label ID="lblFrmtoVenta" runat="server" Text='<%# Eval("FrmtoVenta") %>' /></ItemTemplate>       <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeracion" runat="server" Text='<%# Eval("RefrigeraNombre")%>' /></ItemTemplate>     <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Familia" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFamiliaNombre" runat="server" Text='<%# Eval("FamiliaNombre")%>' /></ItemTemplate>     <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="FamiliaCode" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblFamiliaCode" runat="server" Text='<%# Eval("FamiliaCode")%>' /></ItemTemplate>     <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Volumen" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVolumen" runat="server" Text='<%# Eval("Volumen","{0:N2}")%>' /></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Precio Normal" HeaderStyle-CssClass=""><ItemTemplate>   <asp:LinkButton ID="lblPrecioUnitario" runat="server" OnClick="UltimosPrecios_Event" Text='<%# Eval("PrecioUnitario","{0:N0}") %>'  /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Precio Volumen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioVolumen" runat="server" Text='<%# Eval("PrecioVolumen","{0:N0}") %>'  /></ItemTemplate> <ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Precio Fijo" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblPrecioFijo" runat="server" Text='<%# Eval("PrecioFijo","{0:N0}") %>'  /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Cantidad" HeaderStyle-CssClass="">
                                                                <ItemTemplate>     
                                                                    <asp:TextBox ID="txtCantidad" onblur="SetActivaBotonActualizar()" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("Cantidad") %>'></asp:TextBox>
                                                                    <asp:RegularExpressionValidator ID="NumericOnlyValidator" SetFocusOnError="true" runat="server" ControlToValidate="txtCantidad" ErrorMessage="valor incorrecto" CssClass="d-block" ForeColor="Red" ValidationExpression="^((?:[1-9]\d*)|(?:(?=[\d.]+)(?:[1-9]\d*|0).\d+))$"></asp:RegularExpressionValidator>
                                                                </ItemTemplate><ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Precio" HeaderStyle-CssClass="">
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="txtPrecio" onblur="SetActivaBotonActualizar()" Width="90" CssClass="text-end" runat="server" Text='<%# Eval("Precio") %>'></asp:TextBox>
                                                                    <asp:RegularExpressionValidator ID="NumericOnlyValidator2" runat="server" ControlToValidate="txtPrecio" CssClass="d-block" ErrorMessage="valor incorrecto" ForeColor="Red" ValidationExpression="^((?:[1-9]\d*))$"></asp:RegularExpressionValidator>
                                                                </ItemTemplate>   <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                                            
                                                            <asp:TemplateField HeaderText="Total Neto" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="txtTotal" Width="100" runat="server" Text='<%# Eval("Total","{0:C0}") %>'></asp:Label></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="12%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Margen" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="lblMargen" Width="50" runat="server" Text='<%# Eval("Margen","{0:P1}") %>'></asp:Label></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="12%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Costo<br/> Unitario" HeaderStyle-CssClass="" Visible="true"><ItemTemplate>       <asp:Label ID="lblCosto" CssClass="text-end" runat="server" Text='<%# Eval("Costo","{0:N2}") %>'></asp:Label></ItemTemplate>   <ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>


                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            <i class="fas fa-exclamation-circle"></i>
                                                            <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                                        </EmptyDataTemplate>
                                                        <PagerStyle CssClass="pagination-ys" />
                                                    </asp:GridView>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row justify-content-between" style="max-height: 350px;overflow: auto;">
                                                <div class="col-sm-4">
                                                    <div class="card max-height-topem">
                                                        <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                            Top 10 Productos del Rubro
                                                        </div>
                                                        <div class="card-body overflow-auto">
                                                            <asp:GridView ID="gvTopRubro"
                                                                CssClass="table table-sm table-bordered table-hover header-grid"
                                                                runat="server" 
                                                                AutoGenerateColumns="false"
                                                                RowStyle-CssClass="row-grid"
                                                                HeaderStyle-CssClass="header-grid-small"
                                                                >
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="Ranking">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblRanking" runat="server" Text='<%# Eval("Ranking") %>' />
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Familia">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblFamilia" runat="server" Text='<%# Eval("FamiliaNombre") %>' />
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Left" Width="60%"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Kilos">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblKilos" runat="server" Text='<%# Eval("Kilos","{0:N2}") %>' />
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Right" Width="30%"></ItemStyle>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                                <PagerStyle CssClass="pagination-ys" />
                                                            </asp:GridView>
                                                        </div>
                                                </div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Instrucciones del Pedido </span>
                                                        <asp:TextBox ID="txtInstrucciones" runat="server" TextMode="MultiLine" MaxLength="200" Rows="4"  CssClass="form-control text-start"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="col-sm-3">
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Neto </span>
                                                        <asp:TextBox ID="txtNeto" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">IVA</span>
                                                        <asp:TextBox ID="txtIva" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Total</span>
                                                        <asp:TextBox ID="txtTotal" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                    
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Margen</span>
                                                        <asp:TextBox ID="txtMagenDetalle" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:Button ID="view2Back" runat="Server" Text="Previous." CommandName="PrevView" Width="6em" />
                                        <asp:Button ID="view2Next" runat="Server" Text="Next." CommandName="NextView" Width="6em" />
                                        
                                    </asp:Panel>
                                </asp:View>

                                <asp:View ID="DireccionView" runat="Server">
                                    <asp:Panel ID="panelNavigatonView3" runat="server" CssClass="TabContainer">
                                        <asp:LinkButton ID="lnkb_CategoriesCustomer" runat="Server" CssClass="TabItemInactive" Text="Datos Cliente" OnCommand="LinkButton_Command" CommandName="Cliente" />
                                        <asp:LinkButton ID="lnkb_CategoriesBook" runat="Server" CssClass="TabItemInactive" Text="Detalle Productos" OnCommand="LinkButton_Command" CommandName="Detalle" />
                                        <asp:Label ID="Label4" runat="Server" CssClass="TabItemActive" Text="Dirección de Entrega" /> 
                                        
                                    </asp:Panel>
                                    <asp:Panel ID="panelView3" runat="server" CssClass="ContentPanel">
                                        <div class="row justify-content-md-center">
                                            <div class="col-sm-10">
                                                <div class="row mb-2" style="display: flex;justify-content: space-between;">
                                                    <div class="col-sm-3">
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text label-caption">Retira Cliente</span>
                                                            <asp:CheckBox ID="chkRetiraCliente" CssClass="form-control text-center" runat="server"  />
                                                        </div>
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text label-caption">Fecha Entrega</span>
                                                            <asp:TextBox ID="txtFechaEntrega" runat="server" TextMode="Date" Enabled="false" CssClass="form-control"></asp:TextBox>
                                                            <div class="w-100">
                                                                <asp:CheckBox ID="chkFechadeEntrega" runat="server" CssClass="d-inline-block" AutoPostBack="true" OnCheckedChanged="chkFechadeEntrega_OnCheckedChanged" Text="" />
                                                                <label class="d-inline-block p-1" style="color:blue;" >Indicar Fecha de Entrega</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <asp:LinkButton ID="btnSincronizarDirecciones" runat="server" CssClass="btn btn-sm btn-success float-end" OnClick="SincronizarDirecciones_Event" >Actualizar Direcciones</asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row justify-content-center">
                                            <div class="col-sm-10">
                                                <div style="max-height: 350px;overflow: auto;">
                                                    <asp:GridView ID="gvDirecciones"
                                                CssClass="table table-sm table-bordered table-hover header-grid"
                                                AutoGenerateColumns="False"
                                                runat="server" 
                                                AllowPaging="false" 
                                                RowStyle-CssClass="row-grid"
                                                HeaderStyle-CssClass="header-grid-small headfijo"
                                                >
                                                <Columns>
                                                    <asp:TemplateField HeaderText="*" HeaderStyle-HorizontalAlign="Center"><ItemTemplate><asp:CheckBox ID="chkSelDireccion" runat="server" /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Id" Visible="false"><ItemTemplate><asp:Label ID="lblDireccionCode" runat="server" Text='<%# Eval("DireccionCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Calle"><ItemTemplate><asp:Label ID="lblCalle" runat="server" Text='<%# Eval("Calle") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Numero"><ItemTemplate><asp:Label ID="lblNumero" runat="server" Text='<%# Eval("Numero") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Comuna"><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                    <%--<asp:TemplateField HeaderText="Ciudad"><ItemTemplate><asp:Label ID="lblCiudadNombre" runat="server" Text='<%# Eval("CiudadNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>--%>
                                                    <%--<asp:TemplateField HeaderText="Región"><ItemTemplate><asp:Label ID="lblRegionNombre" runat="server" Text='<%# Eval("RegionNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle></asp:TemplateField>--%>
                                                    <asp:TemplateField HeaderText="Horario de Atencion"><ItemTemplate><asp:Label ID="lblHorarioAtencion" runat="server" Text='<%# Eval("HorarioAtencion") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Observaciones"><ItemTemplate><asp:Label ID="lblObservaciones" runat="server" Text='<%# Eval("Observaciones") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="25%"></ItemStyle></asp:TemplateField>
                                                </Columns>
                                                    <EmptyDataTemplate>
                                                        <i class="fas fa-exclamation-circle"></i>
                                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                                    </EmptyDataTemplate>
                                                    <PagerStyle CssClass="pagination-ys" />
                                            </asp:GridView>
                                                </div>
                                            </div>
                                        </div>
                                        <asp:Button ID="view3Prev" runat="Server" Text="Previous.." CommandName="PrevView" Width="6em" />
                                        <asp:Button ID="view3First" runat="Server" Text="Start.." CommandName="SwitchViewByIndex" CommandArgument="0" Width="6em" />
                                    </asp:Panel>
                                </asp:View>
                            </asp:MultiView>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

        <asp:LinkButton ID="lnkFake2" runat="server"></asp:LinkButton>
        <cc1:ModalPopupExtender
            ID="popupBusquedaClientes" runat="server"
            DropShadow="false"
            PopupControlID="pnlBusquedaClientes"
            TargetControlID="lnkFake2"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:LinkButton ID="lnkFake3" runat="server"></asp:LinkButton>
        <cc1:ModalPopupExtender
            ID="popupBusquedaProductos" runat="server"
            DropShadow="false"
            PopupControlID="pnlBusquedaProductos"
            TargetControlID="lnkFake3"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>

        <asp:LinkButton ID="lnkFake4" runat="server"></asp:LinkButton>
        <cc1:ModalPopupExtender
            ID="popupBusquedaPedidos" runat="server"
            DropShadow="false"
            PopupControlID="pnlBusquedaPedidos"
            TargetControlID="lnkFake4"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>
        
        <asp:LinkButton ID="lnkFake5" runat="server"></asp:LinkButton>
        <cc1:ModalPopupExtender
            ID="popupUltimosPrecios" runat="server"
            DropShadow="false"
            PopupControlID="pnlUltimosPrecios"
            TargetControlID="lnkFake5"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>
        
    </div>
</asp:Content>
