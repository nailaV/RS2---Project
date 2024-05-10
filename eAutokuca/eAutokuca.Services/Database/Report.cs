using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Report
{
    public int ReportId { get; set; }

    public int AutomobilId { get; set; }

    public DateTime DatumProdaje { get; set; }

    public decimal Prihodi { get; set; }

    public virtual Automobil Automobil { get; set; } = null!;
}
