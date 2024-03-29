using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.SearchObjects
{
    public class AutodioSearchObject :BaseSearchObject
    {
        public string? Naziv { get; set; }
        public string? FullTextSearch { get; set; }
        public string? Status { get; set; }
    }
}
