using Dapper;
using Dapper.Contrib;
using Dapper.Contrib.Extensions;

namespace Domain.DataAccess
{
    [Table("mstSparePart")]
    public class mstSparePart : PagingViewModel
    {
        [Key]
        public int AutoID { get; set; }
        public int CarID { get; set; }
        public string SparePartDescription { get; set; }
    }
}
