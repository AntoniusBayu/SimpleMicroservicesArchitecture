using Domain.DataAccess;
using System.Collections.Generic;

namespace Domain.Business
{
    public interface IMstBookDomain
    {
        void CreateData(mstBook data);
        List<mstBook> ReadData(mstBook parameter);
        void UpdateData(mstBook data);
        void DeleteData(string bookID);
    }
}
