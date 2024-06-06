using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore.SqlServer.Query.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IAutomobiliService:ICrudService<Models.Automobil, AutomobilSearchObject, AutomobilInsert, AutomobilUpdate>
    {
        Task<Models.Automobil> Activate(int id);
        Task<Models.Automobil> Hide(int id);
        Task<List<string>> AllowedActions(int id);
        Task<List<string>> GetSveMarke();
        Task<List<string>> GetSveModele();
        Task<PagedResult<Models.Automobil>> Filtriraj(AutomobilSearchObject? searchObject=null);
        public Task deaktiviraj(int id);
        public Task aktiviraj(int id);
        

    }
}
