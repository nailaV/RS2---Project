using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IRezervacijeService : ICrudService<Models.Rezervacija, RezervacijaSearchObject, RezervacijaInsert, RezervacijaUpdate>
    {
        public Task<List<Models.Rezervacija>> getRezervacijeZaUsera(string username);
        public List<string> GetDostupne(int automobilId, DateTime datum);
        public Task<Models.Rezervacija> kreirajRezervaciju(RezervacijaInsert req);
        Task Zavrsi(int rezervacijaId);
        Task Otkazi(int rezervacijaId);
        Task<PagedResult<Models.Rezervacija>> getZavrseneRezervacije(RezervacijaSearchObject? searchObject = null);
        Task<PagedResult<Models.Rezervacija>> GetAktivne(RezervacijaSearchObject? searchObject = null);

    }
}
