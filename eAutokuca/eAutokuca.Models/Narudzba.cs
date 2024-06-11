using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class Narudzba
    {
        public int NarudzbaId { get; set; }

        public decimal UkupniIznos { get; set; }

        public int? KorisnikId { get; set; }

        public DateTime DatumNarudzbe { get; set; }

        public string Status { get; set; } = null!;

        public virtual Korisnik? Korisnik { get; set; }

        public virtual ICollection<StavkeNarudzbe> StavkeNarudzbes { get; set; } = new List<StavkeNarudzbe>();
    }
}
