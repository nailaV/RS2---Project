using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public partial class Autodio
    {
        public int AutodioId { get; set; }

        public string Naziv { get; set; } = null!;

        public decimal Cijena { get; set; }

        public int KolicinaNaStanju { get; set; }
        public string? Opis { get; set; }
        public byte[]? Slika { get; set; } = null!;

        public string Status { get; set; } = null!;
    }
}
