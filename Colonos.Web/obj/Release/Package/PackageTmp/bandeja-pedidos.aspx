<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="bandeja-pedidos.aspx.cs" Inherits="Colonos.Web.bandeja_pedidos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            <span>Bandeja Pedidos de Venta
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
                                            <%--<input
                                                type="search"
                                                class="form-control"
                                                placeholder="Buscar"
                                                aria-label="Search"
                                                aria-describedby="search-addon" />--%>
                                            <div class="navbar-brand d-flex input-group w-auto">
                                            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar"></asp:TextBox>
                                            <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server" OnClick="BuscarPedidoNav_Event" ><i class="fas fa-search"></i></asp:LinkButton>
                                        </div>

                                        <ul class="navbar-nav m-1">
                                            
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption color-rojo" >Vendedor</span>
                                                    <asp:DropDownList ID="cboVendedor" CssClass="form-select" runat="server" Width="150"></asp:DropDownList>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption color-rojo" >Fecha Inicio</span>
                                                    <asp:TextBox ID="txtFechaIni" runat="server" TextMode="Date" CssClass="form-control" Width="150"></asp:TextBox>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption color-rojo">Fecha Final</span>
                                                    <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date" CssClass="form-control" Width="150"></asp:TextBox>
                                                </div>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnConsultar" CssClass="btn btn-nav" runat="server" OnClick="Consultar_Event"><i class="fas fa-sync-alt p-1"></i>Consultar</asp:LinkButton>
                                            </li>
                                            <li class="nav-item" style="margin-left: 5px;">
                                                <asp:LinkButton ID="btnNuevo" CssClass="btn btn-danger" runat="server" OnClick="Nuevo_Event"><i class="fas fa-file-invoice-dollar p-1"></i>Nueva Venta</asp:LinkButton>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </nav>
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 80px - 180px);">
                                <asp:GridView ID="gvBandeja"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid headfijo"
                                    AllowSorting="true"
                                    OnSorting="gvBandeja_Sorting"
                                    Caption=""
                                    CaptionAlign="Top"
                                    >
                                    <Columns>

                                        
                                        <asp:TemplateField HeaderText="Estado"          SortExpression="DocEstado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Creación"   SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerPedido_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Usuario"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>

                                        
                                        <asp:TemplateField HeaderText="DocEntry"        SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocTipo"         SortExpression="DocTipo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocTipo" runat="server" Text='<%# Eval("DocTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Retira Cliente"  SortExpression="RetiraCliente" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor DF"     SortExpression="VendedorCode" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorCode") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        
                                        
                                        
                                        
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
</asp:Content>
