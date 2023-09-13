using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class KorisniciService : IKorisniciService
    {
        AutokucaContext _context;
        public KorisniciService(AutokucaContext context)
        {
            _context = context;
        }
        public List<Models.Korisnik> Get()
        {
            var entityList= _context.Korisniks.ToList();
            var list= new List<Models.Korisnik>();
            foreach (var entity in entityList)
            {
                list.Add(new Models.Korisnik()
                {
                    Email = entity.Email,
                    Ime = entity.Ime,
                    Prezime = entity.Prezime,
                    Username = entity.Username,
                    Stanje = entity.Stanje,
                    Telefon = entity.Telefon,
                    KorisnikId = entity.KorisnikId
                });
            }
            return list;
        }
    }
}
