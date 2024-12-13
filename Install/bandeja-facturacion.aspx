<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="bandeja-facturacion.aspx.cs" Inherits="Colonos.Web.bandeja_facturacion" EnableEventValidation = "false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%--<script type="text/javascript">
       function bloquearboton(botonid) {
           console.log(botonid);
           document.getElementById(botonid).style.display = "none";
          }
    </script>--%>
    <!-- INI POPUP DETALLE BANDEJA-->
    <asp:Panel ID="pnlDetalleBandeja" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="loading-overlay" id="loadingOverlay">
                        <div class="loading-spinner"></div>
                    </div>
                    <asp:HiddenField ID="HiddenFieldDocentry" runat="server" />
                    <asp:HiddenField ID="HiddenFieldDocTipo" runat="server" />
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel5">
                                        <span>Generar FACTURA: </span>
                                        <asp:Label ID="lblRazonSocial" runat="server" ForeColor="antiquewhite" Text="Cliente"></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton11" CssClass="btn-close" runat="server" OnClick="ClosePopupBandeja"></asp:LinkButton>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-6">
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
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130" style="background-color:#ecf0f3;">Orden de Compra</span>
                                                <asp:CheckBox ID="chkActualizarOC" CssClass="form-control text-center" runat="server"  />
                                                <asp:TextBox ID="txtOrdendeCompra" runat="server" CssClass="form-control" Width="40%"  placeholder="orden de compra"></asp:TextBox>
                                                <asp:LinkButton ID="btnActualizarOC" CssClass="btn btn-sm btn-warning text-center" OnClick="ActualizarOC_Event" runat="server"><i class="far fa-edit p-1"></i>Actualizar</asp:LinkButton>
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
                                                <asp:CheckBox ID="chkRetiraCliente" CssClass="form-control text-center" runat="server"  />
                                            </div>
                                        </div>
                                        <div class="col-sm-2">
                                            <div class="row mb-4 d-none">
                                                <div class="form-group mb-1">
                                                    
                                                </div>
                                            </div>
                                            <div class="row mb-0 justify-content-end">
                                                <div class="col-sm-12">
                                                    <%--<button id="spinnerbuttom" class="btn btn-secondary btn-sm float-end wd-120" style="visibility:hidden" type="button" disabled>
                                                      <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                                                      <span class="sr-only">Loading...</span>
                                                    </button>--%>
                                                    <asp:LinkButton ID="brnGenerar" runat="server" CssClass="btn btn-sm btn-success float-end wd-120" OnClick="Generar_Event" OnClientClick="showLoading()" ><i class="far fa-thumbs-up p-1"></i>Generar</asp:LinkButton>
                                                </div>
                                            </div>
                                            <div class="row mb-4 justify-content-end">
                                                <div class="col-sm-12" style="display: flex;align-items: center;justify-content: center;">
                                                    <asp:CheckBox ID="chkConfirmar" Checked="false" AutoPostBack="false" CssClass="float-end p-2" Text="" Font-Size="Small" runat="server" />
                                                    <label style="color:red;">Confirmo facturar</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mb-2">
                                        <div class="col-sm-12">
                                            <div class="table-responsive p-1" style="border-top: 2px solid black; overflow-y: auto;">
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
                                                    <asp:TemplateField HeaderText="LineaItem" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblLineaItem" runat="server" Text='<%# Eval("LineaItem") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Estado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblLineaEstado" runat="server" Text='<%# Eval("LineaEstado") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombre" runat="server"  CssClass="text-truncate w-100" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="12%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Completado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Bodega" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblBodegaCode" runat="server" Text='<%# Eval("BodegaCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Precio" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblPrecioFinal" CssClass="text-end" runat="server" Text='<%# Eval("PrecioFinal","{0:N0}") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Solicitado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="txtCantidad" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("CantidadSolicitada","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Por Facturar" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="txtPendiente" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("CantidadPendiente","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Marcado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="txtCantidadReal" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("CantidadReal","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="txtTotalReal" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("TotalReal","{0:N0}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    
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
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExport" />
                </Triggers>
                <ContentTemplate>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                           <span>Bandeja FACTURACION
                                <asp:Label ID="lblTotalRegistrosBandeja" runat="server" CssClass="badge bg-danger font-size-large position-absolute m-1"  Text="0"></asp:Label>
                            </span>
                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar p-0">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse p-0" id="mynavbar">
                                        <div class="navbar-brand d-flex input-group w-auto p-0">
                                           <%-- <input
                                                type="search"
                                                class="form-control"
                                                placeholder="Buscar"
                                                aria-label="Search"
                                                aria-describedby="search-addon" />--%>
                                            <div class="navbar-brand d-flex input-group w-auto">
                                            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Numero de Pedido"></asp:TextBox>
                                            <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server" OnClick="Buscar_Menu" ><i class="fas fa-search"></i></asp:LinkButton>
                                        </div>

                                        <ul class="navbar-nav">
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnRefresh" CssClass="btn btn-nav" runat="server" OnClick="Refresh_Event"><i class="fas fa-sync-alt p-1"></i>Actualizar</asp:LinkButton>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnExport" CssClass="btn btn-nav" runat="server" OnClick="ExportToExcel"><i class="fas fa-file-excel p-1"></i>Exportar</asp:LinkButton>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </nav>
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 1px solid #e9ecef; overflow-y: auto;    max-height: calc(100vh - 13rem);">
                                <asp:GridView ID="gvBandeja"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid headfijo"
                                    OnRowDataBound="gvBandeja_RowDataBound"
                                    AllowSorting="true"
                                    OnSorting="gvBandeja_Sorting"
                                    EnableSortingAndPagingCallback="True"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Est"          SortExpression="DocEstado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Creación"   SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="160" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalVenta" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="80" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="80" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="KG por<br/>Marcar"     SortExpression="TotalKilosPorMarcar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosPorMarcar" runat="server" Text='<%# Eval("TotalKilosPorMarcar","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Kilos Solicitados" SortExpression="TotalKilos"><ItemTemplate><asp:Label ID="lblTotalKilosSolicitados" runat="server" Text='<%# Eval("TotalKilosSolicitados","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Facturados"   SortExpression="TotalKilosFacturados"><ItemTemplate><asp:Label ID="lblTotalKilosFacturados" runat="server" Text='<%# Eval("TotalKilosFacturados","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos por Facturar" SortExpression="TotalKilosPendientes"><ItemTemplate><asp:Label ID="lblCantidadPendiente" runat="server" Text='<%# Eval("TotalKilosPendientes","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Pendientes"   SortExpression="TotalKilosReales" HeaderStyle-BackColor ="Green"     HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosReales" runat="server" Text='<%# Eval("TotalKilosReales","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Pendiente"    SortExpression="TotalFacturable" HeaderStyle-BackColor ="Green"     HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("TotalFacturable","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>

                                        
                                        <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Us"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vend"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>

                                        <%--<asp:TemplateField HeaderText="Fecha Pedido"    SortExpression="DocFecha"><ItemTemplate><asp:Label ID="lblFechaPedido" runat="server" Text='<%# Eval("DocFecha","{0:dd/MM/yyyy}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Fecha Entrega"   SortExpression="FechaEntrega"><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Retira Cliente"  SortExpression="RetiraCliente"><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial"><ItemTemplate><asp:Label ID="lblCliente" runat="server"  CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"        SortExpression="VendedorCode"><ItemTemplate><asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorCode") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="11%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Impreso"         SortExpression="Impreso" Visible="false"><ItemTemplate><asp:Label ID="lblImpreso" runat="server" Text='<%# Eval("Impreso") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression ="Zona"><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna"          SortExpression="ComunaNombre"><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="80" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Completado"       SortExpression="Completado"><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Horario Atención" SortExpression="Ventana"><ItemTemplate><asp:Label ID="lblVentana" runat="server" Text='<%# Eval("Ventana") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Left" Width="13%"></ItemStyle></asp:TemplateField>--%>
                                        
                                        
                                        
                                        


                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="DocEntry" Visible="false"><ItemTemplate><asp:LinkButton ID="lblDocEntry"  runat="server"  Text='<%# Eval("DocEntry") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <i class="fas fa-exclamation-circle"></i>
                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>
                            <div class="table-responsive p-1 d-none" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 16rem);">
                                <asp:GridView ID="gvListExport"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid headfijo"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Estado"          SortExpression="DocEstado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Creación"   SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPedido"  runat="server" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalVenta" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Usuario"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>

                                        <asp:TemplateField HeaderText="KG por<br/>Marcar"     SortExpression="TotalKilosPorMarcar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosPorMarcar" runat="server" Text='<%# Eval("TotalKilosPorMarcar","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>

                                        <asp:TemplateField HeaderText="Kilos Solicitados" SortExpression="TotalKilos"><ItemTemplate><asp:Label ID="lblTotalKilosSolicitados" runat="server" Text='<%# Eval("TotalKilosSolicitados","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Facturados"   SortExpression="TotalKilosFacturados"><ItemTemplate><asp:Label ID="lblTotalKilosFacturados" runat="server" Text='<%# Eval("TotalKilosFacturados","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos por Facturar" SortExpression="TotalKilosPendientes"><ItemTemplate><asp:Label ID="lblCantidadPendiente" runat="server" Text='<%# Eval("TotalKilosPendientes","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Pendientes"   SortExpression="TotalKilosReales" HeaderStyle-BackColor ="Green"     HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosReales" runat="server" Text='<%# Eval("TotalKilosReales","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Pendiente"    SortExpression="TotalFacturable" HeaderStyle-BackColor ="Green"     HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("TotalFacturable","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>

                                        
                                        


                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="DocEntry" Visible="false"><ItemTemplate><asp:LinkButton ID="lblDocEntry"  runat="server"  Text='<%# Eval("DocEntry") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
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
