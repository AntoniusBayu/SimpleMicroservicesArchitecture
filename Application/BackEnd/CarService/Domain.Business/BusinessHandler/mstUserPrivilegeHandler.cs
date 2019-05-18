using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class mstUserPrivilegeHandler
    {
        private IMstUserPrivilegeDomain _Domain;

        public mstUserPrivilegeHandler(IMstUserPrivilegeDomain Domain)
        {
            this._Domain = Domain;
        }

        public bool validatePrivilege(mstUserPrivilege param)
        {
            try
            {
                return this._Domain.ValidatePrivilege(param);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
