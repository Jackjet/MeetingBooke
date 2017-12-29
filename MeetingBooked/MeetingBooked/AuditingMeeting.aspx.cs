using SMSUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MeetingBooked
{
    public partial class AuditingMeeting : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                try
                {
                    hid_id.Value = Request.QueryString["id"].ToString();
                }
                catch (Exception ex)
                {
                    LogHelper.Debug(ex.Message);
                    
                }
              
            
            }
        }
    }
}