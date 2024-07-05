using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class KomentariInsert
    {
        public string Sadrzaj { get; set; }
        public int KorisnikId { get; set; }
        public int AutomobilId { get; set; }
    }
}
