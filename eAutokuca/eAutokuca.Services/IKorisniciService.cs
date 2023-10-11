using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IKorisniciService:ICrudService<Models.Korisnik, KorisnikSearchObject, KorisniciInsert, KorisniciUpdate>
    {
       
    }
}
