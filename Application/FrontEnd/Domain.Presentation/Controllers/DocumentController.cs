using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;

namespace Domain.Presentation.Controllers
{
    public class DocumentController : Controller
    {
        public FileContentResult DownloadFile(string DocName, string DocURL, string DocContent)
        {
            try
            {
                string prfxFolder = Helper.GetPrefixDocument();
                string DirectoryPath = Server.MapPath(prfxFolder);
                string fullPath = DirectoryPath + DocURL;
                byte[] fileBytes = System.IO.File.ReadAllBytes(fullPath);

                if (!Directory.Exists(DirectoryPath))
                {
                    throw new Exception("Kagak ada directory nya nyong. Salah kali lu. Directory : " + DirectoryPath + " ");
                }

                if (!System.IO.File.Exists(fullPath))
                {
                    throw new Exception("Anjay file nya kagak ada nyong. Salah kali lu. Directory : " + fullPath + " ");
                }

                return File(fileBytes, DocContent, DocName);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}