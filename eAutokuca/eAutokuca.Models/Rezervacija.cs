using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public partial class Rezervacija
    {
        public int RezervacijaId { get; set; }
        public DateTime DatumVrijemeRezervacije { get; set; }

        public string? Status { get; set; }

        public virtual Models.Automobil? Automobil { get; set; }
        public virtual Models.Korisnik? Korisnik { get; set; }

    }
}
