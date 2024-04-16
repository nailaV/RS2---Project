namespace eAutokuca.Models
{
    public partial class Korisnik
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string? Telefon { get; set; }

        public string Username { get; set; } = null!;

        public bool Stanje { get; set; }
        public byte[]? Slika { get; set; } = null!;

        public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; } = new List<KorisnikUloga>();
    }
}