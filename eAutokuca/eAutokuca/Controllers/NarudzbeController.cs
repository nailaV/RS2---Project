using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

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
    }
}
