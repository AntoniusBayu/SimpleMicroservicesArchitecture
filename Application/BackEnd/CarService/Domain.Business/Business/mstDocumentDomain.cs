using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstDocumentDomain : IMstDocumentDomain
    {
        private IUnitofWork _uow;

        public mstDocumentDomain(IUnitofWork uow)
        {
            _uow = uow;
        }

        public void SaveData(mstDocument doc)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstDocumentRepository(_uow);
                repo.Add(doc);

                _uow.CommitTransaction();
            }
            catch (Exception)
            {
                _uow.RollbackTransaction();
                throw;
            }
            finally
            {
                _uow.Dispose();
            }
        }

        public mstDocument LoadDoc(int docID)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);

                mstDocument doc = new mstDocument();
                var repo = new mstDocumentRepository(_uow);

                doc = repo.ReadByFilter(x => x.DocID == docID).FirstOrDefault();
                return doc;
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

        public long GetLatestDocID()
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);

                mstDocument doc = new mstDocument();
                var repo = new mstDocumentRepository(_uow);

                doc = repo.ReadAllData().OrderByDescending(x => x.DocID).FirstOrDefault();
                return doc.DocID;
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
