using System;
using System.Collections.Generic;

namespace eAutokuca.Database;

public partial class Rezervacija
{
    public int RezervacijaId { get; set; }

    public DateTime DatumVrijemeRezervacije { get; set; }

    public string? Status { get; set; }

    public int? AutomobilId { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Automobil? Automobil { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
