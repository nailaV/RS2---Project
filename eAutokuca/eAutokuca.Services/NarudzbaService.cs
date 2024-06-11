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
    public class NarudzbaService : BaseCrudService<Models.Narudzba, Database.Narudzba, NarudzbaSearchObject, NarudzbaInsert, NarudzbaUpdate>, INarudzbaService
    {
        public NarudzbaService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }


        public override IQueryable<Narudzba> AddInclude(IQueryable<Narudzba> query, NarudzbaSearchObject? search = null)
        {
            return query.Include("Korisnik");
        }
        public override IQueryable<Narudzba> AddFilter(IQueryable<Narudzba> query, NarudzbaSearchObject? search = null)
        {

            if (!string.IsNullOrWhiteSpace(search?.Status))
            {
                query = query.Where(x => x.Status.StartsWith(search.Status));
            }
            return base.AddFilter(query, search);
        }

        public async Task posaljiNarudzbu(int id)
        {
            var entity = await _context.Narudzbas.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Narudzba ne postoji");
            }
            entity.Status = "Poslana";
            await _context.SaveChangesAsync();
        }

        public async Task otkaziNarudzbu(int id)
        {
            var entity = await _context.Narudzbas.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Narudzba ne postoji");
            }
            entity.Status = "Otkazana";
            await _context.SaveChangesAsync();
        }

        public async Task dodajNarudzbu(NarudzbaInsert insert)
        {
            var narudzba = new Narudzba();
            _mapper.Map(insert, narudzba);
            narudzba.Status = "Pending";
            narudzba.DatumNarudzbe = DateTime.Now;
            await _context.Narudzbas.AddAsync(narudzba);
            await _context.SaveChangesAsync();

            var stavkaNarudzbe = new StavkeNarudzbe();
            stavkaNarudzbe.AutodioId = insert.autodioId;
            stavkaNarudzbe.Kolicina = insert.kolicina;
            stavkaNarudzbe.NaruzdbaId = narudzba.NarudzbaId;

            await _context.StavkeNarudzbes.AddAsync(stavkaNarudzbe);
            await _context.SaveChangesAsync();

           
        }
    }
}
