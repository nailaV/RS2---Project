using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Autodio
{
    public int AutodioId { get; set; }

    public string Naziv { get; set; } = null!;

    public decimal Cijena { get; set; }

    public int KolicinaNaStanju { get; set; }

    public string Status { get; set; } = null!;

    public virtual ICollection<StavkeNarudzbe> StavkeNarudzbes { get; set; } = new List<StavkeNarudzbe>();
}
