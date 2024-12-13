<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="bandeja-rendicion.aspx.cs" Inherits="Colonos.Web.bandeja_rendicion" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- INI POPUP DETALLE BANDEJA-->
    <asp:Panel ID="pnlDetalleBandeja" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
            <asp:UpdatePanel runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnCalcular" />
                </Triggers>
                <ContentTemplate>
                    <asp:HiddenField ID="HiddenFieldDocentry" runat="server" />
                    <asp:HiddenField ID="HiddenFieldDocTipo" runat="server" />
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel5">
                                        <span>Bandeja RENDICION DE PRODUCCION</span>
                                        <asp:Label ID="lblRazonSocion" runat="server" ForeColor="antiquewhite" Text=""></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton11" CssClass="btn-close" runat="server" OnClick="ClosePopupBandeja"></asp:LinkButton>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-4">
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Numero</span>
                                                <asp:TextBox ID="txtNumeroPedido" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Cliente</span>
                                                <asp:TextBox ID="txtRazonSocial" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Vendedor</span>
                                                <asp:TextBox ID="txtVendedorPedido" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Fecha de Entrega</span>
                                                <asp:TextBox ID="txtFechadeEntrega" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Fecha Pedido</span>
                                                <asp:TextBox ID="txtFechaPedido" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Retira Cliente</span>
                                                <asp:CheckBox ID="chkRetiraCliente" CssClass="form-control text-center" Enabled="false" runat="server"  />
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="row mb-4 justify-content-end">
                                                <div class="col-sm-6">
                                                    <asp:LinkButton ID="btnCalcular" runat="server" CssClass="btn btn-sm btn-success float-end" OnClientClick="showLoading()" OnClick="Calcular_Event" ><i class="far fa-thumbs-up p-1"></i>Calcular</asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mb-2">
                                        <div class="col-sm-12">
                                            <div class="table-responsive p-1" style="border-top: 2px solid black; overflow-y: auto; max-height: calc(100vh - 450px);">
                                                <asp:GridView ID="gvDetalle"
                                                CssClass="table table-sm table-bordered table-hover header-grid"
                                                AutoGenerateColumns="False"
                                                runat="server" 
                                                AllowPaging="false" 
                                                RowStyle-CssClass="row-grid-smaller"
                                                HeaderStyle-CssClass="header-grid-smaller headfijo"
                                                OnRowDataBound="gvDetalle_RowDataBound"
                                                >
                                                <Columns>
                                                    <asp:TemplateField HeaderText="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="DocLinea" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocLinea" runat="server" Text='<%# Eval("DocLinea") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="LineaItem" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblLineaItem" runat="server" Text='<%# Eval("LineaItem") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="ProdTipo" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdTipo" runat="server" Text='<%# Eval("ProdTipo") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Tipo" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblTipoCode" runat="server" Text='<%# Eval("TipoCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombre" runat="server" CssClass="text-truncate w-100" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="12%"></ItemStyle></asp:TemplateField>
<%--                                                    <asp:TemplateField HeaderText="Marca" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>--%>
<%--                                                    <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>--%>
<%--                                                    <asp:TemplateField HeaderText="Origen" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>--%>
                                                    <asp:TemplateField HeaderText="Solicitado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblCantidadSolicitada"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadSolicitada","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Marcado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblCantidadReal"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadReal","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Utilizado" HeaderStyle-CssClass="">
                                                        <ItemTemplate><asp:TextBox ID="txtCantidadRendida" CssClass="text-end w-75" runat="server" Text='<%# Eval("CantidadRendida","{0:N2}") %>'></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="NumericOnlyValidator3" runat="server" ControlToValidate="txtCantidadRendida" CssClass="d-inline" ErrorMessage="*" SetFocusOnError="true" Font-Size="Large" ForeColor="Red" ValidationExpression="^((?:[1-9]\d*)|(?:(?=[\d.]+)(?:[1-9]\d*|0).\d+))$"></asp:RegularExpressionValidator>
                                                        </ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Terminado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblTerminado"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadTerminada","{0:N2}") %>' ></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
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
                                <div class="modal-footer">
                                    <asp:Button ID="Button1" CssClass="btn btn-secondary btn-sm" runat="server" OnClick="ClosePopupBandeja" Text="Cerrar" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
    <!-- FIN POPUP DETALLE BANDEJA -->

    <div class="container-fluid">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="loading-overlay" id="loadingOverlay">
                        <div class="loading-spinner"></div>
                    </div>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            Bandeja RENDICION DE PRODUCCION
                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse" id="mynavbar">
                                        <div class="navbar-brand d-flex input-group w-auto d-none">
                                            <input
                                                type="search"
                                                class="form-control"
                                                placeholder="Buscar"
                                                aria-label="Search"
                                                aria-describedby="search-addon" />
                                            <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server" ><i class="fas fa-search"></i></asp:LinkButton>
                                        </div>

                                        <ul class="navbar-nav">
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnRefresh" CssClass="btn btn-nav" runat="server" OnClick="Refresh_Event"><i class="fas fa-sync-alt p-1"></i>Actualizar</asp:LinkButton>
                                            </li>
                                            <li class="nav-item" style="background-color:crimson;margin-left: 5px;">
                                                <asp:LinkButton ID="btnNuevo" CssClass="btn btn-nav" runat="server" OnClick="Nuevo_Event" ><i class="fas fa-dolly-flatbed p-1"></i>Generar Corte Producción</asp:LinkButton>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </nav>
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 82px - 200px);">
                                <asp:GridView ID="gvBandeja"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid headfijo"
                                    AllowSorting="true"
                                    OnSorting="gvBandeja_Sorting"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Fecha Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaRegistro" runat="server" Text='<%# Eval("FechaRegistro","{0:dd/MM/yyyy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="16%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocEntry"        SortExpression="DocEntry" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblDocEntry"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("DocEntry") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocTipo"         SortExpression="DocTipo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocTipo" runat="server" Text='<%# Eval("DocTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="16%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha"           SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" Text='<%# Eval("DocFecha","{0:dd/MM/yyyy}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="16%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Usuario"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="16%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="NumeroFormulario"    SortExpression="NumeroFormulario" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblNumeroFormulario" runat="server" Text='<%# Eval("NumeroFormulario") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="16%"></ItemStyle></asp:TemplateField>

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
    </div>

    <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupDetalleBandeja" runat="server"
        DropShadow="false"
        PopupControlID="pnlDetalleBandeja"
        TargetControlID="lnkFake"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
</asp:Content>
