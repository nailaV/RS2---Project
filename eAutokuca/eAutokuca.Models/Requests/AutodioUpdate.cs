using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class AutodioUpdate
    {
        public string? Naziv { get; set; }
        public decimal? Cijena { get; set; }
        public int? KolicinaNaStanju { get; set; }
        public string? Status { get; set; }
        public string? Slika { get; set; }
        public string? Opis { get; set; }
    }
}
