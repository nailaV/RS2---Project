using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Oprema
{
    public int OpremaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Opis { get; set; }

    public int? AutomobilId { get; set; }

    public virtual Automobil? Automobil { get; set; }
}
