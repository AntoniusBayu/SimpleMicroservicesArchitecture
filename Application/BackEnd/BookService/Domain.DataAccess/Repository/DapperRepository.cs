using Dapper.Contrib.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
namespace Domain.DataAccess
{
    public abstract class DapperBaseRepository<T> : ITransactionRepository<T>, IReadDataRepository<T> where T : class
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

        public async Task AddAsync(T data)
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

        public async Task DeleteAsync(T data)
        {
            await _uow._Connection.DeleteAsync<T>(data, _uow._Transaction);
        }

        public virtual void Update(T data)
        {
            this._uow._Connection.Update<T>(data, _uow._Transaction);
        }

        public async Task UpdateAsync(T data)
        {
            await _uow._Connection.UpdateAsync<T>(data, _uow._Transaction);
        }

        public virtual IQueryable<T> ReadAllData()
        {
            return this._uow._Connection.GetAll<T>().AsQueryable();
        }

        public virtual IQueryable<T> ReadByFilter(System.Linq.Expressions.Expression<Func<T, bool>> lambda)
        {
            return this._uow._Connection.GetAll<T>().AsQueryable().Where(lambda);
        }
    }
}
