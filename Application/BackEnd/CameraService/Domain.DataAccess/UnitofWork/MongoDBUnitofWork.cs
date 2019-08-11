namespace Domain.DataAccess
{
    public class MongoDBUnitofWork : MongoDBConnection, IUnitofWork
    {
        public void BeginTransaction()
        {
            base._session.StartTransaction();
        }

        public void CommitTransaction()
        {
            base._session.CommitTransaction();
        }

        public void RollbackTransaction()
        {
            base._session.AbortTransaction();
        }
    }
}
