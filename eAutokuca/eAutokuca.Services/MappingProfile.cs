using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Korisnik, Models.Korisnik>();
            CreateMap<Models.Requests.KorisniciInsert, Database.Korisnik>();
            CreateMap<Models.Requests.KorisniciUpdate, Database.Korisnik>();

            CreateMap<Database.Autodio, Models.Autodio>();
            CreateMap<Database.KorisnikUloga, Models.KorisnikUloga>();
            CreateMap<Database.Uloga, Models.Uloga>();
        }
    }
}
