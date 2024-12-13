<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="maestro-socios.aspx.cs" Inherits="Colonos.Web.maestro_socios" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- INI POPUP BUSQUEDA CLIENTES -->
        <asp:Panel ID="pnlBusquedaClientes" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 800px;">
            <div class="window-ficha-modal-sm">
                <div class="card-detail-window">
                    <asp:UpdatePanel runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvClientes" />
                            <asp:PostBackTrigger ControlID="LinkButton4" />
                            <asp:PostBackTrigger ControlID="txtPalabras" />
                            <asp:PostBackTrigger ControlID="cmdBuscar" />
                            <%--<asp:PostBackTrigger ControlID="txtSocioCodigo" />--%>
                            <asp:PostBackTrigger ControlID="btnBuscar" />
                        </Triggers>
                        <ContentTemplate>
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title">
                                        <asp:Label ID="Label28" runat="server" Text="Búsqueda de Clientes"></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton4" CssClass="btn-close" runat="server" TabIndex="-1" OnClick="ClosePopup"></asp:LinkButton>
                                </div>
                                <div class="modal-header">
                                    <div style="margin-left: auto; margin-right: auto; width: 90%;">
                                        <asp:TextBox ID="TextBox2" runat="server" TabIndex="-1" Visible="false"></asp:TextBox>
                                        <asp:Panel DefaultButton="cmdBuscar" runat="server">
                                            <div id="custom-search-input" style="border-width: 1px; border-color: gray;">
                                                <div class="input-group col-md-12">
                                                    <asp:TextBox ID="txtPalabras" CssClass="form-control input-lg" TabIndex="-1" placeholder="Rut o Nombre..." runat="server"></asp:TextBox>
                                                    <span class="input-group-btn">
                                                        <asp:LinkButton ID="cmdBuscar" runat="server" CssClass="btn btn-lg btn-secondary btn-busqueda"  TabIndex="-1" OnClick="BuscarPopop_Event"><i class="fa fa-search fa-md"></i></asp:LinkButton>
                                                    </span>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <asp:GridView ID="gvClientes" runat="server"
                                        CssClass="table table-sm table-bordered table-hover header-grid"
                                        HeaderStyle-CssClass="header-grid-small"
                                        RowStyle-CssClass="row-grid"
                                        AutoGenerateColumns="false"
                                        BorderStyle="None">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Código" HeaderStyle-Width="10%">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lblCardCode" runat="server" OnClick="SelectCliente" Text='<%# Eval("SocioCode") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Razón Social" HeaderStyle-Width="40%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCardName" runat="server" Text='<%# Eval("RazonSocial") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="40%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Condición" HeaderStyle-Width="25%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblSlpName" runat="server" Text='<%# Eval("CondicionNombre") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="25%"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Tipo" HeaderStyle-Width="25%">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblListName" runat="server" Text='<%# Eval("SocioTipoNombre") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <i class="fas fa-exclamation-circle fa-2x"></i>
                                            <span style="font-size: 25px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                                <div class="modal-footer">
                                    <div class="row">
                                        
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>
    <!-- FIN POPUP BUSQUEDA CLIENTES -->

    <!-- INI POPUP DIRECCION CLIENTE -->
        <asp:Panel ID="pnlDireccionCliente" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 800px;">
            <div class="window-ficha-modal-sm">
                <div class="card-detail-window">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title">
                                        <asp:Label ID="Label1" runat="server" Text="Dirección del Cliente"></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton1" CssClass="btn-close" runat="server" TabIndex="-1" OnClick="ClosePopupDireccion"></asp:LinkButton>
                                </div>
                                <div class="modal-header">
                                    
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row justify-content-center">
                                        <div class="col-sm-6">
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">DireccionCode</span><asp:TextBox ID="txtDireccionCode" runat="server" ReadOnly="true" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">DireccionTipo</span><asp:DropDownList ID="cboDirecciontipo" runat="server" Enabled="false" CssClass="form-select"><asp:ListItem Value="F" Text="Facturación" /><asp:ListItem Value="D" Text="Despacho"></asp:ListItem> </asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Socio Codigo</span><asp:TextBox ID="txtSocioCodigoDir" runat="server" ReadOnly="true" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Calle</span><asp:TextBox ID="txtCalle" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Numero</span><asp:TextBox ID="txtNumero" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Comuna</span><asp:DropDownList ID="cboComuna" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Ciudad</span><asp:DropDownList ID="cboCiudad" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Región</span><asp:DropDownList ID="cboRegion" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                        </div>
                                        <div class="col-sm-6">    
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">EmailDriveIn</span><asp:TextBox ID="txtEmailDriveIn" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Ventana_Inicio</span><asp:TextBox ID="txtVentana_Inicio" TextMode="Time" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Ventana_Termino</span><asp:TextBox ID="txtVentana_Termino" TextMode="Time" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Latitud</span><asp:TextBox ID="txtLatitud" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Longitud</span><asp:TextBox ID="txtLongitud" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">SubZona</span><asp:DropDownList ID="cboSubZona" runat="server" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Observaciones</span><asp:TextBox ID="txtObservaciones" TextMode="MultiLine" Rows="2" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <div class="row w-100 d-flex">
                                        <div class="col-sm-6">
                                            <asp:LinkButton ID="btnEliminar" runat="server" CssClass="btn btn-sm btn-secondary float-start" OnClick="EliminarDireccion"><i class="far fa-trash-alt p-1" ></i>Eliminar</asp:LinkButton>
                                        </div>
                                        <div class="col-sm-6">
                                            <asp:LinkButton ID="btnAceptarDireccion" runat="server" CssClass="btn btn-sm btn-primary float-end" OnClick="AceptarDireccion">Aceptar</asp:LinkButton>
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>
    <!-- FIN POPUP DIRECCION CLIENTE -->

    <!-- INI POPUP CONTACTO CLIENTE -->
        <asp:Panel ID="pnlContactoCliente" runat="server" TabIndex="-1" Style="display: none; width: 90%; max-width: 800px;">
            <div class="window-ficha-modal-sm">
                <div class="card-detail-window">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #a9202c; color:white;">
                                    <h2 class="modal-title">
                                        <asp:Label ID="Label2" runat="server" Text="Dirección del Cliente"></asp:Label>
                                    </h2>
                                    <asp:LinkButton ID="LinkButton2" CssClass="btn-close" runat="server" TabIndex="-1" OnClick="ClosePopupContacto"></asp:LinkButton>
                                </div>
                                <div class="modal-header">
                                    
                                </div>
                                <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                                    <div class="row justify-content-center">
                                        <div class="col-sm-6">
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">ContactoCode</span><asp:TextBox ID="txtContactoCode" runat="server" ReadOnly="true" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">ContactoTipo</span><asp:DropDownList ID="cboTipoContacto" runat="server" Enabled="false" CssClass="form-select"></asp:DropDownList></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Socio Codigo</span><asp:TextBox ID="txtSocioCodeCont" runat="server" ReadOnly="true" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Nombre</span><asp:TextBox ID="txtNombreCont" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Email</span><asp:TextBox ID="txtEmailCont" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Celular</span><asp:TextBox ID="txtCelular" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Teléfono</span><asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" ></asp:TextBox></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <div class="row w-100">
                                        <asp:LinkButton ID="btnAceptarContacto" runat="server" CssClass="btn btn-sm btn-primary" OnClick="AceptarContacto">Aceptar</asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </asp:Panel>
     <!-- FIN POPUP CONTACTO CLIENTE -->
    
    <!-- INI ADD FILE-->
        <asp:Panel ID="pnlAddFile" runat="server"   style = "display:none">
            <div class="window-ficha-modal-sm">
                <div class="card-detail-window">
                    <div class="modal-content">
                        <div class="modal-header" style="background-color: #a9202c; color:white;">
                            <h2 class="modal-title">
                                <asp:Label ID="Label3" runat="server" Text="Adjuntar Archivo"></asp:Label>
                            </h2>
                            <asp:LinkButton ID="LinkButton3" CssClass="btn-close" runat="server" TabIndex="-1" OnClick="ClosePopupAddFile"></asp:LinkButton>
                        </div>
                        <div class="modal-body modal-body-max-height" style="min-height: 300px;">
                            <div class="row justify-content-center">
                                <div class="col-sm-6">
                                    <div class="uploaderEdit">
                                        <asp:FileUpload ID="fileUploadPopup" accept="image/jpeg,application/pdf" Width="435px" CssClass="uploaderASP" runat="server" />
                                    </div>
                                    <asp:RegularExpressionValidator 
                                        ID="RegularExpressionValidator7" runat="server" style="color:red;font-size:14px;"
                                        ControlToValidate="fileUploadPopup"
                                        ErrorMessage="*"
                                        ValidationExpression=".*\.(jpg|JPG|jpeg|JPEG|pdf|PDF)$">
                                    </asp:RegularExpressionValidator>
                                    <div style="display: block; " >
                                        <span style="float:left; color: #da1729;margin-top: 30px;" >* Tamaño máximo del archivo: 10MB.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div class="row w-100">
                                <asp:LinkButton ID="btnAceptaAdjunto" runat="server" CssClass="btn btn-sm btn-primary" OnClick="GuardarArchivo">Aceptar</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             <div class="window d-none">
                 <asp:LinkButton ID="btnClosePopupFile" CssClass="dialog-close-button" OnClick = "ClosePopupAddFile"  runat="server">
                      <span class="icon-close-span">
                        <i class="fas fa-times icon-close-size"></i>
                    </span>
                 </asp:LinkButton>
                <div  class="window-main-col-taller" style="padding-top:25px;">
                     <div class="window-module">
                        <div class="window-module-title">
                            <h2>Adjuntar Archivo</h2>
                            <h2><asp:Literal ID="litCaption" runat="server"></asp:Literal></h2>
                        </div>
                        <div class="window-module-body">
                            <div style="display: block; border: 1px solid #efefef;width: 500px;" > 
                                
                                
                            </div>
                            
                        </div>
                         <div class="window-module-body-item">
                            <div style="float:right;margin:15px;">
                                <asp:LinkButton ID="btnGuardarArchivo" ForeColor="#333" CssClass="button-link" OnClick = "GuardarArchivo"   runat="server"> 
                                    <i class="fas fa-file-upload fa-lg"></i>
                                    <span style="padding-left: 5px;">Adjuntar</span>
                                </asp:LinkButton>
                            </div>
                        </div>
                     </div>
                 </div>
             </div>
        </asp:Panel>
    <!-- FIN ADD FILE-->

    
    <div class="container-fluid">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="loading-overlay" id="loadingOverlay">
                    <div class="loading-spinner"></div>
                </div>
                <div class="card card-top">
                    <div class="card-header fw-bold font-size-xx-large">
                    Maestro de Socios (Clientes / Proveedores)
                    </div>
            <div class="card-body">
                <nav class="navbar navbar-expand-lg navbar-light nav-toolbar mb-2">
                    <div class="container-fluid">
                    <%--<a class="navbar-brand" href="javascript:void(0)">Logo</a>--%>
                      
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
                              <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-nav" OnClientClick="showLoading()" OnClick="Guardar_Event">Guardar</asp:LinkButton>
                          </li>
                        </ul>
                    </div>
                  </div>
                </nav>
                <div class="row">
                    <div class="row mb-2">
                        <div class="col-sm-4">
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Socio Codigo</span><asp:TextBox ID="txtSocioCodigo" runat="server" ReadOnly="true" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Tipo</span><asp:DropDownList ID="cboTipo" runat="server" CssClass="form-select"></asp:DropDownList></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Rut</span><asp:TextBox ID="txtRut" runat="server" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Razón Social</span><asp:TextBox ID="txtSocioNombre" runat="server" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Nombre Fantasía</span><asp:TextBox ID="txtNombreFantasia" runat="server" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Código DF</span><asp:TextBox ID="txtclientFileDF" runat="server" CssClass="form-control" ></asp:TextBox></div>
                        </div>
                        <div class="col-sm-4">
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Giro</span><asp:TextBox ID="txtGiro" runat="server" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Condición</span><asp:DropDownList ID="cboCondicion" runat="server" CssClass="form-select"></asp:DropDownList></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Matriz Socio</span><asp:DropDownList ID="cboMatrizSocio" runat="server" CssClass="form-select"></asp:DropDownList></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Vendedor</span><asp:DropDownList ID="cboVendedor" runat="server" CssClass="form-select"></asp:DropDownList></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Rubro</span><asp:DropDownList ID="cboRubro" runat="server" CssClass="form-select"></asp:DropDownList></div>
                        </div>
                        <div class="col-sm-4">
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Crédito</span><asp:TextBox ID="txtCreditoAutorizado" runat="server" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Utilizado</span><asp:TextBox ID="txtCreditoUtilizado" runat="server" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Crédito Máx</span><asp:TextBox ID="txtCreditoMaximo" runat="server" CssClass="form-control" ></asp:TextBox></div>
                            <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Estado Op.</span><asp:DropDownList ID="cboEstadoOperativo" runat="server" CssClass="form-select"></asp:DropDownList></div>
                            <div class="input-group input-group-sm mb-1 d-none"><span class="input-group-text label-caption">Activo</span><asp:CheckBox ID="chkActivo" CssClass="form-control" runat="server" /></div>
                        </div>
                    </div>
                    <div class="row mb-1 overflow-auto" style="max-height:calc(100vh - 500px);">
                        <div class="col-sm-8">
                            <div class="row mb-2">
                                <div class="card-header">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-2"><h5 class="fw-bold float-md-start">Direcciones</h5></div>
                                        <div class="col-sm-1"><asp:LinkButton ID="btnNuevaDireccion" CssClass="btn btn-sm btn-secondary float-end" OnClick="AgregarDireccion" runat="server">Agregar</asp:LinkButton></div>
                                    </div>
                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                        <div style="max-height: 250px;overflow: auto;">
                                            <asp:GridView ID="gvDirecciones"
                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                            AutoGenerateColumns="False"
                                            runat="server" 
                                            AllowPaging="false" 
                                            RowStyle-CssClass="row-grid"
                                            HeaderStyle-CssClass="header-grid-small headfijo"
                                            >
                                            <Columns>
                                                <asp:TemplateField HeaderText="Id" Visible="false"><ItemTemplate><asp:Label ID="lblDireccionCode" runat="server" Text='<%# Eval("DireccionCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="SocioCode" Visible="false"><ItemTemplate><asp:Label ID="lblSocioCode" runat="server" Text='<%# Eval("SocioCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Dirección Tipo"><ItemTemplate><asp:Label ID="lblDireccionTipo" runat="server" Text='<%# Eval("DireccionTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Calle"><ItemTemplate><asp:LinkButton ID="lblCalle" runat="server" OnClick="EditarDireccion_Event" Text='<%# Eval("Calle") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="25%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Numero"><ItemTemplate><asp:Label ID="lblNumero" runat="server" Text='<%# Eval("Numero") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Comuna"><ItemTemplate><asp:Label ID="lblComunaNombre" runat="server" Text='<%# Eval("ComunaNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Ciudad" Visible="false"><ItemTemplate><asp:Label ID="lblCiudadNombre" runat="server" Text='<%# Eval("CiudadNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Email DrivIn"><ItemTemplate><asp:Label ID="lblEmailDriveIn" runat="server" Text='<%# Eval("EmailDriveIn") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="15%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Horario" Visible="false"><ItemTemplate><asp:Label ID="lblHorarioAtencion" runat="server"  Text='<%# Eval("HorarioAtencion") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Inicio"><ItemTemplate><asp:Label ID="lblVentana_Inicio" runat="server" Text='<%# Eval("Ventana_Inicio","{0:HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Termino"><ItemTemplate><asp:Label ID="lblVentana_Termino" runat="server" Text='<%# Eval("Ventana_Termino","{0:HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
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
                            <div class="row mb-2">
                                <div class="card-header">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-2"><h5 class="fw-bold">Contactos</h5></div>
                                        <div class="col-sm-1"><asp:LinkButton ID="btnNuevoContacto" CssClass="btn btn-sm btn-secondary float-end" OnClick="AgregarContacto" runat="server">Agregar</asp:LinkButton></div>
                                    </div>
                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                        <div style="max-height: 250px;overflow: auto;">
                                            <asp:GridView ID="gvContactos"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Id" Visible="false"><ItemTemplate><asp:Label ID="lblContactoCode" runat="server" Text='<%# Eval("ContactoCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="SocioCode" Visible="false"><ItemTemplate><asp:Label ID="lblSocioCode" runat="server" Text='<%# Eval("SocioCode") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Contacto Tipo"><ItemTemplate><asp:Label ID="lblContactoTipo" runat="server" Text='<%# Eval("ContactoTipo") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Nombre"><ItemTemplate><asp:LinkButton ID="lblNombre" runat="server" OnClick="EditarContacto_Event" Text='<%# Eval("Nombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Email"><ItemTemplate><asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Celular"><ItemTemplate><asp:Label ID="lblCelular" runat="server" Text='<%# Eval("Celular") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Telefono" Visible="false"><ItemTemplate><asp:Label ID="lblTelefono" runat="server" Text='<%# Eval("Telefono") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
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
                        <div class="col-sm-4">
                            <div class="row mb-2">
                                <div class="card-header">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-4"><h5 class="fw-bold">DICOM</h5></div>
                                        <div class="col-sm-4"><asp:LinkButton ID="btnNuevoDicom" CssClass="btn btn-sm btn-secondary float-end" OnClick="AgregarDicom" runat="server">Agregar</asp:LinkButton></div>
                                    </div>
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
                                                <asp:TemplateField HeaderText=""><ItemTemplate><asp:LinkButton ID="lblEliminarArchivo" runat="server" OnClick="EliminarArchivo_Event"><i class="far fa-trash-alt"></i></asp:LinkButton></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="20%"></ItemStyle></asp:TemplateField>
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
                            <div class="row mb-2">
                                <div class="card-header">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-8"><h5 class="fw-bold float-md-start">Historial Bandeja Crédito</h5></div>
                                    </div>
                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                        <asp:GridView ID="gvHistorialBandeja"
                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                            AutoGenerateColumns="False"
                                            runat="server" 
                                            PageSize="10"
                                            AllowPaging="false" 
                                            RowStyle-CssClass="row-grid"
                                            HeaderStyle-CssClass="header-grid-small"
                                            >
                                            <Columns>
                                                <asp:TemplateField HeaderText="Fecha"><ItemTemplate><asp:Label ID="lblFechaBandeja" runat="server" Text='<%# Eval("FechaIngreso","{0:dd/MM/yyyy}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Autorizado"><ItemTemplate><asp:Label ID="lblAutorizadoBandeja" runat="server" Text='<%# Eval("Autorizado") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="10%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="MotivoRech"><ItemTemplate><asp:Label ID="lblMotivoRechBandeja" runat="server" Text='<%# Eval("MotivoRech") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="70%"></ItemStyle></asp:TemplateField>
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

                            <div class="row mb-2">
                                <div class="card-header">
                                    <div class="row justify-content-between">
                                        <div class="col-sm-8"><h5 class="fw-bold float-md-start">Historial Modifcaciones</h5></div>
                                    </div>
                                    <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: 90%">
                                        <asp:GridView ID="gvHistorialModifcaciones"
                                            CssClass="table table-sm table-bordered table-hover header-grid"
                                            AutoGenerateColumns="False"
                                            runat="server" 
                                            PageSize="10"
                                            AllowPaging="false" 
                                            RowStyle-CssClass="row-grid"
                                            HeaderStyle-CssClass="header-grid-small"
                                            >
                                            <Columns>
                                                <asp:TemplateField HeaderText="Fecha"><ItemTemplate><asp:Label ID="lblFechaProceso" runat="server" Text='<%# Eval("FechaProceso","{0:dd/MM/yyyy HH:mm}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                                <asp:TemplateField HeaderText="Cambios"><ItemTemplate><asp:Label ID="lblCambios" runat="server" Text='<%# Eval("Cambios") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="70%"></ItemStyle></asp:TemplateField>
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
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupBusquedaClientes" runat="server"
        DropShadow="false"
        PopupControlID="pnlBusquedaClientes"
        TargetControlID="lnkFake"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:LinkButton ID="lnkFake2" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupDireccionCliente" runat="server"
        DropShadow="false"
        PopupControlID="pnlDireccionCliente"
        TargetControlID="lnkFake2"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:LinkButton ID="lnkFake3" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupContactoCliente" runat="server"
        DropShadow="false"
        PopupControlID="pnlContactoCliente"
        TargetControlID="lnkFake3"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
    
    <asp:LinkButton ID="lnkFake4" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender 
            ID="popupAddFile" runat="server" 
            DropShadow="false"
            PopupControlID="pnlAddFile" 
            TargetControlID = "lnkFake4"
            BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>
</asp:Content>
