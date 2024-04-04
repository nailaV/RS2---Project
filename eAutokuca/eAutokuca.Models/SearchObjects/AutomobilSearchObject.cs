using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.SearchObjects
{
    public class AutomobilSearchObject:BaseSearchObject
    {
        public string? Model { get; set; }
        public string? Marka { get; set; }
        public string? FTS { get; set; } 
        public string? Boja { get; set; } = null!;

    }
}
