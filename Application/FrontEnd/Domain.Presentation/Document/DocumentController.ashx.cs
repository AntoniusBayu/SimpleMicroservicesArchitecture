using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Web.Script.Serialization;
using Newtonsoft.Json;

namespace Domain.Presentation
{
    /// <summary>
    /// Summary description for Document
    /// </summary>
    public class DocumentController : IHttpHandler
    {
        private string _prfxUploadDoc { get { return Helper.GetPrefixDocument(); } }

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                context.Response.ContentType = "text/plain";

                string dirFullPath = HttpContext.Current.Server.MapPath(_prfxUploadDoc);
                string[] files;
                int numFiles;
                dynamic model = new object();

                files = System.IO.Directory.GetFiles(dirFullPath);
                numFiles = files.Length;
                numFiles = numFiles + 1;

                string strName = "";

                foreach (string s in context.Request.Files)
                {
                    HttpPostedFile file = context.Request.Files[s];
                    string fileName = file.FileName;
                    string ContentFile = file.ContentType;

                    if (!string.IsNullOrEmpty(fileName))
                    {
                        string fileExtension = Path.GetExtension(fileName);
                        strName = "Doc_" + numFiles.ToString() + fileExtension;
                        string pathToSave_100 = HttpContext.Current.Server.MapPath(_prfxUploadDoc) + strName;

                        model = new
                        {
                            DocName = fileName,
                            DocURL = strName,
                            DocContent = ContentFile
                        };

                        file.SaveAs(pathToSave_100);
                    }
                }

                context.Response.Write(JsonConvert.SerializeObject(model));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}