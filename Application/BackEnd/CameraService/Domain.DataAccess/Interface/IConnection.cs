using System;

namespace Domain.DataAccess
{
    public interface IConnection : IDisposable
    {
        void OpenConnection(string connString, string dbName = "");
    }
}
