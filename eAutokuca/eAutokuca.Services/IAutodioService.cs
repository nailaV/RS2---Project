﻿using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IAutodioService:ICrudService<Models.Autodio, AutodioSearchObject, AutodioInsert, AutodioUpdate>
    {
        public Task aktiviraj(int id);
        public Task deaktiviraj(int id);

        //List<Models.Autodio> Recommend(int autodioID);
    }
}
