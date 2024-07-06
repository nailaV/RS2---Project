using AutoMapper;
using Azure.Core;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class AutodioService :BaseCrudService<Models.Autodio, Database.Autodio, AutodioSearchObject, AutodioInsert, AutodioUpdate>, IAutodioService
    {
        public AutodioService(AutokucaContext context, IMapper mapper):base(context,mapper) 
        {

        }

        public override async Task<Models.Autodio> Update(int id, AutodioUpdate update)
        {
            var entity = await _context.Autodios.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Korisnik ne postoji.");
            }
            if (!string.IsNullOrEmpty(update.Slika))
            {
                entity.Slika = Convert.FromBase64String(update.Slika);
            }
            entity.Opis=update.Opis;
            if (!string.IsNullOrEmpty(update.Naziv))
            {
                entity.Naziv = update.Naziv;
            }
            if (update.Cijena!=null)
            {
                entity.Cijena = update.Cijena.Value;
            }
            if (update.KolicinaNaStanju != null)
            {
                entity.KolicinaNaStanju = update.KolicinaNaStanju.Value;
            }


            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Autodio>(entity);
        }

        public async override Task<Models.Autodio> Insert(AutodioInsert insert)
        {
            var autodio=new Database.Autodio();
            _mapper.Map(insert, autodio);
            autodio.Status = "Dostupno";
            if (insert?.slikaBase64 != null)
            {
                autodio.Slika = Convert.FromBase64String(insert.slikaBase64!);
            }
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

            query = query.Where(x => x.KolicinaNaStanju >= 1);

            return base.AddFilter(query, search);
        }

        public async Task aktiviraj(int id)
        {
            var entity = await _context.Autodios.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Autodio ne postoji");
            }
            entity.Status = "Dostupno";
            await _context.SaveChangesAsync();
        }

        public async Task deaktiviraj(int id)
        {
            var entity = await _context.Autodios.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Autodio ne postoji");
            }
            entity.Status = "Deaktiviran";
            await _context.SaveChangesAsync();
        }


       
    }
}
