using System;

namespace Domain.DataAccess
{
    public interface IConnection : IDisposable
    {
        void OpenSQLConnection(string connString);
    }
}
