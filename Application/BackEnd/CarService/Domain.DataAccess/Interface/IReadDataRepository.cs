using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Domain.DataAccess
{
    public interface IReadDataRepository<T> where T : class
    {
        IQueryable<T> ReadAllData();
        IQueryable<T> ReadByFilter(Expression<Func<T, bool>> lambda);
    }
}
