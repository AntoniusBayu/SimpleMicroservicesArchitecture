using System.Linq;
using Dapper;
using System.Data;
using System.Text;

namespace Domain.DataAccess
{
    public class mstCarRepository : BaseRepository<mstCar>
    {
        public mstCarRepository(IUnitofWork uow)
        {
            base._uow = uow;
        }

        /// <summary>
        /// Ini Sample Read By paging
        /// Kebutuhan untuk di report.
        /// Jadi load data based on Request page
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        public IQueryable<mstCar> ReadByPaging(mstCar param)
        {
            StringBuilder sql = new StringBuilder();
            var parameter = new DynamicParameters();

            sql.Append(" SELECT *, TotalData = COUNT(1) OVER() FROM mstCar ");

            // Filter Area
            sql.Append(" WHERE 1=1 ");
            if (param.AutoID > 0)
            {
                sql.Append(" AND AutoID = @AutoID ");
                parameter.Add("AutoID", param.AutoID, DbType.Int32, ParameterDirection.Input);
            }

            if (!string.IsNullOrEmpty(param.Name))
            {
                sql.Append(" AND Name = @Name ");
                parameter.Add("Name", param.Name, DbType.String, ParameterDirection.Input);
            }

            // Order Area
            sql.Append(" Order By '" + param.SortByField + "' " + param.SortByType + " ");

            // Paging Area
            if (param.CurrentPage > 0)
            {
                sql.Append("  OFFSET @RequestPerPage * (@CurrentPage - 1) ROWS  ");
                sql.Append("  FETCH NEXT @RequestPerPage ROWS ONLY ");
                parameter.Add("RequestPerPage", param.RequestPerPage, DbType.Int32, ParameterDirection.Input);
                parameter.Add("CurrentPage", param.CurrentPage, DbType.Int32, ParameterDirection.Input);
            }

            return base._uow.Connection.Query<mstCar>(sql.ToString(), parameter, commandType: CommandType.Text).AsQueryable();
        }
    }
}
