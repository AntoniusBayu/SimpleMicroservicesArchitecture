using Domain.DataAccess;
using System.Collections.Generic;

namespace Domain.Business
{
    public interface IMstBrandDomain
    {
        void CreateData(mstBrand data);
        IList<mstBrand> ReadData();
    }
}
