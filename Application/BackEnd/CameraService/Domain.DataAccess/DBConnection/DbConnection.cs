namespace Domain.DataAccess
{
    public partial class DbConnection
    {
        public DapperUnitofWork InitDapper(string connString)
        {
            DapperUnitofWork uow = new DapperUnitofWork();
            uow.OpenConnection(connString);

            return uow;
        }

        public MongoDBUnitofWork InitMongoDB(string connString, string tableName)
        {
            MongoDBUnitofWork uow = new MongoDBUnitofWork();
            uow.OpenConnection(connString, tableName);

            return uow;
        }
    }

    public enum DbEngine
    {
        SQLServer = 1,
        MongoDB = 2
    }
}
