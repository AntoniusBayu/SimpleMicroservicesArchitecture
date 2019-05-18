using System.Data;
using System.Data.SqlClient;

namespace Domain.DataAccess
{
    public abstract class DapperConnection : IConnection
    {
        public IDbConnection _Connection { get; set; }
        public IDbTransaction _Transaction { get; set; }

        public virtual void OpenSQLConnection(string connString)
        {
            _Connection = new SqlConnection(connString);
            _Connection.Open();
        }

        public virtual void Dispose()
        {
            if (this._Connection != null)
            {
                _Connection.Dispose();
                _Connection.Close();
                _Connection = null;
            }
        }
    }
}
