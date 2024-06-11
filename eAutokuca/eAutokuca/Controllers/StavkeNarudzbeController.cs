using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class StavkeNarudzbeController : BaseCrudController<Models.StavkeNarudzbe, StavkeNarudzbeSearchObject, StavkeNarudzbeInsert, StavkeNarudzbeUpdate>
    {
        IStavkeNarudzbeService _service;
        public StavkeNarudzbeController(ILogger<BaseController<Models.StavkeNarudzbe, StavkeNarudzbeSearchObject>> logger, IStavkeNarudzbeService service) : base(logger, service)
        {
            _service = service;
        }
    }
}
