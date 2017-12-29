using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Caching;

namespace SMSUtility
{
    /// <summary>
    /// IP地址帮助类,通过对比IP纯真地址库获取真实址
    /// </summary>
    public class IPHelper
    {
        private const string IPDataPath = "~/App_Data/qqwry.dat";
        private MemoryStream _ipFile;
        private static Cache cache = HttpContext.Current.Cache;
        private string cache_key = "qqwry_stream";
        private long _ip;
        //string ipfilePath;


        private IPHelper()
        {
        }


        public static string GetAddressFromIP(string ip)
        {
            IPLocation ipLocation = new IPHelper().GetIPLocation(ip);
            return ipLocation.Country;
        }


        /// <summary>
        /// 获取当前IP对应的地区（省及直辖市）
        /// </summary>
        /// <returns></returns>
        public static string GetAddressFromCurrentIP()
        {
            return GetAddressFromIP(GetIP());
        }





        ///<summary>
        /// 地理位置,包括国家和地区
        ///</summary>
        private struct IPLocation
        {
            public string Country, Area;
        }

        /// <summary>
        /// 获取指定IP所在地理位置
        /// </summary>
        /// <param name="strIP">IP地址</param>
        /// <returns></returns>
        private IPLocation GetIPLocation(string strIP)
        {
            _ip = IPToLong(strIP);
            if (cache[cache_key] == null)
            {
                string path = HttpContext.Current.Server.MapPath(IPDataPath);
                FileStream fs = new FileStream(path, System.IO.FileMode.Open, System.IO.FileAccess.Read);
                byte[] buff = new byte[fs.Length];
                fs.Read(buff, 0, (int)fs.Length);
                CacheDependency cDep = new CacheDependency(path);
                cache.Add(cache_key, buff, cDep, Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.NotRemovable, null);
            }
            _ipFile = new MemoryStream((byte[])cache[cache_key]);
            long[] ipArray = BlockToArray(ReadIPBlock());
            long offset = SearchIP(ipArray, 0, ipArray.Length - 1) * 7 + 4;
            _ipFile.Position += offset;//跳过起始IP
            _ipFile.Position = ReadLongX(3) + 4;//跳过结束IP
            IPLocation loc = new IPLocation();
            int flag = _ipFile.ReadByte();//读取标志
            if (flag == 1)//表示国家和地区被转向
            {
                _ipFile.Position = ReadLongX(3);
                flag = _ipFile.ReadByte();//再读标志
            }
            long countryOffset = _ipFile.Position;
            loc.Country = ReadString(flag);
            if (flag == 2)
                _ipFile.Position = countryOffset + 3;
            flag = _ipFile.ReadByte();
            loc.Area = ReadString(flag);
            _ipFile.Close();
            _ipFile = null;
            return loc;
        }


        ///<summary>
        /// 将字符串形式的IP转换位long
        ///</summary>
        ///<param name="strIP"></param>
        ///<returns></returns>
        private static long IPToLong(string strIP)
        {
            byte[] ipBytes = new byte[8];
            string[] strArr = strIP.Split(new[] { '.' });
            for (int i = 0; i < 4; i++)
                ipBytes[i] = byte.Parse(strArr[3 - i]);
            return BitConverter.ToInt64(ipBytes, 0);
        }

        ///<summary>
        /// 将索引区字节块中的起始IP转换成Long数组
        ///</summary>
        ///<param name="ipBlock"></param>
        private static long[] BlockToArray(byte[] ipBlock)
        {
            long[] ipArray = new long[ipBlock.Length / 7];
            int ipIndex = 0;
            byte[] temp = new byte[8];
            for (int i = 0; i < ipBlock.Length; i += 7)
            {
                Array.Copy(ipBlock, i, temp, 0, 4);
                ipArray[ipIndex] = BitConverter.ToInt64(temp, 0);
                ipIndex++;
            }
            return ipArray;
        }


        ///<summary>
        /// 从IP数组中搜索指定IP并返回其索引
        ///</summary>
        ///<param name="ipArray">IP数组</param>
        ///<param name="start">指定搜索的起始位置</param>
        ///<param name="end">指定搜索的结束位置</param>
        ///<returns></returns>
        private int SearchIP(IList<long> ipArray, int start, int end)
        {
            int middle = (start + end) / 2;
            if (middle == start)
                return middle;
            return _ip < ipArray[middle] ? SearchIP(ipArray, start, middle) : SearchIP(ipArray, middle, end);
        }


        ///<summary>
        /// 读取IP文件中索引区块
        ///</summary>
        ///<returns></returns>
        private byte[] ReadIPBlock()
        {
            long startPosition = ReadLongX(4);
            long endPosition = ReadLongX(4);
            long count = (endPosition - startPosition) / 7 + 1;//总记录数
            _ipFile.Position = startPosition;
            byte[] ipBlock = new byte[count * 7];
            _ipFile.Read(ipBlock, 0, ipBlock.Length);
            _ipFile.Position = startPosition;
            return ipBlock;
        }


        ///<summary>
        /// 从IP文件中读取指定字节并转换位long
        ///</summary>
        ///<param name="bytesCount">需要转换的字节数，主意不要超过8字节</param>
        ///<returns></returns>
        private long ReadLongX(int bytesCount)
        {
            byte[] bytes = new byte[8];
            _ipFile.Read(bytes, 0, bytesCount);
            return BitConverter.ToInt64(bytes, 0);
        }

        ///<summary>
        /// 从IP文件中读取字符串
        ///</summary>
        ///<param name="flag">转向标志</param>
        ///<returns></returns>
        private string ReadString(int flag)
        {
            if (flag == 1 || flag == 2)//转向标志
                _ipFile.Position = ReadLongX(3);
            else
                _ipFile.Position -= 1;
            List<byte> list = new List<byte>();
            byte b = (byte)_ipFile.ReadByte();
            while (b > 0)
            {
                list.Add(b);
                b = (byte)_ipFile.ReadByte();
            }
            return Encoding.Default.GetString(list.ToArray());
        }


        // 穿过代理服务器取远程用户真实IP地址
        public static string GetIP(HttpContext conext)
        {
            string ip = conext.Request.UserHostAddress;
            if (ip == "::1")
                ip = "127.0.0.1";
            return ip;
            ////#if DEBUG
            ////            // for test 公司当前外网IP
            ////            return "221.220.136.40";
            ////#endif
            //string ip = conext.Request.Headers["Cdn-Src-Ip"];
            //if (string.IsNullOrEmpty(ip))
            //{
            //    ip = conext.Request.UserHostAddress;
            //    if (ip == "::1")
            //        ip = "127.0.0.1";
            //    return ip;
            //}
            //if (conext.Request.ServerVariables["HTTP_VIA"] != null)
            //{
            //    if (conext.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] == null)
            //    {
            //        if (conext.Request.ServerVariables["HTTP_CLIENT_IP"] != null)
            //            ip = conext.Request.ServerVariables["HTTP_CLIENT_IP"].ToString(CultureInfo.InvariantCulture);
            //        else
            //            if (conext.Request.ServerVariables["REMOTE_ADDR"] != null)
            //                ip = conext.Request.ServerVariables["REMOTE_ADDR"].ToString(CultureInfo.InvariantCulture);
            //            else
            //                ip = "0.0.0.0";
            //    }
            //    else
            //        ip = conext.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString(CultureInfo.InvariantCulture);
            //}
            //else if (conext.Request.ServerVariables["REMOTE_ADDR"] != null)
            //    ip = conext.Request.ServerVariables["REMOTE_ADDR"].ToString(CultureInfo.InvariantCulture);
            //else
            //    ip = "0.0.0.0";
            //if (ip == "::1")
            //    ip = "127.0.0.1";
            //return ip;
        }


        public static string GetIP()
        {
            string ip = HttpContext.Current.Request.UserHostAddress;
            if (ip == "::1")
                ip = "127.0.0.1";
            return ip;
            //    //#if DEBUG
            //    //            // for test 公司当前外网IP
            //    //            return "221.220.136.40";
            //    //#endif
            //    // 穿过代理服务器取远程用户真实IP地址
            //    string ip = HttpContext.Current.Request.Headers["Cdn-Src-Ip"];
            //    if (string.IsNullOrEmpty(ip))
            //    {
            //        ip = HttpContext.Current.Request.UserHostAddress;
            //        if (ip == "::1")
            //            ip = "127.0.0.1";
            //        return ip;
            //    }
            //    if (HttpContext.Current.Request.ServerVariables["HTTP_VIA"] != null)
            //    {
            //        if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] == null)
            //        {
            //            if (HttpContext.Current.Request.ServerVariables["HTTP_CLIENT_IP"] != null)
            //                ip = HttpContext.Current.Request.ServerVariables["HTTP_CLIENT_IP"].ToString(CultureInfo.InvariantCulture);
            //            else
            //                if (HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] != null)
            //                    ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString(CultureInfo.InvariantCulture);
            //                else
            //                    ip = "0.0.0.0";
            //        }
            //        else
            //            ip = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString(CultureInfo.InvariantCulture);
            //    }
            //    else if (HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] != null)
            //        ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString(CultureInfo.InvariantCulture);
            //    else
            //        ip = "0.0.0.0";
            //    if (ip == "::1")
            //        ip = "127.0.0.1";
            //    return ip;
        }
    }

    public static class IPHelperExtend
    {
        public static IPAddress ToIPAddress(this string ipstr)
        {
            if (string.IsNullOrEmpty(ipstr))
                return null;
            string[] ip_section = ipstr.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
            if (ip_section.Length != 4)
                return null;
            try
            {
                byte[] ip_byte = new byte[4];
                for (int i = 0; i < 4; i++)
                    ip_byte[i] = Convert.ToByte(ip_section[i]);
                return new IPAddress(ip_byte);
            }
            catch
            {
                return null;
            }
        }
    }
}
