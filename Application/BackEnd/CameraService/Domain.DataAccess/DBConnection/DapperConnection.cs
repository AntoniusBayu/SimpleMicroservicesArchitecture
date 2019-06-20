using System.Data;
using System.Data.SqlClient;

namespace Domain.DataAccess
{
    public abstract class DapperConnection : IConnection
    {
        public IDbConnection _Connection { get; set; }
        public IDbTransaction _Transaction { get; set; }
        public void Dispose()
        {
            if (this._Connection != null)
            {
                _Connection.Dispose();
                _Connection.Close();
                _Connection = null;
            }
        }

        public void OpenConnection(string connString, string dbName = "")
        {
            _Connection = new SqlConnection(connString);
            _Connection.Open();
        }
    }
}
