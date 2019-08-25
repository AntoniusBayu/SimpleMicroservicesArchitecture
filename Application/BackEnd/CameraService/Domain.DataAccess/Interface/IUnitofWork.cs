using System;

namespace Domain.DataAccess
{
    public interface IUnitofWork : IDisposable
    {
        void BeginTransaction();
        void RollbackTransaction();
        void CommitTransaction();
    }
}
