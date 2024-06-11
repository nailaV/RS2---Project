﻿using AutoMapper;
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
    public class NarudzbaService : BaseCrudService<Models.Narudzba, Database.Narudzba, NarudzbaSearchObject, NarudzbaInsert, NarudzbaUpdate>, INarudzbaService
    {
        public NarudzbaService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
