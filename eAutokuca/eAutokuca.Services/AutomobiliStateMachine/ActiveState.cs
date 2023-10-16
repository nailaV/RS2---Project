using AutoMapper;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services.AutomobiliStateMachine
{
    public class ActiveState : BaseState
    {
        public ActiveState(IServiceProvider serviceProvider, AutokucaContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Models.Automobil> Hide(int id)
        {
            var set = _context.Set<Database.Automobil>();
            var entity = await set.FindAsync(id);
            entity.Status = "Draft";
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Automobil>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Hide");

            return list;
        }
    }
}
