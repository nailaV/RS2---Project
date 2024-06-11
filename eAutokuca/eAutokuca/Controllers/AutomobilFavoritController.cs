using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace eAutokuca.Controllers
{

    [ApiController]
    public class AutomobilFavoritController : BaseCrudController<Models.AutomobilFavorit, FavoritiSearchObject, FavoritiInsert, FavoritiUpdate>
    {
        IAutomobilFavorit _service;
        public AutomobilFavoritController(ILogger<BaseController<AutomobilFavorit, FavoritiSearchObject>> logger, IAutomobilFavorit service) : base(logger, service)
        {
            _service = service;
        }

        [HttpGet("{username}/getFavoriteZaUsera")]
        public async Task<List<Models.AutomobilFavorit>> getFavoriteZaUsera(string username)
        {
            return await _service.getFavoriteZaUsera(username);
        }

        [HttpGet("isFavorit")]
        public async Task<bool> isFavorit(int automobilId, int korisnikId)
        {
            return await _service.isFavorit(automobilId, korisnikId);
        }

        [Authorize(Roles = "Admin, ObicanUser")]
        [HttpPost("izbrisiFavorita")]
        public async Task izbrisiFavorita(int automobilId, int korisnikId)
        {
             await _service.brisiFavorita(automobilId, korisnikId);
        }
    }
}

