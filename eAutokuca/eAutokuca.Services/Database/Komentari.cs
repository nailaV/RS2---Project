﻿using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Komentari
{
    public int KomentarId { get; set; }

    public string? Sadrzaj { get; set; }

    public DateTime? DatumDodavanja { get; set; }

    public int? KorisnikId { get; set; }

    public int? AutomobilId { get; set; }

    public string? Stanje { get; set; }

    public virtual Automobil? Automobil { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
