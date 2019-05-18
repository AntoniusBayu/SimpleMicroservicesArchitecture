using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;
using System.Diagnostics;
using System.Data.SqlClient;

namespace Domain.Logging
{
    public class DatabaseLogging : ILog
    {
        private IUnitofWork _uow;
        private mstLog _mstLog = new mstLog();

        public DatabaseLogging(IUnitofWork uow)
        {
            _uow = uow;
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

        public void Error(Exception ex, string key)
        {
            _mstLog.Level = "ERROR";
            _mstLog.Token = key;
            handleError(ex);
            Save();
        }

        public void Save()
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
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

        private void handleError(Exception ex)
        {
            var st = new StackTrace(ex, true);
            string strMessage = string.Empty;

            for (var i = st.FrameCount - 1; i >= 0; i--)
            {
                var frame = st.GetFrame(i);
                if (frame.GetFileLineNumber() > 0)
                {
                    strMessage += "# Class : " + frame.GetMethod().DeclaringType.Name + ", Method : " + frame.GetMethod().Name + ", Line Number : " + frame.GetFileLineNumber() + "  ";
                }
            }

            _mstLog.ActivityMessage = string.Format("Error Message : {0} ||| Error StackTrace : {1} ", ex.Message, strMessage);
            _mstLog.ActionName = string.Empty;
            _mstLog.ControllerName = string.Empty;
            _mstLog.CreatedDate = DateTime.Now;
            _mstLog.RequestID = Guid.NewGuid();
            _mstLog.RequestMethod = string.Empty;
        }
    }
}
