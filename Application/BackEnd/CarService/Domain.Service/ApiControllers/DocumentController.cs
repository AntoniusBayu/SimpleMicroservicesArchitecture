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

namespace Domain.Service.ApiControllers
{
    [AutoInvalidateCacheOutput]
    [RoutePrefix("api/document")]
    public class DocumentController : BaseController
    {
        private IMstDocumentDomain _DocDomain { get; set; }
        private IMstLogDomain _logDomain { get; set; }

        public DocumentController(IMstDocumentDomain docDomain, IMstLogDomain logDomain)
        {
            _DocDomain = docDomain;
            _logDomain = logDomain;
        }

        /// <summary>
        /// Get Document URL Based on ID
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet, Route("getDocURL")]
        public HttpResponseMessage getDocURL(int id)
        {
            mstDocument doc = new mstDocument();

            try
            {
                doc = _DocDomain.LoadDoc(id);
                return ApiResponse(ApiResullt.Ok, doc);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Save Document
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPost, Route("postDocument")]
        public HttpResponseMessage Post([FromBody]mstDocument data)
        {
            try
            {
                _DocDomain.SaveData(data);

                return ApiResponse(ApiResullt.Ok, SaveSuccessful);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }

        /// <summary>
        /// Get Latest Document ID
        /// </summary>
        /// <returns></returns>
        [HttpGet, Route("GetLatestDocID")]
        public HttpResponseMessage GetLatestDocumentID()
        {
            long docID;

            try
            {
                docID = _DocDomain.GetLatestDocID();
                return ApiResponse(ApiResullt.Ok, docID);
            }
            catch (Exception ex)
            {
                _log.Error(ex, tokenValue);
                return ApiResponse(ApiResullt.Failed);
            }
        }
    }
}