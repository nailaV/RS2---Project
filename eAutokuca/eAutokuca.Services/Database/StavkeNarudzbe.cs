using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class StavkeNarudzbe
{
    public int StavkeNarudzbeId { get; set; }

    public int? NaruzdbaId { get; set; }

    public int? AutodioId { get; set; }

    public int Kolicina { get; set; }

    public virtual Autodio? Autodio { get; set; }

    public virtual Narudzba? Naruzdba { get; set; }
}
