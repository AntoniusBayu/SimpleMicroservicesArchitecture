namespace Domain.DataAccess
{
    public class mstUser
    {
        public long UserID { get; set; }
        public string UserName { get; set; }
        public string UserPassword { get; set; }
        public string SaltPassword { get; set; }
        public bool IsActive { get; set; }
    }
}
