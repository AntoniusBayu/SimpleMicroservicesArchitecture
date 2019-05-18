using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public interface ISetupDBConnection
    {
        void SetupConnection(string connectionString);
    }
}
