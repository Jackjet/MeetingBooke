<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeSectionEdit.aspx.cs" Inherits="MeetingBookedWeb.TimeSection.TimeSectionEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑时间段</title>
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
     <input type="hidden" id="hid_Userid" runat="server" />
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
                                            <td class="mi"><span class="m">时间段：</span></td>
                                            <td class="ku">
                                                <input id="txtBeginDate" type="text" class="hu" placeholder="请输入会议室名称" />-</td>
                                            <td class="ku"> <input id="txtEndDate" type="text" class="hu" placeholder="请输入会议室名称" /></td>
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
        var TimeSectionID = $("#<%=hid_Id.ClientID%>").val();
        if (TimeSectionID != "0") {
            //为控件绑定数据
            BindTimeSection(TimeSectionID);
        }
    });
    function BindTimeSection(TimeSectionID) {
        $.ajax({
            url: WebServiceUrl + "/MeetingBookedWeb.ashx",//random" + Math.random(),//方法所在页面和方法名
            type: "post",
            async: false,
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: { id: TimeSectionID, action: "BindTimeSection" },
            success: OnBindSuccess,
            //error: OnBindError
        });
    }
    function OnBindSuccess(json) {
        var Name = json.result;
        if (Name.toString() != "") {
            var result = Name.toString().split("-");
            $("#txtBeginDate").val(result[0]);
            $("#txtEndDate").val(result[1]);
        }
    }


    //保存
    function SaveTeacher() {
        var BeginDate = $("#txtBeginDate").val().trim();
        var EndDate = $("#txtEndDate").val().trim();
        var TimeSectionName = BeginDate + "-" + EndDate;
        var userid = $("#hid_Userid").val();
        var Type = "Up";
        var id = $("#hid_Id").val();
        if (id == "0") {
            Type = "In";
        }
        if (!BeginDate.length || !EndDate.length) {
            layer.msg("请填写完整信息！");
            return;
        }
        $.ajax({
            url: WebServiceUrl + "/MeetingBookedWeb.ashx",
            type: "post",
            // async: false,
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: { TimeSectionName: TimeSectionName, userid: userid, id: id, Type: Type, action: "InTimeSection" },
            success: OnSaveSuccess,
            error: OnSaveError
        });

    }

    function OnSaveSuccess(json) {
        if (json.result == "CF") {
            layer.msg("该时间段已经存在！");
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

