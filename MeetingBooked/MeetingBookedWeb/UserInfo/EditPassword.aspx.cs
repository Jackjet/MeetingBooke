using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MeetingBookedWeb.UserInfo
{
    public partial class EditPassword : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            hid_id.Value = id;
        }
    }
}