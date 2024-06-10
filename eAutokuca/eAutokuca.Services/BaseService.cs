using AutoMapper;
using eAutokuca.Models;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class BaseService<T, TDb, TSearch> : IService<T, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        protected AutokucaContext _context;
        protected IMapper _mapper { get; set; }
        public BaseService(AutokucaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public virtual async Task<PagedResult<T>> Get(TSearch? search=null)
        {
            var query = _context.Set<TDb>().AsQueryable();

            PagedResult<T> list = new PagedResult<T>();

            query = AddFilter(query, search);

            list.Count = await query.CountAsync();

            if (search?.PageSize != null)
            {
                double? pageCount = list.Count;
                double? pageSize = search.PageSize;
                if (pageCount.HasValue && pageSize.HasValue)
                {
                    list.TotalPages = (int)Math.Ceiling(pageCount.Value / pageSize.Value);
                }
            }

         
            query = AddInclude(query);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.PageSize.Value * (search.Page.Value - 1)).Take(search.PageSize.Value);
                list.HasNext = search.Page < list.TotalPages;
            }



            var lista = await query.ToListAsync();

            list.Result = _mapper.Map<List<T>>(lista);

            return list;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable <TDb> query,TSearch? search = null)
        {
            return query;
        }

        public virtual async Task<T> GetByID(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }
    }
}
