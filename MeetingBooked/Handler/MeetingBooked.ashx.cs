using Model;
using SMSUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace Handler
{
    /// <summary>
    /// MeetingBooked 的摘要说明
    /// </summary>
    public class MeetingBooked : IHttpHandler
    {
        static JavaScriptSerializer jss = new JavaScriptSerializer();

        static JsonModel jsonModel = new JsonModel() { Status = "ok", Msg = "", BackUrl = "" };
        public void ProcessRequest(HttpContext context)
        {
            string action = context.Request["action"];
            if (!string.IsNullOrEmpty(action))
            {
                switch (action)
                {
                    case "getList": getList(context); break;
                    case "SetList": SetList(context); break;
                    case "GetSeeMeeting": GetSeeMeeting(context); break;
                    case "UpMeetingBooked": UpMeetingBooked(context); break;
                    case "getUserInfo": getUserInfo(context); break;
                    case "GetSeeMeetings": GetSeeMeetings(context); break;
                    case "getMeetingBooked": getMeetingBooked(context); break;
                    case "qxBooked": qxBooked(context); break;
                    case "InUserLog": InUserLog(context); break;
                }
            }
        }


        /// <summary>
        /// 查询会议室和时间段数据用于绑定
        /// </summary>
        /// <param name="context"></param>
        public void getList(HttpContext context)
        {
            try
            {
                DataSet ds = new Bll.MeetingBll().GetList();

                //获取近3天的日期
                DataTable dt = new DataTable();
                dt.Columns.Add("datetime");
                dt.Columns.Add("date");

                int obj = Convert.ToInt32(DateTime.Now.Day.ToString());
                DataRow dr = dt.NewRow();
                for (int i = 0; i < 6; i++)
                {
                    dr = dt.NewRow();
                    dr["datetime"] = DateTime.Now.AddDays(i).ToString("yyyy-MM-dd");
                    dr["date"] = GetWeek(DateTime.Now.AddDays(i).DayOfWeek.ToString()) + "(" + DateTime.Now.AddDays(i).Month.ToString() + "月" + DateTime.Now.AddDays(i).Day.ToString() + "日)";
                    dt.Rows.Add(dr);
                }
                ds.Tables.Add(dt);

                string MeetingList = DataTableToJson(ds.Tables[0]);
                string TimeSectionList = DataTableToJson(ds.Tables[1]);
                string date = DataTableToJson(ds.Tables[2]);
                List<string> list = new List<string>();
                list.Add(MeetingList);
                list.Add(TimeSectionList);
                list.Add(date);

                jsonModel.Data = list;
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.errNum = 3;
                jsonModel.Msg = "接口异常";
                jsonModel.Status = "No";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(jsonModel) + "}");
            }
        }

        /// <summary>
        /// 提交会议预定申请
        /// </summary>
        /// <param name="context"></param>
        public void SetList(HttpContext context)
        {
            string str = string.Empty;
            try
            {
                string MeetingTitle = context.Request["MeetingTitle"].ToString();
                string MeetingID = context.Request["MeetingID"].ToString(); ;
                string TimeSectionID = context.Request["TimeSectionID"].ToString();
                string Name = context.Request["Name"].ToString();
                string Phone = context.Request["Phone"].ToString();
                string BookedDate = context.Request["BookedDate"].ToString();
                string Remark = context.Request["Remark"].ToString();
                str = new Bll.MeetingBll().setList(MeetingTitle, MeetingID, TimeSectionID, BookedDate, Remark, Name, Phone);
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.Msg = ex.Message;
                jsonModel.errNum = -1;
                jsonModel.Data = null;
                jsonModel.Status = "error";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(str) + "}");
            }

        }


        /// <summary>
        /// 管理员获取预约信息
        /// </summary>
        /// <param name="context"></param>
        public void GetSeeMeeting(HttpContext context)
        {
            try
            {
                string id = context.Request["id"].ToString();
                string Name = context.Request["Name"].ToString();
                string Phone = context.Request["Phone"].ToString();
                jsonModel = new Bll.MeetingBll().GetSeeMeeting(id, Name, Phone);
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.Msg = ex.Message;
                jsonModel.errNum = -1;
                jsonModel.Data = null;
                jsonModel.Status = "error";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(jsonModel) + "}");
            }
        }


        /// <summary>
        /// 普通用户获取信息
        /// </summary>
        /// <param name="context"></param>
        public void GetSeeMeetings(HttpContext context)
        {
            try
            {
                string id = context.Request["id"].ToString();
                string Name = context.Request["Name"].ToString();
                string Phone = context.Request["Phone"].ToString();
                DataTable dt = new Bll.MeetingBll().GetSeeMeetings(id, Name, Phone);
                string str = DataTableToJson(dt);
                List<string> list = new List<string>();
                list.Add(str);
                jsonModel.Data = list;
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.Msg = ex.Message;
                jsonModel.errNum = -1;
                jsonModel.Data = null;
                jsonModel.Status = "error";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(jsonModel) + "}");
            }
        }


        /// <summary>
        /// 获取当前会议室是否被占用
        /// </summary>
        /// <param name="context"></param>
        public void getMeetingBooked(HttpContext context)
        {
            try
            {

                string BookedDate = context.Request["BookedDate"].ToString();
                string MeetingID = context.Request["MeetingID"].ToString();
                DataTable dt = new Bll.MeetingBll().getMeetingBooked(BookedDate, MeetingID);
                string str = DataTableToJson(dt);
                List<string> list = new List<string>();
                list.Add(str);
                jsonModel.Data = list;
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.Msg = ex.Message;
                jsonModel.errNum = -1;
                jsonModel.Data = null;
                jsonModel.Status = "error";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(jsonModel) + "}");
            }
        }



        /// <summary>
        /// 审核预约信息
        /// </summary>
        /// <param name="context"></param>
        public void UpMeetingBooked(HttpContext context)
        {
            string str = string.Empty;
            try
            {

                string id = context.Request["id"].ToString();
                string status = context.Request["status"].ToString() == "2" ? "1" : context.Request["status"].ToString();
                string BookedRemark = context.Request["BookedRemark"].ToString();
                DataTable dt = new Bll.MeetingBll().UpMeetingBooked(id, status, BookedRemark);
                str = dt.Rows[0][0].ToString();
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.Msg = ex.Message;
                jsonModel.errNum = -1;
                jsonModel.Data = null;
                jsonModel.Status = "error";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(str) + "}");
            }
        }


        /// <summary>
        /// 取消预约
        /// </summary>
        /// <param name="context"></param>
        public void qxBooked(HttpContext context)
        {
            string str = string.Empty;
            try
            {
                string id = context.Request["id"].ToString();
                DataTable dt = new Bll.MeetingBll().qxBooked(id);
                str = dt.Rows[0][0].ToString();
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.errNum = 3;
                jsonModel.Msg = "接口异常";
                jsonModel.Status = "No";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(str) + "}");
            }
        }


        /// <summary>
        /// 钉钉登陆判断账号所属
        /// </summary>
        /// <param name="context"></param>
        public void getUserInfo(HttpContext context)
        {
            string str = string.Empty;
            try
            {
                string Name = context.Request["Name"].ToString();
                string Phone = context.Request["Phone"].ToString();
                DataTable dt = new Bll.MeetingBll().getUserInfo(Name, Phone);
                if (dt == null)
                {
                    str = "NO";
                }
                else
                {
                    if (dt.Rows.Count > 0)
                    {
                        str = "OK";
                    }
                    else
                    {
                        str = "NO";

                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.errNum = 3;
                jsonModel.Msg = "接口异常";
                jsonModel.Status = "No";
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(str) + "}");
            }
        }

        /// <summary>
        /// 新用户登陆时候自动注册账号
        /// </summary>
        /// <param name="context"></param>
        public void InUserLog(HttpContext context)
        {
              string str = string.Empty;
            try
            {

                string Name = context.Request["Name"].ToString();
                string Phone = context.Request["Phone"].ToString();
                DataTable dt = new Bll.MeetingBll().InUserLog(Name, Phone);
                str = dt.Rows[0][0].ToString();
  }
            catch (Exception ex)
            {
                LogHelper.Debug(ex.Message);
                jsonModel.errNum = 3;
                jsonModel.Msg = "接口异常";
                jsonModel.Status = "No";            
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + jss.Serialize(jsonModel) + "}");
            }
        }

        public string DataTableToJson(DataTable dt)
        {
            if (dt == null) return string.Empty;
            StringBuilder sb = new StringBuilder();
            sb.Append("{\"");
            sb.Append(dt.TableName);
            sb.Append("\":[");
            foreach (DataRow r in dt.Rows)
            {
                sb.Append("{");
                foreach (DataColumn c in dt.Columns)
                {
                    sb.Append("\"");
                    sb.Append(c.ColumnName);
                    sb.Append("\":\"");
                    sb.Append(r[c].ToString());
                    sb.Append("\",");
                }
                sb.Remove(sb.Length - 1, 1);
                sb.Append("},");
            }
            sb.Remove(sb.Length - 1, 1);
            sb.Append("]}");
            return sb.ToString();
        }

        public string GetWeek(string dt)
        {
            string week = "";
            switch (dt)
            {
                case "Monday":
                    week = "周一";
                    break;
                case "Tuesday":
                    week = "周二";
                    break;
                case "Wednesday":
                    week = "周三";
                    break;
                case "Thursday":
                    week = "周四";
                    break;
                case "Friday":
                    week = "周五";
                    break;
                case "Saturday":
                    week = "周六";
                    break;
                case "Sunday":
                    week = "周日";
                    break;
            }
            return week;
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