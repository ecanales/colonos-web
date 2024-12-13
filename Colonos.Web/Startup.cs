using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Colonos.Web.Startup))]
namespace Colonos.Web
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
           // ConfigureAuth(app);
        }
    }
}
