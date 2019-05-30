using Domain.DataAccess;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;

namespace Domain.Business
{
    public class mstCameraDomain : BaseDomain, IMstCameraDomain
    {
        public mstCameraDomain(IConfiguration config)
        {
            base._config = config;
        }
        public void CreateData(mstCamera data)
        {
            var dbConn = base.InitConnection();
            var repo = new mstCameraRepository(dbConn);

            try
            {
                dbConn.BeginTransaction();

                repo.Add(data);

                dbConn.CommitTransaction();
            }
            catch (Exception ex)
            {
                dbConn.RollbackTransaction();
                throw ex;
            }
            finally
            {
                dbConn.Dispose();
            }
        }

        public void DeleteData(mstCamera data)
        {
            var dbConn = base.InitConnection();
            var repo = new mstCameraRepository(dbConn);

            try
            {
                dbConn.BeginTransaction();

                if (!string.IsNullOrEmpty(data.Brand) && !string.IsNullOrEmpty(data.Country))
                {
                    repo.Delete(x => x.Brand == data.Brand && x.Country == data.Country);
                }
                else if (!string.IsNullOrEmpty(data.Brand))
                {
                    repo.Delete(x => x.Brand == data.Brand);
                }

                dbConn.CommitTransaction();
            }
            catch (Exception ex)
            {
                dbConn.RollbackTransaction();
                throw ex;
            }
            finally
            {
                dbConn.Dispose();
            }
        }

        public IList<mstCamera> ReadData(mstCamera param)
        {
            var dbConn = base.InitConnection();
            var repo = new mstCameraRepository(dbConn);
            IList<mstCamera> listData = new List<mstCamera>();

            try
            {
                if (!string.IsNullOrEmpty(param.Brand) && !string.IsNullOrEmpty(param.Country))
                {
                    listData = repo.ReadByFilter(x => x.Brand == param.Brand && x.Country == param.Country);
                }
                else if (!string.IsNullOrEmpty(param.Brand))
                {
                    listData = repo.ReadByFilter(x => x.Brand == param.Brand);
                }

                return listData;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dbConn.Dispose();
            }
        }

        public void UpdateData(mstCamera data)
        {
            throw new System.NotImplementedException();
        }
    }
}
