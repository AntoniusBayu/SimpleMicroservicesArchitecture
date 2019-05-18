using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Domain.Presentation.Startup))]
namespace Domain.Presentation
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
