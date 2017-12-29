using MeetingBookedWeb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMS.Web
{
    public partial class Index : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            hid_RoleID.Value = RoleID;
            sp_LoginName.InnerHtml = Name;
        }
    }
}