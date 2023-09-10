using eAutokuca.Models;
using eAutokuca.Services;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AutomobiliController : ControllerBase
    {
        private readonly IAutomobiliService _automobiliService;
        private readonly ILogger<WeatherForecastController> _logger;

        public AutomobiliController(ILogger<WeatherForecastController> logger, IAutomobiliService automobiliService)
        {
            _logger = logger;
            _automobiliService = automobiliService; 
        }

        [HttpGet()]
        public IEnumerable<Automobili> Get()
        {
           return _automobiliService.Get();
        }
    }
}