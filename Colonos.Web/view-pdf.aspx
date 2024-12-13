<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeBehind="view-pdf.aspx.cs" Inherits="Colonos.Web.view_pdf" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title></title>

    <script type="text/javascript">
        function printPdf() {
            var iframe = document.getElementById('pdfViewer');
            iframe.focus();
            iframe.contentWindow.print();
        }
    </script>

</head>
    <body>
        <div>
        <iframe id="pdfViewer" runat="server" width="100%" height="600px"></iframe>
    </div>
    </body>
</html>

    