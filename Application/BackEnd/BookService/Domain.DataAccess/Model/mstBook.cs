using Dapper;
using Dapper.Contrib;
using Dapper.Contrib.Extensions;
using System;

namespace Domain.DataAccess
{
    [Table("mstBook")]
    public class mstBook
    {
        [ExplicitKey]
        public string SerialNo { get; set; }
        public string Description { get; set; }
        public string Publisher { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
