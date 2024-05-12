using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class AutomobilFavorit
    {
        public int FavoritId { get; set; }
        public int AutomobilId { get; set; }
        public int KorisnikId { get; set; }
        public virtual Automobil? Automobil { get; set; }
        public virtual Korisnik? Korisnik { get; set; }
    }
}
