<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="info-seguimientoperacion.aspx.cs" Inherits="Colonos.Web.info_seguimientoperacion" %>
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
                            <span>
                                Informe Seguimiento Operación
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
                                        <ul class="navbar-nav">
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption color-rojo">Vendedor</span>
                                                    <asp:DropDownList ID="cboVendedor" CssClass="form-select" runat="server" Width="150"></asp:DropDownList>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption color-rojo">Fecha Inicio</span>
                                                    <asp:TextBox ID="txtFechaIni" runat="server" TextMode="Date" CssClass="form-control" Width="150"></asp:TextBox>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption color-rojo">Fecha Final</span>
                                                    <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date" CssClass="form-control" Width="150"></asp:TextBox>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption color-rojo">Solo Abiertos</span>
                                                    <asp:CheckBox ID="chkSoloAbiertos" Width="100" BackColor="White" CssClass="text-center" Checked="true" runat="server" />
                                                </div>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnRefresh" CssClass="btn btn-nav" runat="server" OnClick="Refresh_Event"><i class="fas fa-sync-alt p-1"></i>Actualizar</asp:LinkButton>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </nav>
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 70vh;">
                                <asp:GridView ID="gvBandeja"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                    OnRowDataBound="gvBandeja_RowDataBound"
                                    AllowSorting="true"
                                    OnSorting="gvBandeja_Sorting"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Orden"           SortExpression="DocEntry" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEntry"  runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"        SortExpression="VendedorCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorCode"  runat="server" CssClass="text-truncate" Width="80" Text='<%# Eval("VendedorCode") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Estado Doc"      SortExpression="DocEstado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEstado" runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Estado Operativo"        SortExpression="EstadoOperativo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEstadoOperativo" runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Razon Social"    SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRazonSocial" runat="server" CssClass="text-truncate" Width="150" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha"           SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" Width="100" Text='<%# Eval("DocFecha","{0:dd/MM/yyyy HH:ss}") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>


                                        <asp:TemplateField HeaderText="Credit"         SortExpression="Credito" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCredito" runat="server" Width="60" Text='<%# Eval("Credito") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio"          SortExpression="Precio" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecio" runat="server"  Width="60" Text='<%# Eval("Precio") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Toledo"          SortExpression="Toledo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblToledo" runat="server" Width="60" Text='<%# Eval("Toledo") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="1%" ></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Produc"      SortExpression="Produccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProduccion" runat="server" Width="60" Text='<%# Eval("Produccion") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Factur"     SortExpression="Facturacion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFacturacion" runat="server" Width="60" Text='<%# Eval("Facturacion") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Logist"       SortExpression="Logistica" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblLogistica" runat="server" Width="60" Text='<%# Eval("Logistica") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="1%" ></ItemStyle></asp:TemplateField>
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
    </div>
</asp:Content>
