<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="solicitud-mp.aspx.cs" Inherits="Colonos.Web.solicitud_mp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                                                <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>
                                                        <asp:CheckBox ID="checkbox2" AutoPostBack="true" OnCheckedChanged="CheckAllProductos" runat="server" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkSeleccionado" runat="server" />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="2%" HorizontalAlign="Left"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Candidad" >
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtCantidad" runat="server" CssClass="w-100 text-end" Text="1" ></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="2%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Tipo">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="2%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="SKU" ItemStyle-HorizontalAlign="center">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Descripción">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblDescripcion" runat="server" Text='<%# Eval("ProdNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="23%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Marca">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="10%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Origen">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="10%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Medida" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblMedidaNombre" runat="server" Text='<%# Eval("MedidaNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="0%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="FrmtoVenta" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFrmtoVenta" runat="server" Text='<%# Eval("FrmtoVentaNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="0%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Disponible">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblDisponible" runat="server" Text='<%# Eval("Disponible","{0:N2}")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="8%" HorizontalAlign="Right"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Precio Normal" HeaderStyle-HorizontalAlign="Right">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblPrecioUnitario" runat="server" Text='<%# Eval("PrecioUnitario","{0:C2}")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="10%" HorizontalAlign="Right"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Precio Volumen" HeaderStyle-HorizontalAlign="Right">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblPrecioVolumen" runat="server" Text='<%# Eval("PrecioVolumen","{0:C2}")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="10%" HorizontalAlign="Right"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="RefrigeracionRefrigeraCode" Visible="false" >
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRefrigeraCode" runat="server" Text='<%# Eval("RefrigeraCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="10%"></ItemStyle>
                                                </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Refrigeración" >
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="10%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Bodega" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblBodegaCode" runat="server" Text='<%# Eval("BodegaCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Costo" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblCosto" runat="server" Text='<%# Eval("Costo")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Volumen" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblVolumen" runat="server" Text='<%# Eval("Volumen")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="AnimalCode" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblAnimalCode" runat="server" Text='<%# Eval("AnimalCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="AnimalNombre" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblAnimalNombre" runat="server" Text='<%# Eval("AnimalNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="FamiliaCode" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFamiliaCode" runat="server" Text='<%# Eval("FamiliaCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="FamiliaNombre" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFamiliaNombre" runat="server" Text='<%# Eval("FamiliaNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="MarcaCode" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblMarcaCode" runat="server" Text='<%# Eval("MarcaCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="FormatoCode" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFormatoCode" runat="server" Text='<%# Eval("FormatoCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="FormatoVtaCode" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFormatoVtaCode" runat="server" Text='<%# Eval("FormatoVtaCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="FrmtoVentaNombre" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FormatoNombre")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Factorprecio" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFactorprecio" runat="server" Text='<%# Eval("Factorprecio")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="DescVolumen" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblDescVolumen" runat="server" Text='<%# Eval("DescVolumen")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="MargenRegla" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblMargenRegla" runat="server" Text='<%# Eval("Margen")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="OrigenCode" Visible="false">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblOrigenCode" runat="server" Text='<%# Eval("OrigenCode")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="5%"></ItemStyle>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Precio Normal" Visible="false" HeaderStyle-HorizontalAlign="Right">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblPrecioFijo" runat="server" Text='<%# Eval("PrecioFijo","{0:N2}")%>' />
                                                    </ItemTemplate>
                                                    <ItemStyle Width="10%" HorizontalAlign="Right"></ItemStyle>
                                                </asp:TemplateField>
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
    <div class="container-fluid">
        <div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="card card-top" >
                        <div class="card-header fw-bold font-size-xx-large">
                            Solicitud Materia Prima
                        </div>
                        <div class="card-body overflow-auto">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar mb-2" style="height: 55px;">
                                <div class="container-fluid">
                                    <ul class="navbar-nav">
                                        <li class="nav-item">
                                            <asp:LinkButton ID="btnVolver" CssClass="btn btn-nav" runat="server" PostBackUrl="/bandeja-solicitudmp.aspx" ><i class="fas fa-reply p-1"></i>Volver</asp:LinkButton>
                                        </li>
                                        <li class="nav-item">
                                            <asp:LinkButton ID="btnGuardar" CssClass="btn btn-nav" runat="server" OnClick="Guardar_Event"><i class="far fa-save p-1"></i>Guardar</asp:LinkButton>
                                        </li>
                                    </ul>
                                </div>
                                <div class="float-end">
                                    <h5 style="color:white; margin-right:10px;">Solicitud:<asp:Label ID="lblNumeroPedido" CssClass="p-1"  ForeColor="White" runat="server" Text=""></asp:Label></h5>
                                </div>
                            </nav>
                            <div>
                                <div>
                                    <div class="row mb-2">
                                        <div class="col-sm-12">
                                            <asp:LinkButton ID="btnAddProducto" runat="server" CssClass="btn btn-sm btn-outline-dark" OnClick="BusquedaProductos_Event">Agregar Productos</asp:LinkButton>
                                            <asp:LinkButton ID="btnEliminar" runat="server" CssClass="btn btn-sm btn-outline-dark" OnClick="EliminarSeleccionados_Event">Eliminar Selección</asp:LinkButton>
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
                                                    <asp:TemplateField HeaderText="Disponible" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="lblDisponible" runat="server" Text='<%# Eval("Disponible","{0:N2}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Marca" HeaderStyle-CssClass=""><ItemTemplate>        <asp:Label ID="lblMarca" runat="server" Text='<%# Eval("MarcaNombre")%>' /></ItemTemplate>                     <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Origen" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="lblOrigen" runat="server" Text='<%# Eval("Origen")%>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeracion" runat="server" Text='<%# Eval("RefrigeraNombre")%>' /></ItemTemplate>     <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Cantidad" HeaderStyle-CssClass=""><ItemTemplate>     <asp:TextBox ID="txtCantidad" onblur="SetActivaBotonActualizar()" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("Cantidad","{0:N2}") %>'></asp:TextBox></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
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
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    
    <asp:LinkButton ID="lnkFake3" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupBusquedaProductos" runat="server"
        DropShadow="false"
        PopupControlID="pnlBusquedaProductos"
        TargetControlID="lnkFake3"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
</asp:Content>
