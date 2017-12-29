//生成页码条方法（方法对象,页码条容器，当前页码，总页数，页码组容量，总行数）
function makePageBar(jsMethodName, pageContainer, pgIndex, pgCount, gpSize, roCount) {
    var groupFirstPageIndex = 0;  //当前页码组的第一个页码
    var groupCount = 0; //页码组个数
    //var pageContainer = document.getElementById("pageDiv");
    //获得当前页码组 的 第一个页码 ，为了 在点击 NextGroup 时
    //这样：1.加上 3 就可以获得 【下一个页码组】的 第一页
    //            2.减去1 就可以获得 【上一个页码组】的最后一页
    groupFirstPageIndex = (Math.floor(((pgIndex - 1) / gpSize)) * gpSize) + 1;
    //获得页码组总个数
    groupCount = Math.ceil(pgCount / gpSize);
    //生成统计数据
    //pageHolder.innerHTML = "页码：" + pgIndex + "/" + pgCount + " │ 共" + roCount + "条";
    var pagingInfo = " │" + pgIndex + "/" + pgCount + " 共" + roCount + "条";
    var pagingInfo1 = document.createElement("span");
    pagingInfo1.innerHTML = pagingInfo;
    pageContainer.innerHTML = '';
    //生成首页
    //创建li标签
    var homePage = document.createElement("a");
    homePage.href = "javascript:void(0)";
    homePage.onclick = function () {
        if (pgIndex == 1) {
            return false;
        }
        //pgIndex = 1;
        jsMethodName(1);
    }
    if (typeof (ChangePageCount) != "undefined" && ChangePageCount.length > 0) {
        
        var inputQueryPage = document.createElement("input");
        var inputHidLine = document.createElement("input");
        var btnQuery = document.createElement("input");
        inputHidLine.name = "hidPageSize";
        inputHidLine.id = "hidPageSize";
        inputQueryPage.style.width = "50px";
        inputQueryPage.style.height = "25px";
        btnQuery.style.width = "50px";
        btnQuery.style.height = "25px";
        btnQuery.type = "button";
        btnQuery.className = "Topic_btn";
        inputHidLine.type = "hidden";
        btnQuery.value = "GO";
        inputHidLine.value = "10";
        btnQuery.onclick = function () {
            var g = /^[1-9]*[1-9][0-9]*$/;
            var valPage = inputQueryPage.value;
            if (g.test(valPage)) {
                inputHidLine.value = valPage;
                jsMethodName(pgIndex);
            } else {
                inputQueryPage.value = "";
                return false;
            }
        }
        pageContainer.appendChild(inputQueryPage);
        pageContainer.appendChild(btnQuery);
        pageContainer.appendChild(inputHidLine);
    }
    homePage.innerHTML = "首页";
    pageContainer.appendChild(homePage);
    //生成 上一个页码组 按钮 
    var pagePrevGroup = document.createElement("a");
    if (groupFirstPageIndex > 1) {
        pagePrevGroup.onclick = function () {
            //pgIndex = groupFirstPageIndex - 1;
            jsMethodName(groupFirstPageIndex - 1);
        };
    }
    pagePrevGroup.innerHTML = "上一组";
    //pageContainer.appendChild(pagePrevGroup);

    //生成 上一页 按钮
    //var pagePrev_li = document.createElement("li");
    //pagePrev_li.setAttribute("class", "prev");
    var pagePrev = document.createElement("a");
    pagePrev.href = "javascript:void(0)";
    pagePrev.onclick = function () {
        if (pgIndex > 1) {
            //pgIndex--;
            //jsMethodName(pgIndex);
            jsMethodName(pgIndex-1);
        } else {
            //alert("已经是第一页咯~~！");
            return false;
        }
    };
    //pagePrev.innerHTML = "Prev";
    pagePrev.innerHTML = "上一页";
    //pagePrev.innerHTML = "<i class='fa fa-caret-left'></i>";
    //pagePrev_li.appendChild(pagePrev);
    //pagePrev.setAttribute("class", "previous paginate_button paginate_button_disabled");
    //pagePrev.setAttribute("tabindex", "0");
    //pageContainer.appendChild(pagePrev_li);

    pageContainer.appendChild(pagePrev);

    //按照 页码组容量 和当前页码组 来生成 页码
    var tempI = 0;
    tempI = groupFirstPageIndex;//此时获得的是当前页码组的第一页
    do {
        //页码按钮
        var pageA, pageA_li;
        if (tempI == pgIndex) {//如果 当前生成页码 和 当前访问的页码 相等，则生成 文本，而不是超链接
            //pageA = document.createTextNode(tempI);
            //var pageA = document.createElement("span");
            //var pageA_T = document.createElement("a");
            //pageA_T.href = "javascript:void(0)";
            //pageA_T.setAttribute("class", "paginate_active");
            //pageA_T.setAttribute("tabindex", "0");
            //pageA_T.innerHTML = tempI;
            //pageA.appendChild(pageA_T);
            //pageA_li = document.createElement("li");
            //pageA_li.setAttribute("class", "active");
            pageA = document.createElement("a");
            pageA.href = "javascript:void(0)";
            pageA.innerHTML = tempI;
            pageA.setAttribute("class", "now");
            //pageA_li.appendChild(pageA);
        } else {//否则 生成超链接页码按钮
            //pageA_li = document.createElement("li");
            pageA = document.createElement("a");
            //pageA.href = "javascript:jsMethodName(" + tempI + ");";
            pageA.href = "javascript:void(0)";
            pageA.setAttribute("pi", tempI);
            //pageA.setAttribute("class", "paginate_button");
            //pageA.setAttribute("tabindex", "0");
            pageA.onclick = function () { jsMethodName(this.getAttribute("pi")) };
            pageA.innerHTML = tempI;
            //pageA_li.appendChild(pageA);
        }
        //pageContainer.appendChild(pageA_li);
        pageContainer.appendChild(pageA);
        tempI++;
    } while (tempI < groupFirstPageIndex + gpSize && tempI <= pgCount);//1.不能超过当前页码组最后一个下标 2.不能超过总页数

    //生成下一页
    //var pageNext_li = document.createElement("li");
    //pageNext_li.setAttribute("class", "next");
    var pageNext = document.createElement("a");
    pageNext.href = "javascript:void(0)";
    pageNext.onclick = function () {
        //判断 当前页码 是否小于 总页数
        if (pgIndex < pgCount) {
            //pgIndex++;
            jsMethodName(pgIndex+1);
        } else {
            //alert("已经是最后一页咯~~！");
            return false;
        }
    };
    //pageNext.innerHTML = "Next";
    pageNext.innerHTML = "下一页";
    //pageNext.innerHTML = "<i class='fa fa-caret-right'></i>";
    //pageNext_li.appendChild(pageNext);
    //pageContainer.appendChild(pageNext_li);
    pageContainer.appendChild(pageNext);

    //生成 NextGroup
    var pageNextGroup = document.createElement("a");
    if (groupFirstPageIndex + gpSize <= pgCount) {
        pageNextGroup.onclick = function () {
            pgIndex = groupFirstPageIndex + gpSize;
            jsMethodName(groupFirstPageIndex + gpSize);
        };
    }
    //pageNextGroup.innerHTML = "NextGroup";
    pageNextGroup.innerHTML = "下一组";
    //pageContainer.appendChild(pageNextGroup);
    //生成尾页
    var endPage = document.createElement("a");
    endPage.href = "javascript:void(0)";
    endPage.onclick = function () {
        if (pgIndex == pgCount) {
            return false;
        }
        pgIndex = pgCount;
        jsMethodName(pgCount);
    };
    endPage.innerHTML = "尾页";
    //endPage_li.appendChild(endPage);
    pageContainer.appendChild(endPage);
    var sel = document.createElement("select");
    sel.id = "selectPageId";
    sel.onchange = function () {
        var pi = this.value;
        jsMethodName(pi);
    }
    for (var i = 0; i < pgCount; i++) {
        var opt = new Option("第" + (i + 1) + "页", i + 1);
        if (i == (pgIndex - 1))
            opt.selected = true;
        sel.options.add(opt);
    }
    //pageContainer.appendChild(sel);
    pageContainer.appendChild(pagingInfo1);



};