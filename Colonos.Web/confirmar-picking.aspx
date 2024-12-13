<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="confirmar-picking.aspx.cs" Inherits="Colonos.Web.confirmar_picking" EnableEventValidation = "false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <script type="text/javascript">
        function openPdfPopup(pdfUrl) {
            console.log("dentro de openPdfPopup");
            var popup = window.open('view-pdf.aspx?file=' + encodeURIComponent(pdfUrl), 'PDF Viewer', 'width=850,height=600');
            popup.focus();
        }
    </script>

    <!-- INI POPUP DETALLE BANDEJA-->
    <asp:Panel ID="pnlDetalleBandeja" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
            <asp:UpdatePanel runat="server" ID="UpdatePanelBandeja">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnImprimir" />
                </Triggers>
                <ContentTemplate>
                    <div class="loading-overlay" id="loadingOverlay">
                        <div class="loading-spinner"></div>
                    </div>

                   
                    <asp:HiddenField ID="HiddenFieldDocentry" runat="server" />
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel5">
                                        <span>Marcado</span>
                                        <asp:Label ID="lblRazonSocial" runat="server" ForeColor="antiquewhite" Text=""></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton11" CssClass="btn-close" runat="server" OnClick="ClosePopupBandeja"></asp:LinkButton>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row justify-content-between mb-1">
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
                                                <span class="input-group-text label-caption-130">Responsable</span>
                                                <asp:TextBox ID="txtResponsable" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
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
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Id Picking</span>
                                                <asp:TextBox ID="txtDocEntryPicking" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-sm-2">
                                            <div class="row mb-4">
                                                <div class="col-sm-12">
                                                    <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-sm btn-danger float-end wd-120" OnClientClick="showLoading()" OnClick="Guardar_Event"><i class="far fa-save p-1"></i>Guardar</asp:LinkButton>
                                                </div>
                                            </div>
                                            <div class="row mb-0">
                                                <div class="col-sm-12">
                                                    <asp:LinkButton ID="btnConfirmar" runat="server" CssClass="btn btn-sm btn-success float-end wd-120" OnClientClick="showLoading()" OnClick="Confirmar_Event"><i class="far fa-thumbs-up p-1"></i>Confirmar</asp:LinkButton>
                                                </div>
                                            </div>
                                            <div class="row mb-0">
                                                <div class="col-sm-12" style="display: flex;align-items: center;justify-content: center;">
                                                    <asp:CheckBox ID="chkConfirmar" Checked="false" AutoPostBack="false" CssClass="float-end p-2" Text="" Font-Size="Small" runat="server" />
                                                    <label style="color:red;">Confirmo cierre</label>
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
                                                    <asp:TemplateField HeaderText="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="DocLinea" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocLinea" runat="server" Text='<%# Eval("DocLinea") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="BaseEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblBaseEntry" runat="server" Text='<%# Eval("BaseEntry") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="BaseLinea" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblBaseLinea" runat="server" Text='<%# Eval("BaseLinea") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <%--<asp:TemplateField HeaderText="BaseTipo" HeaderStyle-CssClass="" Visible="true"><ItemTemplate><asp:Label ID="lblBaseTipo" runat="server" Text='<%# Eval("BaseTipo") %>' /></ItemTemplate><ItemStyle Width="3%"></ItemStyle></asp:TemplateField>--%>
                                                    <asp:TemplateField HeaderText="LineaItem" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblLineaItem" runat="server" Text='<%# Eval("LineaItem") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="TieneReceta" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblTieneReceta" runat="server" Text='<%# Eval("TieneReceta") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Tipo" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblTipoCode" runat="server" Text='<%# Eval("TipoCode") %>' /></ItemTemplate>                   <ItemStyle  Width="1%" HorizontalAlign="Center"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombre" runat="server" Width="100%" CssClass="text-truncate" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="12%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Marca" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblMarcaNombre" runat="server" Text='<%# Eval("MarcaNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Refrigeración" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblRefrigeraNombre" runat="server" Text='<%# Eval("RefrigeraNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Origen" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblOrigenNombre" runat="server" Text='<%# Eval("OrigenNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Formato Vta" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblFrmtoVentaNombre" runat="server" Text='<%# Eval("FrmtoVentaNombre") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Bodega" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblBodegaCode" CssClass="text-end w-100" runat="server" Text='<%# Eval("BodegaCode") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Stock Actual" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblStockActual"  CssClass="text-end" runat="server" Text='<%# Eval("StockActual","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Solicitado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblCantidad"  CssClass="text-end" runat="server" Text='<%# Eval("CantidadSolicitada","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Kilos Marcados" HeaderStyle-CssClass="">
                                                        <ItemTemplate><asp:TextBox ID="lblCantidadReal" CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadReal","{0:N2}") %>'></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="NumericOnlyValidator3" runat="server" ControlToValidate="lblCantidadReal" CssClass="d-block" ErrorMessage="valor incorrecto" ForeColor="Red" ValidationExpression="^((?:[1-9]\d*)|(?:(?=[\d.]+)(?:[1-9]\d*|0).\d+))$"></asp:RegularExpressionValidator>
                                                        </ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Cajas" HeaderStyle-CssClass="">
                                                        <ItemTemplate><asp:TextBox ID="lblCajas" CssClass="text-end w-100" runat="server" Text='<%# Eval("Cajas","{0:N0}") %>'></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="NumericOnlyValidator4" runat="server" ControlToValidate="lblCajas" CssClass="d-block" ErrorMessage="valor incorrecto" ForeColor="Red" ValidationExpression="^((?:[0-9]\d*))$"></asp:RegularExpressionValidator>
                                                        </ItemTemplate><ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Desglose"          HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblDesglose" CssClass="text-end w-100" runat="server" OnClick="VerDesglose_Event" ForeColor="Red" ><i class="fas fa-plus-circle fa-lg"></i></asp:LinkButton></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle></asp:TemplateField>
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
                                <div class="modal-footer boxes">
                                    <asp:LinkButton ID="btnImprimir" CssClass="btn btn-primary btn-sm box" OnClientClick="showLoading()"   OnClick="ImprimirPicking_Event" runat="server"><i class="fas fa-print p-1"></i>Imprimir</asp:LinkButton>
                                    <%--<asp:LinkButton ID="btnImprimir" CssClass="btn btn-primary btn-sm box"  OnClick="ImprimirPicking_Event" runat="server"><i class="fas fa-print p-1"></i>Imprimir</asp:LinkButton>--%>
                                    <asp:Button ID="Button3" CssClass="btn btn-secondary btn-sm box" runat="server" OnClick="ClosePopupBandeja" Text="Cerrar" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
    <!-- FIN POPUP DETALLE BANDEJA -->

    <!-- INI POPUP DESGLOSE MARCADO-->
    <asp:Panel ID="pnlDesglose" runat="server" TabIndex="-1" Style="display: none; width: 80%; max-width: 1000px;">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content" style="height:90vh;">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel6">
                                        <span>Desglose Marcado</span>
                                        <asp:Label ID="Label1" runat="server" ForeColor="antiquewhite" Text=""></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton1" CssClass="btn-close" runat="server" OnClick="ClosePopupDesglose"></asp:LinkButton>
                                </div>
                                <div class="modal-body " style="min-height: 300px;">
                                    <div class="row mb-1">
                                        <div class="col-sm-11">
                                            <asp:Label ID="lblProducto" runat="server" ForeColor="#a9202c" Font-Size="XX-Large" Text=""></asp:Label>
                                        </div>
                                    </div>
                                    <div class="row justify-content-between">
                                        <div class="col-sm-5">
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Numero</span>
                                                <asp:TextBox ID="txtNumeroPedidoDesglose" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Cliente</span>
                                                <asp:TextBox ID="txtClienteDesglose" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Vendedor</span>
                                                <asp:TextBox ID="txtVendedorDesglose" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">SKU</span>
                                                <asp:TextBox ID="txtProdCodeDesglose" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Formato</span>
                                                <asp:TextBox ID="txtFormatoDesglose" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Refrigeración</span>
                                                <asp:TextBox ID="txtRefrigeracionDesglose" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1">
                                                <span class="input-group-text label-caption-130">Marca</span>
                                                <asp:TextBox ID="txtMarcaDesglose" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:LinkButton ID="btnGuardarDesglos" runat="server" CssClass="btn btn-sm btn-danger float-end wd-120" OnClick="GuardarDesglose_Event"><i class="far fa-save p-1"></i>Guardar</asp:LinkButton>
                                        </div>
                                    </div>

                                    <div class="row mb-2">
                                        <div class="col-sm-12">
                                            <div class="table-responsive p-1" style="border-top: 2px solid black; overflow-y: auto;height: calc(90vh - 310px);">
                                                <asp:GridView ID="gvDesglose"
                                                CssClass="table table-sm table-bordered header-grid"
                                                AutoGenerateColumns="False"
                                                runat="server" 
                                                AllowPaging="false" 
                                                RowStyle-CssClass="row-grid-smaller"
                                                HeaderStyle-CssClass="header-grid-smaller headfijo"
                                                OnRowDataBound="gvDesglose_RowDataBound"
                                                >
                                                <Columns>
                                                    <asp:TemplateField HeaderText="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntryDesglose" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="DocLinea" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocLineaDesglose" runat="server" Text='<%# Eval("DocLinea") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="BaseEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblBaseEntryDesglose" runat="server" Text='<%# Eval("BaseEntry") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="BaseLinea" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblBaseLineaDesglose" runat="server" Text='<%# Eval("BaseLinea") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Clase" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdTipoDesglose" runat="server" Text='<%# Eval("ProdTipo") %>' /></ItemTemplate>                   <ItemStyle  Width="5%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCodeDesglose" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle  Width="15%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Tipo" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblTipoCodeDesglose" runat="server" Text='<%# Eval("TipoCode") %>' /></ItemTemplate>                   <ItemStyle  Width="1%" HorizontalAlign="Center"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombreDesglose" runat="server" Width="100%" CssClass="text-truncate" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle Width="48%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Bodega"  Visible="false" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblBodegaCodeDesglose" CssClass="text-end w-100" runat="server" Text='<%# Eval("BodegaCode") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                                    
                                                    <%--<asp:TemplateField HeaderText="Bodega" HeaderStyle-CssClass=""><ItemTemplate><asp:DropDownList ID="cboBodegaCode" runat="server" CssClass="w-100 form-select form-select-sm"></asp:DropDownList></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="14%"></ItemStyle></asp:TemplateField>--%>
                                                    <asp:TemplateField HeaderText="Stock Actual" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblStockActualDesglose" CssClass="text-end w-100" runat="server" Text='<%# Eval("StockActual","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Solicitado" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblCantidadDesglose" CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadSolicitada","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Kilos Marcados" HeaderStyle-CssClass=""><ItemTemplate>
                                                            <asp:TextBox ID="txtCantidadRealDesglose" CssClass="text-end w-100" runat="server" Text='<%# Eval("CantidadReal","{0:N2}") %>'></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="NumericOnlyValidator" runat="server" ControlToValidate="txtCantidadRealDesglose" CssClass="d-block" ErrorMessage="valor incorrecto" ForeColor="Red" ValidationExpression="^((?:[1-9]\d*)|(?:(?=[\d.]+)(?:[1-9]\d*|0).\d+))$"></asp:RegularExpressionValidator>                                                        </ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Cajas" Visible="false" HeaderStyle-CssClass="">                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtCajasDesglose" CssClass="text-end w-100" runat="server" Text='<%# Eval("Cajas","{0:N0}") %>'></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="NumericOnlyValidator2" runat="server" ControlToValidate="txtCajasDesglose" CssClass="d-block" ErrorMessage="valor incorrecto" ForeColor="Red" ValidationExpression="^((?:[1-9]\d*))$"></asp:RegularExpressionValidator>
                                                        </ItemTemplate><ItemStyle HorizontalAlign="Right" Width="10%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="ProdCodeRefGlosa" Visible="false" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCodeRefGlosa" runat="server" Text='<%# Eval("ProdCodeRefGlosa") %>' /></ItemTemplate>                   <ItemStyle  Width="15%"></ItemStyle></asp:TemplateField>
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
                                    
                                    <asp:Button ID="Button2" CssClass="btn btn-secondary btn-sm" runat="server" OnClick="ClosePopupDesglose" Text="Cerrar" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </asp:Panel>
    <!-- FIN POPUP DESGLOSE MARCADO -->

    <div class="container-fluid">
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExport" />
                    <asp:PostBackTrigger ControlID="cboOperadores" />
                    <asp:PostBackTrigger ControlID="gvBandeja" />
                    
                </Triggers>
                <ContentTemplate>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            <span>
                                <asp:Label ID="lblTitulo" runat="server" Text="">
                                </asp:Label>
                                <asp:Label ID="lblTotalRegistrosBandeja" runat="server" CssClass="badge bg-danger font-size-large position-absolute m-1"  Text="0"></asp:Label>
                            </span>

                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar p-0">
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

                                        <ul class="navbar-nav">
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnRefresh" CssClass="btn btn-nav" runat="server" OnClick="Refresh_Event"><i class="fas fa-sync-alt p-1"></i>Actualizar</asp:LinkButton>
                                            </li>
                                            <li class="nav-item">
                                                <asp:LinkButton ID="btnExport" CssClass="btn btn-nav" runat="server" OnClick="ExportToExcel"><i class="fas fa-file-excel p-1"></i>Exportar</asp:LinkButton>
                                            </li>
                                        </ul>
                                        <ul class="navbar-nav d-none">
                                            <li class="nav-item">
                                                <div class="input-group input-group-sm mb-1 p-1">
                                                    <span class="input-group-text label-caption" style="color:white;background-color:transparent;">Bodega</span>
                                                    <asp:DropDownList ID="cboBodegas" runat="server" CssClass="form-select" Width="150"></asp:DropDownList>
                                                </div>
                                            </li>
                                        </ul>
                                        <ul class="navbar-nav">
                                            <li class="nav-item">
                                                <div class="input-group input-group-sm mb-1 p-1">
                                                    <span class="input-group-text label-caption color-rojo" >Responsable</span>
                                                    <asp:DropDownList ID="cboOperadores" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FiltrarOperador_Event" Width="180"></asp:DropDownList>
                                                </div>
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
                                    AllowSorting="true"
                                    OnSorting="gvBandeja_Sorting"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Estado"          SortExpression="DocEstado" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Us"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vend"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Creación"   SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="KG por<br/>Marcar"     SortExpression="TotalKilosPorMarcar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosPorMarcar" runat="server" Text='<%# Eval("TotalKilosPorMarcar","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Responsable" SortExpression="UsuarioResponsable" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioResponsable" runat="server" CssClass="text-truncate" Width="120" Text='<%# Eval("UsuarioResponsable") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Etiqueta"     SortExpression="Etiqueta" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEtiqueta" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("Etiqueta") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Left" Width="11%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Condicion"   SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>

                                        <asp:TemplateField HeaderText="Picking"     SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:LinkButton ID="lblDocEntry"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("DocEntry") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="BaseTipo"    SortExpression="BaseTipo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblBaseTipo" runat="server" Text='<%# Eval("BaseTipo") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="TipoDoc"     SortExpression="DocOrigen" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocOrigen" runat="server" Text='<%# Eval("DocOrigen") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocRef"      SortExpression="EntryOrigen" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblEntryOrigen" runat="server" Text='<%# Eval("EntryOrigen") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        
                                        <%--<asp:TemplateField HeaderText="Bodega"      SortExpression="BodegaCode" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblBodegaCode" runat="server" Text='<%# Eval("BodegaCode") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna"      SortExpression="ComunaNombre" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate>                                         <ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Cliente"     SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="35%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"    SortExpression="VendedorCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorCode") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="13%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Completado"  SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>--%>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <i class="fas fa-exclamation-circle"></i>
                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>
                            <div class="table-responsive p-1 d-none" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;    max-height: calc(100vh - 10rem);">
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
                                        <asp:TemplateField HeaderText="Estado"          SortExpression="DocEstado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Creación"   SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPedido"  runat="server" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Usuario"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos por<br/>Marcar"     SortExpression="TotalKilosPorMarcar" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilosPorMarcar" runat="server" Text='<%# Eval("TotalKilosPorMarcar","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Etiqueta"     SortExpression="Etiqueta" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblEtiqueta" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("Etiqueta") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Left" Width="11%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Responsable" SortExpression="UsuarioResponsable" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioResponsable" runat="server" CssClass="text-truncate" Width="120" Text='<%# Eval("UsuarioResponsable") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>

                                        <asp:TemplateField HeaderText="Picking"     SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:LinkButton ID="lblDocEntry"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("DocEntry") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="BaseTipo"    SortExpression="BaseTipo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblBaseTipo" runat="server" Text='<%# Eval("BaseTipo") %>' /></ItemTemplate><ItemStyle Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="TipoDoc"     SortExpression="DocOrigen" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocOrigen" runat="server" Text='<%# Eval("DocOrigen") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="DocRef"      SortExpression="EntryOrigen" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblEntryOrigen" runat="server" Text='<%# Eval("EntryOrigen") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="0%"></ItemStyle></asp:TemplateField>
                                        
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
        ID="popupDesglose" runat="server"
        DropShadow="false"
        PopupControlID="pnlDesglose"
        TargetControlID="lnkFake2"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
    
</asp:Content>
