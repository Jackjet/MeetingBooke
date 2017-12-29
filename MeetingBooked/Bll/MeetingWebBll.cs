using Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bll
{
    public partial class MeetingWebBll
    {
        BLLCommon common = new BLLCommon();
        public DataTable Login(string LoginName, string PassWord)
        {
            DataTable dt = new DLL.MeetingWebDll().Login(LoginName, PassWord);
            //jsonModel js = new jsonModel();
            return dt;

        }

        public DataTable GetMenuInfo(string RoleId)
        {
            return new DLL.MeetingWebDll().GetMenuInfo(RoleId);
        }


        public DataTable EditPassword(string id, string oldpwd, string pwd)
        {
            return new DLL.MeetingWebDll().EditPassword(id, oldpwd, pwd);
        }


        public Bll.jsonModel.JsonModel GetMeeting(Hashtable ht)
        {
            try
            {
                //增加起始条数、结束条数
                ht = common.AddStartEndIndex(ht);
                int PageIndex = Convert.ToInt32(ht["PageIndex"]);
                int PageSize = Convert.ToInt32(ht["PageSize"]);

                DataTable dt = new DLL.MeetingWebDll().GetMeeting(ht);
                //定义分页数据实体
                PagedDataModel<Dictionary<string, object>> pagedDataModel = null;
                //定义JSON标准格式实体中
                Bll.jsonModel.JsonModel jsonModel = null;
                if (dt.Rows.Count <= 0)
                {
                    jsonModel = new Bll.jsonModel.JsonModel()
                    {
                        Status = "no",
                        Msg = "无数据"
                    };
                    return jsonModel;
                }
                List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();
                list = common.DataTableToList(dt);
                //总条数
                int RowCount = Convert.ToInt32(ht["RowCount"].ToString());
                //总页数
                int PageCount = (int)Math.Ceiling(RowCount * 1.0 / PageSize);
                //将数据封装到PagedDataModel分页数据实体中
                pagedDataModel = new PagedDataModel<Dictionary<string, object>>()
                {
                    PageCount = PageCount,
                    PagedData = list,
                    PageIndex = PageIndex,
                    PageSize = PageSize,
                    RowCount = RowCount
                };
                //将分页数据实体封装到JSON标准实体中
                jsonModel = new Bll.jsonModel.JsonModel()
                {
                    Data = pagedDataModel,
                    Msg = "",
                    Status = "ok",
                    BackUrl = ""
                };
                return jsonModel;
            }
            catch (Exception ex)
            {
                Bll.jsonModel.JsonModel jsonModel = new Bll.jsonModel.JsonModel();
                jsonModel.Status = "error";
                jsonModel.Msg = ex.ToString();
                return jsonModel;
            }
        }

        public DataTable SetMeeting(string id, string IsDelete)
        {
            return new DLL.MeetingWebDll().SetMeeting(id, IsDelete);
        }

        public DataTable BindMeeting(string id)
        {
            return new DLL.MeetingWebDll().BindMeeting(id);
        }

        public DataTable InMeeting(string MeetingName, string userid, string id, string Type)
        {
            return new DLL.MeetingWebDll().InMeeting(MeetingName, userid, id, Type);
        }



        public Bll.jsonModel.JsonModel GetTimeSection(Hashtable ht)
        {
            try
            {
                //增加起始条数、结束条数
                ht = common.AddStartEndIndex(ht);
                int PageIndex = Convert.ToInt32(ht["PageIndex"]);
                int PageSize = Convert.ToInt32(ht["PageSize"]);

                DataTable dt = new DLL.MeetingWebDll().GetTimeSection(ht);
                //定义分页数据实体
                PagedDataModel<Dictionary<string, object>> pagedDataModel = null;
                //定义JSON标准格式实体中
                Bll.jsonModel.JsonModel jsonModel = null;
                if (dt.Rows.Count <= 0)
                {
                    jsonModel = new Bll.jsonModel.JsonModel()
                    {
                        Status = "no",
                        Msg = "无数据"
                    };
                    return jsonModel;
                }
                List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();
                list = common.DataTableToList(dt);
                //总条数
                int RowCount = Convert.ToInt32(ht["RowCount"].ToString());
                //总页数
                int PageCount = (int)Math.Ceiling(RowCount * 1.0 / PageSize);
                //将数据封装到PagedDataModel分页数据实体中
                pagedDataModel = new PagedDataModel<Dictionary<string, object>>()
                {
                    PageCount = PageCount,
                    PagedData = list,
                    PageIndex = PageIndex,
                    PageSize = PageSize,
                    RowCount = RowCount
                };
                //将分页数据实体封装到JSON标准实体中
                jsonModel = new Bll.jsonModel.JsonModel()
                {
                    Data = pagedDataModel,
                    Msg = "",
                    Status = "ok",
                    BackUrl = ""
                };
                return jsonModel;
            }
            catch (Exception ex)
            {
                Bll.jsonModel.JsonModel jsonModel = new Bll.jsonModel.JsonModel();
                jsonModel.Status = "error";
                jsonModel.Msg = ex.ToString();
                return jsonModel;
            }
        }


        public DataTable SetTimeSection(string id, string IsDelete)
        {
            return new DLL.MeetingWebDll().SetTimeSection(id, IsDelete);
        }

        public DataTable BindTimeSection(string id)
        {
            return new DLL.MeetingWebDll().BindTimeSection(id);
        }

        public DataTable InTimeSection(string TimeSectionName, string userid, string id, string Type)
        {
            return new DLL.MeetingWebDll().InTimeSection(TimeSectionName, userid, id, Type);
        }



        public Bll.jsonModel.JsonModel GetUserInfo(Hashtable ht)
        {
            try
            {
                //增加起始条数、结束条数
                ht = common.AddStartEndIndex(ht);
                int PageIndex = Convert.ToInt32(ht["PageIndex"]);
                int PageSize = Convert.ToInt32(ht["PageSize"]);

                DataTable dt = new DLL.MeetingWebDll().GetUserInfo(ht);
                //定义分页数据实体
                PagedDataModel<Dictionary<string, object>> pagedDataModel = null;
                //定义JSON标准格式实体中
                Bll.jsonModel.JsonModel jsonModel = null;
                if (dt.Rows.Count <= 0)
                {
                    jsonModel = new Bll.jsonModel.JsonModel()
                    {
                        Status = "no",
                        Msg = "无数据"
                    };
                    return jsonModel;
                }
                List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();
                list = common.DataTableToList(dt);
                //总条数
                int RowCount = Convert.ToInt32(ht["RowCount"].ToString());
                //总页数
                int PageCount = (int)Math.Ceiling(RowCount * 1.0 / PageSize);
                //将数据封装到PagedDataModel分页数据实体中
                pagedDataModel = new PagedDataModel<Dictionary<string, object>>()
                {
                    PageCount = PageCount,
                    PagedData = list,
                    PageIndex = PageIndex,
                    PageSize = PageSize,
                    RowCount = RowCount
                };
                //将分页数据实体封装到JSON标准实体中
                jsonModel = new Bll.jsonModel.JsonModel()
                {
                    Data = pagedDataModel,
                    Msg = "",
                    Status = "ok",
                    BackUrl = ""
                };
                return jsonModel;
            }
            catch (Exception ex)
            {
                Bll.jsonModel.JsonModel jsonModel = new Bll.jsonModel.JsonModel();
                jsonModel.Status = "error";
                jsonModel.Msg = ex.ToString();
                return jsonModel;
            }
        }

        public DataTable SetUserInfoIsDelete(string id, string IsDelete)
        {
            return new DLL.MeetingWebDll().SetUserInfoIsDelete(id, IsDelete);
        }


        public jsonModel.JsonModel BindUserInfo(string id) 
        {
            DataTable dt = new DLL.MeetingWebDll().BindUserInfo(id);
            jsonModel js = new jsonModel();
            return js.DataTableToJson(dt);
        
        }

        public DataTable InUserInfo(string Name, string IDCard, string Phone, string RoleID, string LoginName, string id, string Type)
        {
            return new DLL.MeetingWebDll().InUserInfo(Name, IDCard, Phone, RoleID, LoginName, id, Type);
        }

        public DataTable WhatBooked(string index)
        {
            return new DLL.MeetingWebDll().WhatBooked(index);
        }
    }
}
