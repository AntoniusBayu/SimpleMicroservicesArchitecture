using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstSparePartDomain : IMstSparePartDomain
    {
        private IUnitofWork _uow;

        public mstSparePartDomain(IUnitofWork uow)
        {
            _uow = uow;
        }

        public void SaveData(mstSparePart data)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstSparePartRepository(_uow);
                repo.Add(data);

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

        public void SaveDataFacade(mstSparePart data, IUnitofWork uow)
        {
            try
            {
                var repo = new mstSparePartRepository(uow);

                if (data.SparePartDescription.Length > 10)
                {
                    data.SparePartDescription = "Panjang karakter lebih dari 10";
                }
                else
                {
                    data.SparePartDescription = "Panjang karakter tidak lebih dari 10";
                }

                repo.Add(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void EditData(mstSparePart data)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstSparePartRepository(_uow);
                repo.Edit(data);

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

        public void DeleteData(mstSparePart data)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstSparePartRepository(_uow);
                repo.Delete(data);

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

        public List<mstSparePart> ReadAll()
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);

                var repo = new mstSparePartRepository(_uow);
                List<mstSparePart> listCar = new List<mstSparePart>();

                listCar = repo.ReadAllData().ToList();
                return listCar;
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
