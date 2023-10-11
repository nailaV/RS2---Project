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
        public decimal? Cijena { get; set; }

    }
}
