WebServiceUrl = "http://localhost:1047";
//WebServiceUrl = "http://61.50.119.70:7777";//服务器地址
CallbackName = "jsoncallback";//Ajax回调名称

/**日期转换成时间字符串**/
/** date日期  **/
/** format要转换的字符串格式，默认为 "yyyy-MM-dd"格式，若没有需要的格式可自己添加 **/
function DateTimeConvert(date, format) {
    if (date == null) {
        return "";
    }
    date = date.replace(/(^\s*)|(\s*$)/g, "");
    if (date == "") {
        return "";
    }
    if (date.indexOf("Date") != -1) {
        date = eval(date.replace(/\/Date\((\d+)\)\//gi, "new Date($1)"));
    } else {
        date = new Date(Date.parse(date));
    }
    //date = eval(date.replace(/\/Date\((\d+)\)\//gi, "new Date($1)"));
    var year = date.getFullYear();
    var month = (date.getMonth() + 1).toString();
    var twoMonth = month.length == 1 ? "0" + month : month; //月份为1位数时，前面加0
    var day = (date.getDate()).toString();
    var twoDay = day.length == 1 ? "0" + day : day; //天数为1位数时，前面加0
    var hour = (date.getHours()).toString();
    var twoHour = hour.length == 1 ? "0" + hour : hour; //小时数为1位数时，前面加0
    var minute = (date.getMinutes()).toString();
    var twoMinute = minute.length == 1 ? "0" + minute : minute; //分钟数为1位数时，前面加0
    var second = (date.getSeconds()).toString();
    var twoSecond = second.length == 1 ? "0" + second : second; //秒数为1位数时，前面加0
    var dateTime;
    if (format == "yyyy-MM-dd HH:mm:ss") {
        dateTime = year + "-" + twoMonth + "-" + twoDay + " " + twoHour + ":" + twoMinute + ":" + twoSecond;
    } else if (format == "年月日") {
        dateTime = year + "年" + month + "月" + day + "日";
    }
    else {
        dateTime = year + "-" + twoMonth + "-" + twoDay
    }
    return dateTime;
}

/**根据IsDelete字段转换是否归档描述**/
/** int数字  **/
function DataState(IsDelete) {
    if (IsDelete == 0) {
        return "正常";
    } else if (IsDelete == 1) {
        return "删除";
    } else if (IsDelete == 2) {
        return "归档";
    }
}
//获取URL参数
//使用范例：var UrlDate = new GetUrlDate(); //实例化
//          var orderNo = UrlDate.orderNo;//直接.参数名
function GetUrlDate() {
    var name, value;
    var str = location.href; //取得整个地址栏
    var num = str.indexOf("?")
    str = str.substr(num + 1); //取得所有参数   stringvar.substr(start [, length ]

    var arr = str.split("&"); //各个参数放到数组里
    for (var i = 0; i < arr.length; i++) {
        num = arr[i].indexOf("=");
        if (num > 0) {
            name = arr[i].substring(0, num);
            value = arr[i].substr(num + 1);
            this[name] = value;
        }
    }
}

/**改变启用禁用状态**/
/**obj当前超链接对象，itemid 选中行的主键，status 启用禁用的值，tablename 表名**/
function ChangeUseStatus(obj, itemid, status, tablename) {
    if (itemid != null && itemid != "") {
        jQuery.ajax({
            url: WebServiceUrl + "/Common/CommonFunction.ashx",//random" + Math.random(),//方法所在页面和方法名
            type: "POST",
            dataType: "jsonp",
            jsonp: "jsoncallback",
            data: { itemid: itemid, Status: status, tablename: tablename, action: "ChangeUseStatus" },
            success: function (json) {
                if (json.result != "0") {
                    //if (status == 0) {
                    //    $(obj).next().attr("class", "Disable");
                    //} else {
                    //    $(obj).prev().attr("class", "Disable");
                    //}
                    //$(obj).attr("class", "Enable");
                    getData(1);
                } else {
                    layer.msg("操作失败！");
                }
            },
            error: function (request) {
                layer.msg("操作失败");
            }
        });
    }
}
/*************************************IFrame弹框方法***********************************************************/
var curWinindex;
function OpenIFrameWindow(title,url, width, height) {
    //iframe层
    var index = layer.open({
        type: 2,
        title: title,
        shadeClose: false,
        shade: 0.2,
        area: [width, height],
        content: url //iframe的url
    });
    curWinindex = index;
}
function CloseIFrameWindow() {
    layer.close(curWinindex);
}
function layerMsg(title) { //msg信息框
    layer.msg(title, {
        time: 0 //不自动关闭
        , btn: ['确定']
        , yes: function (index) {
            layer.close(index);
        }
    });
}
/****************************************结束********************************************************/

/*************************************绑定下拉框方法***********************************************************/
/// <summary>绑定下拉框方法</summary>
/// <param name="controlid" type="String">下拉框控件的id</param>
/// <param name="url" type="String">路径</param>  
/// <param name="params" type="String">传递的参数,可为{}</param>
function BindSerDropDownList(controlid, url, params) {
    var isdis = arguments[3] ? arguments[3] : false;//是否显示未分配
    $.ajax({
        url: url,
        type: "post",
        async: false,
        dataType: "jsonp",
        jsonp: "jsoncallback",
        data: params,
        success: function (data) {
            $("#" + controlid).empty().append("<option value=''>全部</option>");
            if (isdis) {
                var extoption = controlid == "sel_User" ? "<option value='-1'>无负责人</option>" : "<option value='0'>未分配</option>";
                $("#" + controlid).append(extoption);
            }
            if (data.result != null) {
                $("#" + controlid).append(data.result);
            }
        },
        error: function () {
            layer.msg("获取失败！");
        }
    });
}
/****************************************结束********************************************************/

/**********************************************ZTree相关方法**********************************************/
//绑定Ztree树
function treeBind(treeId, url, data, setting) {
    /// <summary>绑定Ztree树</summary>
    /// <param name="treeId" type="String">树控件ul的id</param>
    /// <param name="url" type="String">JSON数据源路径</param>  
    /// <param name="data" type="String">传递的参数,可为''</param>
    /// <param name="setting" type="String">Ztree树的配置信息,可为''</param>
    /// <returns>zTree 对象</returns>
    if (setting == "") {
        setting = {
            view: {
                selectedMulti: false
            },
            data: {
                simpleData: {
                    enable: true
                }
            }
        };
    }
    $.ajax({
        type: "post",
        url: url,
        data: data,
        dataType: "jsonp",
        jsonp: "jsoncallback",
        async: false,
        cache: false,
        success: function (json) {
            if (json.result.length > 0) {
                var zTreeNode = json.result;
                var zTreeObj = $.fn.zTree.init($("#" + treeId), setting, zTreeNode); //返回树对象
                zTreeObj.expandNode(zTreeObj.getNodeByParam("id", 0, null), true, false, false); //展开第一个顶级节点
            } else {
                layer.msg("您没有此权限!");
            }
        },
        error: function () {
            layer.msg("Ajax请求数据失败!");
        }
    });
    //return $.fn.zTree.init($("#" + treeId), setting, zTreeNode); //返回树对象
}
//获取选择节点集合(用于ztree插件,且依赖 jquery.ztree.excheck 扩展 js )  
function getChildNodes(ulZtreeId) {
    /// <summary>获取选择节点集合(用于ztree插件,且依赖 jquery.ztree.excheck 扩展 js )</summary>
    /// <param name="ulZtreeId" type="String">Ztree树Id</param>
    /// <param name="getEndChild" type="Bool">是否只获取最低级节点的值,默认获取全部的.</param>
    var getEndChild = arguments[1] || false;

    var treeObj = $.fn.zTree.getZTreeObj(ulZtreeId);
    var treeNode = treeObj.getCheckedNodes(true);
    var data = eval(treeNode);
    var str = "";
    $.each(data, function (n, value) {
        if (getEndChild) {
            if (value.check_Child_State == '-1')  //只获取最底级节点的值
                str += value.id + ',';
        }
        else
            str += value.id + ',';

    });
    return str = str.substr(0, str.length - 1);
}

//设置指定树的节点选中(用于ztree插件,且依赖 jquery.ztree.excheck 扩展 js )  
function setNodesCheck(treeId, nodesList) {
    /// <summary>设置指定树的节点选中(用于ztree插件,且依赖 jquery.ztree.excheck 扩展 js )</summary>
    /// <param name="nodesList" type="String">节点集合(例'1,2,3')</param>
    var treeObj = $.fn.zTree.getZTreeObj(treeId);
    var strArray = nodesList.split(',');
    var nodes = null;
    treeObj.checkAllNodes(false);
    $.each(strArray, function (i, n) {
        nodes = treeObj.getNodeByParam("id", n, null);
        treeObj.checkNode(nodes, true, false, false);
    });
}

//取消指定树的节点的选中状态(用于ztree插件,且依赖 jquery.ztree.excheck 扩展 js )
function setNodesNoCheck(treeId, nodesList) {
    /// <summary>取消指定树的节点的选中状态(用于ztree插件,且依赖 jquery.ztree.excheck 扩展 js )</summary>
    /// <param name="nodesList" type="String">节点集合(例'1,2,3')</param>

    var treeObj = $.fn.zTree.getZTreeObj(treeId);
    var strArray = nodesList.split(',');
    var nodes = null;
    $.each(strArray, function (i, n) {
        nodes = treeObj.getNodeByParam("id", n, null);
        treeObj.checkNode(nodes, false, false, false);
    });
}

/**根据Status字段转换是否生成订单描述**/
/** int数字  **/
function IsProduceOrder(Status) {
    if (Status == 0) {
        return "未生成订单";
    } else if (Status == 1) {
        return "已生成订单";
    } 
}

/**********************************************结束**********************************************/


//JS操作cookies****************************************
//获取
function getCookie(name) {
    var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
    if (arr = document.cookie.match(reg))
        return unescape(arr[2]);
    else
        return null;
}


//写cookies
function setCookie(name, value) {
    var Days = 1;
    var exp = new Date();
    exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
    document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
}
//删除
function delCookie(name) {
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval = getCookie(name);
    if (cval != null)
        document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
}
//JS操作cookies****************************************

//仪器设备详情状态
function EquipStatusChange(type) {
    if (type == 0) {
        return "未借出";
    } else if (type == 1) {
        return "已借出";
    } else if (type == 2) {
        return "维修";
    } else if (type == 3) {
        return "停用";
    } else if (type == 4) {
        return "报废";
    } else {
        return "借用审核";
    }
}

//借用状态
function BorrowStatu(type) {
    if (type == 0) {
        return "审核中";
    } else if (type == 1) {
        return "待领用";
    } else if (type == 2) {
        return "借用中";
    } else if (type == 3) {
        return "已归还";
    } else  { // ==4
        return "未通过";
    } 
}

//报修状态
function RepairStatu(type) {
    if (type == 0) {
        return "已报修";
    } else if (type == 1) {
        return "已送修";
    } else if (type == 2) {
        return "已取回";
    } 
}

//订单状态
function OrderStatus(type) {
    if (type == 0) {
        return "未借出";
    } else if (type == 1) {
        return "部分借出";
    } else if (type == 2) {
        return "已借出";
    } else if (type == 3) {
        return "部分归还";
    } else if (type == 4) {
        return "完成";
    } else {
        return "";
    }
}
//序号
var pageNum = 1;
function pageIndex() {
    return pageNum++;
}

//列表名称长度修正
function NameLengthUpdate(Name, Length) {
    if (Name.length > Length) {
        return Name.substr(0, Length) + "...";
    }
    return Name;
}

//是否耗材
function IsConsumeToStr(type) {
    if (type == 0) {
        return "非耗材";
    } else if (type == 1) {
        return "耗材";
    }
    return "";
}

//设备类别
function EquipTypeToStr(type) {
    if (type == 0) {
        return "教学设备";
    } else if (type == 1) {
        return "科研设备";
    } else if (type == 2) {
        return "办公设备";
    }
        return "";
}

//设备来源
function EquipSourceToStr(type) {
    if (type == 0) {
        return "本院资产";
    } else if (type == 1) {
        return "资产系统";
    }
    return "";
}

function CalculateNumForSplit(strText) {
    if (typeof (strText) == "undefined" || strText.length == 0) {
        return 0;
    } else {
        var count = strText.split('|').length;
        return count;
    }
}

//获取当前时间
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    return currentdate;
}