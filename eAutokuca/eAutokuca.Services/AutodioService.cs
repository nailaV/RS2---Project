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
    public class AutodioService :BaseCrudService<Models.Autodio, Database.Autodio, AutodioSearchObject, AutodioInsert, AutodioUpdate>, IAutodioService
    {
        public AutodioService(AutokucaContext context, IMapper mapper):base(context,mapper) 
        {

        }


        public async override Task<Models.Autodio> Insert(AutodioInsert insert)
        {
            var autodio=new Database.Autodio();
            _mapper.Map(insert, autodio);
            autodio.Status = "Dostupno";
            //if (insert?.slikaBase64 != null)
            //{
            //    autodio.Slika = Convert.FromBase64String(insert.slikaBase64!);
            //}
            await _context.Autodios.AddAsync(autodio);
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Autodio>(autodio);

        }



        public override IQueryable<Database.Autodio> AddFilter(IQueryable<Database.Autodio> query, AutodioSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            if(!string.IsNullOrWhiteSpace(search?.FullTextSearch))
            {
                query=query.Where(x=>x.Naziv.Contains(search.FullTextSearch));  
            }

            if(!string.IsNullOrWhiteSpace(search?.Status)) 
            {
                query=query.Where(x=>x.Status.StartsWith(search.Status));
            }


            return base.AddFilter(query, search);
        }

    }
}
