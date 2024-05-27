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
    public class RecenzijeService : BaseCrudService<Models.Recenzije, Database.Recenzije, RecenzijeSearchObject, RecenzijeInsert, RecenzijeUpdate>, IRecenzijeService
    {
        public RecenzijeService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Recenzije> AddFilter(IQueryable<Recenzije> query, RecenzijeSearchObject? search = null)
        {
            if (search != null && search.ocjena!=null)
            {
                query = query.Where(x => x.Ocjena == search.ocjena);
            }
            return query;
        }

        public async Task<List<Models.Recenzije>> getRecenzijeZaUsera(string username)
        {
            var result = await _context.Recenzijes.Where(x => x.Korisnik.Username == username).ToListAsync();
            if (result.Count == 0)
            {
                return new List<Models.Recenzije>();
            }
            return _mapper.Map<List<Models.Recenzije>>(result);
        }
    }
}
