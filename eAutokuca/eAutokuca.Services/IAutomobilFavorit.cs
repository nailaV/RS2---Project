using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IAutomobilFavorit : ICrudService<Models.AutomobilFavorit,FavoritiSearchObject, FavoritiInsert, FavoritiUpdate>
    {
        public Task<List<Models.AutomobilFavorit>> getFavoriteZaUsera(string username);
        public Task<bool> isFavorit(int automobilId, int korisnikId);
        public Task brisiFavorita(int automobilId, int korisnikId);
      
    }
}
