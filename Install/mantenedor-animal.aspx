<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="mantenedor-animal.aspx.cs" Inherits="Colonos.Web.mantenedor_animal" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- INI POPUP ANIMAL -->
    <asp:Panel ID="pnlAnimal" runat="server" Style="display: none; width:50%;max-width:800px;min-width:500px;">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnGuardar" />
                
            </Triggers>
            <ContentTemplate>
                <div class="window-ficha-modal-sm">
                    <div class="card-detail-window">
                        <div class="modal-content">
                            <div class="modal-header2 color-negro2">
                                <h2 class="modal-title p-1" id="exampleModalLiveLabel3">
                                    <span>
                                        <asp:Label ID="lblTituloPopup" runat="server" CssClass="p-2" Text="Animal"></asp:Label>
                                    </span>
                                    <asp:LinkButton ID="btnClose" CssClass="btn-close p-sm-2 m-1 float-end font-size-large" runat="server" OnClick="ClosePopup"></asp:LinkButton>
                                </h2>
                                
                            </div>

                            <div class="modal-body p-3" style="max-height: 500px; min-height: 200px;">
                                <div class="row justify-content-center">
                                    <div class="col-sm-8">
                                        <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Id</span><asp:TextBox ID="txtAnimalCode" runat="server" ReadOnly="true" CssClass="form-control" ></asp:TextBox></div>
                                        <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Nombre</span><asp:TextBox ID="txtAnimalNombre" runat="server" CssClass="form-control text-end" ></asp:TextBox></div>
                                        <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">% Margen</span><asp:TextBox ID="txtMargen" TextMode="Number" step="0.01" runat="server" CssClass="form-control text-end" ></asp:TextBox></div>
                                        <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">%Dscto. Volumen</span><asp:TextBox ID="txtDescVolumen" TextMode="Number" step="0.01" runat="server" CssClass="form-control text-end" ></asp:TextBox></div>
                                        <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Volumen</span><asp:TextBox ID="txtVolumen" TextMode="Number" runat="server" CssClass="form-control text-end" ></asp:TextBox></div>
                                        <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Factor Precio</span><asp:TextBox ID="txtFactorPrecio" TextMode="Number" step="0.01" runat="server" CssClass="form-control text-end" ></asp:TextBox></div>
                                        <div class="input-group input-group-sm mb-1"><span class="input-group-text label-caption">Cuenta Defontana</span><asp:TextBox ID="txtAccDF" runat="server" CssClass="form-control text-end" ></asp:TextBox></div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer" style="border: none;">
                                <div class="row p-2">
                                    <div class="col-sm-6">
                                    </div>
                                    <div class="col-sm-6">
                                        <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-danger btn-sm float-end" OnClick="Guardar_Event"><i class="far fa-save d-inline"></i><span class="d-inline p-1">Guardar</span></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <!-- FIN POPUP ANIMAL -->

    <div class="container-fluid">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="card card-top">
                        <div class="card-header fw-bold font-size-xx-large">
                            Mantenedor Animal
                        </div>
                        <div class="card-body">
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
                            
                                          <asp:LinkButton ID="btnNuevo" runat="server" CssClass="btn btn-nav" OnClick="Nuevo_Event">Nuevo</asp:LinkButton>
                                      </li>
                                      <li class="nav-item">
                                        <%--<a class="btn btn-nav" href="#">Exportar</a>--%>
                                      </li>
                                    </ul>
                                 </div>
                              </div>
                            </nav>
                            <div class="table-responsive p-1" style="font-size: 13px; border-top: 2px solid black; overflow-y: auto;height: calc(90vh - 300px)">
                                <asp:GridView ID="gvList"
                                    CssClass="table table-sm table-bordered table-hover header-grid"
                                    AutoGenerateColumns="False"
                                    runat="server" 
                                    AllowPaging="false" 
                                    RowStyle-CssClass="row-grid"
                                    HeaderStyle-CssClass="header-grid-small headfijo"
                                    >
                                    <Columns>
                                        <asp:TemplateField HeaderText="AnimalCode"         HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblAnimalCode"  runat="server" Text='<%# Eval("AnimalCode") %>' /></ItemTemplate> <ItemStyle HorizontalAlign="Left" Width="0%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Nombre Animal" HeaderStyle-CssClass=""><ItemTemplate><asp:LinkButton ID="lblAnimalNombre" OnClick="Editar_Event"  runat="server"  Text='<%# Eval("AnimalNombre") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Left" Width="20%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Margen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblMargen"  runat="server"  Text='<%# Eval("Margen","{0:P2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Descuento Volumen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblDescVolumen"  runat="server"  Text='<%# Eval("DescVolumen","{0:P2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Kilos Volumen" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblVolumen"  runat="server"  Text='<%# Eval("Volumen","{0:N0}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Factor Precio" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblFactorPrecio"  runat="server"  Text='<%# Eval("FactorPrecio","{0:N2}") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="15%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cuenta Defontana" HeaderStyle-CssClass=""><ItemTemplate><asp:Label ID="lblAccDF"  runat="server"  Text='<%# Eval("AccDF") %>' /></ItemTemplate><ItemStyle HorizontalAlign="Center" Width="20%"></ItemStyle></asp:TemplateField>
                                        <asp:TemplateField HeaderText=""         HeaderStyle-CssClass="" Visible="false"><ItemTemplate><asp:Label ID="lblEliminar"  runat="server" CssClass="w-100"><i class="far fa-trash-alt"></i></asp:Label></ItemTemplate> <ItemStyle HorizontalAlign="Center" Width="20%"></ItemStyle></asp:TemplateField>
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

    <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender
        ID="popupAnimal" runat="server"
        DropShadow="false"
        PopupControlID="pnlAnimal"
        TargetControlID="lnkFake"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>
</asp:Content>
