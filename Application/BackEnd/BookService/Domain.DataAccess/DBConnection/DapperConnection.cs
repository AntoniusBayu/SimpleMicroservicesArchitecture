﻿using System.Data;
using System.Data.SqlClient;

namespace Domain.DataAccess
{
    public abstract class DapperConnection : IConnection
    {
        public IDbConnection _Connection { get; set; }
        public IDbTransaction _Transaction { get; set; }

        public virtual void OpenSQLConnection(string connString)
        {
            this._Connection = new SqlConnection(connString);
            this._Connection.Open();
        }

        public virtual void Dispose()
        {
            if (this._Transaction != null)
            {
                this._Transaction.Dispose();
                this._Transaction = null;
            }

            if (this._Connection != null)
            {
                this._Connection.Dispose();
                this._Connection.Close();
                this._Connection = null;
            }
        }
    }
}
