using eAutokuca.Models;
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
        public IEnumerable<Models.Korisnik> Get()
        {
            return _service.Get();
        }
    }
}