using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public abstract class EFBaseRepository<T> : ITransactionRepository<T>, IReadRepository<T> where T : class
    {
        protected EFUnitofWork _uow;
        public EFBaseRepository(IUnitofWork uow)
        {
            _uow = (EFUnitofWork)uow;
        }
        public void Add(T data)
        {
            _uow.Set<T>().Add(data);
        }

        public async Task AddAsync(T data)
        {
            await _uow.Set<T>().AddAsync(data);
        }

        public void AddBulk(List<T> data)
        {
            foreach (var x in data)
            {
                _uow.Set<T>().Add(x);
            }
        }

        public void Delete(Expression<Func<T, bool>> lambda)
        {
            var entity = _uow.Set<T>().Where(lambda).ToList();

            foreach (var x in entity)
            {
                _uow.Set<T>().Remove(x);
            }
        }

        public async Task DeleteAsync(Expression<Func<T, bool>> lambda)
        {
            var entity = _uow.Set<T>().Where(lambda).ToList();

            foreach (var x in entity)
            {
                _uow.Set<T>().Remove(x);
            }
        }

        public IList<T> ReadAllData()
        {
            return _uow.Set<T>().ToList();
        }

        public IList<T> ReadByFilter(Expression<Func<T, bool>> lambda)
        {
            return _uow.Set<T>().Where(lambda).ToList();
        }

        public void Update(T data)
        {
            _uow.Set<T>().Update(data);
        }

        public async Task UpdateAsync(T data)
        {
            _uow.Set<T>().Update(data);
        }
    }
}
