using AutoMapper;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.AutomobiliStateMachine;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
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
            if (!string.IsNullOrWhiteSpace(search?.Boja))
            {
                query = query.Where(x => x.Boja.StartsWith(search.Boja));
            }
            return base.AddFilter(query, search);
        }

        public Task<PagedResult<Models.Automobil>> Get(AutomobilSearchObject? search = null)
        {
            return base.Get();
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

        public override async Task<Models.Automobil> Update(int id, AutomobilUpdate update)
        {
            var entity =await _context.Automobils.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);

            return await state.Update(id, update);
           
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
    }
}
