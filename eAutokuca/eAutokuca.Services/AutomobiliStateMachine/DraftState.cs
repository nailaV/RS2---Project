using AutoMapper;
using Azure.Core;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Services.Database;
using Microsoft.Extensions.Logging;
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
        protected ILogger<DraftState> _logger;
        public DraftState(ILogger<DraftState> logger,IServiceProvider serviceProvider, AutokucaContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
            _logger = logger;
        }

        public override async Task<Models.Automobil> Update(int id, AutomobilUpdate request)
        {
            var set = _context.Set<Database.Automobil>();
            var entity = await set.FindAsync(id);
            _mapper.Map(request, entity);
            if (entity.Cijena <= 0)
            {
                throw new UserExceptions("Cijena mora biti veca od 0!");
            }
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Automobil>(entity);
        }

        public override async Task<Models.Automobil> Activate(int id)
        {
            _logger.LogInformation($"I: Aktivacija oglasa: {id}");
            _logger.LogWarning($"W: Aktivacija oglasa: {id}");
            _logger.LogError($"E: Aktivacija oglasa: {id}");

            var set = _context.Set<Database.Automobil>();
            var entity = await set.FindAsync(id);
            entity.Status = "Active";
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Automobil>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Activate");

            return list;
        }
    }
}
