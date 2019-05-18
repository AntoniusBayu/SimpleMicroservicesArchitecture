using System.Collections.Generic;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public interface ITransactionRepository<T> where T : class
    {
        void Add(T data);
        Task AddAsync(T data);
        void AddBulk(List<T> data);
        void Delete(T data);
        Task DeleteAsync(T data);
        void Update(T data);
        Task UpdateAsync(T data);
    }
}
