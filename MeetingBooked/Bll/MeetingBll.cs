using Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bll
{
    public partial class MeetingBll
    {
        BLLCommon common = new BLLCommon();
        public DataSet GetList() 
        {
            return new DLL.MeetingDLL().GetList();
       
        }

        public string setList(string MeetingTitle, string MeetingID, string TimeSectionID, string BookedDate, string Remark,string Name,string Phone)
        {
            return new DLL.MeetingDLL().SetList(MeetingTitle, MeetingID, TimeSectionID, BookedDate, Remark, Name, Phone);

        }

        public JsonModel GetSeeMeeting(string id,string Name,string Phone)
        {
            DataTable dt = new DLL.MeetingDLL().GetSeeMeeting(id, Name, Phone);
            DataView dv = dt.DefaultView;
            dv.Sort = " BookedDate desc,TimeSectionName asc";
            dt = dv.ToTable();
            return GetDataTableToJsonModel(dt);
        }

        public DataTable GetSeeMeetings(string id,string Name,string Phone)
        {
            return new DLL.MeetingDLL().GetSeeMeetings(id, Name, Phone);

        }

        public DataTable UpMeetingBooked(string id, string status, string BookedRemark)
        {
            return new DLL.MeetingDLL().UpMeetingBooked(id, status, BookedRemark);

        }

        public DataTable getUserInfo(string Name, string Phone)
        {
            return new DLL.MeetingDLL().getUserInfo(Name, Phone);

        }

        public DataTable getMeetingBooked(string BookedDate, string MeetingID)
        {
            return new DLL.MeetingDLL().getMeetingBooked(BookedDate, MeetingID);

        }

        public DataTable qxBooked(string id)
        {
            return new DLL.MeetingDLL().qxBooked(id);

        }

        public DataTable InUserLog(string name, string phone)
        {
            return new DLL.MeetingDLL().InUserLog(name,phone);
        }


        public JsonModel GetDataTableToJsonModel(DataTable modList)
        {
            JsonModel jsonModel = null;
            PagedDataModel<Dictionary<string, object>> pagedDataModel = null;
            int RowCount = 0;
            if (modList == null)
            {
                jsonModel = new JsonModel()
                {
                    Status = "null",
                    Msg = "无数据",
                    errNum  = 999
                };
                return jsonModel;
            }
            RowCount = modList.Rows.Count;
            if (RowCount <= 0)
            {
                jsonModel = new JsonModel()
                {
                    Status = "null",
                    Msg = "无数据",
                    errNum = 999
                };
                return jsonModel;
            }
            List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();
            list = common.DataTableToList(modList);
            int PageCount = (int)Math.Ceiling(RowCount * 1.0 / 10000);
            //将数据封装到PagedDataModel分页数据实体中
            pagedDataModel = new PagedDataModel<Dictionary<string, object>>()
            {
                PageCount = PageCount,
                PagedData = list,
                PageIndex = 1,
                PageSize = 10000,
                RowCount = RowCount
            };
            //将分页数据实体封装到JSON标准实体中
            jsonModel = new JsonModel()
            {
                errNum = 0,
                Msg = "success",
                Data = pagedDataModel,
                Status = "ok"
            };
            return jsonModel;
        }
    }
}
