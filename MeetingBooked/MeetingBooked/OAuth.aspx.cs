using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DDHelper.Business;
using DDHelper;
using DDHelper.Common;

/**
 * 
 * des：当前的页面主要的功能是利用oauth协议实现免登
 * 
 * author:dqk1985
 * 
 * date:2015-10-23
 * 
 * */
public partial class Enterprise_OAuth : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EnterPrise_PC.Setting_Redirect(this.Request, this.Session, this.Response, this.Server);
    }
}