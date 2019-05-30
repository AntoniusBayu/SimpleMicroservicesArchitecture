using Domain.DataAccess;
using Microsoft.Extensions.Configuration;

namespace Domain.Business
{
    public abstract class BaseDomain
    {
        protected IConfiguration _config { get; set; }
        private DbConnection _dbConn { get; set; }

        protected DbConnection InitConnection()
        {
            _dbConn = new DbConnection();

            _dbConn.OpenConnection(string.Empty, string.Empty);

            return _dbConn;
        }
    }
}
