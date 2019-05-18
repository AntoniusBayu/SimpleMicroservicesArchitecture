using Domain.Business;
using Domain.DataAccess;
using Domain.Logging;
using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Domain.Service
{
    public class NinjectResolver : IDependencyResolver
    {
        private IKernel _kernel;

        public NinjectResolver(IKernel kernel)
        {
            _kernel = kernel;
            AddBindings();
        }

        public object GetService(Type serviceType)
        {
            return _kernel.TryGet(serviceType);
        }

        public IEnumerable<object> GetServices(Type serviceType)
        {
            return _kernel.GetAll(serviceType);
        }

        private void AddBindings()
        {
            _kernel.Bind<IMstCarDomain>().To<mstCarDomain>().InSingletonScope();
            _kernel.Bind<IMstSparePartDomain>().To<mstSparePartDomain>().InSingletonScope();
            _kernel.Bind<IMstUserPrivilegeDomain>().To<mstUserPrivilegeDomain>().InSingletonScope();
            _kernel.Bind<IMstLogDomain>().To<mstLogDomain>().InSingletonScope();
            _kernel.Bind<IMstDocumentDomain>().To<mstDocumentDomain>().InSingletonScope();
            _kernel.Bind<IUnitofWork>().To<DapperUnitofWork>().InSingletonScope();
            _kernel.Bind<ILog>().To<DatabaseLogging>().InSingletonScope();
        }
    }
}