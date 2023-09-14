using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : ControllerBase
    {
        private readonly IKorisniciService _service;
        private readonly ILogger<WeatherForecastController> _logger;

        public KorisniciController(ILogger<WeatherForecastController> logger, IKorisniciService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet()]
        public async Task<List<Models.Korisnik>> Get()
        {
            return await _service.Get();
        }
        [HttpPost]
        public Models.Korisnik Insert (KorisniciInsert request)
        {
            return _service.Insert(request);
        }
        [HttpPut("{id}")]
        public Models.Korisnik Update (int id, KorisniciUpdate request)
        {
            return _service.Update(id, request);
        }


    }
}