using System;

namespace Domain.DataAccess
{
    public class mstLog
    {
        public int LogID { get; set; }
        public string Level { get; set; }
        public Guid RequestID { get; set; }
        public string Token { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public string RequestMethod { get; set; }
        public string ActivityMessage { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
