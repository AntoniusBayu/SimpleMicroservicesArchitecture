using Domain.Business;
using Domain.DataAccess;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;

namespace Domain.Service.Controllers
{
    [Route("api/book")]
    [ApiController]
    public class BookController : BaseController
    {
        private readonly IMstBookDomain _mstDomain;

        public BookController(IServiceProvider serviceProvider)
        {
            this._mstDomain = serviceProvider.GetRequiredService<IMstBookDomain>();
            base._log = serviceProvider.GetRequiredService<IMstLogDomain>();
        }

        [HttpPost, Route("postBook")]
        public IActionResult postBook(mstBook data)
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

        [HttpGet, Route("getBook")]
        public IActionResult getBook(string description)
        {
            mstBook paramBook = new mstBook();
            List<mstBook> listResult = new List<mstBook>();

            try
            {
                paramBook.Description = description;
                listResult = _mstDomain.ReadData(paramBook);

                return ApiResponse(ApiResullt.Ok, listResult);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        [HttpPut, Route("putBook")]
        public IActionResult putBook(mstBook data)
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

        [HttpDelete, Route("deleteBook/{serialNo}")]
        public IActionResult deleteBook(string serialNo)
        {
            try
            {
                _mstDomain.DeleteData(serialNo);

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