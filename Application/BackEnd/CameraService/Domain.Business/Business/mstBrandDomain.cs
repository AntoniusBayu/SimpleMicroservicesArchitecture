using Domain.DataAccess;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;

namespace Domain.Business
{
    public class mstBrandDomain : BaseDomain, IMstBrandDomain
    {
        public mstBrandDomain(IConfiguration config)
        {
            _config = config;
        }
        public void CreateData(mstBrand data)
        {
            var _dbConn = CommonFunction.InitConnection(DbEngine.MongoDB, _config);
            var repo = new mstBrandRepository(_dbConn);

            try
            {
                _dbConn.BeginTransaction();

                repo.Add(data);

                _dbConn.CommitTransaction();
            }
            catch (Exception ex)
            {
                _dbConn.RollbackTransaction();
                throw ex;
            }
            finally
            {
                _dbConn.Dispose();
            }
        }

        public IList<mstBrand> ReadData()
        {
            var _dbConn = CommonFunction.InitConnection(DbEngine.MongoDB, _config);
            var repo = new mstBrandRepository(_dbConn);
            IList<mstBrand> listData = new List<mstBrand>();

            try
            {
                listData = repo.ReadAllData();

                return listData;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _dbConn.Dispose();
            }
        }
    }
}
