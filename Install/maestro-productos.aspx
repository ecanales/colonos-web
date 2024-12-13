<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="maestro-productos.aspx.cs" Inherits="Colonos.Web.maestros.maestro_productos" EnableEventValidation = "false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- INI POPUP PRODUCTO -->
    <asp:Panel ID="pnlProducto" runat="server" Style="display: none; width:90%;max-width:800px;min-width:400px;">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnGuardar" />
                <asp:AsyncPostBackTrigger ControlID="txtBuscar" />
                <asp:AsyncPostBackTrigger ControlID="gvList" />
                <asp:AsyncPostBackTrigger ControlID="btnNuevo" />
            </Triggers>
            <ContentTemplate>
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header2 color-negro2">
                                <h2 class="modal-title p-1" id="exampleModalLiveLabel3">
                                    <span>
                                        <asp:Label ID="lblTituloPopup" runat="server" CssClass="p-2" Text="Producto"></asp:Label>
                                    </span>
                                    <asp:LinkButton ID="btnClose" CssClass="btn-close p-sm-2 m-1 float-end font-size-large" runat="server" OnClick="ClosePopup"></asp:LinkButton>
                                </h2>
                                
                            </div>

                            <div class="modal-body p-3" style="max-height: 500px; min-height: 200px;">
                                <div>
                                    <div id="divcatDF" runat="server" class="row mb-2 opacity-100">
                                        <div class="col-sm-6">
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption" style="background-color:red;color:white;">DF Cat</span><asp:DropDownList ID="cboDFCat" runat="server" AutoPostBack="true" OnSelectedIndexChanged="CargaSubCatDF_Event" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption" style="background-color:red;color:white;">DF SubCat</span><asp:DropDownList ID="cboDFSubCat" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Familia</span><asp:DropDownList ID="cboFamilia" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Código (SKU)</span><asp:TextBox ID="txtItemCode" runat="server" CssClass="form-control" placeholder="sku"></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Descripción</span><asp:TextBox ID="txtItemName" runat="server" CssClass="form-control" placeholder="descripción"></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Tipo</span><asp:DropDownList ID="cboTipo" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Categoría</span><asp:DropDownList ID="cboCategoria" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Animal</span><asp:DropDownList ID="cboAnimal" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Formato</span><asp:DropDownList ID="cboFormato" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Refrigeración</span><asp:DropDownList ID="cboRefigeracion" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Formato Venta</span><asp:DropDownList ID="cboFormatoVenta" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">UMedida</span><asp:DropDownList ID="cboUmedida" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Proveedor</span><asp:TextBox ID="txtProveedor" runat="server" CssClass="form-control" placeholder="proveedor"></asp:TextBox><span class="input-group-text"><i class="fas fa-search"></i></span></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Marca</span><asp:DropDownList ID="cboMarca" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Procedencia</span><asp:DropDownList ID="cboProcedencia" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Activo</span><asp:CheckBox ID="chkActivo" CssClass="form-control" runat="server" /></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Es Desglose</span><asp:CheckBox ID="chkDesglose" CssClass="form-control" runat="server" /></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Tiene Receta</span><asp:CheckBox ID="chkTieneReceta"  CssClass="form-control" runat="server" /></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Costo</span><asp:TextBox ID="txtCosto" runat="server" Text='<%# Eval("Costo") %>'  CssClass="form-control" placeholder="Costo unitario"></asp:TextBox></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer" style="border: none;">
                                <div class="row p-2">
                                    <div class="col-sm-6">
                                    </div>
                                    <div class="col-sm-6">
                                        <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-danger btn-sm float-end" OnClientClick="showLoading()" OnClick="Guardar_Event"><i class="far fa-save d-inline"></i><span class="d-inline p-1">Guardar</span></asp:LinkButton>
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
    <div class="container-fluid">
        <div class="card card-top">
            <div class="card-header fw-bold font-size-xx-large">
            Maestro de Productos
            </div>
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExport" />
                </Triggers>
                <ContentTemplate>
                     <div class="loading-overlay" id="loadingOverlay">
                        <div class="loading-spinner"></div>
                    </div>
                    <div class="card-body" style="height:75vh;">
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
                                  <asp:LinkButton ID="btnNuevo" runat="server" CssClass="btn btn-danger" OnClick="Nuevo_Event">Nuevo Producto</asp:LinkButton>
                              </li>
                              <li class="nav-item">
                                    <asp:LinkButton ID="btnRefresh" CssClass="btn btn-nav" runat="server" OnClick="Refresh_Event"><i class="fas fa-sync-alt p-1"></i>Actualizar</asp:LinkButton>
                                </li>
                                <li class="nav-item">
                                    <asp:LinkButton ID="btnExport" CssClass="btn btn-nav" runat="server" OnClick="ExportToExcel"><i class="fas fa-file-excel p-1"></i>Exportar</asp:LinkButton>
                                </li>
                              <li class="nav-item">
                                    <span class="btn btn-nav">
                                        <asp:CheckBox ID="chkActivos" Text="" Checked="true" runat="server"/><label style="margin-left:5px;" >Solo Activos</label>
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
                                AllowPaging="true" 
                                PageSize="100"
                                OnPageIndexChanging="gvList_PageIndexChanging"
                                RowStyle-CssClass="row-grid"
                                HeaderStyle-CssClass="header-grid-small headfijo"
                                AllowSorting="true"
                                OnSorting="gvBandeja_Sorting"
                                CaptionAlign="Top"
                                >
                                <Columns>
                                    <asp:TemplateField HeaderText="SKU"         SortExpression="ProdCode" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblProdCode"  runat="server" OnClick="Editar_Event" Text='<%# Eval("ProdCode") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Descripción" SortExpression="ProdNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server"  Text='<%# Eval("ProdNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Familia"     SortExpression="FamiliaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFamiliaNombre" runat="server" Text='<%# Eval("FamiliaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tipo"        SortExpression="Tipo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Animal"      SortExpression="AnimalNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAnimalNombre" runat="server" Text='<%# Eval("AnimalNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Formato"      SortExpression="FormatoNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFormatoNombre" runat="server" Text='<%# Eval("FormatoNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Refrigeración" SortExpression="RefrigeraNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="FormatoVenta" SortExpression="FrmtoVentaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="UMedida"     SortExpression="MedidaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMedidaNombre" runat="server" Text='<%# Eval("MedidaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Marca"       SortExpression="MarcaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Procedencia"       SortExpression="OrigenNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Activo"      SortExpression="Activo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblActivo" runat="server" Text='<%# Eval("Activo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Es Desglose"      SortExpression="EsDesglose" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEsDesglose" runat="server" Text='<%# Eval("EsDesglose") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tiene Receta"      SortExpression="TieneReceta" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTieneReceta" runat="server" Text='<%# Eval("TieneReceta") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Almafrigo"       SortExpression="Almafrigo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAlmafrigo" runat="server" Text='<%# Eval("Almafrigo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Produccion"      SortExpression="Produccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProduccion" runat="server" Text='<%# Eval("Produccion","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Toledo"          SortExpression="Toledo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblToledo" runat="server" Text='<%# Eval("Toledo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Icestar"         SortExpression="Icestar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblIcestar" runat="server" Text='<%# Eval("Icestar","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                </EmptyDataTemplate>
                                <PagerStyle CssClass="pagination-ys" />
                            </asp:GridView>
                        </div>
                        <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                            <asp:GridView ID="gvListExport"
                                CssClass="table table-sm table-bordered table-hover header-grid"
                                AutoGenerateColumns="False"
                                runat="server" 
                                AllowPaging="false" 
                                RowStyle-CssClass="row-grid"
                                HeaderStyle-CssClass="header-grid-small headfijo"
                                CaptionAlign="Top"
                                >
                                <Columns>
                                    <asp:TemplateField HeaderText="SKU"         SortExpression="ProdCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdCode"  runat="server" OnClick="Editar_Event" Text='<%# Eval("ProdCode") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Descripción" SortExpression="ProdNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProdNombre"  runat="server"  Text='<%# Eval("ProdNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Familia"     SortExpression="FamiliaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFamiliaNombre" runat="server" Text='<%# Eval("FamiliaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tipo"        SortExpression="Tipo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTipo" runat="server" Text='<%# Eval("Tipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Animal"      SortExpression="AnimalNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAnimalNombre" runat="server" Text='<%# Eval("AnimalNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Formato"     SortExpression="FormatoNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFormatoNombre" runat="server" Text='<%# Eval("FormatoNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Refrigeración" SortExpression="RefrigeraNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="FormatoVenta" SortExpression="FrmtoVentaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="UMedida"     SortExpression="MedidaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMedidaNombre" runat="server" Text='<%# Eval("MedidaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Marca"       SortExpression="MarcaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Procedencia" SortExpression="OrigenNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Activo"      SortExpression="Activo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblActivo" runat="server" Text='<%# Eval("Activo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Es Desglose" SortExpression="EsDesglose" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEsDesglose" runat="server" Text='<%# Eval("EsDesglose") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tiene Receta" SortExpression="TieneReceta" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTieneReceta" runat="server" Text='<%# Eval("TieneReceta") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Almafrigo"   SortExpression="Almafrigo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAlmafrigo" runat="server" Text='<%# Eval("Almafrigo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Produccion"  SortExpression="Produccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblProduccion" runat="server" Text='<%# Eval("Produccion","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Toledo"      SortExpression="Toledo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblToledo" runat="server" Text='<%# Eval("Toledo","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                    <asp:TemplateField HeaderText="Icestar"     SortExpression="Icestar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblIcestar" runat="server" Text='<%# Eval("Icestar","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>

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

    <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupProducto" runat="server"
        DropShadow="false"
        PopupControlID="pnlProducto"
        TargetControlID="lnkFake"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
</asp:Content>
