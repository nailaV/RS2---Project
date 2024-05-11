using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class RezervacijaController : BaseCrudController<Models.Rezervacija, RezervacijaSearchObject, RezervacijaInsert, RezervacijaUpdate>
    {
        IRezervacijeService _service;

        public RezervacijaController(ILogger<BaseController<Models.Rezervacija, RezervacijaSearchObject>> logger, IRezervacijeService service) : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("{username}/getRezervacijeZaUsera")]
        public async Task<List<Models.Rezervacija>> getRezervacijeZaUsera(string username)
        {
            return await _service.getRezervacijeZaUsera(username);
        }


    }
}
