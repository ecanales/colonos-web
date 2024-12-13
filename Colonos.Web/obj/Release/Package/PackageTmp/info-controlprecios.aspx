<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="info-controlprecios.aspx.cs" Inherits="Colonos.Web.info_controlprecios" EnableEventValidation = "false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <div class="container-fluid">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExport" />
                </Triggers>
                <ContentTemplate>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            Informe Control de Precios
                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse" id="mynavbar">
                                        <ul class="navbar-nav">
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Familia</span>
                                                    <asp:DropDownList ID="cboFamilia" CssClass="form-select" OnSelectedIndexChanged="FiltarCombos" AutoPostBack="true" runat="server" Width="150"></asp:DropDownList>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Origen</span>
                                                    <asp:DropDownList ID="cboOrigen" CssClass="form-select" OnSelectedIndexChanged="FiltarCombos" AutoPostBack="true"  runat="server" Width="150"></asp:DropDownList>
                                                </div>
                                            </li>
                                            <li class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Marca</span>
                                                    <asp:DropDownList ID="cboMarca" CssClass="form-select" OnSelectedIndexChanged="FiltarCombos" AutoPostBack="true"  runat="server" Width="150"></asp:DropDownList>
                                                </div>
                                            </li>
                                            <div class="nav-item m-1">
                                                <div class="input-group input-group-sm mb-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Solo con Stock</span>
                                                    <asp:CheckBox ID="chkSoloconStock" CssClass="form-control text-center" AutoPostBack="true" OnCheckedChanged="FiltarCombos" Enabled="true" runat="server"  />
                                                </div>
                                            </div>
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
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 70vh;">
                                <asp:GridView ID="gvBandeja"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                    AllowSorting="true"
                                    OnSorting="gvBandeja_Sorting"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="SKU"       SortExpression="ProdCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdCode"  runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="6%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Producto"  SortExpression="ProdNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="17%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Familia"   SortExpression="FamiliaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFamiliaNombre" runat="server" Text='<%# Eval("FamiliaNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Origen"    SortExpression="OrigenNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Marca"     SortExpression="MarcaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Costo"     SortExpression="Costo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCosto" runat="server" Text='<%# Eval("Costo","{0:N0}") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Stock Toledo"   SortExpression="Stock" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblStock" runat="server" Text='<%# Eval("Stock","{0:N0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Margen"    SortExpression="Margen" ItemStyle-BackColor="Beige" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMargen" runat="server" Text='<%# Eval("Margen","{0:P0}") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Unitario"   SortExpression="PrecioUnitario" ItemStyle-BackColor="Beige" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioUnitario" runat="server" Text='<%# Eval("PrecioUnitario","{0:C0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Desc Vol"  SortExpression="DescVolumen" ItemStyle-BackColor="paleturquoise" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDescVolumen" runat="server" Text='<%# Eval("DescVolumen","{0:P0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Volumen"   SortExpression="Volumen" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVolumen" runat="server" Text='<%# Eval("Volumen","{0:N0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Volumen"    SortExpression="PrecioVolumen" ItemStyle-BackColor="paleturquoise" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioVolumen" runat="server" Text='<%# Eval("PrecioVolumen","{0:C0}") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Fijo"       SortExpression="PrecioFijo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioFijo" runat="server" Text='<%# Eval("PrecioFijo","{0:C0}") %>' /></ItemTemplate>               <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Min"        SortExpression="PrecioMin" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioMin" runat="server" Text='<%# Eval("PrecioMin","{0:C0}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Prom"       SortExpression="PrecioProm" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioProm" runat="server" Text='<%# Eval("PrecioProm","{0:C0}") %>' /></ItemTemplate>               <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Max"        SortExpression="PrecioMax" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioMax" runat="server" Text='<%# Eval("PrecioMax","{0:C0}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Actual"      SortExpression="KilosActual" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblKilosActual" runat="server" Text='<%# Eval("KilosActual","{0:N0}") %>' /></ItemTemplate>            <ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Pasada"      SortExpression="KilosPasada" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblKilosPasada" runat="server" Text='<%# Eval("KilosPasada","{0:N0}") %>' /></ItemTemplate>            <ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <i class="fas fa-exclamation-circle"></i>
                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>

                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 70vh;">
                                <asp:GridView ID="gvBandejaExport"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="SKU"       SortExpression="ProdCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdCode"  runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="6%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Producto"  SortExpression="ProdNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="17%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Familia"   SortExpression="FamiliaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFamiliaNombre" runat="server" Text='<%# Eval("FamiliaNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Marca"     SortExpression="MarcaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Origen"    SortExpression="OrigenNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Margen"    SortExpression="Margen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMargen" runat="server" Text='<%# Eval("Margen","{0:P0}") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Costo"     SortExpression="Costo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCosto" runat="server" Text='<%# Eval("Costo","{0:N0}") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Desc Vol"  SortExpression="DescVolumen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDescVolumen" runat="server" Text='<%# Eval("DescVolumen","{0:P0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Volumen"   SortExpression="Volumen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVolumen" runat="server" Text='<%# Eval("Volumen","{0:N0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Stock Toledo"   SortExpression="Stock" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblStock" runat="server" Text='<%# Eval("Stock","{0:N0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Unitario"   SortExpression="PrecioUnitario" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioUnitario" runat="server" Text='<%# Eval("PrecioUnitario","{0:C0}") %>' /></ItemTemplate>  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Volumen"    SortExpression="PrecioVolumen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioVolumen" runat="server" Text='<%# Eval("PrecioVolumen","{0:C0}") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Fijo"       SortExpression="PrecioFijo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioFijo" runat="server" Text='<%# Eval("PrecioFijo","{0:C0}") %>' /></ItemTemplate>               <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Min"        SortExpression="PrecioMin" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioMin" runat="server" Text='<%# Eval("PrecioMin","{0:C0}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Prom"       SortExpression="PrecioProm" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioProm" runat="server" Text='<%# Eval("PrecioProm","{0:C0}") %>' /></ItemTemplate>               <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Precio Max"        SortExpression="PrecioMax" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPrecioMax" runat="server" Text='<%# Eval("PrecioMax","{0:C0}") %>' /></ItemTemplate>                  <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Actual"      SortExpression="KilosActual" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblKilosActual" runat="server" Text='<%# Eval("KilosActual","{0:N0}") %>' /></ItemTemplate>            <ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Pasada"      SortExpression="KilosPasada" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblKilosPasada" runat="server" Text='<%# Eval("KilosPasada","{0:N0}") %>' /></ItemTemplate>            <ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos SubPasada"   SortExpression="KiloSubPasada" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblKiloSubPasada" runat="server" Text='<%# Eval("KiloSubPasada","{0:N0}") %>' /></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="4%"></ItemStyle></asp:TemplateField>
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
