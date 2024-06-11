using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Authorization;
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

        [HttpGet("GetSveMarke")]
        public async Task<List<string>> GetSveMarke()
        {
            return await _service.GetSveMarke();
        }

        [HttpGet("GetSveModele")]
        public async Task<List<string>> GetSveModele()
        {
            return await _service.GetSveModele();
        }

        [HttpGet("Filtriraj")]
        public async Task<PagedResult<Models.Automobil>> Filtriraj([FromQuery]AutomobilSearchObject? searchObject = null)
        {
            return await _service.Filtriraj(searchObject);
        }

        [Authorize(Roles = "Admin")]
        public override async Task<Models.Automobil> Update(int id, [FromBody] AutomobilUpdate update)
        {
            return await base.Update(id, update);
        }

        public override async Task Delete(int ID)
        {
             await base.Delete(ID);
        }

        [Authorize (Roles = "Admin")]
        [HttpPost("promijeniStanje/{id}")]
        public async Task promijeniStanje(int id)
        {
            await _service.deaktiviraj(id);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("aktiviraj/{id}")]
        public async Task aktiviraj(int id)
        {
            await _service.aktiviraj(id);
        }
    }
}