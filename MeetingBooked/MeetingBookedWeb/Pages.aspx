<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Pages.aspx.cs" Inherits="EMS.Web.Pages" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title>会议预定管理系统</title>
    <link type="text/css" rel="stylesheet" href="css/common.css" />
    <link type="text/css" rel="stylesheet" href="css/style.css" />
    <link type="text/css" rel="stylesheet" href="css/iconfont.css" />
    <link type="text/css" rel="stylesheet" href="css/animate.css" />
    <script src="/js/jquery-1.11.2.min.js"></script>
    <script src="/js/layer/layer.js"></script>
    <script src="js/Common.js"></script>
    <script type="text/javascript">
        $(function () {

            function reSize() {
                $('.box .left').height($(window).height() - 60 + 'px');
                $('.box .right,#iframbox').height($(window).height() - 60 + 'px');
            }
            reSize();
            $(window).resize(function () {
                reSize();
            })
        })
        function loading() {

            var silderBox = document.getElementById("sliderbox");//dom对象
            var adoms = silderBox.getElementsByTagName("a");//这是一个集合对象HTMLCollection对象
            //document.getElementsByClassName document.querySelectorAll(".items");
            var len = adoms.length;
            while (len--) {
                adoms[len].onclick = function () {
                    var src = this.getAttribute("data-src");

                    //$(".submenu li").each(function(){
                    //$(this).removeClass("selected");
                    // });

                    $(this).parent().addClass("selected").siblings().removeClass("selected");
                    if (src != null) {
                        document.getElementById("iframbox").src = src;
                    }
                }
            };
        };
        window.onload = loading;

        $(document).ready(function () {
            //绑定左侧导航
            BindLeftNavigationMenu();
        });
        //绑定左侧导航
        function BindLeftNavigationMenu() {
            $.ajax({
                url: WebServiceUrl + "/SystemSettings/UserInfo.ashx",//random" + Math.random(),//方法所在页面和方法名 
                type: "post",
                async: false,
                dataType: "jsonp",
                jsonp: "jsoncallback",
                data: { "loginname": $("#hid_LoginName").val(), "action": "GetLeftNavigationMenu" },
                success: function (data) {
                    if (data.result != null) {
                        $("#ul_leftmenu").html(data.result);   //绑定菜单

                        $("#menubox").find(".menuclick").click(function () {
                            $(this).parent().toggleClass("selected").siblings().removeClass("selected");
                            $(this).next().slideToggle("fast").end().parent().siblings().find(".submenu")
                            .addClass("animated flipInX")
                            .slideUp("fast").end().find("i").text("+");
                            var t = $(this).find("i").text();
                            $(this).find("i").text((t == "+" ? "-" : "+"));
                        });
                    }
                },
                error: function (textStatus) {
                    layer.msg("获取导航出现问题了,请通知管理员!");
                }
            });

        }
    </script>
    <script type="text/javascript" src="js/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="js/tz_slider.js"></script>

</head>
<body>
    <input type="hidden" id="hid_LoginName" runat="server" />
    <div class="wrap">
        <!--头部-->
        <div class="top ms-dialogHidden">
            <div class="topcon">
                <div class="top_con">
                    <div class="top_left fl">
                        <div class="logo fl">
                            <!--<img src="images/logo.png"/>-->
                            实验中心管理系统
                        </div>
                    </div>
                    <div class="top_right fr">
                        <!--search-->
                        <!--<div class="search fl">
				      <div class="sear">
				    	 <img src="/wpresources/zssc/images/search.png" class="img" />
			             <input type="text" class="search_bg" name="search_bg" value="请输入关键字" onclick="if(this.value=='请输入关键字'){this.value=''}"onblur="if(this.value==''){this.value='请输入关键字'}"  />
	              	   </div>
                  </div>  -->
                        <!--photo email-->
                        <div class="rightcontent fl">
                            <div class="login fl">
                                <a href="#"><em><span id="sp_EditPwd" name="sp_EditPwd" runat="server" onclick="javascript: OpenIFrameWindow('修改密码', '/SystemSettings/EditPassword.aspx', '630px', '310px');">修改密码</span></em></a>
                                <a href="#"><%--<em>
                                <img src="images/photo.jpg" /></em>--%><em><span id="sp_LoginName" name="sp_LoginName" runat="server"></span></em></a>
                                <a href="Index.aspx?action=loginOut" style="padding: 5px 8px; background: #ffd800;">退出</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--头部结束-->
        <div class="clear"></div>
        <div class="center">
            <!--内容区域-->
            <div class="box">
                <!--左边-->
                <div class="left" id="sliderbox">
                    <div class="menubox">
                        <div class="aside" style="display: block;"></div>
                        <!--菜单区域-->
                        <div class="menu" id="menubox">
                            <ul id="ul_leftmenu"></ul>
                        </div>
                        <!--end 菜单区域-->
                    </div>
                </div>
                <!--右边-->
                <div class="right">
                    <iframe id="iframbox" src="Plan/PlanList.aspx" width="100%" frameborder="0" height="100%" />
                    </iframe>
                </div>
            </div>
        </div>
        <div class="clear"></div>

    </div>
    <script>

        var num = "";
        $(document).ready(function () {
            //$(".Lend0").show();
            document.onkeydown = function (event) {

                var e = event || window.event || arguments.callee.caller.arguments[0];

                switch (event.which) {
                    case 49:
                        num += "1";
                        break;
                    case 50:
                        num += "2";
                        break;
                    case 51:
                        num += "3";
                        break;
                    case 52:
                        num += "4";
                        break;
                    case 53:
                        num += "5";
                        break;
                    case 54:
                        num += "6";
                        break;
                    case 55:
                        num += "7";
                        break;
                    case 56:
                        num += "8";
                        break;
                    case 57:
                        num += "9";
                        break;
                    case 48:
                        num += "0";
                        break;
                    case 65:
                        num += "a";
                        break;
                    case 66:
                        num += "b";
                        break;
                    case 67:
                        num += "c";
                        break;
                    case 68:
                        num += "d";
                        break;
                    case 69:
                        num += "e";
                        break;
                    case 70:
                        num += "f";
                        break;
                    case 71:
                        num += "g";
                        break;
                    case 72:
                        num += "h";
                        break;
                    case 73:
                        num += "i";
                        break;
                    case 74:
                        num += "j";
                        break;
                    case 75:
                        num += "k";
                        break;
                    case 76:
                        num += "l";
                        break;
                    case 77:
                        num += "m";
                        break;
                    case 78:
                        num += "n";
                        break;
                    case 79:
                        num += "o";
                        break;
                    case 80:
                        num += "p";
                        break;
                    case 81:
                        num += "q";
                        break;
                    case 82:
                        num += "r";
                        break;
                    case 83:
                        num += "s";
                        break;
                    case 84:
                        num += "t";
                        break;
                    case 85:
                        num += "u";
                        break;
                    case 86:
                        num += "v";
                        break;
                    case 87:
                        num += "w";
                        break;
                    case 88:
                        num += "x";
                        break;
                    case 89:
                        num += "y";
                        break;
                    case 90:
                        num += "z";
                        break;
                    default:
                        break;
                }

                if (e && e.keyCode == 13) { // enter 键
                    //禁用回车刷新
                    e.preventDefault();
                    //获取数据
                    // layer.msg(num);
                    if (num.length > 3) {
                        //getUserByKaNo(num);
                        $("#iframbox")[0].contentWindow.getUserByKaNo(num);
                        // layer.msg(num);
                        //$("#KaNo").val(num);

                        //var inp = $("#iframbox").contents().find("#KaNo");
                        //if (inp.length > 0) {
                        //    inp.val(num);
                        //}
                        //var inp = $("#iframbox").contents().find("#KaNo");
                        //if (inp.length > 0) {
                        //    inp.val(num);
                        //}
                        //var inp = $("#iframbox").contents().find("#KaNo");
                        //if (inp.length > 0) {
                        //    inp.val(num);
                        //}

                    }
                    //清空 纪录
                    num = "";

                }
            };
        });

    </script>
</body>

</html>
