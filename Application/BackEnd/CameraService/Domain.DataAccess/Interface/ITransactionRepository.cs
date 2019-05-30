using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public interface ITransactionRepository<T> where T : class
    {
        void Add(T data);
        Task AddAsync(T data);
        void AddBulk(List<T> data);
        void Delete(Expression<Func<T, bool>> lambda);
        Task DeleteAsync(Expression<Func<T, bool>> lambda);
        void Update(T data);
        Task UpdateAsync(T data);
    }
}
