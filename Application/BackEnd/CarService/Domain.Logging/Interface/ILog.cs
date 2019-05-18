using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Logging
{
    public interface ILog
    {
        void Setup(mstLog data);
        void Debug(string message);
        void Debug(string message, object data);
        void Info(string message);
        void Info(string message, object data);
        void Error(Exception ex, string key);
        void Save();
    }
}
