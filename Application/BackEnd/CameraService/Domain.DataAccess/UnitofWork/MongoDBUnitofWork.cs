namespace Domain.DataAccess
{
    public abstract class MongoDBUnitofWork : MongoDBConnection, IUnitofWork
    {
        public void BeginTransaction()
        {
            _session.StartTransaction();
        }

        public void CommitTransaction()
        {
            _session.CommitTransaction();
        }

        public void RollbackTransaction()
        {
            _session.AbortTransaction();
        }
    }
}
