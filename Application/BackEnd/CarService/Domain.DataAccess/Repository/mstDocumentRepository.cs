using System.Linq;
using Dapper;
using Dapper.Contrib.Extensions;
using System.Data;
using System.Text;

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
