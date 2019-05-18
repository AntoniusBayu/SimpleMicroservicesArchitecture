namespace Domain.DataAccess
{
    public class mstUserPrivilegeRepository : BaseRepository<mstUserPrivilege>
    {
        public mstUserPrivilegeRepository(IUnitofWork uow)
        {
            base._uow = uow;
        }
    }
}
