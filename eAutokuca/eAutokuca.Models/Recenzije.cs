using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class Recenzije
    {
        public int RecenzijeId { get; set; }

        public string Sadrzaj { get; set; } = null!;

        public int? KorisnikId { get; set; }

        public int Ocjena { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
    }
}
