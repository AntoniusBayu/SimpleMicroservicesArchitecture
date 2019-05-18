using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using System.Data;
using System.Data.SqlClient;

namespace Domain.DataAccess
{
    /// <summary>
    /// Ini itu Unit of work.
    /// Singkat cerita kinerja dia kayak sql transaction lah.
    /// Jadi ngebungkus beberapa transaksi(CRUD) ke dalam 1 kerangka kerja. jadi sekali open, sekali close juga.
    /// Ini juga termasuk dari design pattern. Namanya Unit of Work Pattern.
    /// Hayooo di googling...
    /// </summary>
    public class DapperUnitofWork : IUnitofWork
    {
        public IDbConnection Connection { get; set; }
        public IDbTransaction Transaction { get; set; }

        public void Open(string connString)
        {
            Connection = InitDapperConnection.setupConnection(connString);
            Connection.Open();
        }

        public void BeginTransaction()
        {
            Transaction = Connection.BeginTransaction();
        }

        public void RollbackTransaction()
        {
            Transaction.Rollback();
        }

        public void CommitTransaction()
        {
            Transaction.Commit();
        }

        public void Dispose()
        {
            if (this.Connection != null)
            {
                Connection.Dispose();
                Connection.Close();
                Connection = null;
            }
        }
    }
}
