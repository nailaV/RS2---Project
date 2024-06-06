using AutoMapper;
using eAutokuca.Models;
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

        public override IQueryable<Database.Rezervacija> AddInclude(IQueryable<Database.Rezervacija> query, RezervacijaSearchObject? search = null)
        {
            return query.Include("Automobil").Include("Korisnik");
        }

        public override IQueryable<Database.Rezervacija> AddFilter(IQueryable<Database.Rezervacija> query, RezervacijaSearchObject? search = null)
        {
            if (search != null && search.datum != null)
            {
                query = query.Where(x => x.Status == "Aktivna" && x.DatumVrijemeRezervacije.Date == search.datum);
               

            }
           
         

            return query;
        }

        public async  Task<PagedResult<Models.Rezervacija>> GetAktivne(RezervacijaSearchObject? searchObject = null)
        {
            var query = _context.Rezervacijas.Where(x => x.Status == "Aktivna" && x.DatumVrijemeRezervacije.Date == searchObject!.datum)
               .Include("Korisnik").Include("Automobil")
               .OrderByDescending(i => i.RezervacijaId).AsQueryable();
            if (searchObject?.datum.HasValue == true)
            {
                query = query.Where(x => x.DatumVrijemeRezervacije.Date == searchObject.datum);
            }

            var list = new PagedResult<Models.Rezervacija>
            {
                TotalPages = await query.CountAsync()
            };

            if (searchObject?.PageSize != null)
            {
                double? pageCount = list.TotalPages;
                double? pageSize = searchObject.PageSize;
                if (pageCount.HasValue && pageSize.HasValue)
                {
                    list.TotalPages = (int)Math.Ceiling(pageCount.Value / pageSize.Value);
                }
            }

            query.Include("Korisnik")
                .Include("Automobil");


            if (searchObject?.Page.HasValue == true && searchObject?.PageSize.HasValue == true)
            {
                query = query.Skip(searchObject.PageSize.Value * (searchObject.Page.Value - 1)).Take(searchObject.PageSize.Value);
                list.HasNext = searchObject.Page.Value < list.TotalPages;
            }



            var lista = await query.ToListAsync();

            list.Result = _mapper.Map<List<Models.Rezervacija>>(lista);

            return list;

        }


        public async Task<List<Models.Rezervacija>> getRezervacijeZaUsera(string username)
        {
           var result = await _context.Rezervacijas.Where(x=> x.Korisnik.Username == username ).Include("Automobil").ToListAsync();
            if (result.Count == 0)
            {
                return new List<Models.Rezervacija>();
            }
           return _mapper.Map<List<Models.Rezervacija>>(result);
        }

        public List<string> GetDostupne(int automobilId, DateTime datum)
        {
            DateTime pocetak = datum.AddHours(8);
            DateTime kraj = datum.AddHours(16);

            if (datum.DayOfWeek == DayOfWeek.Sunday || datum.DayOfWeek == DayOfWeek.Saturday)
            {
                return new List<string>();
            }

            var postojeci_termini = _context.Rezervacijas
                .Where(x => x.AutomobilId == automobilId && x.DatumVrijemeRezervacije.Date == datum.Date)
                .Select(d => d.DatumVrijemeRezervacije.TimeOfDay)
                .ToList();

            var dostupni_termini = new List<string>();

            for (DateTime i = pocetak; i < kraj; i = i.AddMinutes(30))
            {
                var timeOfDay = i.TimeOfDay;

                if (!postojeci_termini.Any(x => x.Hours == timeOfDay.Hours && x.Minutes==timeOfDay.Minutes))
                {
                    dostupni_termini.Add(timeOfDay.ToString(@"hh\:mm"));
                }
            }

            return dostupni_termini;
        }

        public async Task<Models.Rezervacija> kreirajRezervaciju(RezervacijaInsert req)
        {
            var rezervacija=new Database.Rezervacija();
            rezervacija.Status = "Aktivna";
            rezervacija.DatumVrijemeRezervacije = DateTime.Parse(req.datum);
            rezervacija.KorisnikId = req.KorisnikId;
            rezervacija.AutomobilId=req.AutomobilId;
            await _context.Rezervacijas.AddAsync(rezervacija);
            
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Rezervacija>(rezervacija);
        }

        public async Task Zavrsi(int rezervacijaId)
        {
            var entity = await _context.Rezervacijas.FindAsync(rezervacijaId);
            entity!.Status = "Zavrsena";
            await _context.SaveChangesAsync();
        }

        public async Task Otkazi(int rezervacijaId)
        {
            var entity = await _context.Rezervacijas.FindAsync(rezervacijaId);
            entity!.Status = "Otkazana";
            await _context.SaveChangesAsync();
        }



        public async Task<PagedResult<Models.Rezervacija>> getZavrseneRezervacije(RezervacijaSearchObject? searchObject = null)
        {
            var query = _context.Rezervacijas
                .Where(x => x.Status == "Zavrsena" || x.Status == "Otkazana")
                .Include("Korisnik")
                .Include("Automobil")
                .OrderByDescending(i => i.RezervacijaId)
                .AsQueryable();

            var list = new PagedResult<Models.Rezervacija>
            {
                TotalPages = await query.CountAsync(),
                Result = new List<Models.Rezervacija>() 
            };

            if (searchObject?.PageSize != null)
            {
                double? pageCount = list.TotalPages;
                double? pageSize = searchObject.PageSize;
                if (pageCount.HasValue && pageSize.HasValue)
                {
                    list.TotalPages = (int)Math.Ceiling(pageCount.Value / pageSize.Value);
                }
            }

            if (searchObject?.Page.HasValue == true && searchObject?.PageSize.HasValue == true)
            {
                query = query
                    .Skip(searchObject.PageSize.Value * (searchObject.Page.Value - 1))
                    .Take(searchObject.PageSize.Value);
                list.HasNext = searchObject.Page.Value < list.TotalPages;
            }

            var lista = await query.ToListAsync();
            list.Result.AddRange(_mapper.Map<List<Models.Rezervacija>>(lista));

            return list;
        }

    }
}
