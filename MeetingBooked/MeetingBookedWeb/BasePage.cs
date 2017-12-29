using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MeetingBookedWeb
{
    public class BasePage : System.Web.UI.Page
    {
        #region  // 当前登陆用户信息

        public string id { get; set; }


        /// <summary>
        /// 姓名
        /// </summary>
        public string Name { get; set; }
       
        /// <summary>
        /// 用户身份证号
        /// </summary>
        public string IDCard { get; set; }
       
        /// <summary>
        /// 手机号码,以'㊣'连接
        /// </summary>
        public string Phone { get; set; }
        /// <summary>
        /// 角色,以'㊣'连接
        /// </summary>
        public string RoleID { get; set; }
        /// <summary>
        /// 密码,以'㊣'连接
        /// </summary>
        public string PassWord { get; set; }
        /// <summary>
        /// 账号
        /// </summary>
        public string LoginName { get; set; }
        #endregion

        #region  // 验证用户是否登录
        protected override void OnInit(EventArgs e)
        {
            string loginCookie = "";
            //登陆页地址 从Web.config 读取
            string LoginPage = System.Configuration.ConfigurationManager.ConnectionStrings["LoginPage"].ConnectionString;
            string action = Request["action"];
            if (!string.IsNullOrEmpty(action) && action == "loginOut")   //退出登录
            {
                //Session.Clear();
                //Session.Abandon();
                Response.Cookies["LoginCookie"].Expires = DateTime.Now.AddDays(-3);
                //跳转登陆页面
                Response.Redirect(LoginPage);
                //Response.Redirect("/Login.aspx");
            }
            else
            {
                if (Request.Cookies["LoginCookie"] != null)
                {
                    loginCookie = System.Web.HttpUtility.UrlDecode(Request.Cookies["LoginCookie"].Value);
                    string[] userArray = loginCookie.Split(',');
                    id = userArray[0].ToString();
                    Name = userArray[1].ToString();
                    IDCard = userArray[2].ToString();
                    Phone = userArray[3].ToString();
                    RoleID = userArray[4].ToString();
                    PassWord = userArray[5].ToString();
                    LoginName = userArray[6].ToString();

                    ////判断此账号是不是管理员
                    //string AdminRoleID = System.Configuration.ConfigurationManager.ConnectionStrings["AdminRoleID"].ConnectionString;
                    //string[] roles = UserRoleId.Split('㊣');
                    //if (Array.IndexOf(roles, AdminRoleID) != -1)
                    //{
                    //    IsAdmin = "true";
                    //}
                    //else
                    //{
                    //    IsAdmin = "false";
                    //}
                }
                else
                {
                    //跳转登陆页面
                    Response.Redirect(LoginPage);
                }
                #region 注释的代码
                //string Url = "http://localhost:11027/Login.aspx";
                //HttpWebRequest req = (HttpWebRequest)WebRequest.Create(Url);
                //req.CookieContainer = new CookieContainer();
                //HttpWebResponse response = (HttpWebResponse)req.GetResponse();
                //string cookie = response.Headers["set-cookie"];
                //if (response.Cookies["LoginCookie"] != null)
                //{
                //    loginCookie = Request.Cookies["LoginCookie"].Value;
                //    string[] userArray = loginCookie.Split(',');
                //    UserLgoinName = userArray[1].ToString();
                //    UserName = userArray[2].ToString();
                //}


                ////开发 跳过登陆操作 模拟管理员已经登陆了
                //UserLgoinName = "admin";
                //UserName = "管理员";
                //UserRole = "管理员";

                ////获取登陆状态
                //if (Session["UserLgoinName"] != null)
                //{
                //    UserLgoinName = Session["UserLgoinName"].ToString();
                //}
                //if (UserLgoinName == null)
                //{//无登陆名
                //    //跳转登陆页面
                //    Response.Redirect(LoginPage);
                //}
                //else
                //{
                //    UserName = Session["UserName"].ToString();
                //    UserRole = Session["UserRole"].ToString();
                //}
                #endregion
            }
            base.OnInit(e);
        }

        #endregion
    }
}