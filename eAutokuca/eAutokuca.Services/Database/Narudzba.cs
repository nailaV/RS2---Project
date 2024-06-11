using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Narudzba
{
    public int NarudzbaId { get; set; }

    public decimal UkupniIznos { get; set; }

    public int? KorisnikId { get; set; }

    public DateTime DatumNarudzbe { get; set; }

    public string Status { get; set; } = null!;

    public string? BrojTransakcije { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual ICollection<StavkeNarudzbe> StavkeNarudzbes { get; set; } = new List<StavkeNarudzbe>();
}
