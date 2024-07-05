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
    public class KomentariController : BaseCrudController<Models.Komentari, KomentariSearchObject, KomentariInsert, KomentariUpdate>
    {
        IKomentariService _service;
        public KomentariController(ILogger<BaseController<Komentari, KomentariSearchObject>> logger, IKomentariService service) : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("getKomentareZaAuto")]
        public async Task<List<Models.Komentari>> getKomentareZaAuto(int autoId)
        {
            return await _service.getKomentareZaAuto(autoId);
        }

       
        [HttpPost("dodajKomentar")]
        public async Task<Models.Komentari> DodajKomentar([FromBody] KomentariInsert req)
        {
            return await _service.dodajKomentar(req);
        }
    }
}
