using Domain.Business;
using Domain.DataAccess;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Domain.Service.Controllers
{
    [Route("api/Camera")]
    [ApiController]
    public class CameraController : BaseController
    {
        private readonly IMstCameraDomain _mstDomain;

        public CameraController(IServiceProvider serviceProvider)
        {
            this._mstDomain = serviceProvider.GetRequiredService<IMstCameraDomain>();
            base._log = serviceProvider.GetRequiredService<IMstLogDomain>();
        }

        [HttpPost, Route("postCamera")]
        public IActionResult postCamera(mstCamera data)
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

        [HttpGet, Route("getCamera")]
        public IActionResult getCamera(string strBrand)
        {
            mstCamera param = new mstCamera();
            List<mstCamera> listResult = new List<mstCamera>();

            try
            {
                param.Brand = strBrand;
                listResult = _mstDomain.ReadData(param).ToList();

                return ApiResponse(ApiResullt.Ok, listResult);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        [HttpPut, Route("putCamera")]
        public IActionResult putCamera(mstCamera data)
        {
            try
            {
                _mstDomain.UpdateData(data);

                return ApiResponse(ApiResullt.Ok, UpdateSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        [HttpDelete, Route("deleteCamera/{strBrand}")]
        public IActionResult deleteCamera(string strBrand)
        {
            try
            {
                mstCamera data = new mstCamera();
                data.Brand = strBrand;

                _mstDomain.DeleteData(data);

                return ApiResponse(ApiResullt.Ok, DeleteSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }
    }
}