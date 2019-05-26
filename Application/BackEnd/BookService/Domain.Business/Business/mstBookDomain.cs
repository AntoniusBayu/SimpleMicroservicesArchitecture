using Domain.DataAccess;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Domain.Business
{
    public class mstBookDomain : BaseDomain, IMstBookDomain
    {
        public mstBookDomain(IConfiguration config)
        {
            base._config = config;
        }

        public void CreateData(mstBook data)
        {
            var uow = new DapperUnitofWork();

            try
            {
                uow.OpenSQLConnection(dbConn);
                uow.BeginTransaction();

                var repo = new mstBookRepository(uow);
                repo.Add(data);

                uow.CommitTransaction();
            }
            catch (Exception)
            {
                uow.RollbackTransaction();
                throw;
            }
        }

        public void DeleteData(string bookID)
        {
            var uow = new DapperUnitofWork();
            var dataBook = new mstBook();

            try
            {
                uow.OpenSQLConnection(dbConn);
                uow.BeginTransaction();

                var repo = new mstBookRepository(uow);
                dataBook.SerialNo = bookID;
                repo.Delete(dataBook);

                uow.CommitTransaction();
            }
            catch (Exception)
            {
                uow.RollbackTransaction();
                throw;
            }
        }

        public List<mstBook> ReadData(mstBook parameter)
        {
            var uow = new DapperUnitofWork();
            List<mstBook> listData = new List<mstBook>();

            try
            {
                uow.OpenSQLConnection(dbConn);

                var repo = new mstBookRepository(uow);

                listData = repo.ReadByFilter(x => x.Description.Contains(parameter.Description)).ToList();

                return listData;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                uow.Dispose();
            }
        }

        public void UpdateData(mstBook data)
        {
            var uow = new DapperUnitofWork();
            mstBook currData = new mstBook();

            try
            {
                uow.OpenSQLConnection(dbConn);
                uow.BeginTransaction();

                var repo = new mstBookRepository(uow);

                currData = repo.ReadByFilter(x => x.SerialNo == data.SerialNo).FirstOrDefault();

                if (!string.IsNullOrEmpty(data.Description))
                {
                    currData.Description = data.Description;
                }

                if (!string.IsNullOrEmpty(data.Publisher))
                {
                    currData.Publisher = data.Publisher;
                }

                repo.Update(currData);

                uow.CommitTransaction();
            }
            catch (Exception)
            {
                uow.RollbackTransaction();
                throw;
            }
        }
    }
}
