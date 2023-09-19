using AutoMapper;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class BaseService<T, TDb> : IService<T> where TDb : class where T : class
    {
        AutokucaContext _context;
        public IMapper _mapper { get; set; }
        public BaseService(AutokucaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<T>> Get()
        {
            var query=_context.Set<TDb>().AsQueryable();

            var list = await query.ToListAsync();
            return _mapper.Map<List<T>>(list);
        }

        public virtual async Task<T> GetByID(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }
    }
}
