using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public interface IMstDocumentDomain
    {
        void SaveData(mstDocument doc);
        mstDocument LoadDoc(int docID);
        long GetLatestDocID();
    }
}
