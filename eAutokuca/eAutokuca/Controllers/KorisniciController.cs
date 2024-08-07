﻿using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using eAutokuca.Services.Database;
using Microsoft.AspNetCore.Authorization;
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

        [Authorize(Roles = "Admin")]
        public override Task<Models.Korisnik> Update(int id, [FromBody] KorisniciUpdate update)
        {
            return base.Update(id, update);
        }
        public override Task Delete(int ID)
        {
            return base.Delete(ID);
        }

        [HttpGet("{username}/getByUsername")]
        public async Task<Models.Korisnik> getByUsername(string username)
        {
            return await _service.getByUsername(username);
        }

        [Authorize(Roles = "Admin, ObicanUser")]
        [HttpPost("PromjenaPassworda/{id}")]
        public async Task<Models.Korisnik> promjenaPassworda(int id,[FromBody] KorisnikPasswordPromjena request)
        {
            return await _service.promjenaPassworda(id, request);
        }

        [Authorize(Roles = "Admin, ObicanUser")]
        [HttpPost("PromjenaSlike/{id}")]
        public async Task promjenaSlike(int id, PromjenaSlike request)
        {
            await _service.promjenaSlike(id, request);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("promijeniStanje/{id}")]
        public async Task promijeniStanje(int id)
        {
            await _service.promijeniStanje(id);
        }

        [AllowAnonymous]
        public override Task<Models.Korisnik> Insert([FromBody] KorisniciInsert insert)
        {
            return _service.Insert(insert);
        }

        [HttpGet("getKorisnikID/{username}")]
        public async Task<int> getKorisnikID(string username)
        {
            return await _service.getKorisnikID( username);
        }
    }
}