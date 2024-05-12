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

        public override async Task<Models.Rezervacija> Insert(RezervacijaInsert insert)
        {
           
            var reservation = new Rezervacija();
            _mapper.Map(insert, reservation);

           
            reservation.Status = "Aktivna";
            
          
            await _context.Rezervacijas.AddAsync(reservation);

            await _context.SaveChangesAsync();
  


            return _mapper.Map<Models.Rezervacija>(reservation);
        }

        public async Task<List<Models.Rezervacija>> getRezervacijeZaUsera(string username)
        {
           var result = await _context.Rezervacijas.Where(x=> x.Korisnik.Username == username).Include("Automobil").ToListAsync();
            if (result.Count == 0)
            {
                return new List<Models.Rezervacija>();
            }
           return _mapper.Map<List<Models.Rezervacija>>(result);
        }

        public List<string> GetDostupne(int id, DateTime datum)
        {
            DateTime pocetak = datum.AddHours(8);
            DateTime kraj = datum.AddHours(16);

            if (datum.DayOfWeek == DayOfWeek.Sunday || datum.DayOfWeek == DayOfWeek.Saturday)
            {
                return new List<string>();
            }

            var postojeci_termini = _context.Rezervacijas
                .Where(x => x.AutomobilId == id && x.DatumVrijemeRezervacije.Date == datum.Date)
                .Select(d => d.DatumVrijemeRezervacije.TimeOfDay)
                .ToList();

            var dostupni_termini = new List<string>();

            for (DateTime i = pocetak; i < kraj; i = i.AddMinutes(30))
            {
                var timeOfDay = i.TimeOfDay;

                if (!postojeci_termini.Any(x => x.Hours == timeOfDay.Hours))
                {
                    dostupni_termini.Add(timeOfDay.ToString(@"hh\:mm"));
                }
            }

            return dostupni_termini;
        }

    }
}
