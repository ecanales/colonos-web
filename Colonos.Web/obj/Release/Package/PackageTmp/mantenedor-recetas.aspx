<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="mantenedor-recetas.aspx.cs" Inherits="Colonos.Web.mantenedor_recetas" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- INI POPUP PRODUCTO -->
    <asp:Panel ID="pnlProducto" runat="server" Style="display: none; width:90%;max-width:1000px;min-width:500px;">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnGuardar" />
                
            </Triggers>
            <ContentTemplate>
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header2 color-negro2">
                                <h2 class="modal-title p-1" id="exampleModalLiveLabel3">
                                    <span>
                                        <asp:Label ID="lblTituloPopup" runat="server" CssClass="p-2" Text="Receta"></asp:Label>
                                    </span>
                                    <asp:LinkButton ID="btnClose" CssClass="btn-close p-sm-2 m-1 float-end font-size-large" runat="server" OnClick="ClosePopup"></asp:LinkButton>
                                </h2>
                                
                            </div>

                            <div class="modal-body p-3" style="max-height: 500px; min-height: 200px;">
                                <div>
                                    <div class="row justify-content-center">
                                        <div class="col-sm-11">
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Código (SKU)</span><asp:TextBox ID="txtItemCode" runat="server" ReadOnly="true" CssClass="form-control" placeholder="sku"></asp:TextBox><asp:LinkButton ID="btnBuscarProductos" runat="server" OnClick="BuscarProductoReceta_Event" CssClass="input-group-text"><i class="fas fa-search"></i></asp:LinkButton></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Descripción</span><asp:TextBox ID="txtItemName" runat="server" ReadOnly="true" CssClass="form-control" placeholder="descripción"></asp:TextBox></div>
                                        </div>
                                    </div>
                                    <div class="row mb-2 justify-content-center">
                                        <div class="col-sm-11">
                                            <asp:LinkButton ID="btnAgregarItem" runat="server" CssClass="btn btn-dark btn-sm" OnClick="BuscarProducto_Event"><i class="fas fa-plus-circle"></i><span class="d-inline p-1">Agregar</span></asp:LinkButton>
                                        </div>
                                    </div>
                                    <div class="row justify-content-center">
                                        <div class="col-sm-11">
                                            
                                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;">
                                                <asp:GridView ID="gvReceta"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    AutoGenerateColumns="False"
                                                    runat="server" 
                                                    AllowPaging="false" 
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="SKU"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdCodeRef"  runat="server" Text='<%# Eval("ProdCodeRef") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombreRef"  runat="server"  Text='<%# Eval("ProdNombreRef") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="50%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Costo"       HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCosto"  runat="server"  Text='<%# Eval("Costo","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Stock"       HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblStock"  runat="server"  Text='<%# Eval("Stock","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Bodega"      HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblBodegaCode"  runat="server"  Text='<%# Eval("BodegaCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText=""            HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblEliminar"  runat="server" CssClass="w-100" OnClick="Eliminar_Event"><i class="far fa-trash-alt"></i></asp:LinkButton></ItemTemplate> <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
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
                                </div>
                            </div>

                            <div class="modal-footer" style="border: none;">
                                <div class="row p-2">
                                    <div class="col-sm-6">
                                    </div>
                                    <div class="col-sm-6">
                                        <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-danger btn-sm float-end" OnClick="Guardar_Event"><i class="far fa-save d-inline"></i><span class="d-inline p-1">Guardar</span></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <!-- FIN POPUP PRODUCTO -->

    <!-- INI POPUP BUSQUEDA PRODUCTO -->
    <asp:Panel ID="pnlBuscarProducto" runat="server" Style="display: none; width:80%;max-width:1000px;min-width:800px;">
        
        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnGuardar" />
                
            </Triggers>
            <ContentTemplate>
                <asp:HiddenField ID="HiddenFieldEsProdCode" runat="server" />
                <asp:HiddenField ID="HiddenFieldEsNuevo" runat="server" />
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header2 color-negro2">
                                <h2 class="modal-title p-1" id="exampleModalLiveLabel4">
                                    <span>
                                        <asp:Label ID="Label1" runat="server" CssClass="p-2" Text="Busqueda Productos"></asp:Label>
                                    </span>
                                    <asp:LinkButton ID="LinkButton1" CssClass="btn-close p-sm-2 m-1 float-end font-size-large" runat="server" OnClick="ClosePopupBusqueda"></asp:LinkButton>
                                </h2>
                                
                            </div>

                            <div class="modal-body p-3 mb-2" style="max-height: 500px; min-height: 200px;">
                                <div>
                                    <div class="row mb-3">
                                        <asp:Panel DefaultButton="btnBuscarProductos" runat="server">
                                            <div class="col-md-6 mx-auto">
                                                <div id="custom-search-input2">
                                                    <div class="input-group col-md-12">
                                                        <asp:TextBox ID="txtPalabrasProducto" CssClass="form-control input-sm foco" placeholder="¿qué estas buscando?..." runat="server"></asp:TextBox>
                                                        <span class="input-group-btn">
                                                            <asp:LinkButton ID="LinkButton2" runat="server" CssClass="btn btn-lg btn-secondary btn-busqueda" OnClick="Cargaprod"><i class="fa fa-search fa-md"></i></asp:LinkButton>
                                                        </span>
                                                    </div>
                                                </div>
                                                
                                            </div>
                                        </asp:Panel>
                                    </div>
                                    <div class="row justify-content-end mb-2">
                                        <div class="col-sm-2">
                                            <asp:LinkButton ID="btnAgregar" runat="server" CssClass="btn btn-sm btn-danger float-end" OnClick="AddProductoSeleccionado">Agregar <i class="fas fa-external-link-alt"></i></asp:LinkButton>
                                        </div>
                                    </div>
                                    <div class="row justify-content-center">
                                        <div class="col-sm-12 p-2">
                                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 27rem">
                                                <asp:GridView ID="gvResultado"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    AutoGenerateColumns="False"
                                                    runat="server" 
                                                    AllowPaging="false" 
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"><HeaderTemplate><asp:CheckBox ID="checkbox2" AutoPostBack="true" OnCheckedChanged="CheckAllProductos" runat="server" /></HeaderTemplate><ItemTemplate><asp:CheckBox ID="chkSeleccionado" runat="server" /></ItemTemplate><ItemStyle Width="2%" HorizontalAlign="Left"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="SKU"         HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblProdCode"  runat="server" OnClick="Select_Event" Text='<%# Eval("ProdCode") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server"  Text='<%# Eval("ProdNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Tipo"        HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Formato"      HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFormato" runat="server" Text='<%# Eval("FormatoNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="FrmtoVenta"     HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Marca"       HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Activo" visible="false"     HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblActivo" runat="server" Text='<%# Eval("Activo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Costo" HeaderStyle-HorizontalAlign="Right"><ItemTemplate><asp:Label ID="lblCosto" runat="server" Text='<%# Eval("Costo","{0:N0}")%>' /></ItemTemplate><ItemStyle Width="7%" HorizontalAlign="Right"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Stock" HeaderStyle-HorizontalAlign="Right"><ItemTemplate><asp:Label ID="lblStock" runat="server" Text='<%# Eval("Stock","{0:N2}")%>' /></ItemTemplate><ItemStyle Width="7%" HorizontalAlign="Right"></ItemStyle>                                                </asp:TemplateField>
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
                                </div>
                            </div>

                            <div class="modal-footer" style="border: none;">
                                <div class="row p-2">
                                    <div class="col-sm-6">
                                    </div>
                                    <div class="col-sm-6">
                                        <asp:LinkButton ID="LinkButton4" runat="server" CssClass="btn btn-danger btn-sm float-end" OnClick="Guardar_Event"><i class="far fa-save d-inline"></i><span class="d-inline p-1">Guardar</span></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <!-- FIN POPUP BUSQUEDA PRODUCTO -->

    <div class="container-fluid">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            Mantenedor Recetas
                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar">
                              <div class="container-fluid">
                                <button class="navbar-toggler" type="button" data-bs-toggle="collapse"  style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                  <span class="navbar-toggler-icon"></span>
                                </button>
                                <div class="collapse navbar-collapse" id="mynavbar">
                                    <div class="navbar-brand d-flex input-group w-auto">
                                      <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar"></asp:TextBox>
                                    <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server" OnClick="Buscar_Event"><i class="fas fa-search"></i></asp:LinkButton>
                                    </div>

                                    <ul class="navbar-nav">
                                      <li class="nav-item">
                            
                                          <asp:LinkButton ID="btnNuevo" runat="server" CssClass="btn btn-nav" OnClick="Nuevo_Event">Nuevo Producto</asp:LinkButton>
                                      </li>
                                      <li class="nav-item">
                                        <a class="btn btn-nav" href="#">Exportar</a>
                                      </li>
                                    </ul>
                                 </div>
                              </div>
                            </nav>
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                <asp:GridView ID="gvList"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="SKU"         HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblProdCode"  runat="server" OnClick="Editar_Event" Text='<%# Eval("ProdCode") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server"  Text='<%# Eval("ProdNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Tipo"        HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Formato"      HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFormato" runat="server" Text='<%# Eval("FormatoNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="FrmtoVenta"     HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Marca"       HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Activo"      HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblActivo" runat="server" Text='<%# Eval("Activo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
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
                </ContentTemplate>
            </asp:UpdatePanel>
    </div>

    <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupProducto" runat="server"
        DropShadow="false"
        PopupControlID="pnlProducto"
        TargetControlID="lnkFake"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:LinkButton ID="lnkFake2" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupBuscarProducto" runat="server"
        DropShadow="false"
        PopupControlID="pnlBuscarProducto"
        TargetControlID="lnkFake2"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
    
</asp:Content>
