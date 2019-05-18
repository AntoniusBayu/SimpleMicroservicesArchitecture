using Domain.Business;
using Domain.Logging;
using Ninject;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace Domain.Service
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_PreSendRequestHeaders()
        {
            Response.Headers.Set("Server", "Anjay Server");
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            MvcHandler.DisableMvcResponseHeader = true;
        }

        protected void Application_Error()
        {
            var ex = Server.GetLastError();
            ILog _log;

            _log = System.Web.Mvc.DependencyResolver.Current.GetService<ILog>();

            _log.Error(ex, string.Empty);
        }
    }
}
