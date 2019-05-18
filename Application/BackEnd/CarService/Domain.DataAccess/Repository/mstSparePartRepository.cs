namespace Domain.DataAccess
{
    public class mstSparePartRepository : BaseRepository<mstSparePart>
    {
        public mstSparePartRepository(IUnitofWork uow)
        {
            base._uow = uow;
        }
    }
}
