using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [ApiController]
    public class KorisniciController : BaseController<Models.Korisnik, KorisnikSearchObject>
    {
        protected IKorisniciService _korisniciService;
        public KorisniciController(ILogger<BaseController<Models.Korisnik,KorisnikSearchObject>>logger, IKorisniciService service): base(logger, service)
        {
            _korisniciService= service;
        }

        [HttpPost]
        public Models.Korisnik Insert (KorisniciInsert request)
        {
            return _korisniciService.Insert(request);
        }
        [HttpPut("{id}")]
        public Models.Korisnik Update (int id, KorisniciUpdate request)
        {
            return _korisniciService.Update(id, request);
        }


    }
}