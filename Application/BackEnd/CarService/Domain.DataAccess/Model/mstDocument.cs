using Dapper;
using Dapper.Contrib;
using Dapper.Contrib.Extensions;
using System;

namespace Domain.DataAccess
{
    [Table("mstDocument")]
    public class mstDocument : PagingViewModel
    {
        [Key]
        public long DocID { get; set; }
        public string DocName { get; set; }
        public string DocContent { get; set; }
        public string DocURL { get; set; }
    }
}
