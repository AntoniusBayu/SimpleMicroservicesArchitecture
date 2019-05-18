namespace Domain.DataAccess
{
    public interface IUnitofWork
    {
        void BeginTransaction();
        void RollbackTransaction();
        void CommitTransaction();
    }
}
