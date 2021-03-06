﻿using Domain.Business;
using Domain.DataAccess;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using System;

namespace Domain.Service
{
    public class BookFilter : IActionFilter
    {
        private const string Token = "Token";
        private IMstLogDomain _log { get; set; }
        private mstLog _mstLog = new mstLog();

        public BookFilter(IMstLogDomain log)
        {
            this._log = log;
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            var controllerActionDescriptor = context.ActionDescriptor as ControllerActionDescriptor;

            var controllerName = controllerActionDescriptor.ControllerName;
            var actionName = controllerActionDescriptor.ActionName;
            var requestMethod = context.HttpContext.Request.Method;
            var ipAddress = context.HttpContext.Connection.RemoteIpAddress;
            var tokenValue = (context.HttpContext.Request.Headers.TryGetValue("token", out var authorizationToken)) ? authorizationToken.ToString() : string.Empty;

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
                    _log.Info("IP Address : {0} ", ipAddress);
                }
                else
                {
                    _log.Info("Unauthorized user, ip address : {0} ", ipAddress);
                    context.Result = new BadRequestObjectResult("Unauthorized user");
                }
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                context.Result = new BadRequestObjectResult("Ooops Error");
            }
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
            // Do something after the action executes.
        }
    }
}
