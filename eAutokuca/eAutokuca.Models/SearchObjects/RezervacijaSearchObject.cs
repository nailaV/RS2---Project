using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models.SearchObjects
{
    public class RezervacijaSearchObject:BaseSearchObject
    {
        private DateTime? _datum;

        public DateTime? datum
        {
            get { return _datum; }
            set
            {
                _datum = value != null ? value.Value.Date : null;
            }
        }
    }
}
