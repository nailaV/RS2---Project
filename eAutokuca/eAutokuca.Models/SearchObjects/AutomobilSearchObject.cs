using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.SearchObjects
{
    public class AutomobilSearchObject:BaseSearchObject
    {
        public string? FTS { get; set; }
        public string? Boja { get; set; } = null!;
        public string? Model { get; set; } = null!;
        public string? Marka { get; set; } = null!;
        public int? GodinaProizvodnje { get; set; }
        public decimal? PredjeniKilometri { get; set; }
        public string? Mjenjac { get; set; } = null!;
        public string? Motor { get; set; } = null!;
        public string? AktivniNeaktivni { get; set; }


    }
}
