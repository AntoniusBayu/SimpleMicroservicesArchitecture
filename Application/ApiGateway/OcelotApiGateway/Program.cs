using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

namespace OcelotApiGateway
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    config
                        .AddJsonFile("ocelot.json", false, true)
                        .AddJsonFile(
                            $"ocelot.{hostingContext.HostingEnvironment.EnvironmentName}.json",
                            true,
                            true
                        );
                })
                .UseStartup<Startup>();
    }
}
