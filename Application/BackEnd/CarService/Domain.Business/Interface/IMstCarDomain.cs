using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public interface IMstCarDomain
    {
        void SaveData(mstCar data);
        void SaveDataFacade(mstCar data, IUnitofWork uow);
        void SaveDataBulk(List<mstCar> data);
        void EditData(mstCar data);
        void DeleteData(mstCar data);
        List<mstCar> ReadAll();
        List<mstCar> ReadByPaging(mstCar param);
    }
}
