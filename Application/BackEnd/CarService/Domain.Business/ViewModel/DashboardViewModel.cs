using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class DashboardViewModel
    {
        public int PostRequest { get; set; }
        public int GetRequest { get; set; }
        public int PutRequest { get; set; }
        public int DeleteRequest { get; set; }
    }
}
