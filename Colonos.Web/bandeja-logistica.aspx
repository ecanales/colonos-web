<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="bandeja-logistica.aspx.cs" Inherits="Colonos.Web.bandeja_logistica" EnableEventValidation = "false" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
        function ShowPopup() {
            $("#btnShowPopup").click();
        }
        function SetActivaBoton(idboton) {
            console.log("llamada a SetActivaBoton");
            console.log(idboton);
            document.getElementById("ContentPlaceHolder1_btnFiltroHoy").style.backgroundColor = "greenyellow";
        }

    </script>  
    
      
        
    <div class="loading-overlay" id="loadingOverlay" style="z-index:100000;">
        <div class="loading-spinner"></div>
    </div>

    <!-- INI POPUP RCT / RCC-->
        <asp:Panel ID="pnlCerrarRutaRCTRCC" runat="server" TabIndex="-1" Style="display: none; width: 50%; max-width: 600px;">
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="HiddenField2" runat="server" />
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header" style="background-color: #a9202c; color: white;">
                                <h2 class="modal-title" id="exampleModalLiveLabel7">
                                    <span>Pedido en Custodia </span>
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
                                <div class="row mb-2 justify-content-center">
                                    <div class="navbar-brand d-flex input-group w-75">
                                        <asp:TextBox ID="txtCustodio" runat="server" CssClass="form-control w-100" ReadOnly="true" placeholder="Ingrese Custodio"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row mb-2 justify-content-center">
                                    <asp:TextBox ID="txtObservacionesCierreCustodio" runat="server" TextMode="MultiLine" ReadOnly="true" Rows="8" CssClass="w-75" ></asp:TextBox>
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
        <!-- FIN POPUP RCT / RCC -->

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
        <div class="">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnExport" />
                    
                </Triggers>
                <ContentTemplate>
                    
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large" style="display: flex;justify-content: flex-start;">
                            <div>
                            <span>Bandeja LOGÍSTICA
                                <asp:Label ID="lblTotalRegistrosBandeja" runat="server" CssClass="badge bg-danger font-size-large position-absolute m-1"  Text="0"></asp:Label>
                            </span>
                            </div>
                            <div>
                                <asp:Label ID="lblFiltro" runat="server" CssClass="btn-filtro" Text=""></asp:Label>
                            </div>

                        </div>
                        <div class="card-body">
                            <nav class="navbar navbar-expand-lg navbar-light nav-toolbar p-0">
                                <div class="container-fluid">
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse p-0" id="mynavbar">
                                        <div class="navbar-brand d-flex input-group w-auto p-0">
                                            <input
                                                type="search"
                                                class="form-control"
                                                placeholder="Buscar"
                                                aria-label="Search"
                                                aria-describedby="search-addon" />
                                            <asp:LinkButton ID="btnBuscar" CssClass="color-rojo input-group-text border-0" runat="server"><i class="fas fa-search"></i></asp:LinkButton>
                                            </div>
                                            <ul class="navbar-nav">
                                                <li class="nav-item">
                                                    <asp:LinkButton ID="btnRefresh" CssClass="btn btn-nav" runat="server" OnClick="Refresh_Event"><i class="fas fa-sync-alt p-1"></i>Actualizar</asp:LinkButton>
                                                </li>
                                                <li class="nav-item">
                                                    <asp:LinkButton ID="btnAsignar" CssClass="btn btn-nav" runat="server"  OnClick="Asignar_Event"><i class="fas fa-paper-plane p-1"></i>Asignar</asp:LinkButton>
                                                </li>
                                                <li class="nav-item">
                                                    <asp:LinkButton ID="btnExport" CssClass="btn btn-nav" runat="server" OnClick="ExportToExcel"><i class="fas fa-file-excel p-1"></i>Exportar</asp:LinkButton>
                                                </li>
                                                <li class="nav-item">
                                                    <asp:LinkButton ID="btnFiltroHoy" CssClass="btn btn-nav" runat="server" OnClick="Filtrar_Event"><i class="fas fa-filter p-1"></i>
                                                        Entregas Hoy
                                                        <asp:Label ID="lblHoy" runat="server" CssClass="badge text-bg-secondary bg-danger" Text=""></asp:Label>
                                                    </asp:LinkButton>
                                                </li>
                                                <li class="nav-item">
                                                    <asp:LinkButton ID="btnFiltroMañana" CssClass="btn btn-nav" runat="server" OnClick="Filtrar_Event"><i class="fas fa-filter p-1"></i>
                                                        Entregas Mañana
                                                        <asp:Label ID="lblMañana" runat="server" CssClass="badge text-bg-secondary bg-danger" Text=""></asp:Label>
                                                    </asp:LinkButton>
                                                </li>
                                                <li class="nav-item">
                                                    <asp:LinkButton ID="btnFiltroPosterior" CssClass="btn btn-nav" runat="server" OnClick="Filtrar_Event"><i class="fas fa-filter p-1"></i>
                                                        Entregas Posterior
                                                        <asp:Label ID="lblPosterior" runat="server" CssClass="badge text-bg-secondary bg-danger" Text=""></asp:Label>
                                                    </asp:LinkButton>
                                                </li>
                                                <li class="nav-item" style="margin-left:4rem;">
                                                    <asp:LinkButton ID="btnVerSeleccion" runat="server" CssClass="btn btn-danger rounded-circle m-2 float-md-end" data-bs-toggle="offcanvas" data-bs-target="#offcanvasScrolling2" aria-controls="offcanvasScrolling">
                                                        <i class="fas fa-th p-0 font-size-large"></i>
                                                        <asp:Label ID="TotalItems" runat="server" Text="" Visible="false" class="position-absolute translate-middle badge rounded-pill" Style="top: 15px; margin-left: 11px; color: black; background-color: gold"></asp:Label>
                                                    </asp:LinkButton>

                                                </li>
                                            </ul>
                                        
                                        <ul class="navbar-nav">
                                            <li class="nav-item">
                                                <button type="button" style="display: none;" id="btnShowPopup" class="btn btn-primary btn-lg"
                                                    data-bs-toggle="offcanvas" data-bs-target="#offcanvasScrolling2">
                                                    Launch demo modal
                                                </button>
                                            </li>
                                        </ul>
                                        
                                        <%--<ul class="navbar-nav d-block" style="width: 70%;">
                                            
                                        </ul>--%>
                                    </div>
                                </div>
                            </nav>

                            <div class="offcanvas offcanvas-top" style="width: 100%; height: 50vh;" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1" id="offcanvasScrolling2" aria-labelledby="offcanvasScrollingLabel">
                                <div class="offcanvas-header" style="background-color: #a9202c; color: white;">
                                    <h5 class="offcanvas-title" id="offcanvasScrollingLabel">Preselección para generar Rutas en DriveIn</h5>
                                    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                                </div>
                                <div class="offcanvas-body" style="background-color: beige;">
                                    <div class="row justify-content-center">
                                        <div class="col-sm-10">
                                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto; height: 35vh;">
                                                <asp:GridView ID="gvSeleccionados"
                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                    AutoGenerateColumns="False"
                                                    runat="server"
                                                    AllowPaging="false"
                                                    RowStyle-CssClass="row-grid"
                                                    HeaderStyle-CssClass="header-grid headfijo"
                                                    ShowFooter="true"
                                                    FooterStyle-CssClass="footertable footerfijo"
                                                    OnRowDataBound="gvSeleccionados_RowDataBound"

                                                    >
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                           <%-- <HeaderTemplate>
                                                                <asp:CheckBox ID="checkboxSel" AutoPostBack="true" OnCheckedChanged="CheckAllSel" runat="server" />
                                                            </HeaderTemplate>--%>
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSeleccionadoSel" runat="server" />
                                                            </ItemTemplate>
                                                            <ItemStyle Width="2%" HorizontalAlign="Left"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Fecha Entrega" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="DocEntry" HeaderStyle-CssClass="" Visible="false">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Zona" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblZona" runat="server" CssClass="text-truncate" Text='<%# Eval("Zona") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="6%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="SubZona" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSubZona" runat="server" Text='<%# Eval("SubZona") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="6%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Total Kilos" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblCantidadPendiente" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Right" Width="7%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Cliente" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblCliente" runat="server" CssClass="text-truncate w-100" Text='<%# Eval("RazonSocial") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Documento" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblFolioDF" runat="server" Text='<%# Eval("FolioDF") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        
                                                        <asp:TemplateField HeaderText="Retira Cliente" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Dirección" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDireccion" runat="server" CssClass="text-truncate w-100" Text='<%# Eval("Direccion") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Comuna" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblComuna" runat="server" CssClass="text-truncate w-100" Text='<%# Eval("ComunaNombre") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="9%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Ventana" HeaderStyle-CssClass="">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblVentana" runat="server" Text='<%# Eval("Ventana") %>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle>
                                                        </asp:TemplateField>
                                                        <%--<asp:TemplateField HeaderText="" Visible="true" ItemStyle-HorizontalAlign="center">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lblEliminar" runat="server" OnClientClick="ShowPopup();" OnClick="EliminarItem" ><i style="color:black;" class="fas fa-trash-alt"></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="center" Width="5%"></ItemStyle>
                                                        </asp:TemplateField>--%>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        <i class="fas fa-exclamation-circle"></i>
                                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                                    </EmptyDataTemplate>
                                                    <PagerStyle CssClass="pagination-ys" />
                                                </asp:GridView>
                                            </div>
                                        </div>
                                        <div class="col-sm-2">
                                            <div class="row mb-4">
                                                <div class="col-12">
                                                    <div class="form-group">
                                                        <label for="exampleInputEmail1">Vehículo DriveIn</label>
                                                        <%--<input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Enter email">--%>
                                                        <asp:DropDownList ID="cboVehiculo" runat="server" CssClass="form-select"></asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-6">
                                                    <asp:LinkButton ID="btnBorrar" runat="server" CssClass="btn btn-sm btn-secondary float-lg-end w-100"  OnClick="Borrar_Event" OnClientClick="ShowPopup();"  ><i class="fas fa-trash-alt"></i></asp:LinkButton>
                                                </div>
                                                <div class="col-6">
                                                    <asp:LinkButton ID="btnEnviar" runat="server" CssClass="btn btn-sm btn-success float-lg-end w-100" OnClientClick="showLoading()"  OnClick="Enviar_Event" ><i class="fas fa-map-marked-alt float-lg-start"></i>Enviar</asp:LinkButton>
                                                </div>
                                                
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row justify-content-lg-start">
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                </div>
                            </div>
                                
                            
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;max-height: calc(100vh - 16rem);">
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
                                                <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"><HeaderTemplate><asp:CheckBox ID="checkbox2" AutoPostBack="true" OnCheckedChanged="CheckAll" runat="server" Width="20" /></HeaderTemplate><ItemTemplate><asp:CheckBox ID="chkSeleccionado" runat="server" /></ItemTemplate><ItemStyle Width="1%" HorizontalAlign="Left"></ItemStyle></asp:TemplateField>

                                                <asp:TemplateField HeaderText="DocEntry"    SortExpression="DocEntry" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEntry" runat="server" Text='<%# Eval("DocEntry") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Est"          SortExpression="DocEstado" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblDocEstado"  runat="server" Width="30" Text='<%# Eval("DocEstado") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Sub<br/>Estado" SortExpression="EstadoOperativo" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblEstadoOperativo"  runat="server" Width="20" Text='<%# Eval("EstadoOperativo") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Custodio"            SortExpression="TipoCustodio" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblTipoCustodio" runat="server" OnClick="CargaDetalleRCTRCC_Evnet" CssClass="text-truncate" Width="30" Text='<%# Eval("TipoCustodio") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>

                                                <asp:TemplateField HeaderText="BaseEntryCustodio"    SortExpression="BaseEntryCustodio" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblBaseEntryCustodio" runat="server" Text='<%# Eval("BaseEntryCustodio") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="9%"></ItemStyle></asp:TemplateField>

                                                <asp:TemplateField HeaderText="Factura"          SortExpression="FolioDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFolioDF"  runat="server" Width="60" Text='<%# Eval("FolioDF") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Pedido"          SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" Width="60" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate>      <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                                     <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="%Comp"      SortExpression="Completado" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCompletado" runat="server" Width="40" Text='<%# Eval("Completado","{0:P0}") %>' /></ItemTemplate>                             <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Fecha<br/>Entrega"   SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate>              <ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ventana"         SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" CssClass="text-truncate" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Comuna/Ret"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Zona"            SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="SubZona"            SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" CssClass="text-truncate" Width="100" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Dirección"   SortExpression="Direccion" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDireccion" runat="server" CssClass="text-truncate" Width="180" Text='<%# Eval("Direccion") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                                
                                                <asp:TemplateField HeaderText="Fecha<br/>Creación"   SortExpression="DocFecha" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocFecha" runat="server" CssClass="text-truncate" Text='<%# Eval("DocFecha","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Fecha<br/>Ingreso"   SortExpression="FechaRegistro" HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblFechaIngresoPrep" runat="server" CssClass="text-truncate" Text='<%# Eval("FechaRegistro","{0:dd/MM/yy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total<br/>Kilos"     SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotalKilos" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total<br/>Venta"     SortExpression="Total" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:N0}") %>' /></ItemTemplate>                <ItemStyle HorizontalAlign="Right" Width="8%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Condicion"            SortExpression="CondicionDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCondicionDF" runat="server" CssClass="text-truncate" Width="90" Text='<%# Eval("CondicionDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Us"         SortExpression="UsuarioNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("UsuarioNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Vend"     SortExpression="VendedorNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorNombre" runat="server" CssClass="text-truncate" Width="30" Text='<%# Eval("VendedorNombre") %>' /></ItemTemplate>                               <ItemStyle HorizontalAlign="Center" Width="1%"></ItemStyle></asp:TemplateField>

                                                <asp:TemplateField HeaderText="Retira Cliente" SortExpression="RetiraCliente" Visible="false" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblRetiraCliente" runat="server" Text='<%# Eval("RetiraCliente") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle></asp:TemplateField>

                                                <%--<asp:TemplateField HeaderText="Zona"        SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="6%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="SubZona"     SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total Kilos" SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCantidadPendiente" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Cliente"     SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate w-100" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Pedido"      SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido" runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Documento"   SortExpression="FolioDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFolioDF" runat="server" Text='<%# Eval("FolioDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Tipo Doc"    SortExpression="DocTipo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocTipo" runat="server" Text='<%# Eval("DocTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Fecha Entrega" SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                
                                                
                                                <asp:TemplateField HeaderText="Comuna"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComuna" runat="server" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="9%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ventana"     SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>--%>
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

                                                <%--<asp:TemplateField HeaderText="Zona"        SortExpression="Zona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblZona" runat="server" Text='<%# Eval("Zona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="6%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="SubZona"     SortExpression="SubZona" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblSubZona" runat="server" Text='<%# Eval("SubZona") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="8%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total Kilos" SortExpression="TotalKilos" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCantidadPendiente" runat="server" Text='<%# Eval("TotalKilos","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Cliente"     SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" CssClass="text-truncate w-100" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="22%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Pedido"      SortExpression="Pedido" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido" runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("Pedido") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Documento"   SortExpression="FolioDF" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFolioDF" runat="server" Text='<%# Eval("FolioDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Tipo Doc"    SortExpression="DocTipo" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDocTipo" runat="server" Text='<%# Eval("DocTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="2%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Fecha Entrega" SortExpression="FechaEntrega" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaEntrega" runat="server" Text='<%# Eval("FechaEntrega","{0:dd/MM/yyyy}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="5%"></ItemStyle></asp:TemplateField>
                                                
                                                
                                                <asp:TemplateField HeaderText="Comuna"      SortExpression="ComunaNombre" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblComuna" runat="server" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="9%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ventana"     SortExpression="Ventana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVentana" runat="server" Text='<%# Eval("Ventana") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="7%"></ItemStyle></asp:TemplateField>--%>
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
        ID="popupCerrarRutaRCTRCC" runat="server"
        DropShadow="false"
        PopupControlID="pnlCerrarRutaRCTRCC"
        TargetControlID="lnkFake2"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

</asp:Content>
