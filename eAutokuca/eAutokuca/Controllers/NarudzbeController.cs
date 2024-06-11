using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace eAutokuca.Controllers
{

    [ApiController]
    public class NarudzbeController : BaseCrudController<Models.Narudzba, NarudzbaSearchObject, NarudzbaInsert, NarudzbaUpdate>
    {
        INarudzbaService _service;
        public NarudzbeController(ILogger<BaseController<Models.Narudzba, NarudzbaSearchObject>> logger, INarudzbaService service) : base(logger, service)
        {
            _service = service;
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("posaljiNarudzbu/{id}")]
        public async Task posaljiNarudzbu(int id)
        {
            await _service.posaljiNarudzbu(id);
        }


        [Authorize(Roles = "Admin")]
        [HttpPost("otkaziNarudzbu/{id}")]
        public async Task otkaziNarudzbu(int id)
        {
            await _service.otkaziNarudzbu(id);
        }

        [HttpPost("dodajNarudzbu")]
        public async Task dodajNarudzbu([FromBody] NarudzbaInsert insert)
        {
            await _service.dodajNarudzbu(insert);
        }
    }
}
