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
        IAutomobiliService _service;
        public AutomobilController(ILogger<BaseController<Models.Automobil, AutomobilSearchObject>> logger, IAutomobiliService service) : base(logger, service)
        {
            _service = service;
        }

        public override async Task<Models.Automobil> Update(int id, [FromBody] AutomobilUpdate update)
        {
            return await base.Update(id, update);
        }

        public override async Task Delete(int ID)
        {
             await base.Delete(ID);
        }


        //[HttpPut("{id}/activate")]
        //public virtual async Task<Models.Automobil> Activate(int id)
        //{
        //    return await (_service as IAutomobiliService).Activate(id);
        //}

        //[HttpPut("{id}/hide")]
        //public virtual async Task<Models.Automobil> Hide(int id)
        //{
        //    return await (_service as IAutomobiliService).Hide(id);
        //}

        //[HttpGet("{id}/allowedActions")]
        //public virtual async Task<List<string>> AllowedActions(int id)
        //{
        //    return await (_service as IAutomobiliService).AllowedActions(id);
        //}
    }
}