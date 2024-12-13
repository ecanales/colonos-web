<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Colonos.Web.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title></title>
    <link href="Content/bootstrap/css/bootstrap.css" rel="stylesheet" />
    <link href="Content/css/login.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="contenedor">
            <div class="boxes w-100">
                <div class="box w25 text-center p-1">
                    <h1 class="text-white">Colonos Web</h1>
                    <img src="Content/img/logoColonos.png" class="w50 " />
                </div>
                <div class="box w25">
                    <asp:login id="Login1" runat="server" style="width: 100%;" DestinationPageUrl="~/index.aspx" OnAuthenticate="Login1_Authenticate">
                        <layouttemplate>
                            <div class="signin-form">
                                <div >
                                    <div class="form-group mt-3 ">
                                        <asp:textbox class="form-control text-white txtLogin" required  id="UserName" runat="server" AutoCompleteType="Disabled" ></asp:textbox>
                                        <label  class="form-control-placeholder text-white" for="username">usuario</label>
                                    </div>
                                    <asp:requiredfieldvalidator id="UserNameRequired" runat="server" controltovalidate="UserName" errormessage="Usuario es requerido" tooltip="User Name is required." validationgroup="Login1">*</asp:requiredfieldvalidator>
                                    <div class="form-group">
                                        <asp:textbox CssClass="form-control text-white txtLogin" required id="Password" runat="server" textmode="Password" ></asp:textbox>
                                        <label class="form-control-placeholder text-white" for="password">contraseña</label>
                                        <span toggle="#Password" class="fa fa-fw fa-eye field-icon toggle-password"></span>
                                    </div>
                                    <asp:requiredfieldvalidator id="PasswordRequired" runat="server" controltovalidate="Password" errormessage="Contraseña es requerido" tooltip="Password is required." validationgroup="Login1">*</asp:requiredfieldvalidator>
                                    <asp:button CssClass="form-control btn btn-danger rounded submit px-3" id="LoginButton" runat="server" commandname="Login" text="Entrar" ForeColor="#ffe335" validationgroup="Login1"></asp:button>
                                    <asp:literal id="FailureText"  runat="server" enableviewstate="False"></asp:literal>
                                            
                                </div>
                            </div>
                        </layouttemplate>
                    </asp:login>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
