using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class AutomobilUpdate
    {
        //public decimal? cijena { get; set; }
        //public string? slikabase64 { get; set; }
        //public string? Model { get; set; }
        public string? Mjenjac { get; set; }
        public string? Motor { get; set; }
        public int?  GodinaProizvodnje { get; set; }
        public decimal? PredjeniKilometri { get; set; }
        public string? BrojSasije { get; set; }
        public string? SnagaMotora { get; set; }
        public int? BrojVrata { get; set; }
        public string? Boja { get; set; }


    }
}
