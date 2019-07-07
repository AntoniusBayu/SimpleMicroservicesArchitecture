namespace Domain.DataAccess
{
    public partial class mstBrandRepository : MongoDBBaseRepository<mstBrand>
    {
        public mstBrandRepository(IUnitofWork uow) : base(uow)
        {

        }
    }
}
