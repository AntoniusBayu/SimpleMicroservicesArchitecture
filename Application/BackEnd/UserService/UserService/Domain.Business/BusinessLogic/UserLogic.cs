using Domain.DataAccess;
using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Business
{
    public class UserLogic : IUser
    {
        private IUnitOfWork _uow;

        public UserLogic(IUnitOfWork uow)
        {
            this._uow = uow;
        }

        public bool CheckUser(mstUser data)
        {
            var exists = false;
            var repo = _uow.GetRepository<mstUser>();

            try
            {
                var currData = repo.Single(x => x.UserID == data.UserID & x.IsActive == true);  
                

                return exists;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public UserLogin GetUser(mstUser data)
        {
            throw new NotImplementedException();
        }

        public void RegisterUser(mstUser data)
        {
            throw new NotImplementedException();
        }
    }
}
