using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class Automobili
    {
        public int AutomobilID { get; set; }
        public float Cijena { get; set; }
        public int GodinaProizvodnje { get; set; }
        public float PredjeniKilometri { get; set; }
        public string BrojSasije { get; set; }
        public string Motor { get; set; }
        public string SnagaMotora { get; set; } 
        public string Mjenjac { get; set;}
        public string Boja { get; set; }
        public int BrojVrata { get; set; }
        public string Model { get; set; }
        public string Marka { get; set; }
        public string Status { get; set; }

    }
}
