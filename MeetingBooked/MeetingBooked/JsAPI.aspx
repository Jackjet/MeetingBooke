<%@ Page Language="C#" AutoEventWireup="true" CodeFile="JsAPI.aspx.cs" Inherits="Enterprise_JsAPI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script type="text/javascript" src="http://g.alicdn.com/ilw/ding/0.5.1/scripts/dingtalk.js"></script>
    <script type="text/javascript">

       

        var _config = {
            appId: '<%=signPackage.appId%>',
            corpId: '<%=signPackage.corpId%>',
            timeStamp: '<%=signPackage.timestamp%>',
            nonce: '<%=signPackage.nonceStr%>',
            signature: '<%=signPackage.signature%>'
        };

        var _ServerHttp = {
            uri: '<%=signPackage.ServerUri%>'
        }
             
        dd.config({
            appId: _config.appId,
            corpId: _config.corpId,
            timeStamp: _config.timeStamp,
            nonceStr: _config.nonce,
            signature: _config.signature,
            jsApiList: '<%=signPackage.config_list%>' 
        });
      
        dd.ready(function () {           
            dd.runtime.permission.requestAuthCode({
                corpId: _config.corpId,
                onSuccess: function (result) {
                    location.href = _ServerHttp.uri + "?code=" + result["code"];
                },
                onFail: function (err) { }

            });          
        });
    </script>


</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
