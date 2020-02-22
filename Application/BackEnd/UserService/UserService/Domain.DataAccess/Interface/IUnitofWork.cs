using Microsoft.EntityFrameworkCore;
using System;

namespace Domain.DataAccess
{
    public interface IUnitOfWork : IDisposable
    {
        IRepository<TEntity> GetRepository<TEntity>() where TEntity : class;
        void BeginTransaction();
        void CommitTransaction();
        void RollbackTransaction();
    }

    public interface IUnitOfWork<TContext> : IUnitOfWork where TContext : DbContext
    {
        TContext Context { get; }
    }
}
