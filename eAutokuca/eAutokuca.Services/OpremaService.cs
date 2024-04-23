﻿using AutoMapper;
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
    public class OpremaService : BaseCrudService<Models.Oprema, Database.Oprema, OpremaSearchObject, OpremaInsert, OpremaUpdate>, IOpremaService
    {
        public OpremaService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Oprema> AddFilter(IQueryable<Oprema> query, OpremaSearchObject? search = null)
        {
           if(search!=null && search.Navigacija.HasValue)
            {
                query = query.Where(x => x.Navigacija == search.Navigacija.Value);
            }
            return base.AddFilter(query, search);
        }

        public async Task<Models.Oprema> GetById(int automobilId)
        {
            var entity = await _context.Opremas.Where(x => x.AutomobilId == automobilId).FirstOrDefaultAsync();
            if (entity == null)
            {
                throw new Exception("Dodatna oprema nije unesena");
            }
            return _mapper.Map<Models.Oprema>(entity);
        }
    }
}
