using Domain.DataAccess;
using Microsoft.Extensions.Configuration;
using System;
using System.Diagnostics;

namespace Domain.Business
{
    public class mstLogDomain : BaseDomain, IMstLogDomain
    {
        private DapperUnitofWork _uow;
        private mstLog _mstLog = new mstLog();

        public mstLogDomain(IConfiguration config)
        {
            base._config = config;
        }

        public void Debug(string message)
        {
            _mstLog.Level = "DEBUG";
            _mstLog.ActivityMessage = message;
            Save();
        }

        public void Debug(string message, object data)
        {
            _mstLog.Level = "DEBUG";
            _mstLog.ActivityMessage = string.Format(message, data);
            Save();
        }

        public void Error(Exception ex, string key)
        {
            _mstLog.Level = "ERROR";
            _mstLog.Token = key;
            handleError(ex);
            Save();
        }

        public void Info(string message)
        {
            _mstLog.Level = "INFO";
            _mstLog.ActivityMessage = message;
            Save();
        }

        public void Info(string message, object data)
        {
            _mstLog.Level = "INFO";
            _mstLog.ActivityMessage = string.Format(message, data);
            Save();
        }

        public void Save()
        {

            try
            {
                _uow = new DapperUnitofWork();
                _uow.OpenSQLConnection(base.dbConn);
                _uow.BeginTransaction();

                var repo = new mstLogRepository(_uow);
                repo.Add(_mstLog);

                _uow.CommitTransaction();
            }
            catch (Exception)
            {
                _uow.RollbackTransaction();
            }
            finally
            {
                _uow.Dispose();
            }
        }

        public void Setup(mstLog data)
        {
            _mstLog.ActionName = data.ActionName;
            _mstLog.ControllerName = data.ControllerName;
            _mstLog.CreatedDate = data.CreatedDate;
            _mstLog.RequestID = data.RequestID;
            _mstLog.RequestMethod = data.RequestMethod;
            _mstLog.Token = data.Token;
        }

        private void handleError(Exception ex)
        {
            var st = new StackTrace(ex, true);
            string strMessage = string.Empty;
            string errMessage = string.Empty;

            for (var i = st.FrameCount - 1; i >= 0; i--)
            {
                var frame = st.GetFrame(i);
                if (frame.GetFileLineNumber() > 0)
                {
                    strMessage += "# Class : " + frame.GetMethod().DeclaringType.Name + ", Method : " + frame.GetMethod().Name + ", Line Number : " + frame.GetFileLineNumber() + "  ";
                }
            }

            if (ex.InnerException != null)
            {
                errMessage = ex.InnerException.Message;
            }
            else
            {
                errMessage = ex.Message;
            }

            _mstLog.ActivityMessage = string.Format("Error Message : {0} ||| Error StackTrace : {1} ", errMessage, strMessage);
            _mstLog.ActionName = string.Empty;
            _mstLog.ControllerName = string.Empty;
            _mstLog.CreatedDate = DateTime.Now;
            _mstLog.RequestID = Guid.NewGuid();
            _mstLog.RequestMethod = string.Empty;
        }
    }
}
