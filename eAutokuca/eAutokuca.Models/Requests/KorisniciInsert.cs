using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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

        public string? slikaBase64 { get; set; } = null!;
   
        [Compare("PasswordPotvrda", ErrorMessage ="Sifre se ne poklapaju!")]
        public string Password { get; set; }
        [Compare("Password", ErrorMessage = "Sifre se ne poklapaju!")]
        public string PasswordPotvrda { get; set; }
    }
}
