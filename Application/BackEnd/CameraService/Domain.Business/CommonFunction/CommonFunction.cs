using Domain.DataAccess;
using Microsoft.Extensions.Configuration;

namespace Domain.Business
{
    public class CommonFunction
    {
        public static IUnitofWork InitConnection(DbEngine _dbEngine, IConfiguration _config)
        {
            IUnitofWork _dbConn = null;
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

            return _dbConn;
        }
    }
}
