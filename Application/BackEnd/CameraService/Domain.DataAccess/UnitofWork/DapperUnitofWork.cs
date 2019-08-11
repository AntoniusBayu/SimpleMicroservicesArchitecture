namespace Domain.DataAccess
{
    public class DapperUnitofWork : DapperConnection, IUnitofWork
    {
        public virtual void BeginTransaction()
        {
            base._Transaction = _Connection.BeginTransaction();
        }

        public virtual void RollbackTransaction()
        {
            base._Transaction.Rollback();
        }

        public virtual void CommitTransaction()
        {
            base._Transaction.Commit();
        }
    }
}
