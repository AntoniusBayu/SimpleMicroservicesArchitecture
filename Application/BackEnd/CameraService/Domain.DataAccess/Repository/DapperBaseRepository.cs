using Dapper.Contrib.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public abstract class DapperBaseRepository<T> : ITransactionRepository<T>, IReadRepository<T> where T : class
    {
        private DapperUnitofWork _uow { get; set; }

        public DapperBaseRepository(IUnitofWork uow)
        {
            _uow = (DapperUnitofWork)uow;
        }

        public virtual void Add(T data)
        {
            this._uow._Connection.Insert<T>(data, _uow._Transaction);
        }

        public virtual async Task AddAsync(T data)
        {
            await _uow._Connection.InsertAsync<T>(data, _uow._Transaction);
        }

        public virtual void AddBulk(List<T> data)
        {
            this._uow._Connection.Insert(data, _uow._Transaction);
        }

        public virtual void Delete(T data)
        {
            this._uow._Connection.Delete<T>(data, _uow._Transaction);
        }

        public void Delete(T data, Expression<Func<T, bool>> lambda)
        {
            throw new NotImplementedException();
        }

        public virtual async Task DeleteAsync(T data)
        {
            await _uow._Connection.DeleteAsync<T>(data, _uow._Transaction);
        }

        public Task DeleteAsync(T data, Expression<Func<T, bool>> lambda)
        {
            throw new NotImplementedException();
        }

        public virtual void Update(T data)
        {
            this._uow._Connection.Update<T>(data, _uow._Transaction);
        }

        public void Update(T data, Expression<Func<T, bool>> lambda)
        {
            throw new NotImplementedException();
        }

        public virtual async Task UpdateAsync(T data)
        {
            await _uow._Connection.UpdateAsync<T>(data, _uow._Transaction);
        }

        public Task UpdateAsync(T data, Expression<Func<T, bool>> lambda)
        {
            throw new NotImplementedException();
        }

        public virtual IList<T> ReadAllData()
        {
            return this._uow._Connection.GetAll<T>(_uow._Transaction).ToList();
        }

        public virtual IList<T> ReadByFilter(Expression<Func<T, bool>> lambda)
        {
            return this._uow._Connection.GetAll<T>(_uow._Transaction).AsQueryable().Where(lambda).ToList();
        }
    }
}
