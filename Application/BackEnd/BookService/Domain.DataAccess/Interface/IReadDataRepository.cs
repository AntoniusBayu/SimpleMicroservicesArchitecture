using System;
using System.Linq;
using System.Linq.Expressions;

namespace Domain.DataAccess
{
    public interface IReadDataRepository<T> where T : class
    {
        IQueryable<T> ReadAllData();
        IQueryable<T> ReadByFilter(Expression<Func<T, bool>> lambda);
    }
}
