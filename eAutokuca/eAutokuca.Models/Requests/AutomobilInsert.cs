using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class AutomobilInsert
    {
        [Range(1,double.MaxValue)]
        public decimal Cijena { get; set; }
        [Required]
        public int GodinaProizvodnje { get; set; }
        [Required]
        public decimal PredjeniKilometri { get; set; }
       
        [StringLength(17,MinimumLength =17, ErrorMessage ="Broj sasije ima 17 karaktera.")]
        public string BrojSasije { get; set; } = null!;
        
        public string Motor { get; set; } = null!;

        public string SnagaMotora { get; set; } = null!;

        public string Mjenjac { get; set; } = null!;

        public string Boja { get; set; } = null!;

        public int BrojVrata { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string Model { get; set; } = null!;

        public string Marka { get; set; } = null!;

        public string Status { get; set; } = null!;
    }
}
