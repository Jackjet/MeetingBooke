<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MeetingBooked.aspx.cs" Inherits="MeetingBooked.MeetingBooked" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="format-detection" content="telephone=no">
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>会议室预约</title>
    <link rel="stylesheet" href="css/reset.css" />
    <link rel="stylesheet" href="css/style.css" />
    <script src="js/zepto.min.js"></script>
    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/menu_top.js"></script>
    <script src="js/Common.js"></script>
    <script>
        var $$ = jQuery.noConflict()
    </script>
    <script src="js/jquery.tmpl.js"></script>
    <script id="liMeeting" type="text/x-jquery-tmpl">
        <li>
            <span>${MeetingName}
                   <input type="hidden" value='${id}' />
            </span>
        </li>
    </script>
    <script id="liTimeSection" type="text/x-jquery-tmpl">
        {{if Status ==''}}
        <li name="li-ok">
            <span>
                <p>${TimeSectionName}</p>
                <p>${Name}</p>
                <p>${MeetingTitle}</p>
                <input type="hidden" value='${id}' />
            </span>
        </li>
        {{/if}}
        {{if Status =='0'}}
                 <li name="li-no" class="mybooking">
                     <span>
                         <p>${TimeSectionName}</p>
                         <p>${Name}</p>
                         <p>${MeetingTitle}</p>
                         <input type="hidden" value='${id}' />
                     </span>
                 </li>

        {{/if}}
         {{if Status =='1'}}
                 <li name="li-no" class="toenrol">
                     <span>
                         <p>${TimeSectionName}</p>
                         <p>${Name}</p>
                         <p class="meeting-title">${MeetingTitle}</p>
                         <input type="hidden" value='${id}' />
                     </span>
                 </li>

        {{/if}}
    </script>
    <script id="lidate" type="text/x-jquery-tmpl">
        <li>
            <span>${date}
                 <input type="hidden" value='${datetime}' />
            </span>
        </li>
    </script>

</head>
<body>
    <nav class="nav_booking menu_mid clearfix">
        <ul>
            <li currentclass="active"><a href="MeetingBooked.aspx">会议室预约</a></li>
            <li currentclass="active"><a href="SeeMeeting.aspx">预约查看</a></li>
        </ul>
    </nav>
    <div id="maina">
        <section class="booking_details1">

            <h1 class="selection">选择会议室</h1>
            <div class="booking_body">
                <ul class="sele_meeting clearfix" id="trMeeting">
                </ul>
            </div>
            <h1 class="selection">选择时间</h1>
            <div class="booking_body">
                <ul class="sele_time clearfix" id="uldate">
                </ul>
            </div>
            <h1 class="selection">选择时间段 </h1>
            <div class="booking_body">
                <ul class="sele_timeduan clearfix" id="ulTimeSection">
                </ul>
            </div>
            <%--<textarea name="" id="Remark" placeholder="备注" class="textarea"></textarea>--%>
        </section>
    </div>
    <section class="booking_details" style="position: fixed; bottom: 0; z-index: 9999;">
        <a href="javascript:;" class="submit_booking" id="SubmitBooking">提交预约</a>
    </section>
    <input type="hidden" id="hid_Name" runat="server" />
    <input type="hidden" id="hid_Phone" runat="server" />
    <input type="hidden" id="hdxzid" runat="server" />

    <input type="hidden" id="hid_MeetingID" runat="server" />
    <input type="hidden" id="hid_BookedDate" runat="server" />

</body>

<script type="text/javascript">
    var reg1 = /AppleWebKit.*Mobile/i, reg2 = /MIDP|SymbianOS|NOKIA|SAMSUNG|LG|NEC|TCL|Alcatel|BIRD|DBTEL|Dopod|PHILIPS|HAIER|LENOVO|MOT-|Nokia|SonyEricsson|SIE-|Amoi|ZTE/;
    //加载
    $$(function () {
        if (reg1.test(navigator.userAgent) || reg2.test(navigator.userAgent)) {
            $('#SubmitBooking').on('tap', function () {
                SetList();
            })
        } else {
            $$('#SubmitBooking').on('click', function () {
                SetList();
            })
        }

        if ($$("#hid_Name").val() != "") {
            sessionStorage.setItem("name", $$("#hid_Name").val())
            sessionStorage.setItem("phone", $$("#hid_Phone").val())

        }

        if (sessionStorage.getItem("name") == "" || sessionStorage.getItem("name") == null) {
            window.location.href = 'error.aspx';
            //getUserInfo();
        } else {

            getUserInfo();
        }

    })


    ///获取账号信息
    function getUserInfo() {

        var Name = sessionStorage.getItem("name");
        var Phone = sessionStorage.getItem("phone");
        //alert(WebServiceUrl)
      
        //Name = '唐宾阁';
        //Phone = '15303363783';
        $$.ajax({
            type: "post",
            url: WebServiceUrl + "/MeetingBooked.ashx",

            dataType: "json",
            //jsonp: "jsoncallback",
            data: { "Name": Name, "Phone": Phone, "action": "getUserInfo", "NUM": Math.random(1000) },
            success: function (json) {
                if (json.result == "OK") {
                    if (reg1.test(navigator.userAgent) || reg2.test(navigator.userAgent)) {
                        //alert(JSON.stringify(json))
                        //alert(Phone)
                        GetList('tap');
                    } else {
                        GetList('click');
                    }

                } else {
                    InUserLog(Name, Phone);
                    //window.location.href = 'error.aspx';
                }
            },
            error: OnError
        });
    }



    //新用户自动注册账号
    function InUserLog(Name, Phone) {
        $$.ajax({
            type: "post",
            url: WebServiceUrl + "/MeetingBooked.ashx",
            dataType: "json",
            ////jsonp: "jsoncallback",
            async: false,
            data: { "Name": Name, "Phone": Phone, "action": "InUserLog", "NUM": Math.random(1000) },
            success: function (json) {
                if (json.result == "OK") {
                    MesTips('欢迎新用户，您的账号已经自动注册！')
                    if (reg1.test(navigator.userAgent) || reg2.test(navigator.userAgent)) {
                        GetList('tap');
                    } else {
                        GetList('click');
                    }
                    GetList();
                } else {
                    MesTips('欢迎新用户，您的账号已经自动注册失败，请联系管理员！')
                }
            },
            error: OnError
        });
    }



    //页面初始化数据
    function GetList(event) {
        $$.ajax({
            type: "post",
            url: WebServiceUrl + "/MeetingBooked.ashx",
            dataType: "json",
            async: false,
            ////jsonp: "jsoncallback",
            data: { "action": "getList" },
            success: function (json) {

                $$("#trMeeting").html('');
                $$("#uldate").html('');

                var LoadModel = $$("#trMeeting");
                var Loaddate = $$("#uldate");
                var items = json.result.Data;
                if (items != null && items.length > 0) {
                    $$("#liMeeting").tmpl($$.parseJSON(items[0]).data).appendTo(LoadModel);
                    $$("#lidate").tmpl($$.parseJSON(items[2]).Table1).appendTo(Loaddate);;
                }

                if ($$("#hid_MeetingID").val().trim() == "") {
                    $$('.sele_meeting li').eq(0).addClass('on');
                    $$('.sele_time li').eq(0).addClass('on');
                } else {
                    $$('.sele_meeting li').eq(parseInt($$('#hid_MeetingID').val()) - 1).addClass('on');

                    $$('.sele_time li').each(function () {
                        if ($$(this).find('input').val() == $$("#hid_BookedDate").val().trim()) {
                            $$(this).addClass('on');
                        }
                    })
                }
                //
                if (reg1.test(navigator.userAgent) || reg2.test(navigator.userAgent)) {
                    $('.sele_meeting li').on(event, function () {
                        $(this).addClass('on').siblings().removeClass('on');
                        getMeetingBooked('tap');
                    })
                    $('.sele_time li').on(event, function () {
                        $(this).addClass('on').siblings().removeClass('on');
                        getMeetingBooked('tap');
                    })
                    getMeetingBooked('tap');
                } else {
                    $$('.sele_meeting li').on(event, function () {
                        $$(this).addClass('on').siblings().removeClass('on');
                        getMeetingBooked('click');
                    })
                    $$('.sele_time li').on(event, function () {
                        $$(this).addClass('on').siblings().removeClass('on');
                        getMeetingBooked('click');
                    })
                    getMeetingBooked('click');
                }

            },
            error: OnError
        });

    }


    ///获取当前会议室是否被占用
    function getMeetingBooked(event) {
        var MeetingID = $$('.sele_meeting li[class=on]').find('input').val();
        var BookedDate = $$('.sele_time li[class=on]').find('input').val();

        $$.ajax({
            type: "post",
            url: WebServiceUrl + "/MeetingBooked.ashx",
            dataType: "json",
            //jsonp: "jsoncallback",
            data: { "BookedDate": BookedDate, "MeetingID": MeetingID, "action": "getMeetingBooked" },
            success: function (json) {
                $$("#ulTimeSection").html('');
                var LoadTimeSection = $$("#ulTimeSection");

                var items = json.result.Data;
                if (items != null && items.length > 0) {
                    $$("#liTimeSection").tmpl($$.parseJSON(items[0]).data).appendTo(LoadTimeSection);
                }
                if (reg1.test(navigator.userAgent) || reg2.test(navigator.userAgent)) {
                    $('.sele_timeduan li[name=li-ok]').on(event, function () {
                        if ($(this).hasClass("on")) {
                            $(this).removeClass("on");
                        } else {
                            $(this).addClass('on');
                        }
                    })
                } else {
                    $$('.sele_timeduan li[name=li-ok]').on(event, function () {
                        if ($$(this).hasClass("on")) {
                            $$(this).removeClass("on");
                        } else {
                            $$(this).addClass('on');
                        }
                    })
                }

            },
            error: OnError
        });
    }


    function MesTips(MesContent) {
        $$('body').append('<div class="screen_success"><div class="wenzi"></div></div>');
        $$('.screen_success .wenzi').html(MesContent);

        setTimeout(function () {
            $$('.screen_success').remove();
        }, 2000);
    }




    function SetList() {
        var bool = true;
        if (sessionStorage.getItem("name") == "" || sessionStorage.getItem("phone") == "") {
            //alert("对不起暂无您的账号信息，请联系管理员！");
            MesTips('对不起暂无您的账号信息，请联系管理员！')
        }
        else {

            var MeetingID = $$('.sele_meeting li[class=on]').find('input').val();
            var BookedDate = $$('.sele_time li[class=on]').find('input').val();
            var TimeSectionID = "";
            var TimeSectionName = "";
            var MeetingTitle = $$("#meetingTitle").val();
            var Remark = "";// $("#Remark").val();


            $$('.sele_timeduan li[class=on]').each(function () {
                if (bool) {
                    if (TimeSectionID == "") {
                        TimeSectionID = $$(this).find('input').val();
                        $$("#hdxzid").val(TimeSectionID);
                    } else {
                        if ($$("#hdxzid").val() == (parseInt($$(this).find('input').val()) + 1) || $$("#hdxzid").val() == (parseInt($$(this).find('input').val()) - 1)) {
                            TimeSectionID = TimeSectionID + "," + $$(this).find('input').val();
                            $$("#hdxzid").val($$(this).find('input').val());
                        } else {
                            MesTips('多选时，请选择连续的时间段！')
                            bool = false
                        }
                    }
                }
            })
            if (TimeSectionID == "") {
                MesTips('请选择要预约的时间段！')
                bool = false
            }

            if (bool) {
                var MeetingName = $$('.sele_meeting li[class=on]').find('span').text();
                var BookedDateName = $$('.sele_time li[class=on]').find('span').text();

                $$('.sele_timeduan li[class=on]').each(function () {
                    if (TimeSectionName == "") {
                        TimeSectionName = $$(this).children('span').find('p:eq(0)').html();
                    } else {
                        TimeSectionName = TimeSectionName + "," + $$(this).find('p:eq(0)').html();
                    }
                })

                if (TimeSectionName.indexOf(",") > 0) {
                    var begindate = TimeSectionName.split(",")[0].split("-")[0];
                    var enddate = TimeSectionName.split(",")[TimeSectionName.split(",").length - 1].split("-")[1];
                    TimeSectionName = begindate + "-" + enddate;
                }



                var Meeting = MeetingName.trim() + "*" + MeetingID;
                var BookedDates = BookedDateName.trim() + "*" + BookedDate;
                var TimeSection = TimeSectionName.trim() + "*" + TimeSectionID;
                window.location.href = 'SureMeetingBooked.aspx?Meeting=' + Meeting + '&BookedDates=' + BookedDates + '&TimeSection=' + TimeSection;
            }
        }

    }

    //错误处理
    function OnError(XMLHttpRequest, textStatus, errorThrown) {

    }


</script>


</html>

