using AutoMapper;
using eAutokuca.Models;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class AutodioService :BaseService<Models.Autodio, Database.Autodio>, IAutodioService
    {
        public AutodioService(AutokucaContext context, IMapper mapper):base(context,mapper) 
        {

        }
       
    }
}
