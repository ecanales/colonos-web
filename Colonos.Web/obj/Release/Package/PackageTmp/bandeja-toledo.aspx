<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="bandeja-toledo.aspx.cs" Inherits="Colonos.Web.bandeja_toledo" EnableEventValidation = "false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function openInNewTab() {
            console.log("dentro de openInNewTab()");
            window.open('/bandeja-toledo', '_blank');
            //window.document.forms[0].target = '_blank';
            //setTimeout(function () { window.document.forms[0].target = ''; }, 0);
        }
        function shwwindow(myurl) {
            console.log("dentro de shwwindow()");
            window.open(myurl, '_blank');
        }
    </script>
    

    <!-- INI POPUP DETALLE BANDEJA-->
    <asp:Panel ID="pnlDetalleBandeja" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
            <asp:UpdatePanel runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnAsignar" />
                </Triggers>
                <ContentTemplate>
                    
                    <asp:HiddenField ID="HiddenFieldDocentry" runat="server" />
                    <asp:HiddenField ID="HiddenFieldDocTipo" runat="server" />
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel5">
                                        <span>Bandeja TOLEDO</span>
                                        <asp:Label ID="lblRazonSocial" runat="server" ForeColor="antiquewhite" Text="Cliente"></asp:Label>
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
                                            <asp:Button ID="Button2" CssClass="btn btn-danger btn-sm" runat="server" OnClick="CerrarItem_Event" Text="Cerrar Item Seleccionado" />
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
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130" style="background-color:#ecf0f3;">Etiquetar</span>
                                                <asp:CheckBox ID="chkEtiquetar" CssClass="form-control text-center" runat="server"  />
                                                <asp:TextBox ID="txtGlosaEtiqueta" runat="server" CssClass="form-control" Width="40%"  placeholder="indique un comentario"></asp:TextBox>
                                                <asp:LinkButton ID="btnEtiquetar" CssClass="btn btn-sm btn-warning text-center" OnClick="Etiquetar_Event" runat="server"><i class="fas fa-exclamation-triangle"></i></asp:LinkButton>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="row mb-4">
                                                <div class="form-group mb-1">
                                                    <label for="txtComentarios">Asignar Responsable</label>
                                                    <asp:DropDownList ID="cboOperadores" runat="server" CssClass="form-select"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="row mb-4 justify-content-end">
                                                <div class="col-sm-6">
                                                    <asp:LinkButton ID="btnAsignar" runat="server" CssClass="btn btn-sm btn-success float-end" OnClientClick="showLoading()"  OnClick="Asignar_Event"  ><i class="far fa-thumbs-up p-1"></i>Asignar</asp:LinkButton>
                                                </div>
                                            </div>
                                            <div class="row mb-4 justify-content-end">
                                                <div class="col-sm-6">
                                                    <asp:LinkButton ID="btnPrepararProd" runat="server" CssClass="btn btn-sm btn-primary float-end"  OnClick="PrepararOrdeProduccion_Event"  ><i class="fas fa-puzzle-piece p-1"></i>Preparar Producción</asp:LinkButton>
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
                                                    <asp:TemplateField HeaderText="*" HeaderStyle-CssClass="" HeaderStyle-HorizontalAlign="Center"><ItemTemplate><asp:CheckBox ID="chkSelItem" runat="server" /></ItemTemplate>             <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="En Produccion" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblEnProduccion" runat="server" Text='<%# Eval("EnProduccion") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Estado" HeaderStyle-CssClass="" Visible="false"><ItemTemplate>     <asp:Label ID="lblLineaEstado" runat="server" Text='<%# Eval("LineaEstado") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="LineaItem" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblLineaItem" runat="server" Text='<%# Eval("LineaItem") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Tipo" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblTipoCode" runat="server" Text='<%# Eval("TipoCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Stock Receta <br/> PRODUCCION" HeaderStyle-CssClass="" Visible="false"><ItemTemplate>     <asp:Label ID="lblStockReceta"  CssClass="text-end w-100" runat="server" Text='<%# Eval("StockReceta","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Stock Receta <br/> TOLEDO" HeaderStyle-CssClass="" Visible="false"><ItemTemplate>     <asp:Label ID="lblStockRecetaMP"  CssClass="text-end w-100" runat="server" Text='<%# Eval("StockRecetaMP","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombre" runat="server"  CssClass="text-truncate w-100" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="12%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Marca" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Origen" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Ya Marcado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblCantidadReal"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadReal","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Stock Actual" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblStock"  CssClass="text-end w-100" runat="server" Text='<%# Eval("StockActual","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Pendiente" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="txtCantidad"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadPendiente","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
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

    <!-- INI POPUP DETALLE ENVIO OPDC-->
    <asp:Panel ID="pnlDetalleOrdenProd" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
            <asp:UpdatePanel runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnAsignar" />
                </Triggers>
                <ContentTemplate>
                    
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                    <asp:HiddenField ID="HiddenField2" runat="server" />
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #0d6efd; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel6">
                                        <span>Preparar Solicitud a PRODUCCION</span>
                                        <asp:Label ID="Label1" runat="server" ForeColor="#343a40" Text=""></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton2" CssClass="btn-close" runat="server" OnClick="ClosePopupOrdenProd"></asp:LinkButton>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-4">
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Numero</span>
                                                <asp:TextBox ID="txtNumeroPedidoProd" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Cliente</span>
                                                <asp:TextBox ID="txtRazonSocialProd" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Vendedor</span>
                                                <asp:TextBox ID="txtVendedorPedidoProd" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Fecha de Entrega</span>
                                                <asp:TextBox ID="txtFechadeEntregaProd" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Fecha Pedido</span>
                                                <asp:TextBox ID="txtFechaPedidoProd" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Retira Cliente</span>
                                                <asp:CheckBox ID="chkRetiraClienteProd" CssClass="form-control text-center" Enabled="false" runat="server"  />
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="row mb-4 justify-content-end">
                                                <div class="col-sm-6">
                                                    <asp:LinkButton ID="btnGenerarOrdenProduccion" runat="server" CssClass="btn btn-sm btn-danger float-end" OnClientClick="showLoading()"  OnClick="GenerarOrdenProduccion_Event"  ><i class="far fa-paper-plane p-1"></i>Enviar a Producción</asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mb-2">
                                        <div class="col-sm-12">
                                            <div class="table-responsive p-1" style="border-top: 2px solid black; overflow-y: auto;">
                                                <asp:GridView ID="gvDetalleOrdenProd"
                                                CssClass="table table-sm table-bordered table-hover header-grid"
                                                AutoGenerateColumns="False"
                                                runat="server" 
                                                AllowPaging="false" 
                                                RowStyle-CssClass="row-grid-smaller"
                                                HeaderStyle-CssClass="header-grid-smaller headfijo"
                                                OnRowDataBound="gvDetalleOrdenProd_RowDataBound"
                                                >
                                                <Columns>
                                                    <asp:TemplateField HeaderText="*" HeaderStyle-CssClass="" HeaderStyle-HorizontalAlign="Center"><ItemTemplate><asp:CheckBox ID="chkSelItem" Checked="true" runat="server" /></ItemTemplate>             <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Estado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblLineaEstado" runat="server" Text='<%# Eval("LineaEstado") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="LineaItem" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblLineaItem" runat="server" Text='<%# Eval("LineaItem") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Tipo" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblTipoCode" runat="server" Text='<%# Eval("TipoCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombre" runat="server"  CssClass="text-truncate w-100" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="12%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Marca" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Origen" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Solicitado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblSolicitado"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadSolicitada","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Ya Marcado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblCantidadReal"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadReal","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Stock Actual" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblStock"  CssClass="text-end w-100" runat="server" Text='<%# Eval("StockActual","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Enviar a Producir" HeaderStyle-CssClass="" HeaderStyle-BackColor="#1e8019">
                                                        <ItemTemplate>     
                                                            <asp:TextBox ID="txtCantidadEnviar"  CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadPendiente","{0:#.##}") %>'></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="NumericOnlyValidator3" runat="server" ControlToValidate="txtCantidadEnviar" CssClass="d-block" ErrorMessage="valor incorrecto" ForeColor="Red" ValidationExpression="^((?:[1-9]\d*)|(?:(?=[\d.]+)(?:[1-9]\d*|0).\d+))$"></asp:RegularExpressionValidator>
                                                        </ItemTemplate><ItemStyle HorizontalAlign="Right" Width="6%"></ItemStyle></asp:TemplateField>
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
                                    <asp:Button ID="Button4" CssClass="btn btn-secondary btn-sm" runat="server" OnClick="ClosePopupOrdenProd" Text="Cerrar" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
    <!-- FIN POPUP DETALLE ENVIO OPDC -->

    
    <div class="container-fluid">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExport" />
                </Triggers>
                <ContentTemplate>
                    <div class="loading-overlay" id="loadingOverlay" style="z-index:16000;">
                        <div class="loading-spinner"></div>
                    </div>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            <span>Bandeja TOLEDO
                                <asp:Label ID="lblTotalRegistrosBandeja" runat="server" CssClass="badge bg-danger font-size-large position-absolute m-1"  Text="0"></asp:Label>
                            </span>
                        </div>
                        <div class="card-body" style="overflow: auto;">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar p-0">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse p-0" id="mynavbar">
                                        <div class="navbar-brand d-flex input-group w-auto">
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
                                            <li class="nav-item">
                                                <span class="btn btn-nav">
                                                    <asp:CheckBox ID="chkSoloEtiquetados" Text="" runat="server"/><label style="margin-left:5px;" >Solo Etiquetados</label>
                                                </span>
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
                                    CaptionAlign="Top"
                                    Caption=""
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Est"          SortExpression="DocEstado" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Us"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vend"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Creación"  SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="150" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Tiene<br/>Prodts.B"     SortExpression="TieneB" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTieneB" runat="server" CssClass="text-truncate" Width="10" Text='<%# Eval("TieneB") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ultimo<br/>Picking"  SortExpression="UltimoPK" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUltimoPK" runat="server" Width="35" Text='<%# Eval("UltimoPK") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="KG por<br/>Marcar"     SortExpression="TotalKilosPorMarcar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosPorMarcar" runat="server" Text='<%# Eval("TotalKilosPorMarcar","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Etiqueta"     SortExpression="Etiqueta" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEtiqueta" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("Etiqueta") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>


                                        <asp:TemplateField HeaderText="Etiquetado"      SortExpression="Etiquetado" HeaderStyle-CssClass="" Visible="false" ><ItemTemplate><asp:CheckBox ID="chkEtiquetado" runat="server" Enabled="false" Checked='<%# Eval("Etiquetado") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocEntry"        SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocTipo"         SortExpression="DocTipo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocTipo" runat="server" Text='<%# Eval("DocTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>

                                        <%--<asp:TemplateField HeaderText="Fecha Ingreso"   SortExpression="FechaIngresoPrep" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" Text='<%# Eval("FechaIngresoPrep","{0:dd/MM/yyyy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"        SortExpression="VendedorCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Impreso"         SortExpression="Impreso" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblImpreso" runat="server" Text='<%# Eval("Impreso") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna"          SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Completado"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Retira Cliente"  SortExpression="RetiraCliente" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Horario Atención"         SortExpression="HorarioAtencion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblHorarioAtencion" runat="server" Text='<%# Eval("Ventana") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Center" Width="7%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Kilos"     SortExpression="CantidadPendiente" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCantidadPendiente" runat="server" Text='<%# Eval("TotalKilosPendientes","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ultimo Picking"  SortExpression="DocEntryPK" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEntryPK" runat="server" Text='<%# Eval("DocEntryPK") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        --%>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <i class="fas fa-exclamation-circle"></i>
                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>

                            <div class="table-responsive p-1 mb-2 d-none" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 82px - 200px);">
                                <asp:GridView ID="gvListExport"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid headfijo"
                                    CaptionAlign="Top"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Estado"             SortExpression="DocEstado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Creación"  SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPedido"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Usuario"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ultimo<br/>Picking"  SortExpression="UltimoPK" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUltimoPK" runat="server" Width="35" Text='<%# Eval("UltimoPK") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos por<br/>Marcar"     SortExpression="TotalKilosPorMarcar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosPorMarcar" runat="server" Text='<%# Eval("TotalKilosPorMarcar","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Etiqueta"     SortExpression="CantidadPendiente" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEtiqueta" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("Etiqueta") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Left" Width="11%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Tiene<br/>Producto<br/>B"     SortExpression="TieneB" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTieneB" runat="server" CssClass="text-truncate" Width="10" Text='<%# Eval("TieneB") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        

                                    </Columns>
                                    <EmptyDataTemplate>
                                        <i class="fas fa-exclamation-circle"></i>
                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>
                            <h3 class="d-none">Solicitudes de Materia Prima</h3>
                            <div class="table-responsive p-1 mb-2 d-none" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 82px - 200px);">
                                <asp:GridView ID="gvBandejamp"
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
                                        <asp:TemplateField HeaderText="Pedido"          HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha Entrega"   HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="11%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Retira Cliente"  HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"        HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorCode") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="11%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Impreso"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblImpreso" runat="server" Text='<%# Eval("Impreso") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Completado"   HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Horario Atención"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblHorarioAtencion" runat="server" Text='<%# Eval("HorarioAtencion") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total Kilos"         HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCantidadPendiente" runat="server" Text='<%# Eval("CantidadPendiente","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
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

    <asp:LinkButton ID="lnkFake2" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupDetalleOrdenProd" runat="server"
        DropShadow="false"
        PopupControlID="pnlDetalleOrdenProd"
        TargetControlID="lnkFake2"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
</asp:Content>
