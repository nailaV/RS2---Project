﻿using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Automobil
{
    public int AutomobilId { get; set; }

    public decimal Cijena { get; set; }

    public int GodinaProizvodnje { get; set; }

    public decimal PredjeniKilometri { get; set; }

    public string BrojSasije { get; set; } = null!;

    public string Motor { get; set; } = null!;

    public string SnagaMotora { get; set; } = null!;

    public string Mjenjac { get; set; } = null!;

    public string Boja { get; set; } = null!;

    public int BrojVrata { get; set; }

    public string Model { get; set; } = null!;

    public string Marka { get; set; } = null!;

    public string Status { get; set; } = null!;

    public virtual ICollection<Oprema> Opremas { get; set; } = new List<Oprema>();

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();
}
