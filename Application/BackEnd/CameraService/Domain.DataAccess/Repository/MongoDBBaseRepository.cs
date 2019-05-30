using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public abstract class MongoDBBaseRepository<T> : ITransactionRepository<T>, IReadRepository<T> where T : class
    {
        protected MongoDBUnitofWork _uow;
        protected IMongoCollection<T> _collection;

        public MongoDBBaseRepository(IUnitofWork uow)
        {
            _uow = (MongoDBUnitofWork)uow;
            _collection = _uow._database.GetCollection<T>(typeof(T).Name.ToLower());
        }
        public void Add(T data)
        {
            _collection.InsertOne(data);
        }

        public async Task AddAsync(T data)
        {
            await _collection.InsertOneAsync(data);
        }

        public void AddBulk(List<T> data)
        {
            _collection.InsertMany(data);
        }

        public void Delete(Expression<Func<T, bool>> lambda)
        {
            _collection.DeleteOne(lambda);
        }

        public async Task DeleteAsync(Expression<Func<T, bool>> lambda)
        {
            await _collection.DeleteOneAsync(lambda);
        }

        public IList<T> ReadAllData()
        {
            return _collection.Find(new BsonDocument()).ToList();
        }

        public IList<T> ReadByFilter(Expression<Func<T, bool>> lambda)
        {
            return _collection.Find(lambda).ToList();
        }

        public void Update(T data)
        {
            throw new System.NotImplementedException();
        }

        public Task UpdateAsync(T data)
        {
            throw new System.NotImplementedException();
        }
    }
}
