namespace Domain.DataAccess
{
    public interface IUnitofWork : IConnection
    {
        void BeginTransaction();
        void RollbackTransaction();
        void CommitTransaction();
    }
}
