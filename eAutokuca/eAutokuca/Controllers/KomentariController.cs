using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class KomentariController : BaseCrudController<Models.Komentari, KomentariSearchObject, KomentariInsert, KomentariUpdate>
    {
        IKomentariService _service;
        public KomentariController(ILogger<BaseController<Komentari, KomentariSearchObject>> logger, IKomentariService service) : base(logger, service)
        {
            _service = service;
        }
    }
}
