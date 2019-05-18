using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public interface IUnitofWork : IDisposable
    {
        IDbConnection Connection { get; set; }
        IDbTransaction Transaction { get; set; }

        void Open(string connString);
        void BeginTransaction();
        void RollbackTransaction();
        void CommitTransaction();
    }
}
