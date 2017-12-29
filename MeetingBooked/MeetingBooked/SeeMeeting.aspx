<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SeeMeeting.aspx.cs" Inherits="MeetingBooked.SeeMeeting" %>

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
    <script src="js/jquery.tmpl.js"></script>
    <script id="seemeeting" type="text/x-jquery-tmpl">
        <a href="AuditingMeeting.aspx?id= ${bs}" class="clearfix">
            <div class="meeting_img">
                
                <span class="sp1">${subStarNum(MeetingName)}<i>${subStyle(MeetingName)}</i></span>
                <span class="sp2">${subEndNum(MeetingName)}</span>
            </div>

            <h1 class="title clearfix">${MeetingTitle}<span>${Status}</span></h1>
            <p class="data clearfix"><span class="fl">申请人：${Name}</span><span class="fr">${BookedDate}&nbsp;&nbsp;${TimeSectionName}</span></p>
            <div class="jiantou">
                
            </div>
        </a>
    </script>




</head>
<body>
    <nav class="nav_booking menu_mid clearfix">
        <ul>
            <li currentclass="active"><a href="MeetingBooked.aspx">会议室预约</a></li>
            <li currentclass="active"><a href="SeeMeeting.aspx">预约查看</a></li>
        </ul>
    </nav>
    <div id="main">
         <div class="people_message pr">
            <img src="images/tu.jpg" alt="">
            <div class="people_wrap">
                <div class="people_img">
                    <img src="images/men.png" alt="">
                </div>
                <div class="people_depart" id="UserName"></div>
            </div>
        </div>
        <section class="booking_details">
            <div class="seebooking" id="stdiv">
            </div>
        </section>
    </div>
    
</body>

<script type="text/javascript">
    //加载
    $(document).ready(function () {
        $("#UserName").html(sessionStorage.getItem("name"));
            GetSeeMeeting();
    })


    ///加载预约会议室信息
    function GetSeeMeeting() {
        var Name = sessionStorage.getItem("name");
        var Phone = sessionStorage.getItem("phone");

        //Name = '唐宾阁';
        //Phone = '15303363783';

        var postData = { action: 'GetSeeMeeting', Name: Name, Phone: Phone, id: '0', };
        $.ajax({           
            url: WebServiceUrl + "/MeetingBooked.ashx",
            type: "post",
            async: false,
            dataType: "json",
            data: postData,//组合input标签
            success: function (json) {
                $("#stdiv").html('');
                var LoadModel = $("#stdiv");
                var items = json.result.Data;
                if (items != null && items.PagedData.length > 0) {
                    var list = items.PagedData;
                    if (list.length > 0) {
                        //list.sort(getSortFun('desc','id'));
                        $("#seemeeting").tmpl(list).appendTo(LoadModel);
                    } else {
                        $('#stdiv').html('<div style="background: url(images/error.png) no-repeat center;background-size:200px auto;height:300px;"></div>')
                    }
                    
                } else {
                    $('#stdiv').html('<div style="background: url(images/error.png) no-repeat center;background-size:200px auto;height:300px;"></div>')
                }
                

            },
            error: function () {
                //接口错误时需要执行的
            }
        });
       
           
    }

    
    function getSortFun(order, sortBy) {
        var ordAlpah = (order == 'asc') ? '>' : '<';
        var sortFun = new Function('a', 'b', 'return parseInt(a.' + sortBy + ')' + ordAlpah + 'parseInt(b.' + sortBy + ')?1:-1');
        return sortFun;
    }

    function subStarNum(room) {
        var num = "";
        if (room != "" && room != null) {
            var index = room.indexOf("室") - 1;
            num = room.substr(index, 1);
            
        }
        return num;
    }

    function subEndNum(room) {
        var num = "";
        if (room != "" && room != null) {
            var index = room.indexOf("室") + 1;
            num = room.substring(0, index);
        }
        return num;
    }

    function subStyle(room) {
        var num=""
        if (room.indexOf("大") > -1) num = "(大)";
        return num;
    }


    //错误处理
    function OnError(XMLHttpRequest, textStatus, errorThrown) {

    }


</script>

</html>
