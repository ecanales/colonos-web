<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="mantenedor-usuarios.aspx.cs" Inherits="Colonos.Web.mantenedor_usuarios" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>

    <!-- INI POPUP EDITAR -->
    <asp:Panel ID="pnlEditarUsuario" runat="server" Style="display: none; width:90%;max-width:800px;">
        <div class="window-ficha-modal-sm" style="font-family: 'Ubuntu', sans-serif;">
            <div class="card-detail-window">
                <div class="modal-content">
                    <div class="modal-header" style="background-color:#ffe500;">
                        <asp:HiddenField ID="HiddenFieldSKU" runat="server" />
                        <h2><asp:Label ID="Label3" runat="server" ForeColor="black" CssClass="d-block" Text="Configuración Usuario"></asp:Label></h2>
                        <asp:LinkButton ID="btnClosePopupEstanque" CssClass="btn-close" runat="server" OnClick="ClosePopupEditar"></asp:LinkButton>
                    </div>
                    
                    <div class="modal-body modal-body-max-height" >
                        
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group py-2">
                                    <label for="txtIdUsuario">Id Usuario</label>
                                    <asp:TextBox ID="txtIdUsuario" runat="server" CssClass="form-control" placeholder="Id Usuario"></asp:TextBox>
                                </div>
                                <div class="form-group py-2">
                                    <label for="txtUserName">User Name</label>
                                    <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" placeholder="Nombre.Apellido"></asp:TextBox>
                                </div>
                                <div class="form-group py-2">
                                    <label for="txtPassword">Contaseña</label>
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                                </div>
                                <div class="form-group py-2">
                                    <label for="txtNombre">Nombre</label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" aria-describedby="emailHelp" placeholder="Nombre"></asp:TextBox>
                                </div>
                                <div class="form-group py-2">
                                    <label for="txtEmail">Email</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" aria-describedby="emailHelp" placeholder="Email"></asp:TextBox>
                                </div>
                                <div class="form-group py-2">
                                    <label for="txtTelefono">Teléfono  (+569) xxxx xxxx</label>
                                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" aria-describedby="emailHelp" placeholder="Nombre"></asp:TextBox>
                                </div>
                                <div class="form-group py-2">
                                    <%--<label for="chkBloqueado">Bloqueado</label>--%>
                                    <asp:CheckBox ID="chkBloqueado" runat="server" Text="Bloqueado" CssClass="form-control mgr-10" />
                                </div>
                                
                            </div>
                            <div class="col-sm-6">
                                <div class="py-2">
                                    <label for="cboSucursal">Sucursal</label>
                                    <asp:DropDownList ID="cboSucursal" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <div class="py-2">
                                    <label for="cboSlpCode">Asociar Vendedor SAP</label>
                                    <asp:DropDownList ID="cboSlpCode" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <div class="py-2">
                                    <label for="cboGrupo">Grupo de Usuario</label>
                                    <asp:DropDownList ID="cboGrupo" runat="server" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <asp:UpdatePanel runat="server">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="chkTienePartner" EventName="CheckedChanged" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <div class="form-group py-2">
                                            <%--<label for="chkTienePartner">Tiene Partner</label>--%>
                                            <asp:CheckBox ID="chkTienePartner" runat="server" Text="Tiene Partner" AutoPostBack="true" OnCheckedChanged="ActivaCboPartnet" />
                                            <asp:DropDownList ID="cboPartner" runat="server" Visible="false" CssClass="form-select"></asp:DropDownList>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <div class="form-group py-2">
                                    <%--<label for="chkAccesoSurusal">Visualiza y Edita Información de la Sucursal</label>--%>
                                    <asp:CheckBox ID="chkAccesoSucursal" runat="server" Text="Visualiza y Edita Información de la Sucursal" CssClass="form-control mgr-10" />
                                </div>
                                <div class="form-group py-2">
                                    <%--<label for="chkAccesoTodos">Vusualiza y Edita Información de Todos</label>--%>
                                    <asp:CheckBox ID="chkAccesoTodos" runat="server" Text="Visualiza y Edita Información de Todos" CssClass="form-control mgr-10" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <div class="row w-100">
                            <div class="col-sm-6">
                                <%--<asp:LinkButton ID="cmdElininar" runat="server" CssClass="float-start" Font-Size="20" ><i style="color:black;" class="fas fa-trash-alt fa-xl"></i></asp:LinkButton>--%>
                                
                            </div>
                            <div class="col-sm-6">
                                <asp:Button ID="cmdActualizar" CssClass="btn btn-treck btn-sm float-end" ForeColor="#ffe500" BackColor="#1d1d1b" runat="server" OnClick="Guardar" Text="Guardar" />
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>
    <!-- FIN POPUP EDITAR -->

        <div class="stycky-top60-body" style="background-color: white;">
            <header class="bg-white shadow-sm px-4 py-3">
                <div class="container-fluid px-0">
                    <h2 class="mb-0 p-1 h-size2em h-weight400">Mantener Usuarios</h2>
                </div>
            </header>
            <div class="shadow-sm">
                <div class="row">
                    <div>
                        <div class="col-md-12">
                            <asp:LinkButton ID="cmdNuevo" runat="server" CssClass="btn btn-treck-menu" OnClick="CargaUsuario"><i class="fas fa-plus fa-lg p-2"></i>Nuevo</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <main class="main-page shadow-lg p-3 mb-0 bg-body rounded">
            <div class="border-main-page">
                <div class="row">
                    <div class="col-md-12">
                        <div style="padding-left: 10px; padding-right: 10px;">
                            <div class="table-responsive p-1 table-dark-treck" style="height:67vh;">
                                <asp:GridView ID="gvResultado" runat="server"
                                    AutoGenerateColumns="False"
                                    AllowPaging="false"
                                    CssClass="table table-sm border-0 table-hover th-align-left"
                                    HeaderStyle-CssClass="table-dark-treck thfijo"
                                    RowStyle-CssClass="table-row-treck">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Id" ItemStyle-HorizontalAlign="center">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblIdUsuario" runat="server" OnClick="CargaUsuario" Text='<%# Eval("IdUsuario")%>' />
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Left" Width="5%"></ItemStyle>
                                        </asp:TemplateField>
                                        <%--<asp:TemplateField HeaderText="User Name">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lblUsuario" runat="server" OnClick="CargaUsuario" Text='<%# Eval("Usuario")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="25%"></ItemStyle>
                                        </asp:TemplateField>--%>
                                        <asp:TemplateField HeaderText="Nombre">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNombre" runat="server" Text='<%# Eval("Nombre")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="15%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sucursal">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSucursal" runat="server" Text='<%# Eval("Sucursal")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Email">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="15%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Vend SAP">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSlpName" runat="server" Text='<%# Eval("SlpName")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="15%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Grupo">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNombreGrupo" runat="server" Text='<%# Eval("NombreGrupo")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="10%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Bloqueado">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBoqueado" runat="server" Text='<%# Eval("Boqueado")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="5%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Acceso Sucursal">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAccesoSucursal" runat="server" Text='<%# Eval("AccesoSucursal")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="5%"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Acceso Global">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAccesoGlobal" runat="server" Text='<%# Eval("AccesoGlobal")%>' />
                                            </ItemTemplate>
                                            <ItemStyle Width="5%"></ItemStyle>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <i class="fas fa-exclamation-circle fa-lg"></i>
                                        <span style="font-size: 15px; font-style: italic; margin-left: 5px;">Ningún registro encontrado...</span>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupEditarUsuario" runat="server"
        DropShadow="false"
        PopupControlID="pnlEditarUsuario"
        TargetControlID="lnkFake"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
</asp:Content>
