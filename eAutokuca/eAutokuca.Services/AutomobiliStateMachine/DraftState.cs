using AutoMapper;
using Azure.Core;
using eAutokuca.Models.Requests;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eAutokuca.Services.AutomobiliStateMachine
{
    public class DraftState : BaseState
    {
        public DraftState(IServiceProvider serviceProvider, AutokucaContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
        }

        public override async Task<Models.Automobil> Update(int id, AutomobilUpdate request)
        {
            var set = _context.Set<Database.Automobil>();
            var entity = await set.FindAsync(id);
            _mapper.Map(request, entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Automobil>(entity);
        }

        public override async Task<Models.Automobil> Activate(int id)
        {
            var set = _context.Set<Database.Automobil>();
            var entity = await set.FindAsync(id);
            entity.Status = "Active";
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Automobil>(entity);
        }
    }
}
