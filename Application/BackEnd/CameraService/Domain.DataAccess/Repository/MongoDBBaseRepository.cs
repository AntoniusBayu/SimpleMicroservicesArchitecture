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
        public virtual void Add(T data)
        {
            _collection.InsertOne(data);
        }

        public virtual async Task AddAsync(T data)
        {
            await _collection.InsertOneAsync(data);
        }

        public virtual void AddBulk(List<T> data)
        {
            _collection.InsertMany(data);
        }
        public virtual void Delete(T data)
        {
            throw new NotImplementedException();
        }

        public virtual void Delete(T data, Expression<Func<T, bool>> lambda)
        {
            _collection.DeleteOne<T>(lambda);
        }

        public Task DeleteAsync(T data)
        {
            throw new NotImplementedException();
        }

        public virtual async Task DeleteAsync(T data, Expression<Func<T, bool>> lambda)
        {
            await _collection.DeleteOneAsync<T>(lambda);
        }

        public virtual IList<T> ReadAllData()
        {
            return _collection.Find(new BsonDocument()).ToList();
        }

        public virtual IList<T> ReadByFilter(Expression<Func<T, bool>> lambda)
        {
            return _collection.Find(lambda).ToList();
        }

        public void Update(T data)
        {
            throw new NotImplementedException();
        }

        public void Update(T data, Expression<Func<T, bool>> lambda)
        {
            _collection.ReplaceOne<T>(lambda, data);
        }

        public Task UpdateAsync(T data)
        {
            throw new NotImplementedException();
        }

        public async Task UpdateAsync(T data, Expression<Func<T, bool>> lambda)
        {
            await _collection.ReplaceOneAsync<T>(lambda, data);
        }
    }
}
