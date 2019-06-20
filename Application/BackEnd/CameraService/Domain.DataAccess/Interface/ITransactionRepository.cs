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
        void Delete(T data);
        void Delete(T data, Expression<Func<T, bool>> lambda);
        Task DeleteAsync(T data);
        Task DeleteAsync(T data, Expression<Func<T, bool>> lambda);
        void Update(T data);
        void Update(T data, Expression<Func<T, bool>> lambda);
        Task UpdateAsync(T data);
        Task UpdateAsync(T data, Expression<Func<T, bool>> lambda);
    }
}
