using eAutokuca.Models.Requests;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IKorisniciService
    {
        Task<List<Models.Korisnik>> Get();
        Models.Korisnik Insert(KorisniciInsert request);
        Models.Korisnik Update(int id, KorisniciUpdate request);
    }
}
