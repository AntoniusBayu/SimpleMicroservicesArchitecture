using Dapper;
using Dapper.Contrib;
using Dapper.Contrib.Extensions;

namespace Domain.DataAccess
{
    [Table("mstUserPrivilege")]
    public class mstUserPrivilege : PagingViewModel
    {
        [ExplicitKey]
        public string Token { get; set; }
        public string Controller { get; set; }
        public string RequestMethod { get; set; }
    }
}
