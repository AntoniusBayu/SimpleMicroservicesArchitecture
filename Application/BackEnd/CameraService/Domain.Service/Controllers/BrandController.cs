using Domain.Business;
using Domain.DataAccess;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Domain.Service.Controllers
{
    [Route("api/Brand")]
    [ApiController]
    public class BrandController : BaseController
    {
        private readonly IMstBrandDomain _mstDomain;

        public BrandController(IServiceProvider serviceProvider)
        {
            this._mstDomain = serviceProvider.GetRequiredService<IMstBrandDomain>();
            base._log = serviceProvider.GetRequiredService<IMstLogDomain>();
        }

        [HttpPost, Route("postBrand")]
        public IActionResult postBook(mstBrand data)
        {
            try
            {
                _mstDomain.CreateData(data);

                return ApiResponse(ApiResullt.Ok, SaveSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        [HttpGet, Route("getBrand")]
        public IActionResult getBook()
        {
            List<mstBrand> listResult = new List<mstBrand>();

            try
            {
                listResult = _mstDomain.ReadData().ToList();

                return ApiResponse(ApiResullt.Ok, listResult);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }
    }
}