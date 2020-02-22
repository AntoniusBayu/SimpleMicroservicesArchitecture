using System;

namespace Domain.DataAccess
{
    public class UserLogin
    {
        public long LogID { get; set; }
        public long UserID { get; set; }
        public string IPAddress { get; set; }
        public Guid Token { get; set; }
    }
}
