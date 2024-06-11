using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface INarudzbaService:ICrudService<Models.Narudzba, NarudzbaSearchObject, NarudzbaInsert, NarudzbaUpdate>
    {
        public Task posaljiNarudzbu(int id);
        public Task otkaziNarudzbu(int id);
        Task dodajNarudzbu (NarudzbaInsert insert);
    }
}
