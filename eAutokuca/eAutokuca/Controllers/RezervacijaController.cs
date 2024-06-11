using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

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

        [HttpGet("getDostupne")]
        public List<string> GetDostupne(int id, DateTime datum)
        {
            return _service.GetDostupne(id, datum);
        }

        [Authorize(Roles = "ObicanUser")]
        [HttpPost("kreirajRezervaciju")]
        public async Task<Models.Rezervacija> KreirajRezervaciju([FromBody] RezervacijaInsert req)
        {
            return await _service.kreirajRezervaciju(req);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("Zavrsi/{rezervacijaId}")]
        public async Task Zavrsi(int rezervacijaId)
        {
            await _service.Zavrsi(rezervacijaId);
        }


        [Authorize(Roles = "Admin")]
        [HttpPut("Otkazi/{rezervacijaId}")]
        public async Task Otkazi(int rezervacijaId)
        {
            await _service.Otkazi(rezervacijaId);
        }

        [HttpGet("GetZavrsene")]
        public async Task<PagedResult<Models.Rezervacija>> getZavrseneRezervacije([FromQuery] RezervacijaSearchObject? searchObject = null)
        {
            return await _service.getZavrseneRezervacije(searchObject);
        }
        [HttpGet("GetAktivne")]
        public async Task<PagedResult<Models.Rezervacija>> getAktivneRezervacije([FromQuery] RezervacijaSearchObject? searchObject = null)
        {
            return await _service.GetAktivne(searchObject);
        }
    }
}
