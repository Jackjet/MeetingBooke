using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bll
{
    public partial class jsonModel
    {

        /// <summary>
        /// 将Datatable转成JsonModel类输出
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public JsonModel DataTableToJson(DataTable dt)
        {
            try
            {
                JsonModel jsonModel = null;
                if (dt == null)
                {
                    jsonModel = new JsonModel()
                    {
                        Status = "no",
                        Msg = "无数据"
                    };
                    return jsonModel;
                }
                StringBuilder sb = new StringBuilder();
                sb.Append("{\"");
                sb.Append("data");
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



                List<string> list = new List<string>();
                list.Add(sb.ToString());
                jsonModel = new JsonModel()
                {
                    Data = list,
                    Msg = "",
                    Status = "",
                    BackUrl = ""
                };

                return jsonModel;
            }
            catch (Exception ex)
            {
                JsonModel jsonModel = new JsonModel();
                jsonModel.Status = "error";
                jsonModel.Msg = ex.ToString();
                return jsonModel;
            }
        }



        public class JsonModel
        {
            public object Data { get; set; }
            public string Msg { get; set; }
            public string Status { get; set; }
            public string BackUrl { get; set; }

        }
    }
}
