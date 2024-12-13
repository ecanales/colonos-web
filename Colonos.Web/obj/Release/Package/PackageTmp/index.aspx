<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Colonos.Web.index" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--<link href="Content/css/customgrid.css" rel="stylesheet" />--%>
    
        <style type="text/css">
        .BackColorTab
        {
            /*font-family:Verdana, Arial, Courier New;
            font-size: 10px;
            color:white;*/
            background-color:white;
        }

        .TabHeaderCSS
        {
             font-family:Verdana, Arial, Courier New;
             font-size: 10px;
             background-color: white;
             text-align: center;
             cursor: pointer
        }

        .TabHeaderCSS a span {
            color:blue;
            background-color:white;
            padding-left: 20px;
            padding-right: 20px;
        }
       
        .ajax__tab_header {
            height:35px;
        }

        .ajax__tab_default .ajax__tab span {
            display: block;
            float: left;
            height: 20px;
            margin-top: 1px;
            border: 1px solid red;
        }
                
        .ajax__tab_xp .ajax__tab_header .ajax__tab_outer {
            background-image:none;
        }

        .ajax__tab_xp .ajax__tab_header .ajax__tab_outer:hover {
            background-image:none;
        }
            
    </style>
       
    <script type="text/javascript">
        function MoveTab(num) {
            var container = $find('TabContainer1');
            container.set_activeTabIndex(num);
        }
    </script>

        <style type="text/css">
      

      /*#ContentPlaceHolder1_UpdatePanel1{
          overflow:auto;
      }*/
  </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
    <h1>index</h1>
    <%--<asp:LinkButton ID="LinkButton1" runat="server" OnClick="Descargarproductos" ForeColor="red">LinkButton</asp:LinkButton>--%>
        <%--<asp:LinkButton ID="LinkButton2" runat="server" OnClick="TestPicking" ForeColor="red">Picking</asp:LinkButton>--%>
    </div>
</asp:Content>
