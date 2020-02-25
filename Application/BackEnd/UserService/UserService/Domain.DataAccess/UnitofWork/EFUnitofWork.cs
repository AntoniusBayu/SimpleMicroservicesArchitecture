using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

namespace Domain.DataAccess
{
    public class EFUnitofWork<TContext> : IUnitOfWork<TContext>, IUnitOfWork
        where TContext : DbContext, IDisposable
    {

        private Dictionary<Type, object> _repositories;
        public TContext Context { get; set; }

        public void BeginTransaction()
        {
            if (Context.Database.CurrentTransaction == null)
            {
                Context.Database.BeginTransaction();
            }
        }

        public void CommitTransaction()
        {
            if (Context.Database.CurrentTransaction == null)
            {
                Context.Database.CommitTransaction();
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool isDisposed)
        {
            if (isDisposed)
            {
                Context.Dispose();
            }
        }

        public IRepository<TEntity> GetRepository<TEntity>() where TEntity : class
        {
            if (_repositories == null) _repositories = new Dictionary<Type, object>();

            var type = typeof(TEntity);
            if (!_repositories.ContainsKey(type)) _repositories[type] = new EFRepository<TEntity>(Context);
            return (IRepository<TEntity>)_repositories[type];
        }

        public void RollbackTransaction()
        {
            if (Context.Database.CurrentTransaction == null)
            {
                Context.Database.RollbackTransaction();
            }
        }
    }
}
