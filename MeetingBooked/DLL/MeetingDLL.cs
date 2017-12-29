using SMSUtility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DLL
{
    public partial class MeetingDLL
    {

        /// <summary>
        /// 查询时间段和会议室
        /// </summary>
        /// <returns></returns>
        public DataSet GetList()
        {
            SqlParameter[] Para = new SqlParameter[]{
               
            };
            DataSet ds = SQLHelp.ExecuteDataSet("Proc_GetList", CommandType.StoredProcedure, Para);
            return ds;
        }

        ///// <summary>
        ///// 提交预约信息
        ///// </summary>
        ///// <param name="MeetingTitle"></param>
        ///// <param name="MeetingID"></param>
        ///// <param name="TimeSectionID"></param>
        ///// <param name="UserInfoID"></param>
        ///// <param name="BookedDate"></param>
        ///// <param name="Remark"></param>
        ///// <returns></returns>
        //public DataTable SetList(string MeetingTitle, string MeetingID, string TimeSectionID, string UserInfoID, string BookedDate, string Remark)
        //{
        //    SqlParameter[] Para = new SqlParameter[]{
        //      new SqlParameter("@MeetingTitle",MeetingTitle),
        //      new SqlParameter("@MeetingID",MeetingID),
        //      new SqlParameter("@TimeSectionID",TimeSectionID),
        //      new SqlParameter("@UserInfoID",UserInfoID),
        //      new SqlParameter("@BookedDate",BookedDate),
        //      new SqlParameter("@Remark",Remark)
        //    };
        //    DataTable dt = SQLHelp.ExecuteDataTable("Proc_SetList", CommandType.StoredProcedure, Para);
        //    return dt;
        //}



        /// <summary>
        /// 提交预约信息
        /// </summary>
        /// <param name="MeetingTitle"></param>
        /// <param name="MeetingID"></param>
        /// <param name="TimeSectionID"></param>
        /// <param name="UserInfoID"></param>
        /// <param name="BookedDate"></param>
        /// <param name="Remark"></param>
        /// <returns></returns>
        public string SetList(string MeetingTitle, string MeetingID, string TimeSectionID, string BookedDate, string Remark,string Name,string Phone)
        {


            DataTable dts = SQLHelp.ExecuteDataTable(" select (max(bs)+1) from MeetingBooked ", CommandType.Text, null);

            string obj = "OK";
            string[] str = TimeSectionID.Split(',');
            foreach (string i in str)
            {
                DataTable dt = SQLHelp.ExecuteDataTable(" exec Proc_SetList '" + MeetingTitle + "','" + MeetingID + "','" + i + "','" + BookedDate + "','" + Remark + "','" + Name + "','" + Phone + "','" + dts.Rows[0][0].ToString()+ "'", CommandType.StoredProcedure, null);
               if(dt.Rows[0][0].ToString()=="NO")
               {
                   obj = "NO";
               }
            }

            return obj;
          
        }




        /// <summary>
        /// 管理员查询预约信息
        /// </summary>
        /// <returns></returns>
        public DataTable GetSeeMeeting(string id,string Name,string Phone)
        {
            //SqlParameter[] Para = new SqlParameter[]{
            //  new SqlParameter("@id",id)
            //};
            //DataTable dt = SQLHelp.ExecuteDataTable("Proc_SeeMeeting", CommandType.StoredProcedure, Para);
            //return dt;

            DataTable dt = SQLHelp.ExecuteDataTable(" exec Proc_SeeMeeting '" + id + "','" + Name + "','" + Phone + "'", CommandType.StoredProcedure, null);
            return dt;

        }


        ///// <summary>
        ///// 用户查询个人预约信息
        ///// </summary>
        ///// <returns></returns>
        //public DataTable GetSeeMeetings(string id,string UserInfor)
        //{
        //    SqlParameter[] Para = new SqlParameter[]{
        //      new SqlParameter("@UserInfor",UserInfor),
        //       new SqlParameter("@id",id)
        //    };
        //    DataTable dt = SQLHelp.ExecuteDataTable("Proc_SeeMeetings", CommandType.StoredProcedure, Para);
        //    return dt;
        //}



        /// <summary>
        /// 用户查询个人预约信息
        /// </summary>
        /// <returns></returns>
        public DataTable GetSeeMeetings(string id,string Name,string Phone)
        {

            DataTable dt = SQLHelp.ExecuteDataTable("exec Proc_SeeMeetings '" + id + "','" + Name + "','" + Phone + "'", CommandType.StoredProcedure, null);
            return dt;
        }



        /// <summary>
        ///获取当前会议室是否被占用
        /// </summary>
        /// <returns></returns>
        public DataTable getMeetingBooked(string BookedDate, string MeetingID)
        {

            DataTable dt = SQLHelp.ExecuteDataTable("exec Proc_getMeetingBooked '" + BookedDate + "','" + MeetingID + "'", CommandType.StoredProcedure, null);
            return dt;
        }



        ///// <summary>
        ///// 审核预约信息
        ///// </summary>
        ///// <param name="id"></param>
        ///// <param name="status"></param>
        ///// <param name="BookedRemark"></param>
        ///// <returns></returns>
        //public DataTable UpMeetingBooked(string id, string status, string BookedRemark)
        //{
        //    SqlParameter[] Para = new SqlParameter[]{
        //      new SqlParameter("@id",id),
        //      new SqlParameter("@status",status),
        //      new SqlParameter("@BookedRemark",BookedRemark)
        //    };
        //    DataTable dt = SQLHelp.ExecuteDataTable("Proc_UpMeetingBooked", CommandType.StoredProcedure, Para);
        //    return dt;
        //}


        /// <summary>
        /// 审核预约信息
        /// </summary>
        /// <param name="id"></param>
        /// <param name="status"></param>
        /// <param name="BookedRemark"></param>
        /// <returns></returns>
        public DataTable UpMeetingBooked(string id, string status, string BookedRemark)
        {
            DataTable dt = SQLHelp.ExecuteDataTable("exec Proc_UpMeetingBooked '"+id+"','"+status+"','"+BookedRemark+"'", CommandType.StoredProcedure, null);
            return dt;
        }


       /// <summary>
       /// 取消预约
       /// </summary>
       /// <param name="id"></param>
       /// <returns></returns>
        public DataTable qxBooked(string id)
        {
            DataTable dt = SQLHelp.ExecuteDataTable("exec Proc_qxBooked '" + id + "'", CommandType.StoredProcedure, null);
            return dt;
        }

        ///// <summary>
        ///// 钉钉登陆判断账号所属
        ///// </summary>
        ///// <param name="Name"></param>
        ///// <param name="Phone"></param>
        ///// <returns></returns>
        //public DataTable getUserInfo(string Name, string Phone)
        //{
        //    SqlParameter[] Para = new SqlParameter[]{
        //      new SqlParameter("@UserName",Name.ToString()),
        //      new SqlParameter("@UserPhone",Phone.ToString())
        //    };
        //    DataTable dt = SQLHelp.ExecuteDataTable("Proc_getUserInfo", CommandType.StoredProcedure, Para);

        //    return dt;
        //}


        /// <summary>
        /// 钉钉登陆判断账号所属
        /// </summary>
        /// <param name="Name"></param>
        /// <param name="Phone"></param>
        /// <returns></returns>
        public DataTable getUserInfo(string Name, string Phone)
        {

            DataTable dt = SQLHelp.ExecuteDataTable(" select * from UserInfo where Name='" + Name + "' and Phone='" + Phone + "' ", CommandType.Text, null);

            return dt;
        }

        /// <summary>
        /// 新用户登陆时候自动注册账号
        /// </summary>
        /// <param name="name"></param>
        /// <param name="phone"></param>
        /// <returns></returns>
        public DataTable InUserLog(string name,string phone)
        {
            DataTable dt = SQLHelp.ExecuteDataTable("exec PROC_InUserLog '" + name + "','" + phone + "'", CommandType.StoredProcedure, null);
            return dt;
        }
    }
}
