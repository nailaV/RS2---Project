using AutoMapper;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.AutomobiliStateMachine;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eAutokuca.Services
{
    public class AutomobiliService : BaseCrudService<Models.Automobil, Database.Automobil, AutomobilSearchObject, AutomobilInsert, AutomobilUpdate>, IAutomobiliService
    {
        public BaseState _baseState { get; set; }
        public AutomobiliService(BaseState baseState, AutokucaContext context, IMapper mapper) :
            base(context, mapper)
        {
            _baseState = baseState;
        }




        public override IQueryable<Database.Automobil> AddFilter(IQueryable<Database.Automobil> query, AutomobilSearchObject? search = null)
        {
            query = query.Where(x => x.Status == search.AktivniNeaktivni);
            return query;
        }


        public override async Task<Models.Automobil> Insert(AutomobilInsert insert)
        {   
            Database.Automobil entity=new ();

            _mapper.Map(insert, entity);
            if(!string.IsNullOrEmpty(insert?.slikaBase64))
            {
                entity.Slike=Convert.FromBase64String(insert.slikaBase64);
            }
            entity.Status = "Aktivan";

            await _context.AddAsync(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Models.Automobil>(entity);


        }


        public async Task<Models.Automobil> Activate(int id)
        {
            var entity = await _context.Automobils.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);

            return await state.Activate(id);
        }

        public async Task<Models.Automobil> Hide(int id)
        {
            var entity = await _context.Automobils.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);

            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Automobils.FindAsync(id);
            var state=_baseState.CreateState(entity?.Status ?? "Initial");

            return await state.AllowedActions();
            
        }

        public async Task<List<string>> GetSveMarke()
        {
            var lista = new List<string>
            {
                "Sve marke"
            };

            var marke = await _context.Automobils.Select(x => x.Marka).Distinct().ToListAsync();
            foreach (var item in marke)
            {
                lista.Add(item);
            }

            return lista;
        }

        public async Task<List<string>> GetSveModele()
        {
            var lista = new List<string>
            {
                "Svi modeli"
            };

            var modeli=await _context.Automobils.Select(x=>x.Model).Distinct().ToListAsync();
            foreach (var item in modeli)
            {
                lista.Add(item);
            }

            return lista;
        }

        public async Task<PagedResult<Models.Automobil>> Filtriraj(AutomobilSearchObject? searchObject = null)
        {
            var query= _context.Automobils.OrderByDescending(x=>x.AutomobilId).AsQueryable();

            if (!string.IsNullOrWhiteSpace(searchObject?.FTS))
            {
                query = query.Where(x => x.Model.Contains(searchObject.FTS) || x.Marka.Contains(searchObject.FTS) || x.Boja.Contains(searchObject.FTS));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Marka))
            {
                if(searchObject.Marka!="Sve marke")
                {
                    query = query.Where(x => x.Marka == searchObject.Marka);
                }
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Boja))
            {
                if (searchObject.Model != "Sve boje")
                {
                    query = query.Where(x => x.Boja == searchObject.Boja);
                }
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Mjenjac))
            {
                if (searchObject.Mjenjac != "Svi")
                {
                    query = query.Where(x => x.Mjenjac == searchObject.Mjenjac);
                }
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Motor))
            {
                if (searchObject.Motor != "Svi")
                {
                    query = query.Where(x => x.Motor == searchObject.Motor);
                }
            }
            if (searchObject?.PredjeniKilometri.HasValue == true)
            {
                query = query.Where(x => x.PredjeniKilometri > searchObject.PredjeniKilometri);
            }
            if (searchObject?.GodinaProizvodnje.HasValue == true)
            {
                query = query.Where(x => x.GodinaProizvodnje >= searchObject.GodinaProizvodnje);
            }

            var lista = new PagedResult<Models.Automobil>()
            {
                Count = await query.CountAsync(),
            };

            if(searchObject?.PageSize != null)
            {
                double? count = lista.Count;
                double? pageSize = searchObject.PageSize;
                if(count.HasValue && pageSize.HasValue)
                {
                    lista.TotalPages = (int)Math.Ceiling(count.Value / pageSize.Value);
                }
            }

            if(searchObject?.Page.HasValue==true && searchObject?.PageSize.HasValue==true)
            {
                query = query.Skip(searchObject.PageSize.Value * (searchObject.Page.Value - 1)).Take(searchObject.PageSize
                    .Value);
                lista.HasNext = searchObject.Page.Value < lista.TotalPages;
            }    

            var lista1=await query.ToListAsync();
            lista.Result = _mapper.Map<List<Models.Automobil>>(lista1);

            return lista;
        }

        public async Task promijeniStanje(int id)
        {
            var entity=await _context.Automobils.FindAsync(id);
            if(entity==null)
            {
                throw new Exception("Automobil ne postoji");
            }
            entity.Status = "Neaktivan";
            await _context.SaveChangesAsync();
        }
    }
}
