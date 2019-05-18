using Dapper;
using Dapper.Contrib;
using Dapper.Contrib.Extensions;

namespace Domain.DataAccess
{
    public class PagingViewModel
    {
        [Write(false)]
        public string SortByField { get; set; }
        [Write(false)]
        public string SortByType { get; set; }
        [Write(false)]
        public int CurrentPage { get; set; }
        [Write(false)]
        public int RequestPerPage { get; set; }
        [Write(false)]
        public int TotalData { get; set; }
    }
}
