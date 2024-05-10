using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class Report
    {
        public int ReportId { get; set; }

        public int? AutomobilId { get; set; }

        public DateTime? DatumProdaje { get; set; }

        public decimal? Prihod { get; set; }

        public virtual Automobil? Automobil { get; set; }
    }
}
