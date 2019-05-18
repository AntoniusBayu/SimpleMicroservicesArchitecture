using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public interface IMstSparePartDomain
    {
        void SaveData(mstSparePart data);
        void SaveDataFacade(mstSparePart data, IUnitofWork uow);
        void EditData(mstSparePart data);
        void DeleteData(mstSparePart data);
        List<mstSparePart> ReadAll();
    }
}
