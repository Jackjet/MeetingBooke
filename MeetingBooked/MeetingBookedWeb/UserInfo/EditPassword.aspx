<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditPassword.aspx.cs" Inherits="MeetingBookedWeb.UserInfo.EditPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>修改密码</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/common.css" rel="stylesheet" />
    <link href="/css/iconfont.css" rel="stylesheet" />
    <link href="/css/animate.css" rel="stylesheet" />
    <script src="/js/jquery-1.11.2.min.js"></script>
    <script src="/js/layer/layer.js"></script>
    <script src="/js/Common.js"></script>
    <script src="/js/jquery.tmpl.js"></script>
</head>
<body onload="this.focus();">
    <input type="hidden" id="hid_id" runat="server" />
    <!--tz_dialog start-->
    <div class="yy_dialog">
        <div class="t_content">
            <div class="yy_tab">
                <div class="content">
                    <div class="tc">
                        <div class="t_message">
                            <div class="message_con">
                                <form>
                                    <table class="m_top">
                                        <tr>
                                            <td class="mi"><span class="m">旧密码：</span></td>
                                            <td class="ku">
                                                <input id="txt_OldPwd" type="password" class="hu" placeholder="请输入旧密码" /><span class="wstar">*</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="mi"><span class="m">新密码：</span></td>
                                            <td class="ku">
                                                <input id="txt_Pwd" type="password" class="hu" placeholder="请输入新密码" /><span class="wstar">*</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="mi" style="padding-left: 15px;"><span class="m">确认密码：</span></td>
                                            <td class="ku">
                                                <input id="txt_ConfirmPwd" type="password" class="hu" placeholder="请确认密码" /><span class="wstar">*</span></td>
                                        </tr>
                                    </table>

                                </form>
                            </div>
                        </div>
                        <div class="submit_btn">
                            <span class="Save_and_submit">
                                <input type="submit" value="确定" class="Save_and_submit" onclick="SavePwd();" /></span>
                            <span class="cancel">
                                <input type="submit" value="取消" class="cancel" onclick="javascript: parent.CloseIFrameWindow();" /></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--end tz_dialog-->

    <!--tz_yy start-->
    <div class="tz_yy"></div>
    <!--end tz_yy-->
</body>
<script type="text/javascript">
    var num = "";
    $(document).ready(function () {
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
                default:
            }
            if (e && e.keyCode == 13) { // enter 键
                //禁用回车刷新
                e.preventDefault();
                if (num.length > 3) {
                    $("#txt_kano").val(num);
                }
                //清空 纪录
                num = "";
            }
        };
    });
    //保存密码
    function SavePwd() {
        var oldpwd = $("#txt_OldPwd").val();
        var pwd = $("#txt_Pwd").val();
        var confirmpwd = $("#txt_ConfirmPwd").val();
        var id = $("#hid_id").val();
        var judge = !oldpwd.length || !pwd.length || !confirmpwd.length;
        if (judge) {
            layer.msg("请填写完整信息！");
            return;
        }
        if (pwd != confirmpwd) {
            layer.msg("密码不一致,请重新输入!");
            return;
        }
        $.ajax({
            url: WebServiceUrl + "/MeetingBookedWeb.ashx",
            type: "post",
            async: false,
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: { oldpwd: oldpwd, id: id, pwd: pwd, action: "EditPassword" },
            success: OnSaveSuccess,
            error: OnSaveError
        });

    }

    function OnSaveSuccess(json) {
        if (json.result == "CW") {
            layer.msg("旧密码不正确！");
        }
        else if (json.result != "NO") {
            parent.layer.msg('操作成功!');
            parent.CloseIFrameWindow();
        } else {
            layer.msg("操作失败！");
        }
    }
    function OnSaveError(XMLHttpRequest, textStatus, errorThrown) {
        layer.msg("操作失败！");
    }
</script>
</html>

