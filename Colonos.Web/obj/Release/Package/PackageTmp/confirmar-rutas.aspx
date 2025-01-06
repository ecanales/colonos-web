<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="confirmar-rutas.aspx.cs" Inherits="Colonos.Web.confirmar_rutas" EnableEventValidation = "false" MaintainScrollPositionOnPostback = "true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function fun() {
            console.log("dentro");
            document.getElementById("ContentPlaceHolder1_radEntregaTotal").style.color = "red";
        }
    </script>
    <div>
        <div class="loading-overlay" id="loadingOverlay" style="z-index:100000;">
            <div class="loading-spinner"></div>
        </div>
        <!-- INI POPUP CERRAR RUTA-->
        <asp:Panel ID="pnlCerrarRuta" runat="server" TabIndex="-1" Style="display: none; width: 50%; max-width: 600px;">
        <asp:UpdatePanel runat="server">
            <Triggers>
                <asp:PostBackTrigger ControlID="optEntregaTotal" />
                <asp:PostBackTrigger ControlID="optEntregaParcial" />
                <asp:PostBackTrigger ControlID="optNoEntregado" />

                <asp:PostBackTrigger ControlID="optOtraEntregaSI" />
                <asp:PostBackTrigger ControlID="optOtraEntregaNO" />

                <asp:PostBackTrigger ControlID="optPlanta" />
                <asp:PostBackTrigger ControlID="optTransporte" />
                <asp:PostBackTrigger ControlID="optCliente" />

            </Triggers>
            <ContentTemplate>
                <asp:HiddenField ID="HiddenField1" runat="server" />
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header" style="background-color: #a9202c; color: white;">
                                <h2 class="modal-title" id="exampleModalLiveLabel6">
                                    <span>Cerrar Ruta</span>
                                    <asp:Label ID="Label1" runat="server" ForeColor="antiquewhite" Text=""></asp:Label>
                                </h2>
                                <asp:LinkButton ID="LinkButton1" CssClass="btn-close" runat="server" OnClick="ClosePopupCerrar"></asp:LinkButton>
                            </div>
                            <div class="modal-body modal-body-max-height" style="min-height: 300px;height:500px;">
                                <div class="row mb-2 justify-content-center border-top border-secondary">
                                    <label class="text-start" >Tipo de Entrega</label>
                                    <div class="btn-group" role="group" aria-label="Basic radio toggle button group">
                                        <div class="input-group mb-3 p-1">
                                          <span class="input-group-text border border-secondary w-75" id="basic-addon1">Entrega Total</span>
                                            <asp:Label ID="lblEntregaTotal" runat="server" CssClass="m-0 border border-secondary">
                                                <asp:RadioButton ID="optEntregaTotal" runat="server" GroupName="TipoEntrega" AutoPostBack="true" OnCheckedChanged="optEntregaTotal_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                            </asp:Label>
                                        </div>
                                        <div class="input-group mb-3 p-1">
                                          <span class="input-group-text border border-secondary w-75" id="basic-addon2">Entrega Parcial</span>
                                          <asp:Label ID="lblEntregaParcial" runat="server" CssClass="m-0 border border-secondary">
                                              <asp:RadioButton ID="optEntregaParcial" runat="server" GroupName="TipoEntrega" AutoPostBack="true" OnCheckedChanged="optEntregaParcial_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                          </asp:Label>
                                        </div>
                                        <div class="input-group mb-3 p-1">
                                          <span class="input-group-text border border-secondary w-75" id="basic-addon3">No Entregado</span>
                                            <asp:Label ID="lblNoEntregado" runat="server" CssClass="m-0 border border-secondary">
                                                <asp:RadioButton ID="optNoEntregado" runat="server" GroupName="TipoEntrega" AutoPostBack="true" OnCheckedChanged="optNoEntrergado_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                            </asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <asp:Panel ID="pnlOpcionesEntrega" runat="server" Visible="false">
                                    <div class="row mb-2 justify-content-start border-top border-secondary">
                                        <label class="text-start" >Requiere Otra Entrega</label>
                                        <div class="btn-group w-75" role="group" aria-label="Basic radio toggle button group">
                                            <div class="input-group mb-3 p-1 w-25">
                                              <span class="input-group-text border border-secondary" id="basic-addon4">SI</span>
                                                <asp:Label ID="lblOtraEntregaSI" runat="server" CssClass="m-0 border border-secondary">
                                                    <asp:RadioButton ID="optOtraEntregaSI" runat="server" GroupName="OtraEntrega" AutoPostBack="true" OnCheckedChanged="optOtraEntregaSI_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                                </asp:Label>
                                            </div>
                                            <div class="input-group mb-3 p-1 w-25">
                                              <span class="input-group-text border border-secondary" id="basic-addon5">NO</span>
                                                <asp:Label ID="lblOtraEntregaNO" runat="server" CssClass="m-0 border border-secondary">
                                                    <asp:RadioButton ID="optOtraEntregaNO" runat="server" GroupName="OtraEntrega" AutoPostBack="true" OnCheckedChanged="optOtraEntregaNO_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                                </asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mb-2 justify-content-center border-top border-secondary">
                                        <label class="text-start" >Dónde quedaron los Productos</label>
                                        <div class="btn-group" role="group" aria-label="Basic radio toggle button group">
                                            <div class="input-group mb-3 p-1">
                                              <span class="input-group-text border border-secondary w-75" id="basic-addon6">Planta</span>
                                                <asp:Label ID="lblPlanta" runat="server" CssClass="m-0 border border-secondary">
                                                    <asp:RadioButton ID="optPlanta" runat="server" GroupName="Custodia" AutoPostBack="true" OnCheckedChanged="optPlata_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                                </asp:Label>
                                            </div>
                                            <div class="input-group mb-3 p-1">
                                              <span class="input-group-text border border-secondary w-75" id="basic-addon7">Transporte</span>
                                              <asp:Label ID="lblTransporte" runat="server" CssClass="m-0 border border-secondary">
                                                  <asp:RadioButton ID="optTransporte" runat="server" GroupName="Custodia" AutoPostBack="true" OnCheckedChanged="optTransporte_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                              </asp:Label>
                                            </div>
                                            <div class="input-group mb-3 p-1">
                                              <span class="input-group-text border border-secondary w-75" id="basic-addon8">Cliente</span>
                                                <asp:Label ID="lblCliente" runat="server" CssClass="m-0 border border-secondary">
                                                    <asp:RadioButton ID="optCliente" runat="server" GroupName="Custodia" AutoPostBack="true" OnCheckedChanged="optCliente_CheckedChanged" BorderStyle="None" CssClass="form-control text-center bg-transparent" />
                                                </asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                                <div class="row mb-2 justify-content-center border-top border-secondary">
                                    <label class="text-start" >Observaciones (Opcional)</label>
                                    <asp:Label ID="Label3" runat="server" Visible="false" CssClass="text-start w-75" ForeColor="Maroon" Text="Observaciones (Opcional)"></asp:Label>
                                    <asp:TextBox ID="txtObservacionesCierre" runat="server" TextMode="MultiLine" MaxLength="200" Rows="2" CssClass="w-75" ></asp:TextBox>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-12 mb-1" style="display: flex;flex-wrap: wrap;justify-content:center;">
                                        
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-12">
                                        <div class="table-responsive p-1" style="border-top: 2px solid black; overflow-y: auto;max-height: 20rem;">
                                            <asp:GridView ID="gvCerrarRutas"
                                                CssClass="table table-sm2 table-bordered table-hover header-grid"
                                                AutoGenerateColumns="False"
                                                runat="server"
                                                AllowPaging="false"
                                                RowStyle-CssClass="row-grid-smaller"
                                                HeaderStyle-CssClass="header-grid-smaller headfijo"
                                                FooterStyle-CssClass="footertable footerfijo"
                                                >
                                                <Columns>
                                                    <asp:TemplateField HeaderText="DocEntry"    SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Factura"   HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFolioDF"  runat="server" Width="40" Text='<%# Eval("FolioDF") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Pedido"        HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPedido"  runat="server" Width="40" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Cliente"       HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="200" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
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
                                <asp:LinkButton ID="btnCerrarRutaPopupOK" runat="server" OnClientClick="showLoading()" OnClick="CerrarRutaOK" CssClass="btn btn-sm btn-danger">Guardar Cierre</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
        <!-- FIN POPUP CERRAR RUTA -->

        <!-- INI POPUP CERRAR CON RCT / RCC-->
        <asp:Panel ID="pnlCerrarRutaRCTRCC" runat="server" TabIndex="-1" Style="display: none; width: 50%; max-width: 600px;">
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="HiddenField2" runat="server" />
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header" style="background-color: #a9202c; color: white;">
                                <h2 class="modal-title" id="exampleModalLiveLabel7">
                                    <span>Cerrar Ruta / NO ENTREGADO </span>
                                    <asp:Label ID="Label4" runat="server" ForeColor="antiquewhite" Text=""></asp:Label>
                                </h2>
                                <asp:LinkButton ID="LinkButton2" CssClass="btn-close" runat="server" OnClick="ClosePopupCerrarRTC"></asp:LinkButton>
                            </div>
                            <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                <div class="row mb-2">
                                    <div class="col-sm-12" style="display: flex;flex-wrap: wrap;justify-content: space-evenly;">
                                       <h2><asp:Label ID="Label5" runat="server" Text="Productos quedan en Custodia"></asp:Label></h2>
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-12 mb-1" style="display: flex;flex-wrap: wrap;justify-content: space-evenly;">
                                        <asp:LinkButton ID="btnCerrarRutaRCT" runat="server" OnClientClick="showLoading()" OnClick="CerrarRutaRCT" CssClass="btn btn-sm btn-danger w-25">Guardar</asp:LinkButton>
                                        <asp:LinkButton ID="btnCerrarRutaRCC" runat="server" OnClientClick="showLoading()" OnClick="CerrarRutaRCC" CssClass="btn btn-sm btn-danger w-25">Guardar</asp:LinkButton>
                                    </div>
                                    <asp:Label ID="Label6" runat="server" CssClass="text-center" ForeColor="Maroon" Text="Las Facturas vuelven a Bandeja Logística para ser planificadas"></asp:Label>
                                </div>
                                <div class="row mb-2 justify-content-center">
                                    <div class="navbar-brand d-flex input-group w-auto">
                                        <asp:TextBox ID="txtCustodio" runat="server" CssClass="form-control" placeholder="Ingrese Custodio"></asp:TextBox>
                                        <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server"  ><i class="fas fa-search"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div class="row mb-2 justify-content-center">
                                    <asp:TextBox ID="txtObservacionesCierreCustodio" runat="server" TextMode="MultiLine" MaxLength="200" Rows="2" CssClass="w-75" ></asp:TextBox>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-12">
                                        <div class="table-responsive p-1" style="border-top: 2px solid black; overflow-y: auto;max-height: 20rem;">
                                            <asp:GridView ID="gvCerrarRutasRCTRCC"
                                                CssClass="table table-sm2 table-bordered table-hover header-grid"
                                                AutoGenerateColumns="False"
                                                runat="server"
                                                AllowPaging="false"
                                                RowStyle-CssClass="row-grid-smaller"
                                                HeaderStyle-CssClass="header-grid-smaller headfijo"
                                                FooterStyle-CssClass="footertable footerfijo"
                                                >
                                                <Columns>
                                                    <asp:TemplateField HeaderText="DocEntry"    SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Factura"   HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFolioDF"  runat="server" Width="40" Text='<%# Eval("FolioDF") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Pedido"        HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblPedido"  runat="server" Width="40" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Cliente"       HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="200" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
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
                                <asp:Button ID="Button3" CssClass="btn btn-secondary btn-sm" runat="server" OnClick="ClosePopupCerrarRTC" Text="Cerrar" />
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
        <!-- FIN POPUP CERRAR CON RCT / RCC -->

        <!-- INI POPUP DETALLE BANDEJA-->
        <asp:Panel ID="pnlDetalleBandeja" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="HiddenFieldDocentry" runat="server" />
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header" style="background-color: #a9202c; color: white;">
                                <h2 class="modal-title" id="exampleModalLiveLabel5">
                                    <span>Documento: </span>
                                    <asp:Label ID="lblRazonSocion" runat="server" ForeColor="antiquewhite" Text="Cliente"></asp:Label>
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
                                            <asp:CheckBox ID="chkRetiraCliente" CssClass="form-control text-center" runat="server" />
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="input-group input-group-sm mb-1">
                                            <span class="input-group-text label-caption-130">Neto</span>
                                            <asp:TextBox ID="txtNeto" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                        </div>
                                        <div class="input-group input-group-sm mb-1">
                                            <span class="input-group-text label-caption-130">IVA</span>
                                            <asp:TextBox ID="txtIVA" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                        </div>
                                        <div class="input-group input-group-sm mb-1">
                                            <span class="input-group-text label-caption-130">Total</span>
                                            <asp:TextBox ID="txtTotal" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
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
                                                ShowFooter="true"
                                                FooterStyle-CssClass="footertable footerfijo"
                                                OnRowDataBound="gvDetalle_RowDataBound"
                                                >
                                                <Columns>
                                                    <asp:TemplateField HeaderText="LineaItem" HeaderStyle-CssClass="" Visible="false">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblLineaItem" runat="server" Text='<%# Eval("LineaItem") %>' /></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" Width="3%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblProdNombre" runat="server" CssClass="text-truncate w-100" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Left" Width="12%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Completado" Visible="false" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblCompletado" runat="server" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Bodega" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblBodegaCode" runat="server" Text='<%# Eval("BodegaCode") %>' /></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Precio" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblPrecioFinal" CssClass="text-end" runat="server" Text='<%# Eval("PrecioFinal","{0:N0}") %>' /></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Solicitado" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="txtCantidad" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("CantidadSolicitada","{0:N2}") %>'></asp:Label></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Pendiente" Visible="false" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="txtPendiente" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("CantidadPendiente","{0:N2}") %>'></asp:Label></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Marcado" Visible="false" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="txtCantidadReal" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("CantidadReal","{0:N2}") %>'></asp:Label></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass="">
                                                        <ItemTemplate>
                                                            <asp:Label ID="txtTotalReal" Width="70" CssClass="text-end" runat="server" Text='<%# Eval("TotalReal","{0:N0}") %>'></asp:Label></ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle>
                                                    </asp:TemplateField>

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
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExport" />
                    <asp:PostBackTrigger ControlID="gvRutas" />
                </Triggers>
                <ContentTemplate>
                    
                    <div class="card card-top" style="overflow:hidden;">
                        <div class="card-header fw-bold font-size-xx-large">
                            <span>Bandeja CONFIRMAR RUTAS
                                <asp:Label ID="lblTotalRegistrosBandeja"  runat="server" CssClass="badge bg-danger font-size-large position-absolute m-1"  Text="0"></asp:Label>
                            </span>
                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar p-0" ">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse p-0" id="mynavbar">
                                        <div class="navbar-brand d-flex input-group w-auto p-0">
       <%--                                     <input
                                                type="search"
                                                class="form-control"
                                                placeholder="Buscar"
                                                aria-label="Search"
                                                aria-describedby="search-addon" />
                                            <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server"><i class="fas fa-search"></i></asp:LinkButton>--%>
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
                                </div>
                            </nav>

                            <div class="row mb-1">
                                <div class="col-sm-2">
                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 15rem);">
                                        <asp:GridView ID="gvRutas"
                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                            AutoGenerateColumns="False"
                                            runat="server"
                                            AllowPaging="true"
                                            PageSize="100"
                                            RowStyle-CssClass="row-grid"
                                            HeaderStyle-CssClass="header-grid headfijo"
                                            AllowSorting="true"
                                            OnSorting="gvRutas_Sorting"
                                            >
                                            <Columns>
                                                <asp:TemplateField HeaderText="" Visible="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"><HeaderTemplate><asp:CheckBox ID="checkbox2" AutoPostBack="true" OnCheckedChanged="CheckAll" runat="server" Width="20" /></HeaderTemplate><ItemTemplate><asp:CheckBox ID="chkSeleccionado" runat="server" /></ItemTemplate><ItemStyle Width="1%" HorizontalAlign="Left"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="scenario_token"    SortExpression="scenario_token" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblscenario_token" runat="server" Text='<%# Eval("scenario_token") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="DocEntry"    SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Est"          SortExpression="DocEstado" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ruta Drivin"          SortExpression="Descripcion" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblDescripcion"  runat="server" OnClick="Filtrar_Event" CssClass="text-truncate" Text='<%# Eval("Descripcion") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="40%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Fecha Creación"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaRegistro" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Vehiculo"          SortExpression="Vehiculo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblVehiculo"  runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("Vehiculo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Us"         SortExpression="UsuarioNombre" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle></asp:TemplateField>
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <i class="fas fa-exclamation-circle"></i>
                                                <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                            </EmptyDataTemplate>
                                            <PagerStyle CssClass="pagination-ys" />
                                        </asp:GridView>
                                    </div>
                                </div>
                                <div class="col-sm-10">
                                    <nav class="navbar navbar-expand-lg navbar-light p-0 m-0" style="background-color:#fff3cd;border-top: 1px solid maroon;">
                                        <div class="container-fluid">
                                            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"  data-bs-target="#mynavbar">
                                                <span class="navbar-toggler-icon"></span>
                                            </button>
                                            <div class="collapse navbar-collapse p-0" id="mynavbar2">
                                                <div class="navbar-brand d-flex input-group w-auto p-0">
                                                    <ul class="navbar-nav">
                                                        <li class="nav-item">
                                                            <asp:LinkButton ID="btnCerrarRuta" CssClass="btn btn-sm btn-outline-success m-1" runat="server" OnClick="CerrarRuta_Event"><i class="fas fa-check-circle p-1"></i>Cerrar Ruta</asp:LinkButton>
                                                        </li>
                                                        <li class="nav-item">
                                                            <asp:LinkButton ID="btnGenerarRCT" Visible="false" CssClass="btn btn-sm btn-outline-danger m-1" runat="server" OnClick="GeneraRCT_Event"><i class="fas fa-exclamation-circle p-1"></i>Cerrar con RCT</asp:LinkButton>
                                                        </li>
                                                        <li class="nav-item">
                                                            <asp:LinkButton ID="btnGenerarRCC" Visible="false" CssClass="btn btn-sm btn-outline-danger m-1" runat="server" OnClick="GeneraRCC_Event"><i class="fas fa-exclamation-circle p-1"></i>Cerrar con RCC</asp:LinkButton>
                                                        </li>
                                                        <li>
                                                            <h4><asp:Label ID="lblRutaSeleccionada" Font-Bold="true" runat="server" CssClass="btn btn-sm font-size-large" Text=""></asp:Label></h4>
                                                        </li>        
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="float-end">
                                                
                                            </div>
                                        </div>
                                    </nav>
                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 20rem);">
                                        <asp:GridView ID="gvBandeja"
                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                            AutoGenerateColumns="False"
                                            runat="server"
                                            AllowPaging="true"
                                            PageSize="100"
                                            RowStyle-CssClass="row-grid"
                                            HeaderStyle-CssClass="header-grid headfijo"
                                            AllowSorting="true"
                                            OnSorting="gvBandeja_Sorting"
                                            >
                                            <Columns>
                                                <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"><HeaderTemplate><asp:CheckBox ID="checkbox2" AutoPostBack="true" OnCheckedChanged="CheckAll" runat="server" Width="20" /></HeaderTemplate><ItemTemplate><asp:CheckBox ID="chkSeleccionado" runat="server" /></ItemTemplate><ItemStyle Width="1%" HorizontalAlign="Center"></ItemStyle></asp:TemplateField>

                                                <asp:TemplateField HeaderText="DocEntry"    SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Est"          SortExpression="DocEstado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Width="30" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Sub/Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Width="20" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>

                                                <asp:TemplateField HeaderText="Factura"          SortExpression="FolioDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFolioDF"  runat="server" Width="60" Text='<%# Eval("FolioDF") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" Width="60" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Width="40" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Fecha/Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Dirección"   SortExpression="Direccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDireccion" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("Direccion") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                                
                                                <asp:TemplateField HeaderText="Fecha/Creación"   SortExpression="DocFecha" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Fecha/Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total/Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total/Venta"     SortExpression="Total" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Us"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Vend"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>

                                                <asp:TemplateField HeaderText="Retira Cliente" SortExpression="RetiraCliente" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle></asp:TemplateField>
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
                                            RowStyle-CssClass="row-grid"
                                            HeaderStyle-CssClass="header-grid headfijo"
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
                                                <asp:TemplateField HeaderText="Factura"          SortExpression="FolioDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFolioDF"  runat="server" Width="60" Text='<%# Eval("FolioDF") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Dirección"   SortExpression="Direccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDireccion" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("Direccion") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="DocEntry"    SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Retira Cliente" SortExpression="RetiraCliente" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle></asp:TemplateField>
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
                            <%--<div class="row">
                                <div class="col-sm-12">
                                    
                                    
                                </div>
                            </div>--%>
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
        ID="popupCerrarRuta" runat="server"
        DropShadow="false"
        PopupControlID="pnlCerrarRuta"
        TargetControlID="lnkFake2"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:LinkButton ID="lnkFake3" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupCerrarRutaRCTRCC" runat="server"
        DropShadow="false"
        PopupControlID="pnlCerrarRutaRCTRCC"
        TargetControlID="lnkFake3"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
</asp:Content>
