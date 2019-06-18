using System;
using System.Collections.Generic;
using System.Linq;
using Dapper.Contrib.Extensions;
using System.Data;

namespace Domain.DataAccess
{
    /// <summary>
    /// Base Repository class. Ini uwe pake ORM Dapper. Enak toooo....
    /// Repository itu bagian dari design pattern.
    /// Singkatnya repository pattern itu kayak transportasi aja. sebuah pattern yang hanya menerima dan mengirimkan/mengantarkan data dari code ke database, begitupun dari database ke kode.
    /// Jadi tidak ada tuh namanya business logic disini.
    /// Coba di google Repository Pattern
    /// Hayooo..........
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class BaseRepository<T> : ITransactionRepository<T>, IReadDataRepository<T> where T : class
    {
        protected IUnitofWork _uow;

        /// <summary>
        /// Add Data based on generic class
        /// Enak to nggak usah bikin script sql insert intooo........
        /// Semua langsung bahagia
        /// </summary>
        /// <param name="data"></param>
        public virtual void Add(T data)
        {
            this._uow.Connection.Insert<T>(data, _uow.Transaction);
        }

        /// <summary>
        /// Add bulky
        /// </summary>
        /// <param name="data"></param>
        public virtual void AddBulk(List<T> data)
        {
            this._uow.Connection.Insert(data, _uow.Transaction);
        }

        /// <summary>
        /// Delete ini berdasarkan key yang ditentuin di property tiap model
        /// jadi tentuin key nya dulu broo...
        /// </summary>
        /// <param name="data"></param>
        public virtual void Delete(T data)
        {
            this._uow.Connection.Delete<T>(data, _uow.Transaction);
        }

        /// <summary>
        /// Edit ini berdasarkan key yang ditentuin di property tiap model
        /// jadi tentuin key nya dulu broo...
        /// </summary>
        /// <param name="data"></param>
        public virtual void Edit(T data)
        {
            this._uow.Connection.Update<T>(data, _uow.Transaction);
        }

        /// <summary>
        /// Ini read all data tanpa filter
        /// inget tanpa filter. kalo mau pake filter pake ReadByFilter
        /// </summary>
        /// <returns></returns>
        public virtual IQueryable<T> ReadAllData()
        {
            return this._uow.Connection.GetAll<T>().AsQueryable();
        }

        /// <summary>
        /// Nah ini dia. Read data by filter.
        /// Pake ini bro kalo mau pake where where an
        /// Where nya pake lambda expression
        /// </summary>
        /// <param name="lambda"></param>
        /// <returns></returns>
        public virtual IQueryable<T> ReadByFilter(System.Linq.Expressions.Expression<Func<T, bool>> lambda)
        {
            return this._uow.Connection.GetAll<T>().AsQueryable().Where(lambda);
        }
    }
}
