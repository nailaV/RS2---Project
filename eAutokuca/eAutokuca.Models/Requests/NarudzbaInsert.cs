using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class NarudzbaInsert
    {
        public decimal UkupniIznos { get; set; }

        public int? KorisnikId { get; set; }
        public string BrojTransakcije { get; set; } = null!;
        public int autodioId { get; set; }
        public int kolicina { get; set; }

    }
}
