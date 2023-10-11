using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class AutomobilInsert
    {
        public decimal Cijena { get; set; }

        public int GodinaProizvodnje { get; set; }

        public decimal PredjeniKilometri { get; set; }

        public string BrojSasije { get; set; } = null!;

        public string Motor { get; set; } = null!;

        public string SnagaMotora { get; set; } = null!;

        public string Mjenjac { get; set; } = null!;

        public string Boja { get; set; } = null!;

        public int BrojVrata { get; set; }

        public string Model { get; set; } = null!;

        public string Marka { get; set; } = null!;

        public string Status { get; set; } = null!;
    }
}
