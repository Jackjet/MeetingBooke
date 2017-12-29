using SMSUtility;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DLL
{
    public partial class MeetingWebDll : DALHelper
    {
        /// <summary>
        /// 登陆验证
        /// </summary>
        /// <param name="LoginName"></param>
        /// <param name="PassWord"></param>
        /// <returns></returns>
        public DataTable Login(string LoginName, string PassWord)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@LoginName",LoginName),
              new SqlParameter("@PassWord",PassWord)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_GetLogin", Para);
            return dt;

        }


        /// <summary>
        /// 获取功能菜单
        /// </summary>
        /// <param name="RoleId"></param>
        /// <returns></returns>
        public DataTable GetMenuInfo(string RoleId)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@RoleId",RoleId)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_GetMenuInfo", Para);
            return dt;
        }

        /// <summary>
        /// 修改密码
        /// </summary>
        /// <param name="id"></param>
        /// <param name="oldpwd"></param>
        /// <param name="pwd"></param>
        /// <returns></returns>
        public DataTable EditPassword(string id, string oldpwd, string pwd)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@id",id),
              new SqlParameter("@oldpwd",oldpwd),
              new SqlParameter("@pwd",pwd)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_SetUserInfo", Para);
            return dt;
        }


        /// <summary>
        /// 根据会议室名称，模糊查询会议室信息
        /// </summary>
        /// <param name="MeetingName"></param>
        /// <returns></returns>
        public DataTable GetMeeting(Hashtable ht)
        {
            //SqlParameter[] Para = new SqlParameter[]{
            //  new SqlParameter("@MeetingName",MeetingName)
            //};
            //DataTable dt = SQLHelp.ExexProcQuery("Proc_GetMeeting", Para);
            //return dt;
            StringBuilder sbSql4org;
            sbSql4org = new StringBuilder();
            sbSql4org.Append(@"  select a.id,MeetingName,CreateTime,b.Name as CreatorName,(case a.IsDelete when 0 then '正常' else '禁用' end ) as IsDeleteName,a.IsDelete,a.WhatBooked  from Meeting a left join UserInfo b on a.Creator=b.id where 1=1 ");

            List<DbParameter> List = new List<DbParameter>();
            if (ht.ContainsKey("MeetingName") && !string.IsNullOrWhiteSpace(ht["MeetingName"].ToString()))
            {
                sbSql4org.Append(" and MeetingName like N'%'+@MeetingName+'%' ");
                List.Add(dbHelper.CreateInDbParameter("@MeetingName", DbType.String, ht["MeetingName"].ToString()));
            }



            DataSet ds = base.GetListByPage("(" + sbSql4org.ToString() + ")", "", "", Convert.ToInt32(ht["StartIndex"].ToString()), Convert.ToInt32(ht["EndIndex"].ToString()), List.ToArray());
            int RowCount = base.GetRecordCount("(" + sbSql4org.ToString() + ") T", "", List.ToArray());
            ht.Add("RowCount", RowCount);
            return ds.Tables[0];
        }



        /// <summary>
        /// 禁用或启用会议室
        /// </summary>
        /// <param name="id"></param>
        /// <param name="IsDelete"></param>
        /// <returns></returns>
        public DataTable SetMeeting(string id, string IsDelete)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@id",id),
              new SqlParameter("@IsDelete",IsDelete)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_SetMeeting", Para);
            return dt;
        }


        /// <summary>
        /// 根据ID查询会议室
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public DataTable BindMeeting(string id)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@id",id)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_BindMeeting", Para);
            return dt;
        }


        /// <summary>
        /// 修改或新增会议室
        /// </summary>
        /// <param name="MeetingName"></param>
        /// <param name="userid"></param>
        /// <param name="id"></param>
        /// <param name="Type">修改还是新增</param>
        /// <returns></returns>
        public DataTable InMeeting(string MeetingName, string userid, string id, string Type)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@MeetingName",MeetingName),
              new SqlParameter("@userid",userid),
              new SqlParameter("@id",id),
              new SqlParameter("@Type",Type)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_InMeeting", Para);
            return dt;
        }




        /// <summary>
        /// 根据起止时间，查询时间段
        /// </summary>
        /// <param name="GetTimeSection"></param>
        /// <returns></returns>
        public DataTable GetTimeSection(Hashtable ht)
        {
            StringBuilder sbSql4org;
            sbSql4org = new StringBuilder();
            sbSql4org.Append(@"  select a.id,TimeSectionName,CreateTime,b.Name as CreatorName ,(case a.IsDelete when 0 then '正常' else '禁用' end ) as IsDeleteName,a.IsDelete  from TimeSection a left join UserInfo b on a.Creator=b.id where 1=1 ");

            List<DbParameter> List = new List<DbParameter>();
            if (ht.ContainsKey("TimeSectionName") && !string.IsNullOrWhiteSpace(ht["TimeSectionName"].ToString()))
            {
                sbSql4org.Append(" and TimeSectionName like N'%'+@TimeSectionName+'%' ");
                List.Add(dbHelper.CreateInDbParameter("@TimeSectionName", DbType.String, ht["TimeSectionName"].ToString()));
            }
            DataSet ds = base.GetListByPage("(" + sbSql4org.ToString() + ")", "", "", Convert.ToInt32(ht["StartIndex"].ToString()), Convert.ToInt32(ht["EndIndex"].ToString()), List.ToArray());
            int RowCount = base.GetRecordCount("(" + sbSql4org.ToString() + ") T", "", List.ToArray());
            ht.Add("RowCount", RowCount);
            return ds.Tables[0];
        }


        /// <summary>
        /// 禁用或启用会议室
        /// </summary>
        /// <param name="id"></param>
        /// <param name="IsDelete"></param>
        /// <returns></returns>
        public DataTable SetTimeSection(string id, string IsDelete)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@id",id),
              new SqlParameter("@IsDelete",IsDelete)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_SetTimeSection", Para);
            return dt;
        }


        /// <summary>
        /// 根据ID查询时间段
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public DataTable BindTimeSection(string id)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@id",id)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_BindTimeSection", Para);
            return dt;
        }


        /// <summary>
        /// 修改或新增时间段
        /// </summary>
        /// <param name="TimeSectionName"></param>
        /// <param name="userid"></param>
        /// <param name="id"></param>
        /// <param name="Type">修改还是新增</param>
        /// <returns></returns>
        public DataTable InTimeSection(string TimeSectionName, string userid, string id, string Type)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@TimeSectionName",TimeSectionName),
              new SqlParameter("@userid",userid),
              new SqlParameter("@id",id),
              new SqlParameter("@Type",Type)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_InTimeSection", Para);
            return dt;
        }




        /// <summary>
        /// 查询用户信息
        /// </summary>
        /// <param name="GetTimeSection"></param>
        /// <returns></returns>
        public DataTable GetUserInfo(Hashtable ht)
        {
            StringBuilder sbSql4org;
            sbSql4org = new StringBuilder();
            sbSql4org.Append(@"select a.id,a.Name,a.IDCard,a.Phone,a.LoginName,(case a.IsDelete when 0 then '正常' else '禁用' end ) as IsDeleteName,a.IsDelete,b.RoleName from UserInfo a left join Role b on a.RoleID=b.id where 1=1 ");

            List<DbParameter> List = new List<DbParameter>();
            if (ht.ContainsKey("Name") && !string.IsNullOrWhiteSpace(ht["Name"].ToString()))
            {
                sbSql4org.Append(" and Name like N'%'+@Name+'%' ");
                List.Add(dbHelper.CreateInDbParameter("@Name", DbType.String, ht["Name"].ToString()));
            }

            if (ht.ContainsKey("LoginName") && !string.IsNullOrWhiteSpace(ht["LoginName"].ToString()))
            {
                sbSql4org.Append(" and LoginName like N'%'+@LoginName+'%' ");
                List.Add(dbHelper.CreateInDbParameter("@LoginName", DbType.String, ht["LoginName"].ToString()));
            }

            if (ht.ContainsKey("Phone") && !string.IsNullOrWhiteSpace(ht["Phone"].ToString()))
            {
                sbSql4org.Append(" and Phone like N'%'+@Phone+'%' ");
                List.Add(dbHelper.CreateInDbParameter("@Phone", DbType.String, ht["Phone"].ToString()));
            }
            DataSet ds = base.GetListByPage("(" + sbSql4org.ToString() + ")", "", "", Convert.ToInt32(ht["StartIndex"].ToString()), Convert.ToInt32(ht["EndIndex"].ToString()), List.ToArray());
            int RowCount = base.GetRecordCount("(" + sbSql4org.ToString() + ") T", "", List.ToArray());
            ht.Add("RowCount", RowCount);
            return ds.Tables[0];
        }


        /// <summary>
        /// 启用禁用账号
        /// </summary>
        /// <param name="id"></param>
        /// <param name="IsDelete"></param>
        /// <returns></returns>
        public DataTable SetUserInfoIsDelete(string id, string IsDelete)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@id",id),
              new SqlParameter("@IsDelete",IsDelete)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_SetUserInfoIsDelete", Para);
            return dt;
        }


        /// <summary>
        /// 根据ID查询人员信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public DataTable BindUserInfo(string id)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@id",id)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_BindUserInfo", Para);
            return dt;
        }



        /// <summary>
        /// 修改或删除人员信息
        /// </summary>
        /// <param name="Name"></param>
        /// <param name="IDCard"></param>
        /// <param name="Phone"></param>
        /// <param name="RoleID"></param>
        /// <param name="LoginName"></param>
        /// <param name="id"></param>
        /// <param name="Type"></param>
        /// <returns></returns>
        public DataTable InUserInfo(string Name, string IDCard, string Phone, string RoleID, string LoginName, string id, string Type)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@Name",Name),
              new SqlParameter("@IDCard",IDCard),
              new SqlParameter("@Phone",Phone),
              new SqlParameter("@RoleID",RoleID),
              new SqlParameter("@LoginName",LoginName),
              new SqlParameter("@id",id),
              new SqlParameter("@Type",Type)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_InUserInfo", Para);
            return dt;
        }


        /// <summary>
        /// 设置/取消是否需要审核
        /// </summary>
        /// <param name="id"></param>
        /// <param name="IsDelete"></param>
        /// <returns></returns>
        public DataTable WhatBooked(string index)
        {
            SqlParameter[] Para = new SqlParameter[]{
              new SqlParameter("@index",index)
            };
            DataTable dt = SQLHelp.ExexProcQuery("Proc_WhatBooked", Para);
            return dt;
        }
    }
}
