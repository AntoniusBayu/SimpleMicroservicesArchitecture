namespace Domain.DataAccess
{
    public class mstLogRepository : DapperBaseRepository<mstLog>
    {
        public mstLogRepository(IUnitofWork uow) : base(uow)
        {
        }
    }
}
