<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="bandeja-credito.aspx.cs" Inherits="Colonos.Web.bandeja_credito" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- INI POPUP DETALLE BANDEJA-->
        <asp:Panel ID="pnlDetalleBandeja" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 1300px;">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <asp:HiddenField ID="HiddenFieldDocentry" runat="server" />
                    <div class="window-ficha-modal-sm">
                        <div class="card-detail-window">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title" id="exampleModalLiveLabel5">
                                        <span>Bandeja Crédito</span>
                                        <asp:Label ID="lblRazonSocion" runat="server" ForeColor="antiquewhite" Text="Cliente"></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton11" CssClass="btn-close" runat="server" OnClick="ClosePopupBandeja"></asp:LinkButton>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row mb-2">
                                        <div class="col-sm-5">
                                            <div class="card max-height-topem">
                                                <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                    Cuenta Corriente
                                                </div>
                                                <div class="card-body overflow-y-auto p-1">
                                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;">
                                                        <asp:GridView ID="gvCuentaCorriente"
                                                        CssClass="table table-sm table-bordered header-grid"
                                                        AutoGenerateColumns="False"
                                                        runat="server" 
                                                        AllowPaging="false" 
                                                        RowStyle-CssClass="row-grid"
                                                        HeaderStyle-CssClass="header-grid-small headfijo"
                                                        >
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Numero" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lbNumero" runat="server" Text='<%# Eval("Numero") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="16%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Vencimiento" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblVencimiento" runat="server" CssClass="text-truncate" Text='<%# Eval("Vencimiento","{0:dd/MM/yyyy}") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="16%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="+90" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblV91" CssClass="text-end" runat="server" Text='<%# Eval("V91","{0:N0}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="16%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="90" HeaderStyle-CssClass=""><ItemTemplate> <asp:Label ID="lblV90" CssClass="text-end" runat="server" Text='<%# Eval("V90","{0:N0}") %>'></asp:Label></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="16%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="60" HeaderStyle-CssClass=""><ItemTemplate> <asp:Label ID="lblV60" CssClass="text-end" runat="server" Text='<%# Eval("V60","{0:N0}") %>'></asp:Label></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="16%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="30" HeaderStyle-CssClass=""><ItemTemplate> <asp:Label ID="lblV30" CssClass="text-end" runat="server" Text='<%# Eval("V30","{0:N0}") %>'></asp:Label></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="16%"></ItemStyle></asp:TemplateField>
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
                                        <div class="col-sm-3">
                                            <div class="card max-height-topem">
                                                <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                    Estado Financiero
                                                </div>
                                                <div class="card-body overflow-y-auto">
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Condición</span>
                                                        <asp:TextBox ID="txtCondicion" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Estado Op.</span>
                                                        <asp:TextBox ID="txtEstadoCliente" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Cupo</span>
                                                        <asp:TextBox ID="txtCupo" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Utilizado</span>
                                                        <asp:TextBox ID="txtUtilizado" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Disponible</span>
                                                        <asp:TextBox ID="txtDisponible" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-4" style="background-color:whitesmoke;">
                                            <div class="form-group">
                                                <label for="txtCausa">Causa</label>
                                                <asp:TextBox ID="txtCausa" runat="server" ReadOnly="true" Font-Size="Smaller" TextMode="MultiLine" Rows="2" CssClass="form-control resize-none"></asp:TextBox>
                                            </div>
                                            <div class="form-group mb-1">
                                                <label for="txtComentarios">Comentarios</label>
                                                <asp:TextBox ID="txtComentarios" runat="server" TextMode="MultiLine" Font-Size="Smaller" Rows="2" CssClass="form-control resize-none" EnableViewState="True"></asp:TextBox>
                                            </div>
                                            <div class="input-group input-group-sm mb-1 d-none">
                                                <asp:CheckBox ID="chkEnviaraEspecial" runat="server" CssClass="p-1" Text="Enviar a Bandeja Especial" /> 
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <asp:LinkButton ID="btnRechazar" runat="server" CssClass="btn btn-sm btn-outline-danger float-lg-start" OnClientClick="showLoading()" OnClick="RechazarBandeja_Event"><i class="far fa-thumbs-down p-1"></i>Rechazar</asp:LinkButton>
                                                </div>
                                                <div class="col-sm-6">
                                                    <asp:LinkButton ID="brnAprobar" runat="server" CssClass="btn btn-sm btn-success float-end" OnClientClick="showLoading()" OnClick="AprobarBandeja_Event"><i class="far fa-thumbs-up p-1"></i>Aprobar</asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-5">
                                            <div class="card">
                                                <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                    Pedido de Venta
                                                </div>
                                                <div class="card-body overflow-y-auto">
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Numero</span>
                                                        <asp:TextBox ID="txtNumeroPedido" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Condicion</span>
                                                        <asp:TextBox ID="txtCondicionPedido" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Fecha</span>
                                                        <asp:TextBox ID="txtFechaPedido" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Vendedor</span>
                                                        <asp:TextBox ID="txtVendedorPedido" runat="server" ReadOnly="true" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Neto</span>
                                                        <asp:TextBox ID="txtNetoPedido" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                    <div class="input-group input-group-sm mb-1">
                                                        <span class="input-group-text label-caption">Margen</span>
                                                        <asp:TextBox ID="txtMargen" runat="server" ReadOnly="true" CssClass="form-control text-end"></asp:TextBox>
                                                    </div>
                                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;">
                                                        <asp:GridView ID="gvDetalle"
                                                        CssClass="table table-sm table-bordered header-grid"
                                                        AutoGenerateColumns="False"
                                                        runat="server" 
                                                        AllowPaging="false" 
                                                        RowStyle-CssClass="row-grid"
                                                        HeaderStyle-CssClass="header-grid-small headfijo"
                                                        >
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="SKU" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="lblProdCode" runat="server" Text='<%# Eval("ProdCode") %>' /></ItemTemplate>                   <ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Descripción" HeaderStyle-CssClass=""><ItemTemplate>   <asp:Label ID="lblProdNombre" runat="server" CssClass="text-truncate" Text='<%# Eval("ProdNombre") %>' /></ItemTemplate>         <ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Cant" HeaderStyle-CssClass=""><ItemTemplate>     <asp:Label ID="txtCantidad" CssClass="text-end" runat="server" Text='<%# Eval("CantidadSolicitada","{0:N2}") %>'></asp:Label></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="15%"></ItemStyle></asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass=""><ItemTemplate>       <asp:Label ID="txtTotal" CssClass="text-end" runat="server" Text='<%# Eval("TotalSolicitado","{0:N0}") %>'></asp:Label></ItemTemplate>     <ItemStyle HorizontalAlign="Right" Width="20%"></ItemStyle></asp:TemplateField>
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
                                        <div class="col-sm-7">
                                            <div class="row mb-2">
                                                <div class="col-sm-5">
                                                    <div class="card max-height-topem">
                                                        <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                            Dicom Histórico
                                                        </div>
                                                        <div class="card-body overflow-y-auto p-1">
                                                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                                                <asp:GridView ID="gvDicom"
                                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                                    AutoGenerateColumns="False"
                                                                    runat="server" 
                                                                    PageSize="10"
                                                                    AllowPaging="false" 
                                                                    RowStyle-CssClass="row-grid"
                                                                    HeaderStyle-CssClass="header-grid-small"
                                                                    >
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="Id" Visible="false"><ItemTemplate><asp:Label ID="lblIdArchivo" runat="server" Text='<%# Eval("Id") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="SocioCode" Visible="false"><ItemTemplate><asp:Label ID="lblSocioCodeArchvo" runat="server" Text='<%# Eval("SocioCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Nombre Archivo" Visible="true"><ItemTemplate><asp:Label ID="lblNombreArchivo" runat="server" Text='<%# Eval("NombreArchivo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="60%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Download"><ItemTemplate>
                                                                                <asp:HyperLink ID="lblDowloadArchivo" runat="server" CssClass="text-center" NavigateUrl='<%# Eval("Ruta") %>' Target="_blank"><i class="fas fa-cloud-download-alt"></i></asp:HyperLink></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="20%"></ItemStyle>
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
                                                <div class="col-sm-7">
                                                    <div class="card max-height-topem">
                                                        <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                            Ventas ultimo 12 meses
                                                        </div>
                                                        <div class="card-body overflow-y-auto p-1">
                                                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                                                <asp:GridView ID="gVentas12m"
                                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                                    AutoGenerateColumns="False"
                                                                    runat="server" 
                                                                    PageSize="10"
                                                                    AllowPaging="false" 
                                                                    RowStyle-CssClass="row-grid"
                                                                    HeaderStyle-CssClass="header-grid-small"
                                                                    >
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="Año" Visible="true"><ItemTemplate><asp:Label ID="lblYear" runat="server" Text='<%# Eval("Year") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Mes" Visible="true"><ItemTemplate><asp:Label ID="lblMes" runat="server" Text='<%# Eval("Mes") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="SocioCode" Visible="false"><ItemTemplate><asp:Label ID="lblSocioCodeArchvo" runat="server" Text='<%# Eval("SocioCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Total" Visible="true"><ItemTemplate><asp:Label ID="lblTotal" runat="server" Text='<%# Eval("Total","{0:C0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Right" Width="40%"></ItemStyle></asp:TemplateField>
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
                                            <div class="row">
                                                    <div class="col-sm-5">
                                                        <div class="card max-height-topem">
                                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                                Promedio de Pago
                                                            </div>
                                                            <div class="card-body overflow-y-auto">
                                                                
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-7">
                                                        <div class="card max-height-topem">
                                                            <div class="card-header fw-bold back-ground-white card-header-border-bottom">
                                                                Hitórico Aprobación
                                                            </div>
                                                            <div class="card-body overflow-y-auto">
                                                                <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                                                <asp:GridView ID="gvHistorialAprobacion"
                                                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                                                    AutoGenerateColumns="False"
                                                                    runat="server" 
                                                                    RowStyle-CssClass="row-grid"
                                                                    HeaderStyle-CssClass="header-grid-small"
                                                                    OnRowDataBound="gvHistorialAprobacion_RowDataBound"
                                                                    >
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="Autorizado" Visible="false"><ItemTemplate><asp:Label ID="lblAutorizado" runat="server" Text='<%# Eval("Autorizado") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Fecha" Visible="true"><ItemTemplate><asp:Label ID="lblFechaIngreso" runat="server" Text='<%# Eval("FechaIngreso","{0:dd/MM/yyyy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Motivo / Rechazo" Visible="true"><ItemTemplate><asp:Label ID="lblMotivoRech" runat="server" Text='<%# Eval("MotivoRech") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="70%"></ItemStyle></asp:TemplateField>
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
                <ContentTemplate>
                    <div class="loading-overlay" id="loadingOverlay">
                        <div class="loading-spinner"></div>
                    </div>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            <span>Bandeja de Crédito
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
                                        <div class="navbar-brand d-flex input-group w-auto p-0">
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
                                        </ul>
                                    </div>
                                </div>
                            </nav>
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;">
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
                                        <asp:TemplateField HeaderText="Fecha Ingreso"   SortExpression="FechaIngreso" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFechaIngreso" runat="server" Text='<%# Eval("FechaIngreso","{0:dd/MM/yyyy HH:mm}") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="12%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pedido"          SortExpression="DocEntry" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblPedido"  runat="server" OnClick="VerBandeja_Event" Text='<%# Eval("DocEntry") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="12%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="BandejaCode"     SortExpression="BandejaCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblBandejaCode"  runat="server" Text='<%# Eval("BandejaCode") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="12%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Usuario"         SortExpression="UsuarioCodeIngreso" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblUsuarioCodeIngreso" runat="server" Text='<%# Eval("UsuarioCodeIngreso") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Center" Width="12%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cliente"         SortExpression="RazonSocial" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblCliente" runat="server" Text='<%# Eval("RazonSocial") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="30%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vendedor"        SortExpression="VendedorCode" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVendedorCode" runat="server" Text='<%# Eval("VendedorCode") %>' /></ItemTemplate>                      <ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
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
</asp:Content>
