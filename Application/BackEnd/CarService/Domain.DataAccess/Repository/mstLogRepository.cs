using Dapper;
using System;
using System.Data;
using System.Linq;
using System.Text;
namespace Domain.DataAccess
{
    public class mstLogRepository : BaseRepository<mstLog>
    {
        public mstLogRepository(IUnitofWork uow)
        {
            base._uow = uow;
        }

        public IQueryable<DashboardModel> GetAnotherDataforDashboard()
        {
            StringBuilder sql = new StringBuilder();
            var parameter = new DynamicParameters();

            sql.Append(" SELECT SUM(CASE WHEN [Level] = 'ERROR' THEN 1 ELSE 0 END) As TotalError, ");
            sql.Append(" SUM(CASE WHEN [Level] <> 'ERROR' THEN 1 ELSE 0 END) As TotalRequest, ");
            sql.Append(" Day(CreatedDate) As Hari ");
            sql.Append(" from mstLog ");
            sql.Append(" where MONTH(CreatedDate) = @Month ");
            sql.Append(" AND YEAR(CreatedDate) = @Year ");
            sql.Append(" Group by Day(CreatedDate) ");

            parameter.Add("Month", DateTime.Now.Month, DbType.Int32, ParameterDirection.Input);
            parameter.Add("Year", DateTime.Now.Year, DbType.Int32, ParameterDirection.Input);

            return base._uow.Connection.Query<DashboardModel>(sql.ToString(), parameter, commandType: CommandType.Text).AsQueryable();
        }
    }
}
