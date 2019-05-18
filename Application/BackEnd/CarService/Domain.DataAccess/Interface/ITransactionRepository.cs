using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public interface ITransactionRepository<T> where T : class
    {
        void Add(T data);
        void AddBulk(List<T> data);
        void Delete(T data);
        void Edit(T data);
    }
}
