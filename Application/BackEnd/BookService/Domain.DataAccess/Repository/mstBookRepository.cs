namespace Domain.DataAccess
{
    public partial class mstBookRepository : DapperBaseRepository<mstBook>
    {
        public mstBookRepository(IUnitofWork uow) : base(uow)
        {
        }
    }
}
