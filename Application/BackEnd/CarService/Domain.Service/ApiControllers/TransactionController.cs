using Domain.DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using NLog;
using System.Reflection;
using Ninject;
using Domain.Business;
using WebApi.OutputCache.V2;
using Domain.Logging;

namespace Domain.Service
{
    [AutoInvalidateCacheOutput]
    [RoutePrefix("api/transaction")]
    public class TransactionController : BaseController
    {
        private IMstCarDomain _carDomain { get; set; }
        private IMstSparePartDomain _spDomain { get; set; }
        private IMstLogDomain _logDomain { get; set; }

        /// <summary>
        /// Bingung. Ini constructor diisi dari mana? Bingung? pusing?
        /// Dibawah ini, gue menggunakan yang namanya dependency injection. Pake Ninject
        /// Lagi lagi, ini tuh design pattern.
        /// Singkatnya gini, Sebenernya kalo nggak kepepet untuk business logic kita menghindari pemanggilan concrete class
        /// Kenapa? Nih misal Andai kita punya custom logging tools yang inherit dari interface ILog (yang kayak dibawah ini)
        /// Sejatinya gue saat ini membuat logging ke dalam database. makanya gue bikin class databaselogging inherit dari Ilog
        /// Ninject membantu kita mencentralized settingan kalau gue tembak Ilog dari api controller secara otomatis yang kepanggil adalah class databaselogging
        /// Jadi gue gak tergantung harus lempar class database logging buat ngelog activity
        /// Nah pertanyaannya, andai kedepan database amit amit udah penuh. udah gak bisa insert data. Pasti ngelog ke database error juga kan?
        /// Salah satu solusinya apa? kita bikin logging ke txtfile. Kita bikin class baru letsay txtlogging yang inherit Ilog.
        /// Nah nanti di Ninject, kita tinggal ubah yang tadinya ILog ke database logging sekarang ILog ke txtLogging.
        /// Once kita ubah di ninject. Semua langsung bahagia. Simple bukan?
        /// </summary>
        /// <param name="carDomain"></param>
        /// <param name="spDomain"></param>
        public TransactionController(IMstCarDomain carDomain, IMstSparePartDomain spDomain, IMstLogDomain logDomain)
        {
            _carDomain = carDomain;
            _spDomain = spDomain;
            _logDomain = logDomain;
        }

        /// <summary>
        /// Get All Data
        /// </summary>
        /// <returns></returns>
        [HttpGet, Route("")]
        [CacheOutput(ClientTimeSpan = 30, ServerTimeSpan = 30, ExcludeQueryStringFromCacheKey = true)]
        public HttpResponseMessage Get()
        {
            List<mstCar> listCar = new List<mstCar>();

            try
            {
                listCar = _carDomain.ReadAll();
                return ApiResponse(ApiResullt.Ok, listCar);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Read Data by paging
        /// </summary>
        /// <returns></returns>
        [HttpPost, Route("getPaging")]
        [CacheOutput(ClientTimeSpan = 30, ServerTimeSpan = 30, ExcludeQueryStringFromCacheKey = true)]
        public HttpResponseMessage GetDataByPaging([FromBody]mstCar data)
        {
            List<mstCar> listCar = new List<mstCar>();

            try
            {
                listCar = _carDomain.ReadByPaging(data);
                return ApiResponse(ApiResullt.Ok, listCar);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Get Data for Dashboard
        /// </summary>
        /// <returns></returns>
        [SkipGlobalActionFilterAttribute]
        [HttpGet, Route("getDashboard")]
        [CacheOutput(ClientTimeSpan = 30, ServerTimeSpan = 30, ExcludeQueryStringFromCacheKey = true)]
        public HttpResponseMessage GetDashboard()
        {
            DashboardViewModel data = new DashboardViewModel();

            try
            {
                data = _logDomain.GetDataDashboard();
                return ApiResponse(ApiResullt.Ok, data);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Get Data for Chart Dashboard
        /// </summary>
        /// <returns></returns>
        [HttpGet, Route("getDashboard2")]
        [CacheOutput(ClientTimeSpan = 30, ServerTimeSpan = 30, ExcludeQueryStringFromCacheKey = true)]
        public HttpResponseMessage GetDashboard2()
        {
            List<DashboardModel> list = new List<DashboardModel>();

            try
            {
                list = _logDomain.GetDataChart();
                return ApiResponse(ApiResullt.Ok, list);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Post data
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPost, Route("postCar")]
        public HttpResponseMessage Post([FromBody]mstCar data)
        {
            try
            {
                _carDomain.SaveData(data);

                return ApiResponse(ApiResullt.Ok, SaveSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Post Car Rame an
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPost, Route("postCarBulk")]
        public HttpResponseMessage Post([FromBody]List<mstCar> data)
        {
            try
            {
                _carDomain.SaveDataBulk(data);

                return ApiResponse(ApiResullt.Ok, SaveSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// put car
        /// </summary>
        /// <param name="id"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPut, Route("putCar")]
        public HttpResponseMessage Put([FromBody]mstCar data)
        {
            try
            {
                _carDomain.EditData(data);

                return ApiResponse(ApiResullt.Ok, UpdateSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// delete car
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete, Route("deleteCar/{id}")]
        public HttpResponseMessage Delete(int id)
        {
            var data = new mstCar();

            try
            {
                data.AutoID = id;
                _carDomain.DeleteData(data);

                return ApiResponse(ApiResullt.Ok, DeleteSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Post data
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPost, Route("postFacadeCar")]
        public HttpResponseMessage Post([FromBody]CarViewModel data)
        {
            var facade = new CarTransactionFacade(_uow, _carDomain, _spDomain);

            try
            {
                facade.Save(data);
                return ApiResponse(ApiResullt.Ok, SaveSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }
    }
}