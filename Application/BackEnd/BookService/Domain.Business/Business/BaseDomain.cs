﻿using Microsoft.Extensions.Configuration;

namespace Domain.Business
{
    public abstract class BaseDomain
    {
        protected IConfiguration _config { get; set; }

        protected string dbConn { get { return _config.GetConnectionString("dbConnection"); } }
    }
}
