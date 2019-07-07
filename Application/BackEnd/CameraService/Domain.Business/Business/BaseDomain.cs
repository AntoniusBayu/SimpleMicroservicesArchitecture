using Domain.DataAccess;
using Microsoft.Extensions.Configuration;

namespace Domain.Business
{
    public abstract class BaseDomain
    {
        protected IConfiguration _config { get; set; }
        protected IUnitofWork _dbConn { get; set; }

        protected void InitConnection(DbEngine _dbEngine)
        {
            DbConnection dbConn = new DbConnection();

            switch (_dbEngine)
            {
                case DbEngine.SQLServer:
                    _dbConn = dbConn.InitDapper(_config.GetConnectionString("dbConnection"));
                    break;
                case DbEngine.MongoDB:
                    var settingsSection = _config.GetSection("AppSettings");
                    var settings = settingsSection.Get<AppSettings>();

                    _dbConn = dbConn.InitMongoDB(settings.MongoDBConnectionString, settings.TableName);
                    break;
            }
        }
    }
}
