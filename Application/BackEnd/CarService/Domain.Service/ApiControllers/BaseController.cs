using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Mvc;
using Domain.DataAccess;
using Domain.Logging;

namespace Domain.Service
{
    public abstract class BaseController : ApiController
    {
        protected IUnitofWork _uow { get; set; }
        protected ILog _log { get; set; }

        protected const string SaveSuccessful = "Data has been saved successfully";
        protected const string UpdateSuccessful = "Data has been updated successfully";
        protected const string DeleteSuccessful = "Data has been deleted successfully";

        protected const string GlobalErrorMessage = "Ooops Something went wrong!";

        protected string tokenValue { get { return Request.Headers.Contains("Token") ? Request.Headers.GetValues("Token").First() : string.Empty; } }

        public BaseController()
        {
            _log = System.Web.Mvc.DependencyResolver.Current.GetService<ILog>();
            _uow = System.Web.Mvc.DependencyResolver.Current.GetService<IUnitofWork>();
        }

        protected enum ApiResullt
        {
            Ok = 1,
            Failed = 2
        }

        protected virtual HttpResponseMessage ApiResponse(ApiResullt result, object data = null)
        {
            HttpResponseMessage response;

            if (result == ApiResullt.Failed)
            {
                response = Request.CreateResponse(HttpStatusCode.BadRequest, GlobalErrorMessage);
            }
            else
            {
                response = Request.CreateResponse(HttpStatusCode.OK, new { dataObject = data });
            }
            return response;
        }
    }
}