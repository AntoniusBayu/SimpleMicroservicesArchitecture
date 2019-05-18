using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using System.Data;
using System.Data.SqlClient;

namespace Domain.DataAccess
{
    public class DapperConnection : ISetupDBConnection
    {
        public IDbConnection dbConn;

        public void SetupConnection(string connectionString)
        {
            dbConn = new SqlConnection(connectionString);
        }
    }
}
