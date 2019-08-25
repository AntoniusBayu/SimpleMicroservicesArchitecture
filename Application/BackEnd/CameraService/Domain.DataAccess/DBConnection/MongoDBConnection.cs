using MongoDB.Driver;

namespace Domain.DataAccess
{
    public abstract class MongoDBConnection : IConnection
    {
        public IMongoClient _client;
        public IMongoDatabase _database;
        public IClientSession _session;

        public virtual void Dispose()
        {
            this._session.Dispose();
        }

        public virtual void OpenConnection(string connString, string dbName = "")
        {
            this._client = new MongoClient(connString);
            this._database = _client.GetDatabase(dbName);
            this._session = _client.StartSession();
        }
    }
}
