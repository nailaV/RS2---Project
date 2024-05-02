using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class KorisnikPasswordPromjena
    {
        public string StariPassword { get; set; }
        public string NoviPassword { get; set; }
        public string NoviPasswordProvjera { get; set; }
    }
}
