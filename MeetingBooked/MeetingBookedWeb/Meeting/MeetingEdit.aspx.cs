using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MeetingBookedWeb.Meeting
{
    public partial class MeetingEdit : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hid_Userid.Value = id;
                hid_Id.Value = Request.QueryString["id"];
            }
        }
    }
}