using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class AutodioController : BaseCrudController<Models.Autodio, AutodioSearchObject, AutodioInsert, AutodioUpdate>
    {
        IAutodioService _service;
        public AutodioController(ILogger<BaseController<Models.Autodio, AutodioSearchObject>> logger, IAutodioService service) : base(logger, service)
        { 
            _service = service;
        }


        [HttpPost("aktiviraj/{id}")]
        public async Task aktiviraj(int id)
        {
            await _service.aktiviraj(id);
        }

        [HttpPost("deaktiviraj/{id}")]
        public async Task deaktiviraj(int id)
        {
            await _service.deaktiviraj(id);
        }

        [HttpGet("recommend")]
        public List<Models.Autodio> Recommend(int autodioID)
        {
            return _service.Recommend(autodioID);
        }



    }
}