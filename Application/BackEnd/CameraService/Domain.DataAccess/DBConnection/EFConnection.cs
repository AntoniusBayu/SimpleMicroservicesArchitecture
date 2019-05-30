using Microsoft.EntityFrameworkCore;
using System;

namespace Domain.DataAccess
{
    public abstract class EFConnection : DbContext, IConnection
    {
        public EFConnection() { }
        public EFConnection(DbContextOptions opt) : base(opt)
        {

        }
        public DbSet<mstCamera> mstCamera { get; set; }

        public override void Dispose()
        {
            base.Database.CloseConnection();
        }

        public void OpenConnection(string connString, string dbName = "")
        {
            base.Database.OpenConnection();
        }
    }
}
