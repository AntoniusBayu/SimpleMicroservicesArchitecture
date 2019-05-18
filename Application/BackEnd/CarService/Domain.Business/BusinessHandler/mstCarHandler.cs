using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstCarHandler
    {
        private IMstCarDomain _carDomain;

        public mstCarHandler(IMstCarDomain carDomain)
        {
            this._carDomain = carDomain;
        }

        public void saveData(mstCar data)
        {
            try
            {
                this._carDomain.SaveData(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void deleteData(mstCar data)
        {
            try
            {
                this._carDomain.DeleteData(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void editData(mstCar data)
        {
            try
            {
                this._carDomain.EditData(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<mstCar> getAllData()
        {
            try
            {
                return this._carDomain.ReadAll().ToList();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
