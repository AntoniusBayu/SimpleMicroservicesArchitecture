using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using Domain.Business;
using Domain.DataAccess;
using System.Web;
using System.ServiceModel.Channels;
using System;
using Newtonsoft.Json;
using Domain.Logging;


namespace Domain.Service
{
    public class SkipGlobalActionFilterAttribute : Attribute
    {
    }

    public class WebApiAuthorizationAttribute : ActionFilterAttribute
    {
        private const string Token = "Token";
        private ILog _log { get; set; }
        private IMstUserPrivilegeDomain _userDomain { get; set; }
        private mstLog _mstLog = new mstLog();
        private bool _exclude { get; set; }

        /// <summary>
        /// Check auth and Logging before Executing Action
        /// </summary>
        /// <param name="actionContext"></param>
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            if (actionContext.ActionDescriptor.GetCustomAttributes<SkipGlobalActionFilterAttribute>().Any())
            {
                return;
            }

            _log = actionContext.Request.GetDependencyScope().GetService(typeof(ILog)) as ILog;
            _userDomain = actionContext.Request.GetDependencyScope().GetService(typeof(IMstUserPrivilegeDomain)) as IMstUserPrivilegeDomain;

            var controllerName = actionContext.ActionDescriptor.ControllerDescriptor.ControllerName;
            var actionName = actionContext.ActionDescriptor.ActionName;
            var requestMethod = actionContext.Request.Method.Method;
            var ipAddress = GetClientIpAddress(actionContext);
            var tokenValue = actionContext.Request.Headers.Contains(Token) ? actionContext.Request.Headers.GetValues(Token).First() : string.Empty;

            _mstLog.RequestID = Guid.NewGuid();
            _mstLog.ControllerName = controllerName;
            _mstLog.ActionName = actionName;
            _mstLog.RequestMethod = requestMethod;
            _mstLog.CreatedDate = DateTime.Now;
            _mstLog.Token = tokenValue;

            _log.Setup(_mstLog);

            try
            {
                _log.Info("Start Invoke......");

                if (!string.IsNullOrEmpty(tokenValue))
                {
                    var param = new mstUserPrivilege();

                    _log.Info("IP Address : {0} ", ipAddress);

                    param.Token = tokenValue;
                    param.Controller = controllerName;
                    param.RequestMethod = requestMethod;

                    if (actionContext.ActionArguments.Count > 0)
                    {
                        _log.Debug("Parameter(s) : {0} ", getListParameter(actionContext));
                    }

                    if (!_userDomain.ValidatePrivilege(param))
                    {
                        actionContext.Response = new HttpResponseMessage(HttpStatusCode.Forbidden) { Content = new StringContent("Ooopss... You are not allowed to access this resource") };
                    }
                }
                else
                {
                    _log.Info("Unauthorized user, ip address : {0} ", ipAddress);
                    actionContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized) { Content = new StringContent("You are unauthorized to access this resource") };
                }
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                actionContext.Response = new HttpResponseMessage(HttpStatusCode.BadRequest) { Content = new StringContent("Ooops... Something went wrong!") };
            }
            base.OnActionExecuting(actionContext);
        }

        /// <summary>
        /// Get IP client
        /// </summary>
        /// <param name="actionContext"></param>
        /// <returns></returns>
        private string GetClientIpAddress(HttpActionContext actionContext)
        {
            HttpRequestMessage request = actionContext.Request;

            if (request.Properties.ContainsKey("MS_HttpContext"))
            {
                return ((HttpContextWrapper)request.Properties["MS_HttpContext"]).Request.UserHostAddress;
            }
            else if (request.Properties.ContainsKey(RemoteEndpointMessageProperty.Name))
            {
                RemoteEndpointMessageProperty prop = (RemoteEndpointMessageProperty)request.Properties[RemoteEndpointMessageProperty.Name];
                return prop.Address;
            }
            else if (HttpContext.Current != null)
            {
                return HttpContext.Current.Request.UserHostAddress;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Convert to JSON Object
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        private string ToJsonObject(object data)
        {
            return JsonConvert.SerializeObject(data);
        }

        /// <summary>
        /// Get list paramater
        /// </summary>
        /// <param name="actionContext"></param>
        /// <returns></returns>
        private string getListParameter(HttpActionContext actionContext)
        {
            string param = string.Empty;

            foreach (var x in actionContext.ActionArguments)
            {
                param += ToJsonObject(x);
            }

            return param;
        }
    }
}