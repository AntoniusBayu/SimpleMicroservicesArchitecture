using System.Data;

namespace Domain.DataAccess
{
    public class DapperUnitofWork : DapperConnection, IUnitofWork
    {
        public virtual void BeginTransaction()
        {
            _Transaction = _Connection.BeginTransaction(IsolationLevel.ReadUncommitted);
        }

        public virtual void RollbackTransaction()
        {
            _Transaction.Rollback();
        }

        public virtual void CommitTransaction()
        {
            _Transaction.Commit();
        }
    }
}
