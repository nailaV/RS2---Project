using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IOpremaService:ICrudService<Models.Oprema, OpremaSearchObject, OpremaInsert, OpremaUpdate>
    {
        Task<Models.Oprema> GetById(int automobilId);
    }
}
