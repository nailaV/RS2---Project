using eAutokuca.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IAutomobiliService
    {
        IList<Automobili> Get();
    }
}
