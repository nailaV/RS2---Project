using AutoMapper;
using eAutokuca.Models;
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
    public class AutodioService :BaseService<Models.Autodio, Database.Autodio, AutodioSearchObject>, IAutodioService
    {
        public AutodioService(AutokucaContext context, IMapper mapper):base(context,mapper) 
        {

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
