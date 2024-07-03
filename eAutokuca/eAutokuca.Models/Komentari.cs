using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class Komentari
    {
        public int KomentarId { get; set; }

        public string? Sadrzaj { get; set; }

        public int? KorisnikId { get; set; }

        public int? AutomobilId { get; set; }

 
    }
}
