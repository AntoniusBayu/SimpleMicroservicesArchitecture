using Domain.DataAccess;

namespace Domain.Business
{
    public interface IUser
    {
        public void RegisterUser(mstUser data);
        public UserLogin GetUser(mstUser data);
        public bool CheckUser(mstUser data);

    }
}
