using Bll;
using SMSUtility;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace Handler
{
    /// <summary>
    /// MeetingBookedWeb 的摘要说明
    /// </summary>
    public class MeetingBookedWeb : IHttpHandler
    {
        static JavaScriptSerializer jss = new JavaScriptSerializer();
        static Bll.jsonModel.JsonModel jsonModel = new Bll.jsonModel.JsonModel() { Status = "ok", Msg = "", BackUrl = "" };
        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "text/plain";

            //context.Response.ContentType = "application/json";
            //context.Response.ContentEncoding = System.Text.Encoding.UTF8;

            string action = context.Request["action"];
            if (!string.IsNullOrEmpty(action))
            {
                switch (action)
                {
                    case "Login": Login(context); break;
                    case "GetLeftNavigationMenu": GetLeftNavigationMenu(context); break;
                    case "EditPassword": EditPassword(context); break;
                    case "GetMeeting": GetMeeting(context); break;
                    case "SetMeeting": SetMeeting(context); break;
                    case "BindMeeting": BindMeeting(context); break;
                    case "InMeeting": InMeeting(context); break;
                    case "GetTimeSection": GetTimeSection(context); break;
                    case "SetTimeSection": SetTimeSection(context); break;
                    case "BindTimeSection": BindTimeSection(context); break;
                    case "InTimeSection": InTimeSection(context); break;
                    case "GetUserInfo": GetUserInfo(context); break;
                    case "SetUserInfoIsDelete": SetUserInfoIsDelete(context); break;
                    case "BindUserInfo": BindUserInfo(context); break;
                    case "InUserInfo": InUserInfo(context); break;
                    case "WhatBooked": WhatBooked(context); break;
                }
            }
        }


        /// <summary>
        /// 登陆
        /// </summary>
        /// <param name="context"></param>
        public void Login(HttpContext context)
        {
            string str = string.Empty;
            try
            {
                BLLCommon bll_com = new BLLCommon();

                string loginName = context.Request["loginName"];
                string passWord = bll_com.Md5Encrypting(context.Request["passWord"]);
                //序列化

                DataTable dt = new Bll.MeetingWebBll().Login(loginName, passWord);
                string result = "";
                if (dt != null && dt.Rows.Count > 0)
                {
                    if (string.IsNullOrWhiteSpace(Convert.ToString(dt.Rows[0]["RoleID"])) || Convert.ToString(dt.Rows[0]["RoleID"]) == "2")
                    {
                        str = "({\"result\":'" + result + "',\"msg\":\"noqx\"})";
                    }
                    else
                    {
                        result = dt.Rows[0]["id"].ToString() + "," + dt.Rows[0]["Name"].ToString() + "," + dt.Rows[0]["IDCard"].ToString() + "," + dt.Rows[0]["Phone"].ToString() + "," + dt.Rows[0]["RoleID"].ToString() + ","
                            + dt.Rows[0]["PassWord"].ToString() + "," + dt.Rows[0]["LoginName"].ToString();
                        str = "({\"result\":'" + result + "',\"msg\":\"ok\"})";
                    }
                }
                else
                {
                    str = "({\"result\":'" + result + "',\"msg\":\"null\"})";
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                str = "({\"result\":\"\",\"msg\":\"error\"})";
            }
            finally
            {
                context.Response.Write(str);
            }
            //输出Json

        }


        /// <summary>
        /// 绑定菜单
        /// </summary>
        /// <param name="context"></param>
        public void GetLeftNavigationMenu(HttpContext context)
        {
            StringBuilder orgJson = new StringBuilder();
            try
            {
                string Roleid = context.Request["Roleid"];
                //序列化

                DataTable dt = new Bll.MeetingWebBll().GetMenuInfo(Roleid);

                DataRow[] parMenu = dt.Select("Pid=0");
                for (int i = 0; i < parMenu.Count(); i++)
                {
                    orgJson.Append("<li>");
                    orgJson.Append("<a class='menuclick' href='#'><i class='" + parMenu[i]["iconClass"] + "'></i>" + parMenu[i]["Name"] + "<span class='iconfont icon-icoxiala'></span></a>");
                    DataRow[] subMenu = dt.Select(" Pid=" + parMenu[i]["Id"]);
                    orgJson.Append("<ul class='submenu' style='display:none;'>");
                    for (int j = 0; j < subMenu.Count(); j++)
                    {
                        orgJson.Append("<li><a href='javascript:void(0);' data-src='" + subMenu[j]["Url"] + "'>" + subMenu[j]["Name"] + "</a></li>");
                    }
                    orgJson.Append("</ul>");
                    orgJson.Append("</li>");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":\"" + orgJson.ToString() + "\"})");
            }
            //输出Json

        }


        /// <summary>
        /// 修改密码
        /// </summary>
        /// <param name="context"></param>
        public void EditPassword(HttpContext context)
        {
            string result = "";
            try
            {
                BLLCommon bll_com = new BLLCommon();

                string oldpwd = bll_com.Md5Encrypting(context.Request["oldpwd"]);
                string id = context.Request["id"];
                string pwd = bll_com.Md5Encrypting(context.Request["pwd"]);
                DataTable dt = new Bll.MeetingWebBll().EditPassword(id, oldpwd, pwd);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }

        }

        /// <summary>
        /// 查询会议室
        /// </summary>
        /// <param name="context"></param>
        public void GetMeeting(HttpContext context)
        {
            try
            {
                Hashtable ht = new Hashtable();
                if (!string.IsNullOrEmpty(context.Request["MeetingName"]))
                {
                    ht.Add("MeetingName", context.Request["MeetingName"].ToString());
                }
                ht.Add("PageIndex", context.Request["PageIndex"].ToString());
                ht.Add("PageSize", context.Request["PageSize"].ToString());
                jsonModel = new Bll.MeetingWebBll().GetMeeting(ht);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(jsonModel) + "})");
            }


        }


        /// <summary>
        /// 启用/禁用会议室
        /// </summary>
        /// <param name="context"></param>
        public void SetMeeting(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                string IsDelete = context.Request["IsDelete"];
                DataTable dt = new Bll.MeetingWebBll().SetMeeting(id, IsDelete);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }


        }


        /// <summary>
        /// 根据ID查询会议室
        /// </summary>
        /// <param name="context"></param>
        public void BindMeeting(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                DataTable dt = new Bll.MeetingWebBll().BindMeeting(id);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }

        }

        /// <summary>
        /// 修改或新增会议室
        /// </summary>
        /// <param name="context"></param>
        public void InMeeting(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                string MeetingName = context.Request["MeetingName"];
                string userid = context.Request["userid"];
                string Type = context.Request["Type"];
                DataTable dt = new Bll.MeetingWebBll().InMeeting(MeetingName, userid, id, Type);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }

        }



        /// <summary>
        /// 查询时间段
        /// </summary>
        /// <param name="context"></param>
        public void GetTimeSection(HttpContext context)
        {
            try
            {
                Hashtable ht = new Hashtable();
                if (!string.IsNullOrEmpty(context.Request["TimeSectionName"]))
                {
                    ht.Add("TimeSectionName", context.Request["TimeSectionName"].ToString());
                }
                ht.Add("PageIndex", context.Request["PageIndex"].ToString());
                ht.Add("PageSize", context.Request["PageSize"].ToString());
                jsonModel = new Bll.MeetingWebBll().GetTimeSection(ht);
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(jsonModel) + "})");
            }


        }



        /// <summary>
        /// 启用/禁用时间段
        /// </summary>
        /// <param name="context"></param>
        public void SetTimeSection(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                string IsDelete = context.Request["IsDelete"];
                DataTable dt = new Bll.MeetingWebBll().SetTimeSection(id, IsDelete);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }

        }



        /// <summary>
        /// 根据ID查询时间段
        /// </summary>
        /// <param name="context"></param>
        public void BindTimeSection(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                DataTable dt = new Bll.MeetingWebBll().BindTimeSection(id);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }

        }


        /// <summary>
        /// 修改或新增时间段
        /// </summary>
        /// <param name="context"></param>
        public void InTimeSection(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                string TimeSectionName = context.Request["TimeSectionName"];
                string userid = context.Request["userid"];
                string Type = context.Request["Type"];
                DataTable dt = new Bll.MeetingWebBll().InTimeSection(TimeSectionName, userid, id, Type);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }

        }


        /// <summary>
        ///  查询用户信息
        /// </summary>
        /// <param name="context"></param>
        public void GetUserInfo(HttpContext context)
        {
            try
            {
                Hashtable ht = new Hashtable();
                if (!string.IsNullOrEmpty(context.Request["LoginName"]))
                {
                    ht.Add("LoginName", context.Request["LoginName"].ToString());
                }
                if (!string.IsNullOrEmpty(context.Request["Name"]))
                {
                    ht.Add("Name", context.Request["Name"].ToString());
                }
                if (!string.IsNullOrEmpty(context.Request["Phone"]))
                {
                    ht.Add("Phone", context.Request["Phone"].ToString());
                }
                ht.Add("PageIndex", context.Request["PageIndex"].ToString());
                ht.Add("PageSize", context.Request["PageSize"].ToString());
                jsonModel = new Bll.MeetingWebBll().GetUserInfo(ht);
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(jsonModel) + "})");
            }


        }


        /// <summary>
        /// 启用/禁用账号
        /// </summary>
        /// <param name="context"></param>
        public void SetUserInfoIsDelete(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                string IsDelete = context.Request["IsDelete"];
                DataTable dt = new Bll.MeetingWebBll().SetUserInfoIsDelete(id, IsDelete);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }

        }


        /// <summary>
        /// 根据ID查询人员信息
        /// </summary>
        /// <param name="context"></param>
        public void BindUserInfo(HttpContext context)
        {
            try
            {
                string id = context.Request["id"];
                jsonModel = new Bll.MeetingWebBll().BindUserInfo(id);
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(jsonModel) + "})");
            }


        }


        /// <summary>
        /// 修改或新增人员信息
        /// </summary>
        /// <param name="context"></param>
        public void InUserInfo(HttpContext context)
        {
            string result = "";
            try
            {
                string id = context.Request["id"];
                string Name = context.Request["name"];
                string LoginName = context.Request["LoginName"];
                string Phone = context.Request["Phone"];
                string IDCard = context.Request["IDCard"];
                string RoleID = context.Request["RoleID"];
                string Type = context.Request["Type"];
                DataTable dt = new Bll.MeetingWebBll().InUserInfo(Name, IDCard, Phone, RoleID, LoginName, id, Type);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }


        }


        /// <summary>
        /// 设置/取消是否需要审核
        /// </summary>
        /// <param name="context"></param>
        public void WhatBooked(HttpContext context)
        {
            string result = "";
            try
            {
                string index = context.Request["index"];
                DataTable dt = new Bll.MeetingWebBll().WhatBooked(index);

                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        result = dt.Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
            }
            finally
            {
                context.Response.Write("({\"result\":" + jss.Serialize(result) + "})");
            }


        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}