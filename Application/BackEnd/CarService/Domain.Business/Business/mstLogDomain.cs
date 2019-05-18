using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstLogDomain : IMstLogDomain
    {
        private IUnitofWork _uow;

        public mstLogDomain(IUnitofWork uow)
        {
            _uow = uow;
        }

        public DashboardViewModel GetDataDashboard()
        {
            DashboardViewModel data = new DashboardViewModel();

            try
            {
                _uow.Open(DBConnection.BMIERP);

                var repo = new mstLogRepository(_uow);
                data.GetRequest = repo.ReadByFilter(x => x.RequestMethod == "GET").ToList().Count();
                data.PutRequest = repo.ReadByFilter(x => x.RequestMethod == "PUT").ToList().Count();
                data.PostRequest = repo.ReadByFilter(x => x.RequestMethod == "POST").ToList().Count();
                data.DeleteRequest = repo.ReadByFilter(x => x.RequestMethod == "DELETE").ToList().Count();

                return data;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                _uow.Dispose();
            }
        }

        public List<DashboardModel> GetDataChart()
        {
            List<DashboardModel> list = new List<DashboardModel>();
            DashboardModel data = new DashboardModel();

            try
            {
                _uow.Open(DBConnection.BMIERP);

                var repo = new mstLogRepository(_uow);

                list = repo.GetAnotherDataforDashboard().ToList();

                return list;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                _uow.Dispose();
            }
        }
    }
}
