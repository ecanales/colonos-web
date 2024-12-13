<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="parametros-generales.aspx.cs" Inherits="Colonos.Web.parametros_generales" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- INI POPUP CARGA ARCHIVO-->
        <asp:Panel ID="pnlCargaArchivo" runat="server" Style="display: none; width:90%;max-width:900px;">
        <div class="window-ficha-modal-sm">
            <div class="card-detail-window">
                <div class="modal-content">
                    <div class="modal-header" style="background-color: #a9202c; color:white;">
                        <h2 class="modal-title" id="exampleModalLiveLabel2">
                            <span class="p-2">Carga CxC Full</span>
                        </h2>
                        <asp:LinkButton ID="LinkButton7" CssClass="btn-close p-2" runat="server" OnClick="ClosepopupCarga"></asp:LinkButton>
                    </div>
                    <div class="modal-body p-2" style="max-height:500px;">

                        <div class="row justify-content-md-center">
                            <div class="col-sm-10">
                                <div class="form-group py-2">
                                    <label for="upArchivo">Ubicar Archivo</label>
                                    <asp:FileUpload ID="upArchivo" runat="server" CssClass="form-control" />
                                </div>
                            </div>

                        </div>
                        <div class="row justify-content-md-center">
                            <div class="col-sm-12 m-2">
                                <div style="margin-left: auto; margin-right: auto; width: inherit;">
                                    <span class="m-2">ejemplo de archivo de carga en formato excel (.xlsx)</span>
                                    <img src="Content/img/imgcargaexcel.png" style="margin-top: 10px; margin-right: auto; margin-left: auto; padding-left: 15px;width:100%;" />
                                </div>
                            </div>

                        </div>

                    </div>
                    <div class="modal-footer p-3">
                        <asp:LinkButton ID="LinkButton8" runat="server" CssClass="btn btn-danger btn-sm" OnClientClick="showLoading()"  OnClick="ProcesarArchivo">Procesar Archivo</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
        </asp:Panel>
    <!-- FIN POPUP CARGA ARCHIVO -->
    <div class="container-fluid">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="loading-overlay" id="loadingOverlay">
                    <div class="loading-spinner"></div>
                </div>
                <div class="card card-top">
                    <div class="card-header fw-bold font-size-xx-large">
                        Parámetros Generales
                    </div>
                    <div class="card-body">
                        <nav class="navbar navbar-expand-lg navbar-light nav-toolbar mb-2">
                            <div class="container-fluid">
                            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"  style="border: 1px solid #575b5e;" data-bs-target="#mynavbar">
                              <span class="navbar-toggler-icon"></span>
                            </button>
                            <div class="collapse navbar-collapse" id="mynavbar">
                                <ul class="navbar-nav">
                                  <li class="nav-item">
                                      <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-nav" OnClick="Guardar_Event">Guardar</asp:LinkButton>
                                  </li>
                                </ul>
                            </div>
                          </div>
                        </nav>
                        <div class="row">
                          <div class="col-sm-3 mb-3 mb-sm-0">
                            <div class="card">
                              <div class="card-body">
                                <h5 class="card-title">Cargar Cuentas por Cobrar</h5>
                                <p class="card-text">Utilice un excel para cargar </p>
                                <asp:LinkButton ID="btnLoadCXC" CssClass="btn btn-danger" OnClick="CargarArchivo_Event" runat="server">Cargar Archivo</asp:LinkButton>
                                  <asp:Label ID="lbLogCxc" runat="server" Text=""></asp:Label>
                              </div>
                            </div>
                          </div>
                          <div class="col-sm-3">
                            <div class="card">
                              <div class="card-body">
                                <h5 class="card-title">Actualizar Stock DF</h5>
                                <p class="card-text">Actualizar el stock desde Defontana</p>
                                  <asp:LinkButton ID="btnActualizarStock" CssClass="btn btn-danger" OnClientClick="showLoading()"  OnClick="ActualizarStock_Event" runat="server">Actualizar</asp:LinkButton>
                                  <asp:Label ID="lblLogStosk" runat="server" Text=""></asp:Label>
                              </div>
                            </div>
                          </div>
                          <div class="col-sm-3">
                            <div class="card">
                              <div class="card-body">
                                <h5 class="card-title">Factor de Precios</h5>
                                <div class="input-group input-group-sm mb-1">
                                    <span class="input-group-text label-caption">Factor Precio</span>
                                    <asp:TextBox ID="txtFactor" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="input-group input-group-sm mb-1">
                                    <span class="input-group-text label-caption">Margen</span>
                                    <asp:TextBox ID="txtMargen" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="input-group input-group-sm mb-1">
                                    <span class="input-group-text label-caption">% Decuento Vol</span>
                                    <asp:TextBox ID="txtDescuentoVolumen" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="input-group input-group-sm mb-1">
                                    <span class="input-group-text label-caption">Kilos Volumen</span>
                                    <asp:TextBox ID="txtVolumen" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                              </div>
                            </div>
                          </div>
                          <div class="col-sm-3">
                            <div class="card">
                              <div class="card-body">
                                <h5 class="card-title">Preparación de Pedidos</h5>
                                <div class="input-group input-group-sm mb-1">
                                    <span class="input-group-text label-caption">Tolerancia</span>
                                    <asp:TextBox ID="txtTolerancia" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="input-group input-group-sm mb-1">
                                    <span class="input-group-text label-caption">Bodega Producción</span>
                                    <asp:DropDownList ID="cboBodega" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                            <div class="card">
                              <div class="card-body">
                                <h5 class="card-title">Actualizar Costo DF</h5>
                                <p class="card-text">Actualizar Costo desde Defontana</p>
                                  <asp:LinkButton ID="btnActualizarCosto" CssClass="btn btn-danger"  OnClientClick="showLoading()" OnClick="ActualizarCosto_Event" runat="server">Actualizar</asp:LinkButton>
                                  <asp:Label ID="lblLogCosto" runat="server" Text=""></asp:Label>
                              </div>
                            </div>
                          </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
        <cc1:ModalPopupExtender
            ID="popupCargaArchivo" runat="server"
            DropShadow="false"
            PopupControlID="pnlCargaArchivo"
            TargetControlID="lnkFake"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>
    </div>

</asp:Content>
