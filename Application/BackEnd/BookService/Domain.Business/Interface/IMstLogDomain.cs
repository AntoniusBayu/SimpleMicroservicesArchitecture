using Domain.DataAccess;
using System;

namespace Domain.Business
{
    public interface IMstLogDomain
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
