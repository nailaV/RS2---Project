using eAutokuca.Services;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [Route("[controller]")]
    public class BaseController<T> : ControllerBase where T : class
    {
        private readonly IService<T> _service;
        private readonly ILogger<BaseController<T>> _logger;

        public BaseController(ILogger<BaseController<T>> logger, IService<T> service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet()]
        public async Task<List<T>> Get()
        {
            return await _service.Get();
        }

        [HttpGet("{id}")]
        public async Task<T> GetByID(int id)
        {
            return await _service.GetByID(id);
        }


    }
}
