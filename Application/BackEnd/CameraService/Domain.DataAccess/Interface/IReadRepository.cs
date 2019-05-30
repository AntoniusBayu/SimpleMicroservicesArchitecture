using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Domain.DataAccess
{
    public interface IReadRepository<T> where T : class
    {
        IList<T> ReadAllData();
        IList<T> ReadByFilter(Expression<Func<T, bool>> lambda);
    }
}
