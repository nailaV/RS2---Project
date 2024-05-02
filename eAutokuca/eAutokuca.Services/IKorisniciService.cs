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
        public Task<Models.Korisnik> Login(string username, string password);
        public Task<Models.Korisnik> getByUsername(string username);
        public Task<Models.Korisnik> promjenaPassworda(int id, KorisnikPasswordPromjena request);
    }
}
