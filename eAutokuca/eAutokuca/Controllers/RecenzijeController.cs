using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class RecenzijeController : BaseCrudController<Models.Recenzije, RecenzijeSearchObject, RecenzijeInsert, RecenzijeUpdate>
    {
        IRecenzijeService _service;
        public RecenzijeController(ILogger<BaseController<Models.Recenzije, RecenzijeSearchObject>> logger, IRecenzijeService service) : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("getRecenzijeZaUsera")]
        public async Task<List<Models.Recenzije>> getRecenzijeZaUsera(string username)
        {
            return await _service.getRecenzijeZaUsera(username);
        }

        [HttpGet("getAverage")]
        public async Task<double> getProsjecnuRecenziju()
        {
            return await _service.getProsjecnuRecenziju();
        }
    }
}
