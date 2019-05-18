using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstUserPrivilegeDomain : IMstUserPrivilegeDomain
    {
        private IUnitofWork _uow;

        public mstUserPrivilegeDomain(IUnitofWork uow)
        {
            _uow = uow;
        }

        public bool ValidatePrivilege(mstUserPrivilege param)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);

                var repo = new mstUserPrivilegeRepository(_uow);
                var data = repo.ReadByFilter(x => x.Token == param.Token && x.Controller == param.Controller && x.RequestMethod == param.RequestMethod).FirstOrDefault();

                if (data != null)
                {
                    return true;
                }

                return false;
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                _uow.Dispose();
            }
        }
    }
}
