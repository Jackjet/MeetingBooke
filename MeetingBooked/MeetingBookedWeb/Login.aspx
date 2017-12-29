<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EMS.Web.Login" %>

<!DOCTYPE html>

<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <title>会议预定后台管理系统</title>
    <link type="text/css" rel="stylesheet" href="css/layout.css" />
    <link type="text/css" rel="stylesheet" href="css/reset.css" />
    <script type="text/javascript" src="js/jquery-1.11.2.min.js"></script>
    <script src="/js/layer/layer.js"></script>
    <script type="text/javascript" src="js/tab.js"></script>
    <script src="js/Common.js"></script>
    <script src="js/jquery.cookie.js"></script>
    <style type="text/css">
        .code {
            background-image: url(w1.jpg);
            font-family: Arial;
            font-style: italic;
            color: Red;
            border: 0;
            padding: 2px 3px;
            letter-spacing: 3px;
            font-weight: bolder;
        }
    </style>
</head>
<body>
    <!--- -->
    <div class="wrap">
        <div class="top_top">
            <div class="top_top_con">
                <h1 class="main">会议预定后台管理系统</h1>
            </div>
        </div>
        <div class="Login main">
            <div class="login_con">
                <h1>系统登录</h1>
                <div class="form">
                    <form method="get" action="">
                        <ul class="con">
                            <li class="xian"><span class="icon">
                                <img src="images/people.png" /></span><input id="txt_loginName" type="text" class="kuang" placeholder="请输入用户名" /></li>
                            <li class="xian"><span class="icon">
                                <img src="images/password.png" /></span><input id="txt_passWord" type="password" class="kuang" placeholder="请输入密码" /></li>
                            <li class="yzm xian"><span class="icon">
                                <img src="images/yzm.png" /></span><input id="inpCode" type="text" class="kuang1" placeholder="请输入验证码" /><span class="yzmtu">
                                    <input type="text" id="checkCode" class="code" style="width: 50px" /></span><a href="#" onclick="createCode()">刷新</a></li>
                            <li>
                                <span class="btn">
                                    <input id="BtnLogin" type="button" class="btn_btn" value="登录" onclick="Login()" />
                                </span>
                            </li>
                        </ul>
                        <div class="clear"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
<script>

    $(document).ready(function () {
        //加载验证码
        createCode();
        //回车提交事件
        $("body").keydown(function () {
            if (event.keyCode == "13") {//keyCode=13是回车键
                $("#BtnLogin").click();
            }
        });
    });

    var code; //在全局 定义验证码
    function createCode() {
        code = "";
        var codeLength = 4;//验证码的长度
        var checkCode = document.getElementById("checkCode");
        checkCode.value = "";
        var selectChar = new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');

        for (var i = 0; i < codeLength; i++) {
            var charIndex = Math.floor(Math.random() * 60);
            code += selectChar[charIndex];
        }
        if (code.length != codeLength) {
            createCode();
        }
        checkCode.value = code;
    }

    ///登陆
    function Login() {
        var inputCode = document.getElementById("inpCode").value.toUpperCase();
        var codeToUp = code.toUpperCase();

        if (inputCode.length <= 0) {
            layer.msg("请输入验证码！");
            return false;
        }
        else if (inputCode != codeToUp) {
            layer.msg("验证码输入错误！");
            createCode();
            $("#inpCode").val('').focus();
            return false;
        }
        else {
            var loginName = $("#txt_loginName").val();
            var passWord = $("#txt_passWord").val();
            $.ajax({
                type: "post",
              
                url: WebServiceUrl + "/MeetingBookedWeb.ashx",
                dataType: "jsonp",
                jsonp: "jsoncallback",
                data: { "loginName": loginName, "passWord": passWord, "action": "Login" },
                success: function (json) {
                    var item = json.result;
                    if (json.msg=="ok") {
                        $.cookie('LoginCookie', item);
                        location.href = "index.aspx";
                    } else if (json.msg == "noqx") {
                        layer.msg("当前用户没有权限登录！");
                        return;
                    } else if (json.msg == "error") {
                        layer.msg("系统异常，请与管理员联系！");
                        return;
                    }
                    else {
                        layer.msg("登录名或密码错误！");
                        return;
                    }
                },
                error: OnErrorLogin
            });
        }
    }


    function OnErrorLogin(XMLHttpRequest, textStatus, errorThrown) {
        layer.msg("登录名或密码错误！" + errorThrown);
    }
</script>
</html>
