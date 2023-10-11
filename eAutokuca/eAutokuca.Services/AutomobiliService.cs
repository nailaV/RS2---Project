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
    public class AutomobiliService : BaseCrudService<Models.Automobil, Database.Automobil, AutodioSearchObject, AutomobilInsert, AutomobilUpdate>, IAutomobiliService
    {
        public BaseState _baseState { get; set; }
        public AutomobiliService(BaseState baseState, AutokucaContext context, IMapper mapper) :
            base(context, mapper)
        {
            _baseState = baseState;
        }

        public Task<PagedResult<Models.Automobil>> Get(AutomobilSearchObject? search = null)
        {
            return base.Get();
        }
        public override Task<Models.Automobil> Insert(AutomobilInsert insert)
        {
            var state = _baseState.CreateState("Initial");
            return state.Insert(insert);
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


    }
}
