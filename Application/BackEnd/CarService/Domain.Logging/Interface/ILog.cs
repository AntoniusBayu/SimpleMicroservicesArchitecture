using System;
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
