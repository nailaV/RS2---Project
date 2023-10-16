using AutoMapper;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services.AutomobiliStateMachine
{
    public class InitialState: BaseState
    {
        public InitialState(IServiceProvider serviceProvider, Database.AutokucaContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Automobil> Insert(AutomobilInsert request)
        {
            var set = _context.Set<Database.Automobil>();
            var entity = _mapper.Map<Database.Automobil>(request);

            entity.Status = "Draft";
            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Automobil>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list=  await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
