﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.Requests
{
    public class AutomobilUpdate
    {
        public decimal? Cijena { get; set; }
        public string? slikabase64 { get; set; }
        public string? Model { get; set; }

    }
}
