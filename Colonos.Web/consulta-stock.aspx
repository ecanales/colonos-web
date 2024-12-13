<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="consulta-stock.aspx.cs" Inherits="Colonos.Web.consulta_stock"  EnableEventValidation = "false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="card card-top">
            <div class="card-header fw-bold font-size-xx-large">
            Consulta Stock
            </div>
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <div class="card-body" style="height:75vh;">
                <nav class="navbar navbar-expand-lg navbar-light nav-toolbar p-0">
                  <div class="container-fluid">
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"  style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                      <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse p-0" id="mynavbar">
                        <div class="navbar-brand d-flex input-group w-auto ">
                          <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar"></asp:TextBox>
                        <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server" OnClick="Buscar_Event"><i class="fas fa-search"></i></asp:LinkButton>
                        </div>

                        <ul class="navbar-nav">
                          <li class="nav-item">
                            <asp:LinkButton ID="btnExport" CssClass="btn btn-nav d-none" runat="server" OnClick="ExportToExcel"><i class="fas fa-file-excel p-1"></i>Exportar</asp:LinkButton>
                          </li>
                          <li class="nav-item">
                            <span class="btn btn-nav">
                                <asp:CheckBox ID="chkActivos" Text="" Checked="true" runat="server" Enabled="false"/><label style="margin-left:5px;" >Solo Activos</label>
                            </span>
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
                        AllowSorting="true"
                        OnSorting="gvBandeja_Sorting"
                        CaptionAlign="Top"
                        >
                        <Columns>
                            <asp:TemplateField HeaderText="SKU"             SortExpression="ProdCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdCode"  runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Descripción"     SortExpression="ProdNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server"  Text='<%# Eval("ProdNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Tipo"            SortExpression="Tipo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Tiene Receta"    SortExpression="TieneReceta" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTieneReceta" runat="server" Text='<%# Eval("TieneReceta") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Es Desglose"     SortExpression="EsDesglose" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEsDesglose" runat="server" Text='<%# Eval("EsDesglose") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Activo"          SortExpression="Activo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblActivo" runat="server" Text='<%# Eval("Activo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Refrigeración"   SortExpression="RefrigeraNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Marca"           SortExpression="MarcaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Origen"          SortExpression="OrigenNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Formato"      SortExpression="FormatoNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFormatoNombre" runat="server" Text='<%# Eval("FormatoNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Formato Venta" SortExpression="FrmtoVentaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Costo"           SortExpression="Costo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCosto" runat="server" Text='<%# Eval("Costo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Asignado"        SortExpression="Asignado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAsignado" runat="server" Text='<%# Eval("Asignado","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Almafrigo"       SortExpression="Almafrigo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAlmafrigo" runat="server" Text='<%# Eval("Almafrigo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Produccion"      SortExpression="Produccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProduccion" runat="server" Text='<%# Eval("Produccion","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Toledo"          SortExpression="Toledo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblToledo" runat="server" Text='<%# Eval("Toledo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Icestar"         SortExpression="Icestar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblIcestar" runat="server" Text='<%# Eval("Icestar","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="StockTotal"      SortExpression="StockTotal" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblStockTotal" runat="server" Text='<%# Eval("StockTotal","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <i class="fas fa-exclamation-circle"></i>
                            <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                        </EmptyDataTemplate>
                        <PagerStyle CssClass="pagination-ys" />
                    </asp:GridView>
                </div>

                <div class="table-responsive p-1 d-none" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                    <asp:GridView ID="gvListExport"
                        CssClass="table table-sm table-bordered table-hover header-grid"
                        AutoGenerateColumns="False"
                        runat="server" 
                        AllowPaging="false" 
                        RowStyle-CssClass="row-grid"
                        HeaderStyle-CssClass="header-grid-small headfijo"
                        
                        >
                        <Columns>
                            <asp:TemplateField HeaderText="SKU"             SortExpression="ProdCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdCode"  runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Descripción"     SortExpression="ProdNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server"  Text='<%# Eval("ProdNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Tipo"            SortExpression="Tipo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Tiene Receta"    SortExpression="TieneReceta" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTieneReceta" runat="server" Text='<%# Eval("TieneReceta") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Es Desglose"     SortExpression="EsDesglose" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEsDesglose" runat="server" Text='<%# Eval("EsDesglose") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Activo"          SortExpression="Activo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblActivo" runat="server" Text='<%# Eval("Activo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Refrigeración"   SortExpression="RefrigeraNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Marca"           SortExpression="MarcaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Origen"          SortExpression="OrigenNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Formato"      SortExpression="FormatoNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFormatoNombre" runat="server" Text='<%# Eval("FormatoNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Formato Venta" SortExpression="FrmtoVentaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Costo"           SortExpression="Costo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCosto" runat="server" Text='<%# Eval("Costo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Asignado"        SortExpression="Asignado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAsignado" runat="server" Text='<%# Eval("Asignado","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Almafrigo"       SortExpression="Almafrigo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAlmafrigo" runat="server" Text='<%# Eval("Almafrigo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Produccion"      SortExpression="Produccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProduccion" runat="server" Text='<%# Eval("Produccion","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Toledo"          SortExpression="Toledo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblToledo" runat="server" Text='<%# Eval("Toledo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="Icestar"         SortExpression="Icestar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblIcestar" runat="server" Text='<%# Eval("Icestar","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                            <asp:TemplateField HeaderText="StockTotal"      SortExpression="StockTotal" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblStockTotal" runat="server" Text='<%# Eval("StockTotal","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <i class="fas fa-exclamation-circle"></i>
                            <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                        </EmptyDataTemplate>
                        <PagerStyle CssClass="pagination-ys" />
                    </asp:GridView>
                </div>
            </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
