using Domain.DataAccess;
using System.Collections.Generic;

namespace Domain.Business
{
    public interface IMstCameraDomain
    {
        void CreateData(mstCamera data);
        IList<mstCamera> ReadData(mstCamera param);
        void UpdateData(mstCamera data);
        void DeleteData(mstCamera data);
    }
}
