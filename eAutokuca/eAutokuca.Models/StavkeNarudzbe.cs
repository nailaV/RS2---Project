using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class StavkeNarudzbe
    {
        public int StavkeNarudzbeId { get; set; }

        public int? NaruzdbaId { get; set; }

        public int? AutodioId { get; set; }

        public int Kolicina { get; set; }

        public virtual Autodio? Autodio { get; set; }

        public virtual Narudzba? Naruzdba { get; set; }
    }
}
