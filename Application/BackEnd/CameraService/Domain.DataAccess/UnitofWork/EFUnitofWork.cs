namespace Domain.DataAccess
{
    public abstract class EFUnitofWork : EFConnection, IUnitofWork
    {
        public void BeginTransaction()
        {
            base.Database.BeginTransaction();
        }

        public void CommitTransaction()
        {
            base.Database.CommitTransaction();
        }

        public void RollbackTransaction()
        {
            base.Database.RollbackTransaction();
        }
    }
}
