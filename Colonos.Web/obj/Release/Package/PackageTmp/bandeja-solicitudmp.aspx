<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="bandeja-solicitudmp.aspx.cs" Inherits="Colonos.Web.bandeja_solicitudmp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            Bandeja Solicitud de Materia Prima
                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse" id="mynavbar">
                                        
                                        <div class="navbar-brand d-flex input-group w-auto">
                                            <input
                                                type="search"
                                                class="form-control"
                                                placeholder="Buscar"
                                                aria-label="Search"
                                                aria-describedby="search-addon" />
                                            <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server" ><i class="fas fa-search"></i></asp:LinkButton>
                                        </div>

                                        <ul class="navbar-nav m-1">
                                            
                                            <li class="nav-item m-1 d-none">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Vendedor</span>
                                                    <asp:DropDownList ID="cboCondicion" CssClass="form-select" runat="server" Width="150"></asp:DropDownList>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1 d-none">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Fecha Inicio</span>
                                                    <asp:TextBox ID="txtFechaIni" runat="server" TextMode="Date" CssClass="form-control" Width="150"></asp:TextBox>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1 d-none">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Fecha Final</span>
                                                    <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date" CssClass="form-control" Width="150"></asp:TextBox>
                                                </div>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnConsultar" CssClass="btn btn-nav" runat="server" OnClick="Consultar_Event"><i class="fas fa-sync-alt p-1"></i>Refresh</asp:LinkButton>
                                            </li>
                                            <li class="nav-item" style="background-color:crimson;margin-left: 5px;">
                                                <asp:LinkButton ID="btnNuevo" CssClass="btn btn-nav" runat="server" OnClick="Nuevo_Event" ><i class="fas fa-dolly p-1"></i>Nueva Solicitud</asp:LinkButton>
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
                                    
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Fecha Ingreso"   HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" Text='<%# Eval("FechaIngresoPrep","{0:dd/MM/yyyy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocEntry"   HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocTipo"   HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocTipo" runat="server" Text='<%# Eval("DocTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerPedido_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Estado"          HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha Entrega"   HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="11%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Retira Cliente"  HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"        HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorCode") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="11%"></ItemStyle></asp:TemplateField>
                                        <%--<asp:TemplateField HeaderText="Impreso"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblImpreso" runat="server" Text='<%# Eval("Impreso") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>--%>
                                        <asp:TemplateField HeaderText="Completado"   HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Kilos"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Venta"         HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:C0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
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
