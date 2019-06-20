namespace Domain.DataAccess
{
    public class DapperUnitofWork : DapperConnection, IUnitofWork
    {
        public virtual void BeginTransaction()
        {
            _Transaction = _Connection.BeginTransaction();
        }

        public virtual void RollbackTransaction()
        {
            _Transaction.Rollback();
            base.Dispose();
        }

        public virtual void CommitTransaction()
        {
            _Transaction.Commit();
            base.Dispose();
        }
    }
}
