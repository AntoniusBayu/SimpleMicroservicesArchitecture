using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public class InitDapperConnection
    {
        public static IDbConnection setupConnection(string connString = "")
        {
            if (string.IsNullOrEmpty(connString))
            {
                // Default
                connString = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            }

            DapperConnection conn = new DapperConnection();
            conn.SetupConnection(connString);
            return conn.dbConn;
        }
    }
}
