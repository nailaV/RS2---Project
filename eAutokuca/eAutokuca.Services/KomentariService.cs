using AutoMapper;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class KomentariService : BaseCrudService<Models.Komentari, Database.Komentari, KomentariSearchObject, KomentariInsert, KomentariUpdate>, IKomentariService
    {
        public KomentariService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Komentari> AddFilter(IQueryable<Komentari> query, KomentariSearchObject? search = null)
        {
            query = query.Where(x => x.AutomobilId == search.AutomobilId);
            return base.AddFilter(query, search);
        }
    }
}
