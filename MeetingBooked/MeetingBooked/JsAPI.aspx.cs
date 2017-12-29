using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using DDHelper.Business;
using DDHelper;
using DDHelper.Common;
using System.Collections;

/**
 * 
 * des：当前的页面主要的功能是利用jsapi实现免登
 * 
 * author:dqk1985
 * 
 * date:2015-10-23
 * 
 * */
public partial class Enterprise_JsAPI : System.Web.UI.Page
{

    public EnterPrise_MB signPackage = new EnterPrise_MB();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        signPackage.GetConfig(Request);
    }

}