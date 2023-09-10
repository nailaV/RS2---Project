using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Recenzije
{
    public int RecenzijeId { get; set; }

    public string Sadrzaj { get; set; } = null!;

    public int? KorisnikId { get; set; }

    public int Ocjena { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
