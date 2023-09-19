using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class AutodioController : BaseController<Models.Autodio>
    {
        public AutodioController(ILogger<BaseController<Models.Autodio>> logger, IAutodioService service) : base(logger, service)
        {
        }
    }
}