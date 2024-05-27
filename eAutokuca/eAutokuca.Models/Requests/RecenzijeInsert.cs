using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class RecenzijeInsert
    {
        public string Sadrzaj { get; set; } = null!;

        public int? KorisnikId { get; set; }

        public int Ocjena { get; set; }

        
    }
}
