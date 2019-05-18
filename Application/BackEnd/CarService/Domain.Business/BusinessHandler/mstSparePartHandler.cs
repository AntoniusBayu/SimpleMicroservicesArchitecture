using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstSparePartHandler
    {
        private IMstSparePartDomain _carSparePart;

        public mstSparePartHandler(IMstSparePartDomain carDomain)
        {
            this._carSparePart = carDomain;
        }

        public void saveData(mstSparePart data)
        {
            try
            {
                this._carSparePart.SaveData(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void deleteData(mstSparePart data)
        {
            try
            {
                this._carSparePart.DeleteData(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void editData(mstSparePart data)
        {
            try
            {
                this._carSparePart.EditData(data);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<mstSparePart> getAllData()
        {
            try
            {
                return this._carSparePart.ReadAll().ToList();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
