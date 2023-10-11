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
    }
}
