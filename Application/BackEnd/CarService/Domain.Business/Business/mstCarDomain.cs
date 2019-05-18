using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstCarDomain : IMstCarDomain
    {
        private IUnitofWork _uow;

        public mstCarDomain(IUnitofWork uow)
        {
            _uow = uow;
        }

        public void SaveData(mstCar data)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstCarRepository(_uow);
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

        public void SaveDataFacade(mstCar data, IUnitofWork uow)
        {
            try
            {
                var repo = new mstCarRepository(uow);

                if (data.Name.Length > 5)
                {
                    data.Name = "Panjang karakter lebih dari 5";
                }
                else
                {
                    data.Name = "Panjang karakter tidak lebih dari 5";
                }

                repo.Add(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void SaveDataBulk(List<mstCar> data)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstCarRepository(_uow);
                repo.AddBulk(data);

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

        public void EditData(mstCar data)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstCarRepository(_uow);
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

        public void DeleteData(mstCar data)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                var repo = new mstCarRepository(_uow);
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

        public List<mstCar> ReadAll()
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);

                List<mstCar> listCar = new List<mstCar>();
                var repo = new mstCarRepository(_uow);

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

        public List<mstCar> ReadByPaging(mstCar param)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);

                List<mstCar> listCar = new List<mstCar>();
                var repo = new mstCarRepository(_uow);

                listCar = repo.ReadByPaging(param).ToList();
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
