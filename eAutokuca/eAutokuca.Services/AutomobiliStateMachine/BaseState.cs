using AutoMapper;
using eAutokuca.Models.Requests;
using eAutokuca.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services.AutomobiliStateMachine
{
    public class BaseState
    {
        protected AutokucaContext _context;
        protected IMapper _mapper { get; set; }
        protected IServiceProvider _serviceProvider { get; set; }
        public BaseState(IServiceProvider serviceProvider, AutokucaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }
        public virtual Task<Models.Automobil> Insert(AutomobilInsert request)
        {
            throw new Exception("This action is not allowed.");
        }

        public virtual Task<Models.Automobil> Update(int id, AutomobilUpdate request)
        {
            throw new Exception("This action is not allowed.");
        }

        public virtual Task<Models.Automobil> Activate(int id)
        {
            throw new Exception("This action is not allowed.");
        }

        public virtual Task<Models.Automobil> Hide(int id)
        {
            throw new Exception("This action is not allowed.");
        }

        public virtual Task<Models.Automobil> Delete(int id)
        {
            throw new Exception("This action is not allowed.");
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "Initial":
                    return _serviceProvider.GetService<InitialState>();
                    break;
                case "Draft":
                    return _serviceProvider.GetService<DraftState>();
                    break;
                case "Active":
                    return _serviceProvider.GetService<ActiveState>();
                    break;

                default:
                    throw new Exception("Not allowed");
            }
        }
    }
}
