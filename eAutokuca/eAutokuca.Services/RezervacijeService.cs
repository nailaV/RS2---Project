using AutoMapper;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class RezervacijeService : BaseCrudService<Models.Rezervacija, Database.Rezervacija, RezervacijaSearchObject, RezervacijaInsert, RezervacijaUpdate>, IRezervacijeService
    {
        public RezervacijeService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Rezervacija> AddInclude(IQueryable<Rezervacija> query, RezervacijaSearchObject? search = null)
        {
            return query.Include("Automobil").Include("Korisnik");
        }

        public override IQueryable<Rezervacija> AddFilter(IQueryable<Rezervacija> query, RezervacijaSearchObject? search = null)
        {
            if (search != null && search.datum != null)
            {
                query = query.Where(x => x.DatumVrijemeRezervacije.Date == search.datum);
            }

            return query;
        }


    }
}
