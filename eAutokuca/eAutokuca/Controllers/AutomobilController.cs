using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class AutomobilController : BaseCrudController<Models.Automobil, AutomobilSearchObject, AutomobilInsert, AutomobilUpdate>
    {

        public AutomobilController(ILogger<BaseController<Models.Automobil, AutomobilSearchObject>> logger, IAutomobiliService service) : base(logger, service)
        {
        }

        [HttpPut("{id}/activate")]
        public virtual async Task<Models.Automobil> Activate(int id)
        {
            return await (_service as IAutomobiliService).Activate(id);
        }
    }
}