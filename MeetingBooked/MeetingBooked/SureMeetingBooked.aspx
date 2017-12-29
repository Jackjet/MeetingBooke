<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SureMeetingBooked.aspx.cs" Inherits="MeetingBooked.SureMeetingBooked" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <title>会议室预约</title>
    <link rel="stylesheet" href="css/reset.css" />
    <link rel="stylesheet" href="css/style.css" />
    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/menu_top.js"></script>
        <script src="js/Common.js"></script>
</head>
<body style="background: #f2f2f2;">
    <input type="hidden" id="hid_Meeting" runat="server" />
    <input type="hidden" id="hid_BookedDate" runat="server" />
    <input type="hidden" id="hid_TimeSection" runat="server" />
    <header class="enrol-header">
        <a href="javascript:;" class="back" id="Back"></a>
        <span class="title">确认预约</span>
    </header>
    <div id="main" class="sure_box">
        <section class="enrol_details">
            <h1 class="enrol_title">预约信息确认</h1>
            <div class="mes">
                <h1>
                    <span class="mes_title">预约会议室：</span>
                    <span class="mes_detail" id="MeetingName"></span>
                </h1>
                <h1>
                    <span class="mes_title">预约日期：</span>
                    <span class="mes_detail" id="BookedDate"></span>
                </h1>
                <h1>
                    <span class="mes_title">预约时间段：</span>
                    <span class="mes_detail" id="TimeSection"></span>
                </h1>
            </div>
            <h1 class="enrol_title">会议信息完善</h1>
            <div class="mes">
                <div class="meeting_title">
                    <label for="meetingTitle">会议名称：</label>
                    <input type="text" id="meetingTitle" placeholder="请输入会议名称"  autofocus="autofocus" maxlength='20'/>
                </div>
                <h1>
                    <span class="mes_title">申请人：</span>
                    <span class="mes_detail" id="UserName"></span>
                </h1>
            </div>
            <div style="padding:0px 12px;">
                <a href="javascript:;" class="submit_booking" style="margin:20px auto;" id="SetMeeting">确认预约</a>
            </div>
        </section>
    </div>
</body>

    <script type="text/javascript">
        var reg1 = /AppleWebKit.*Mobile/i, reg2 = /MIDP|SymbianOS|NOKIA|SAMSUNG|LG|NEC|TCL|Alcatel|BIRD|DBTEL|Dopod|PHILIPS|HAIER|LENOVO|MOT-|Nokia|SonyEricsson|SIE-|Amoi|ZTE/;
        var MeetingID = $("#hid_Meeting").val().split("*")[1];
        var BookedDateID = $("#hid_BookedDate").val().split("*")[1];
        var TimeSectionID = $("#hid_TimeSection").val().split("*")[1];
        var Name = sessionStorage.getItem("name");
        var Phone = sessionStorage.getItem("phone");
        $(function () {
          
            var MeetingName = $("#hid_Meeting").val().split("*")[0];
            var BookedDateName = $("#hid_BookedDate").val().split("*")[0];
            var TimeSectionName = $("#hid_TimeSection").val().split("*")[0];
          

            $("#MeetingName").html(MeetingName);
            $("#BookedDate").html(BookedDateName);
            $("#TimeSection").html(TimeSectionName);
            $("#UserName").html(sessionStorage.getItem("name"));
            if (reg1.test(navigator.userAgent) || reg2.test(navigator.userAgent)) {
                $('#SetMeeting').on('touchstart', function () {
                    SetList();
                })
                $('#Back').on('touchstart', function () {
                    window.location.href = "MeetingBooked.aspx?BookedDateID=" + BookedDateID + "&MeetingID=" + MeetingID;
                })
            } else {
                $('#SetMeeting').on('click', function () {
                    SetList();
                })
                $('#Back').on('click', function () {
                    window.location.href = "MeetingBooked.aspx?BookedDateID=" + BookedDateID + "&MeetingID=" + MeetingID;
                })
            }
        })

        function MesTips(MesContent) {
            $('body').append('<div class="screen_success"><div class="wenzi"></div></div>');
            $('.screen_success .wenzi').html(MesContent);

            setTimeout(function () {
                $('.screen_success').remove();
            }, 2000);
        }

        function SetList() {
         

            var meetingTitle = $("#meetingTitle").val();
            var reg = /^[\u4E00-\u9FA5A-Za-z0-9]{1,20}$/;
                if (!reg.test(meetingTitle)) {
                    MesTips('请输入会议名称且不包含特殊字符！')
                    return;
                }
                var Remark = "";
                $.ajax({
                    type: "post",
                    url: WebServiceUrl + "/MeetingBooked.ashx",
                    dataType: "json",
                    //jsonp: "jsoncallback",
                    data: { "Name": Name, "Phone": Phone, "MeetingID": MeetingID, "BookedDate": BookedDateID, "TimeSectionID": TimeSectionID, "MeetingTitle": meetingTitle, "Remark": Remark, "action": "SetList" },
                    success: function (json) {
                        if (json.result == "OK") {
                            MesTips('预约成功')
                            window.location.href = "MeetingBooked.aspx?BookedDateID=" + BookedDateID + "&MeetingID=" + MeetingID;

                        } else if (json.result == "CF") {
                            MesTips('您来晚了一步，会议室刚刚被预定了！');
                            window.location.href = "MeetingBooked.aspx?BookedDateID=" + BookedDateID + "&MeetingID=" + MeetingID;
                        }
                        else {
                            MesTips('预约失败');
                        }
                    },
                    error: OnError
                });
        }

        //错误处理
        function OnError(XMLHttpRequest, textStatus, errorThrown) {

        }
       </script>
</html>