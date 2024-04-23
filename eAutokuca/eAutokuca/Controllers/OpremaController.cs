using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]

    public class OpremaController : BaseCrudController<Models.Oprema, OpremaSearchObject, OpremaInsert, OpremaUpdate>
    {
        IOpremaService _service;
        public OpremaController(ILogger<BaseController<Oprema, OpremaSearchObject>> logger, IOpremaService service) : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("getOpremuZaAutomobil/{automobilId}")]
        public async Task<Models.Oprema> GetById(int automobilId)
        {
            return await _service.GetById(automobilId);
        }

    }
}
