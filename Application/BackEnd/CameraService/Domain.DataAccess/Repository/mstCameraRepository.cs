namespace Domain.DataAccess
{
    public partial class mstCameraRepository : MongoDBBaseRepository<mstCamera>
    {
        public mstCameraRepository(IUnitofWork uow) : base(uow)
        {

        }
    }
}
