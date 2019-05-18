using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public class DBConnection
    {
        public static string BMIERP = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
    }
}
