<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AuditingMeeting.aspx.cs" Inherits="MeetingBooked.AuditingMeeting" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <title>预约查看</title>
    <link rel="stylesheet" href="css/reset.css" />
    <link rel="stylesheet" href="css/style.css" />

  
      <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/menu_top.js"></script>
    <script src="js/Common.js"></script>

    
</head>
<body style="background: #f2f2f2">
    <header class="enrol-header">
        <a href="SeeMeeting.aspx" class="back"></a>
        <span class="title">预约查看</span>
       <%-- <span class="enrol"></span>--%>
    </header>
    <div id="main">
    <section class="enrol_details">
        <h1 class="enrol_title">预约信息确认</h1>
        <div class="mes">
            <h1>
                <span class="mes_title">预约会议室：</span>
                <span class="mes_detail">
                    <label id="txt_MeetingName"></label>
                </span>
            </h1>
            <h1>
                <span class="mes_title">预约日期：</span>
                <span class="mes_detail">
                    <label id="txt_BookedDate"></label>
                </span>
            </h1>
            <h1>
                <span class="mes_title">预约时间段：</span>
                <span class="mes_detail">
                    <label id="txt_TimeSectionName"></label>
                </span>
            </h1>
        </div>
        <h1 class="enrol_title">会议信息完善</h1>
        <div class="mes">
            <h1>
                <span class="mes_title">会议名称：</span>
                <span class="mes_detail">
                    <label id="txt_MeetingTitle"></label>
                </span>
            </h1>
            <h1>
                <span class="mes_title">申请人：</span>
                <span class="mes_detail">
                    <label id="txt_Name"></label>
                </span>
            </h1>
        </div>
        <div class="submit mt35 none" id="divsh">
            <div class="radiobox">
                <input type="radio" name="ifthrough " id="radioOK" value="2" checked />
                <label for="">通过</label>
                <input type="radio" name="ifthrough " id="radioNO" value="3" />
                <label for="">不通过</label>
            </div>
            <textarea name="BookedRemark" id="BookedRemark" placeholder="请填写审核意见" class="textarea"></textarea>
            <a href="javascript:;" class="submit_booking"  id="SubmitCheck">提交审核</a>
        </div>
         <div class="submit mt35 none" id="divqx">
            <a href="javascript:;" class="submit_booking"  id="CancelBooking">取消预约</a>
        </div>
    </section>
    <input type="hidden" id="hid_id" runat="server" />
        </div>
</body>



<script type="text/javascript">
    var reg1 = /AppleWebKit.*Mobile/i,reg2 = /MIDP|SymbianOS|NOKIA|SAMSUNG|LG|NEC|TCL|Alcatel|BIRD|DBTEL|Dopod|PHILIPS|HAIER|LENOVO|MOT-|Nokia|SonyEricsson|SIE-|Amoi|ZTE/;
    //加载
    $(document).ready(function () {
        GetList();
       
       
        if (reg1.test(navigator.userAgent) || reg2.test(navigator.userAgent)) {
            $('#CancelBooking').on('touchend', function () {
                qxBooked();
            })
            $('#SubmitCheck').on('touchend', function () {
                SetUpMeetingBooked()
            })
        } else {
            $('#CancelBooking').on('click', function () {
                qxBooked();
            })
            $('#SubmitCheck').on('click', function () {
                SetUpMeetingBooked()
            })
        }
    })

    ///加载数据
    function GetList() {
        var Name = sessionStorage.getItem("name");
        var Phone = sessionStorage.getItem("phone");
        $.ajax({
            type: "post",
            url: WebServiceUrl + "/MeetingBooked.ashx",
            dataType: "json",
            //jsonp: "jsoncallback",
            data: { "id": $("#hid_id").val(), "Name": Name, "Phone": Phone, "action": "GetSeeMeetings" },
            success: function (json) {
               
                var item = json.result.Data;
                var items = $.parseJSON(item[0]).data[0];
                if (items != null) {
                    var beginDate = items.BookedDate;
                    var currentDate = getNowFormatDate();
                    var d1 = new Date(beginDate.replace(/\-/g, "\/"));
                    var d2 = new Date(currentDate.replace(/\-/g, "\/"));
                    if (d2>d1) {
                        $("#divqx").hide();
                    } else {
                        $("#divqx").show();
                    }
                    $("#txt_MeetingName").html(items.MeetingName)
                    $("#txt_BookedDate").html(items.BookedDate)
                    $("#txt_TimeSectionName").html(items.TimeSectionName)
                    $("#txt_MeetingTitle").html(items.MeetingTitle)
                    $("#txt_Name").html(items.Name)
                    if (items.RoleID == "1" && items.StatusID == "0") {
                        $("#divsh").show();
                    }
                }
                //} else
                //{
                //    $("#divqx").show();
                //}

            },
            error: OnError
        });

    }


    function MesTips(MesContent) {
        $('body').append('<div class="screen_success"><div class="wenzi"></div></div>');
        $('.screen_success .wenzi').html(MesContent);
        
        setTimeout(function () {
            $('.screen_success').remove();
        }, 2000);
    }


    function SetUpMeetingBooked() {
        var radioObj = $("input[type='radio']:checked").val();;
        var BookedRemark = $("#BookedRemark").val();
        $.ajax({
            type: "post",
            url: WebServiceUrl + "/MeetingBooked.ashx",
            dataType: "json",
            //jsonp: "jsoncallback",
            data: { "id": $("#hid_id").val(), "status": radioObj, "BookedRemark": BookedRemark, "action": "UpMeetingBooked" },
            success: function (json) {
                if (json.result == "OK") {
                    location.href = "SeeMeeting.aspx";
                    //alert("操作成功");
                    MesTips('操作成功')
                } else {
                    //alert("操作失败");
                    MesTips('操作失败')
                }
            },
            error: OnError
        });
    }

    function qxBooked()
    {
        $.ajax({
            type: "post",
            url: WebServiceUrl + "/MeetingBooked.ashx",
            dataType: "json",
            //jsonp: "jsoncallback",
            data: { "id": $("#hid_id").val(), "action": "qxBooked" },
            success: function (json) {
                if (json.result == "OK") {
                    window.location.href = "SeeMeeting.aspx";
                    MesTips('取消预约成功')
                } else {
                    //alert("取消预约失败");
                    MesTips('取消预约失败')
                }
            },
            error: OnError
        });
    }


    function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var seperator2 = "-";
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
        return currentdate;
    }

    //错误处理
    function OnError(XMLHttpRequest, textStatus, errorThrown) {

    }


</script>


</html>
