namespace Domain.DataAccess
{
    public class mstDocumentRepository : BaseRepository<mstDocument>
    {
        public mstDocumentRepository(IUnitofWork uow)
        {
            base._uow = uow;
        }
    }
}
