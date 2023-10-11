using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class KorisniciController : BaseCrudController<Models.Korisnik, KorisnikSearchObject, KorisniciInsert, KorisniciUpdate>
    {

        public KorisniciController(ILogger<BaseController<Models.Korisnik, KorisnikSearchObject>> logger, IKorisniciService service) : base(logger, service)
        {
        }

    }
}