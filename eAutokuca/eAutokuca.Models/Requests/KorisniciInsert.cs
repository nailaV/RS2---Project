﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class KorisniciInsert
    {
        [Required(AllowEmptyStrings =false)]
        public string Ime { get; set; } = null!;

        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string? Telefon { get; set; }

        public string Username { get; set; } = null!;

        public bool Stanje { get; set; }
        [Compare("PasswordPotvrda", ErrorMessage ="Sifre se ne poklapaju!")]
        public string Password { get; set; }
        [Compare("Password", ErrorMessage = "Sifre se ne poklapaju!")]
        public string PasswordPotvrda { get; set; }
    }
}
