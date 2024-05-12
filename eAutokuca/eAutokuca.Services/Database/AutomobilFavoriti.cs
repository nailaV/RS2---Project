using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class AutomobilFavoriti
{
    public int FavoritId { get; set; }

    public int? AutomobilId { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Automobil? Automobil { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
