namespace Domain.DataAccess
{
    public class MongoDBUnitofWork : MongoDBConnection, IUnitofWork
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
