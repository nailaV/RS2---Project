using System;
using System.Collections.Generic;

namespace eAutokuca.Services.Database;

public partial class Oprema
{
    public int OpremaId { get; set; }

    public int? AutomobilId { get; set; }

    public bool? ZracniJastuci { get; set; }

    public bool? Bluetooth { get; set; }

    public bool? Xenon { get; set; }

    public bool? Alarm { get; set; }

    public bool? DaljinskoKljucanje { get; set; }

    public bool? Navigacija { get; set; }

    public bool? ServoVolan { get; set; }

    public bool? AutoPilot { get; set; }

    public bool? Tempomat { get; set; }

    public bool? ParkingSenzori { get; set; }

    public bool? GrijanjeSjedista { get; set; }

    public bool? GrijanjeVolana { get; set; }

    public virtual Automobil? Automobil { get; set; }
}
