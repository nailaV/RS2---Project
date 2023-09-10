using eAutokuca.Models;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class AutomobiliService : IAutomobiliService
    {
        AutokucaContext _context;
        public AutomobiliService(AutokucaContext context)
        {
            _context = context;
        }
     
        public IList<Automobil> Get()
        {
            var lista=_context.Automobils.ToList();
            return lista;
        }
    }
}
