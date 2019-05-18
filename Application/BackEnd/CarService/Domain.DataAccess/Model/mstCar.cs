using Dapper;
using Dapper.Contrib;
using Dapper.Contrib.Extensions;
using System;

namespace Domain.DataAccess
{
    [Table("mstCar")]
    public class mstCar : PagingViewModel
    {
        [Key]
        public int AutoID { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
