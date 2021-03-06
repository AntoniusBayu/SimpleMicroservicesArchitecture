﻿using Domain.DataAccess;
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
            var _dbConn = CommonFunction.InitConnection(DbEngine.MongoDB, _config);
            var repo = new mstCameraRepository(_dbConn);

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

        public void DeleteData(mstCamera data)
        {
            var _dbConn = CommonFunction.InitConnection(DbEngine.MongoDB, _config);
            var repo = new mstCameraRepository(_dbConn);

            try
            {
                _dbConn.BeginTransaction();

                if (!string.IsNullOrEmpty(data.Brand) && !string.IsNullOrEmpty(data.Country))
                {
                    repo.Delete(data, x => x.Brand == data.Brand && x.Country == data.Country);
                }
                else if (!string.IsNullOrEmpty(data.Brand))
                {
                    repo.Delete(data, x => x.Brand == data.Brand);
                }

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

        public IList<mstCamera> ReadData(mstCamera param)
        {
            var _dbConn = CommonFunction.InitConnection(DbEngine.MongoDB, _config);
            var repo = new mstCameraRepository(_dbConn);
            IList<mstCamera> listData = new List<mstCamera>();

            try
            {
                if (!string.IsNullOrEmpty(param.Brand) && !string.IsNullOrEmpty(param.Country))
                {
                    listData = repo.ReadByFilter(x => x.Brand == param.Brand && x.Country == param.Country);
                }
                else if (!string.IsNullOrEmpty(param.Brand))
                {
                    listData = repo.ReadByFilter(x => x.Brand.Contains(param.Brand));
                }

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

        public void UpdateData(mstCamera data)
        {
            var _dbConn = CommonFunction.InitConnection(DbEngine.MongoDB, _config);
            var repo = new mstCameraRepository(_dbConn);

            try
            {
                _dbConn.BeginTransaction();

                repo.Update(data, x => x.id == data.id);

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
    }
}
