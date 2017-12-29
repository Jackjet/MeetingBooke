//#menubox > #box.find(".items") > .class.find("class")>class>tag 	

//email下拉
$(document).ready(function (e) {
    //下拉列表
    $(".slidedown").mouseover(function () {
        $(this).find(".slidecon").show();
        $(this).find("dt").addClass("hover");
    });
    $(".slidedown").mouseout(function () {
        $(this).find(".slidecon").hide();
        $(this).find("dt").removeClass("hover");
    });
});
/*百叶窗*/
$(function () {
    $("#menubox").find(".menuclick").click(function () {
        $(this).parent().toggleClass("selected").siblings().removeClass("selected");
        $(this).next().slideToggle("fast").end().parent().siblings().find(".submenu")
		.addClass("animated flipInX")
		.slideUp("fast").end().find("i").text("+");
        var t = $(this).find("i").text();
        $(this).find("i").text((t == "+" ? "-" : "+"));
    });
});
/*两层列表*/
$(function () {
    $("#slide").find("ul.Two_list li a.Topic_click").click(function () {
        $(this).parent().toggleClass("selected").siblings().removeClass("selected");
        $(this).next().slideToggle("fast").end().parent().siblings().find(".Topic_con")
		.addClass("animated bounceIn")
		.slideUp("fast").end().find("i").text("+");
        var t = $(this).find("i").text();
        $(this).find("i").text((t == "+" ? "-" : "+"));
    });
});



//左侧导航点击下拉
$(function () {
    $(".menubox1").find(".menuclick1").click(function () {
        $(this).parent().toggleClass("selected").siblings().removeClass("selected");
        $(this).next().slideToggle("fast").end().parent().siblings().find(".submenu1")
		.addClass("animated flipInX")
		.slideUp("fast").end().find("i").text("+");
        var t = $(this).find("i").text();
        $(this).find("i").text((t == "+" ? "-" : "+"));
    });
});



//左侧导航点击下拉
$(function () {
    $(".i-menu").each(function () {
        var _this = $(this);
        $(this).hover(function () {
            _this.find(".btn-area").show();
        }, function () {
            _this.find(".btn-area").hide();
        });
        var i_con = $(this).next(".i-con")[0];
        i_con.style.display = "none";
        $(this).click(function () {
            if (i_con.style.display == "none") {
                i_con.style.display = "block";
            } else {
                i_con.style.display = "none";
            };
        });

    });
    $(".ici-menu").each(function () {
        var _this = $(this);
        $(this).hover(function () {
            _this.find(".btn-area").show();
        }, function () {
            _this.find(".btn-area").hide();
        });
        var i_con = $(this).next(".ici-con")[0];
        i_con.style.display = "none";
        $(this).click(function () {
            if (i_con.style.display == "none") {
                i_con.style.display = "block";
            } else {
                i_con.style.display = "none";
            };
        });
    });
    $(".icic-item").each(function () {
        var _this = $(this);
        $(this).hover(function () {
            _this.find(".btn-area").show();
        }, function () {
            _this.find(".btn-area").hide();
        });
    });


})
