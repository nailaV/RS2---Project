using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class AutodioController : BaseController<Models.Autodio, AutodioSearchObject>
    {
        public AutodioController(ILogger<BaseController<Models.Autodio, AutodioSearchObject>> logger, IAutodioService service) : base(logger, service)
        { 
        }
    }
}