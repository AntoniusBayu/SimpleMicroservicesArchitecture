using Domain.Business;
using Microsoft.AspNetCore.Mvc;

namespace Domain.Service.Controllers
{
    public class BaseController : ControllerBase
    {
        protected IMstLogDomain _log { get; set; }
        protected const string SaveSuccessful = "Data has been saved successfully";
        protected const string UpdateSuccessful = "Data has been updated successfully";
        protected const string DeleteSuccessful = "Data has been deleted successfully";

        protected const string GlobalErrorMessage = "Ooops Something went wrong!";
        protected string tokenValue { get { return string.IsNullOrEmpty(Request.Headers["token"]) ? Request.Headers["token"].ToString() : string.Empty; } }

        protected enum ApiResullt
        {
            Ok = 1,
            Failed = 2
        }

        protected virtual IActionResult ApiResponse(ApiResullt result, object data = null)
        {
            IActionResult response;

            if (result == ApiResullt.Failed)
            {
                response = BadRequest(GlobalErrorMessage);
            }
            else
            {
                response = Ok(new { dataObject = data });
            }
            return response;
        }
    }
}