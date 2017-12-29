using SMSUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MeetingBooked
{
    public partial class SureMeetingBooked : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                try
                {
                    hid_Meeting.Value = Request.QueryString["Meeting"].ToString();
                    hid_BookedDate.Value = Request.QueryString["BookedDates"].ToString();
                    hid_TimeSection.Value = Request.QueryString["TimeSection"].ToString();
                }
                catch (Exception ex)
                {
                    LogHelper.Debug(ex.Message);

                }
            }
        }
    }
}