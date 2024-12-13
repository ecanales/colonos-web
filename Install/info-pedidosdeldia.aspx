<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="info-pedidosdeldia.aspx.cs" Inherits="Colonos.Web.info_pedidosdeldia" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <div class="container-fluid">
            <div class="">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="card card-top">
                            <div class="card-header fw-bold font-size-xx-large">
                                Informe Pedidos del Día
                            </div>
                            <div class="card-body" style="overflow:auto;">
                                <nav class="navbar navbar-expand-lg navbar-light nav-toolbar mb-1">
                                    <div class="container-fluid">
                                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                            <span class="navbar-toggler-icon"></span>
                                        </button>
                                        <div class="collapse navbar-collapse" id="mynavbar">
                                            <ul class="navbar-nav">
                                                <li class="nav-item m-1">
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Fecha</span>
                                                        <asp:TextBox ID="txtFecha" runat="server" TextMode="Date" CssClass="form-control" Width="150"></asp:TextBox>
                                                    </div>
                                                </li>
                                                <li class="nav-item">
                                                    <asp:LinkButton ID="btnRefresh" CssClass="btn btn-nav" runat="server" OnClick="Refresh_Event"><i class="fas fa-sync-alt p-1"></i>Actualizar</asp:LinkButton>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </nav>
                                <div class="row mb-1">
                                    <div class="col-sm-4">
                                        <div class="card">
                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                            Resumen Pedido día
                                            </div>
                                            <div class="card-body overflow-y-auto">
                                                <asp:GridView ID="gvResumenVendedor"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    runat="server" 
                                                    AutoGenerateColumns="false"
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small"
                                                    ShowFooter="true"
                                                    FooterStyle-CssClass="footertable footerfijo"
                                                    OnRowDataBound="gvResumenVendedor_RowDataBound"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Ejecutivo"><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="60%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total Pedidos"><ItemTemplate><asp:Label ID="lblPedidos" runat="server" Text='<%# Eval("Pedidos") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total Kilos"><ItemTemplate><asp:Label ID="lblKilos" runat="server" Text='<%# Eval("Kilos","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Kilos Promedio"><ItemTemplate><asp:Label ID="lblKilosPromedio" runat="server" Text='<%# Eval("KilosPromedio","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Pedidos Hora"><ItemTemplate><asp:Label ID="lblPedidosporHora" runat="server" Text='<%# Eval("PedidosporHora","{0:N1}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle CssClass="pagination-ys" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="card">
                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                            Pedidos por Hora Área
                                            </div>
                                            <div class="card-body overflow-y-auto">
                                                <asp:GridView ID="gvPorHoraArea"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    runat="server" 
                                                    AutoGenerateColumns="false"
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small"
                                                    ShowFooter="true"
                                                    FooterStyle-CssClass="footertable footerfijo"
                                                    OnRowDataBound="gvPorHoraArea_RowDataBound"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Area"><ItemTemplate><asp:Label ID="lblIdGrupo" runat="server" Text='<%# Eval("IdGrupo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="60%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total Pedidos"><ItemTemplate><asp:Label ID="lblPedidos" runat="server" Text='<%# Eval("Pedidos") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Pedidos Hora"><ItemTemplate><asp:Label ID="lblPedidosporHora" runat="server" Text='<%# Eval("PedidosporHora","{0:N1}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle CssClass="pagination-ys" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                    <%--<div class="col-sm-3 d-none">
                                        <div class="card">
                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                            Pedidos por Hora Ejecutivo
                                            </div>
                                            <div class="card-body overflow-y-auto">
                                                <asp:GridView ID="gvPorHoraEjecutivo"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    runat="server" 
                                                    AutoGenerateColumns="false"
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Ejecutivo"><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="60%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total"><ItemTemplate><asp:Label ID="lblPedidos" runat="server" Text='<%# Eval("Pedidos") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="P/Hora"><ItemTemplate><asp:Label ID="lblPedidosporHora" runat="server" Text='<%# Eval("PedidosporHora","{0:N1}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle CssClass="pagination-ys" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>--%>
                                    <div class="col-sm-5">
                                        <div class="card">
                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                Volumenes del día (10 Principales)
                                            </div>
                                            <div class="card-body overflow-auto">
                                                <asp:GridView ID="gvTopClientes"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    runat="server" 
                                                    AutoGenerateColumns="false"
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Razon Social"><ItemTemplate><asp:Label ID="lblRazonSocial" runat="server" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="60%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Ejecutivo"><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Kilos"><ItemTemplate><asp:Label ID="lblKilos" runat="server" Text='<%# Eval("Kilos","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle CssClass="pagination-ys" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="card">
                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                            Pedidos en Curso Camara
                                            </div>
                                            <div class="card-body overflow-y-auto">
                                                <asp:GridView ID="gvEntregasCamara"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    runat="server" 
                                                    AutoGenerateColumns="false"
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small"
                                                    ShowFooter="true"
                                                    FooterStyle-CssClass="footertable footerfijo"
                                                    OnRowDataBound="gvEntregasCamara_RowDataBound"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Bodega"><ItemTemplate><asp:Label ID="lblBodega" runat="server" Text='<%# Eval("Bodega") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="RangoKilos"><ItemTemplate><asp:Label ID="lblRangoKilos" runat="server" Text='<%# Eval("RangoKilos") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Atrasado"><ItemTemplate><asp:Label ID="lblAyer" runat="server" Text='<%# Eval("Ayer","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Hoy"><ItemTemplate><asp:Label ID="lblHoy" runat="server" Text='<%# Eval("Hoy","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Posterior"><ItemTemplate><asp:Label ID="lblMañana" runat="server" Text='<%# Eval("Mañana","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total"><ItemTemplate><asp:Label ID="lblPedidos" runat="server" Text='<%# Eval("Pedidos","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle CssClass="pagination-ys" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="card">
                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                            Pedidos en Curso Produccción
                                            </div>
                                            <div class="card-body overflow-y-auto">
                                                <asp:GridView ID="gvEntregasProduccion"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    runat="server" 
                                                    AutoGenerateColumns="false"
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid-small"
                                                    ShowFooter="true"
                                                    FooterStyle-CssClass="footertable footerfijo"
                                                    OnRowDataBound="gvEntregasProduccion_RowDataBound"
                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Bodega"><ItemTemplate><asp:Label ID="lblBodega" runat="server" Text='<%# Eval("Bodega") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="RangoKilos"><ItemTemplate><asp:Label ID="lblRangoKilos" runat="server" Text='<%# Eval("RangoKilos") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Atrasado"><ItemTemplate><asp:Label ID="lblAyer" runat="server" Text='<%# Eval("Ayer","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Hoy"><ItemTemplate><asp:Label ID="lblHoy" runat="server" Text='<%# Eval("Hoy","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Posterior"><ItemTemplate><asp:Label ID="lblMañana" runat="server" Text='<%# Eval("Mañana","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total"><ItemTemplate><asp:Label ID="lblPedidos" runat="server" Text='<%# Eval("Pedidos","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    </Columns>
                                                    <PagerStyle CssClass="pagination-ys" />
                                                </asp:GridView>
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
    </div>
</asp:Content>
