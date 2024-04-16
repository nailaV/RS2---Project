﻿using eAutokuca.Models;
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
        IKorisniciService _service;

        public KorisniciController(ILogger<BaseController<Models.Korisnik, KorisnikSearchObject>> logger, IKorisniciService service) : base(logger, service)
        {
            _service = service;
        }

        public override Task<Models.Korisnik> Update(int id, [FromBody] KorisniciUpdate update)
        {
            return base.Update(id, update);
        }
        public override Task Delete(int ID)
        {
            return base.Delete(ID);
        }

    }
}