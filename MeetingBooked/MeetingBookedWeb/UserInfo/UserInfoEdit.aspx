<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserInfoEdit.aspx.cs" Inherits="MeetingBookedWeb.UserInfo.UserInfoEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑人员信息</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/common.css" rel="stylesheet" />
    <link href="/css/iconfont.css" rel="stylesheet" />
    <link href="/css/animate.css" rel="stylesheet" />
    <script src="/js/jquery-1.11.2.min.js"></script>
    <script src="/js/layer/layer.js"></script>
    <script src="/js/Common.js"></script>
    <script src="/js/jquery.tmpl.js"></script>
</head>
<body>
    <input type="hidden" id="hid_Id" runat="server" />
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
                                            <td class="mi"><span class="m">姓名：</span></td>
                                            <td class="ku">
                                                <input id="txt_name" type="text" class="hu" placeholder="请输入姓名" /><span class="wstar">*</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="mi"><span class="m">账号：</span></td>
                                            <td class="ku">
                                                <input id="txt_LoginName" type="text" class="hu" placeholder="请输入账号" /><span class="wstar">*</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="mi"><span class="m">手机号码：</span></td>
                                            <td class="ku">
                                                <input id="txt_Phone" type="text" class="hu" placeholder="请输入手机号码" /><span class="wstar">*</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="mi"><span class="m">身份证号码：</span></td>
                                            <td class="ku">
                                                <input id="txt_IDCard" type="text" class="hu" placeholder="请输入身份证号码" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="mi"><span class="m">角色：</span></td>
                                            <td class="ku">
                                                <select class="option" id="RoleID">
                                                    <option value='1'>会议室管理员</option>
                                                    <option value='2'>普通用户</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </div>
                        </div>
                        <div class="submit_btn">
                            <span class="Save_and_submit">
                                <input type="submit" value="确定" class="Save_and_submit" onclick="SaveTeacher();" /></span>
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
    $(document).ready(function () {
        var UserInfoID = $("#<%=hid_Id.ClientID%>").val();
        if (UserInfoID != "0") {
            //为控件绑定数据
            BindUserInfo(UserInfoID);
        }
    });
    function BindUserInfo(UserInfoID) {
        $.ajax({
            url: WebServiceUrl + "/MeetingBookedWeb.ashx",//random" + Math.random(),//方法所在页面和方法名
            type: "post",
            async: false,
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: { id: UserInfoID, action: "BindUserInfo" },
            success: OnBindSuccess,
            //error: OnBindError
        });
    }
    function OnBindSuccess(json) {
        var item = json.result.Data;
        var items = $.parseJSON(item[0]).data[0];
        $("#txt_name").val(items.Name);
        $("#txt_LoginName").val(items.LoginName);
        $("#txt_Phone").val(items.Phone);
        $("#txt_IDCard").val(items.IDCard);
        $("#RoleID").val(items.RoleID);
        //$("#txt_name").hide();
        //$("#txt_LoginName").hide();
    }


    //保存
    function SaveTeacher() {
        var name = $("#txt_name").val().trim();
        var LoginName = $("#txt_LoginName").val().trim();
        var Phone = $("#txt_Phone").val().trim();
        var IDCard = $("#txt_IDCard").val().trim();
        var RoleID = $("#RoleID").val().trim();
        var Type = "Up";
        var id = $("#hid_Id").val();
        if (id == "0") {
            Type = "In";
        }
        if (!name.length || !Phone) {
            layer.msg("请填写完整信息！");
            return;
        }
        $.ajax({
            url: WebServiceUrl + "/MeetingBookedWeb.ashx",
            type: "post",
            // async: false,
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: { name: name, LoginName: LoginName, Phone: Phone, IDCard: IDCard, RoleID: RoleID, id: id, Type: Type, action: "InUserInfo" },
            success: OnSaveSuccess,
            error: OnSaveError
        });

    }

    function OnSaveSuccess(json) {
        if (json.result == "CF") {
            layer.msg("该人员信息已经存在！");
        }
        else if (json.result == "OK") {
            parent.layer.msg('操作成功!');
            parent.getData(1);
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
