using AutoMapper;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class StavkeNarudzbeService : BaseCrudService<Models.StavkeNarudzbe, Database.StavkeNarudzbe, StavkeNarudzbeSearchObject, StavkeNarudzbeInsert, StavkeNarudzbeUpdate>, IStavkeNarudzbeService
    {
        public StavkeNarudzbeService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
