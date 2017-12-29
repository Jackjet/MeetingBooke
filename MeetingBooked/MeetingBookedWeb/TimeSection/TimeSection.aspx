<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeSection.aspx.cs" Inherits="MeetingBookedWeb.TimeSection.TimeSection" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>时间段列表</title>
    <link href="../css/common.css" rel="stylesheet" />
    <link href="../css/style.css" rel="stylesheet" />
    <link href="../css/iconfont.css" rel="stylesheet" />
    <link href="../css/animate.css" rel="stylesheet" />

    <script src="../js/Common.js"></script>
    <script src="../js/jquery-1.11.2.min.js"></script>
    <script src="../js/jquery.tmpl.js"></script>
    <script src="../js/PageBar.js"></script>
    <script src="../js/tz_slider.js"></script>
    <script src="../js/layer/layer.js"></script>
</head>

<body>
    <form id="form1" runat="server">
        <div class="Teaching_plan_management">
            <h1 class="Page_name">时间段列表</h1>
            <div class="Operation_area">
                <div class="left_choice fl">
                    <ul>
                        <li class="Sear">
                             <input id="TimeSectionName" type="text" name="search_w" class="search_w" placeholder="请输入时间段 如：09：00" value="" />
                            
                        </li>
                        <li>
                            <a class="btn1" href="#" onclick="javascript:SearchData();">搜索</a>
                        </li>
                         <li>
                            <a class="btn1" href="#" onclick="OpenIFrameWindow('新增', 'TimeSectionEdit.aspx?id=0', '650px', '360px')">新增</a>
                        </li>

                    </ul>
                </div>
                <div class="right_add fr">
                </div>
            </div>
            <div class="Honor_management">
                <table class="W_form">
                    <thead>
                        <tr class="trth">
                            <th>序号</th>
                            <th>时间段</th>
                            <th>创建人</th>
                            <th>创建时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="TbodyList">
                    </tbody>

                </table>
            </div>
        </div>
        <!--分页页码开始-->
        <div class="paging">
            <span id="pageBar"></span>
        </div>
        <!--分页页码结束-->
        <asp:HiddenField ID="hidIsAdmin" runat="server" />
        <asp:HiddenField ID="hidUserIDCard" runat="server" />
        <asp:HiddenField ID="hidUserRoleID" runat="server" />
    </form>
</body>
<script type="text/javascript">
    var MeetingName = "";//设备来源

    $(document).ready(function () {
        SearchData();
    });

    //搜索
    function SearchData() {
        //获得搜索条件
        TimeSectionName = $('#TimeSectionName').val().trim();

        getData(1);
    }

    //获取数据
    function getData(PageIndex) {
        //初始化序号 
        pageNum = (PageIndex - 1) * 10 + 1;
        PageSize = 10;
        $.ajax({
            type: "Post",
            url: WebServiceUrl + "/MeetingBookedWeb.ashx",//random" + Math.random(),//方法所在页面和方法名
            //async: false,
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: {
                "PageIndex": PageIndex, "PageSize": PageSize, "TimeSectionName": TimeSectionName, "action": "GetTimeSection"
            },
            success: function (json) {
                if (json.result.Status == "error") {
                    //layer.msg(json.result.Msg);
                    return;
                }
                if (json.result.Status == "no") {
                    //layer.msg(json.result.Msg);
                    $("#TbodyList").html('');
                    //生成页码条方法（方法对象,页码条容器，当前页码，总页数，页码组容量，总行数）
                    makePageBar(getData, document.getElementById("pageBar"), 1, 1, 8, 0);

                    return;
                }
                if (json.result.Status == "ok") {
                    $("#TbodyList").html('');
                    $("#trTemp").tmpl(json.result.Data.PagedData).appendTo("#TbodyList");
                    //生成页码条方法（方法对象,页码条容器，当前页码，总页数，页码组容量，总行数）
                    makePageBar(getData, document.getElementById("pageBar"), json.result.Data.PageIndex, json.result.Data.PageCount, 8, json.result.Data.RowCount);
                }

            },
            error: OnError
        });

    }
    //错误处理
    function OnError(XMLHttpRequest, textStatus, errorThrown) {
        //layer.msg("");
    }

    ///启用/禁用
    function SetMeeting(id, IsDelete) {
        $.ajax({
            url: WebServiceUrl + "/MeetingBookedWeb.ashx",
            type: "post",
            // async: false,
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: { id: id, IsDelete: IsDelete, action: "SetTimeSection" },
            success: OnSaveSuccess,
            error: OnSaveError
        });
    }

    function OnSaveSuccess(json) {
        if (json.result == "OK") {
            parent.layer.msg('操作成功!');
            getData(1);
        } else {
            layer.msg("操作失败！");
        }
    }
    function OnSaveError(XMLHttpRequest, textStatus, errorThrown) {
        layer.msg("操作失败！");
    }


</script>
<script id="trTemp" type="text/x-jquery-tmpl">
    <tr class="Single">
        <td>${pageIndex()}</td>
        <td>${TimeSectionName}</td>
        <td>${CreatorName}</td>
        <td>${CreateTime}</td>
        <td>${IsDeleteName}</td>
        <td>
            <span>
                <input type="button" class="Topic_btn" value="编辑" onclick="OpenIFrameWindow('编辑', 'TimeSectionEdit.aspx?id=${id}', '650px', '360px')" />
                {{if IsDelete==0}}
                     <input type="button" class="Topic_btn" value="禁用" onclick="SetMeeting('${id}', 1)" />
                {{/if}}
                 {{if IsDelete!=0}}
                     <input type="button" class="Topic_btn" value="启用" onclick="SetMeeting('${id}', 0)" />
                {{/if}}
                
               

            </span>

        </td>
    </tr>
</script>
</html>