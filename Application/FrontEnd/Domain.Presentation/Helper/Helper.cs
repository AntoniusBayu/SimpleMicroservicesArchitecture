using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace Domain.Presentation
{
    public class Helper
    {
        public static string GetDefaultJsStringFormat()
        {
            string stringformat = "<script type=\"text/javascript\" src=\"{0}?v=" + GetJsCssVersion() + "\"></script>";
            return stringformat;
        }

        public static string GetDefaultCssStringFormat()
        {
            string stringformat = "<link href=\"{0}?v=" + GetJsCssVersion() + "\" rel=\"stylesheet\" />";
            return stringformat;
        }

        private static string GetJsCssVersion()
        {
            string version = ConfigurationManager.AppSettings["JsCSSVersion"];
            return version;
        }

        public static string GetToken()
        {
            string stringformat = "test";
            return stringformat;
        }

        public static string GetUrl()
        {
            string stringformat = ConfigurationManager.AppSettings["ApiURL"];
            return stringformat;
        }

        public static string GetPrefixDocument()
        {
            string stringformat = ConfigurationManager.AppSettings["PrefixDocURL"];
            return stringformat;
        }
    }
}