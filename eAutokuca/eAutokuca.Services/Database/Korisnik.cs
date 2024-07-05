using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Korisnik
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Telefon { get; set; }

    public string Username { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public bool Stanje { get; set; }

    public byte[]? Slika { get; set; }

    public DateTime? DatumRegistracije { get; set; }

    public virtual ICollection<AutomobilFavoriti> AutomobilFavoritis { get; set; } = new List<AutomobilFavoriti>();

    public virtual ICollection<Komentari> Komentaris { get; set; } = new List<Komentari>();

    public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; } = new List<KorisnikUloga>();

    public virtual ICollection<Narudzba> Narudzbas { get; set; } = new List<Narudzba>();

    public virtual ICollection<Recenzije> Recenzijes { get; set; } = new List<Recenzije>();

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();
}
