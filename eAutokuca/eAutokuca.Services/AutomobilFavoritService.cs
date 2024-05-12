﻿using AutoMapper;
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
    public class AutomobilFavoritService : BaseCrudService<Models.AutomobilFavorit, Database.AutomobilFavoriti, FavoritiSearchObject, FavoritiInsert, FavoritiUpdate>, IAutomobilFavorit
    {
        public AutomobilFavoritService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<List<Models.AutomobilFavorit>> getFavoriteZaUsera(string username)
        {
            var korisnik= await _context.Korisniks.Where(x => x.Username == username).FirstOrDefaultAsync();
            var result = await _context.AutomobilFavoritis.Where(x => x.KorisnikId == korisnik.KorisnikId).Include("Automobil").ToListAsync();
            if(result.Count==0)
            {
                return new List<Models.AutomobilFavorit>();
            }
            return _mapper.Map<List<Models.AutomobilFavorit>>(result);


        }

      
    }
}
