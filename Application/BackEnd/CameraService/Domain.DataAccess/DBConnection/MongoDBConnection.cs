using MongoDB.Driver;

namespace Domain.DataAccess
{
    public abstract class MongoDBConnection : IConnection
    {
        public IMongoClient _client;
        public IMongoDatabase _database;
        public IClientSession _session;

        public void Dispose()
        {
            _session.Dispose();
        }

        public void OpenConnection(string connString, string dbName = "")
        {
            _client = new MongoClient(connString);
            _database = _client.GetDatabase(dbName);
            _session = _client.StartSession();
        }
    }
}
