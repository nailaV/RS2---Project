using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class KorisniciInsert
    { 
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string? Telefon { get; set; }

        public string Username { get; set; } = null!;

        public bool Stanje { get; set; }
        public string Password { get; set; }
        public string PasswordPotvrda { get; set; }
    }
}
