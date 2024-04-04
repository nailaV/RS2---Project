using AutoMapper;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class BaseCrudService<T, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDb, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        public BaseCrudService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb entity, TInsert insert)
        {

        }

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set=_context.Set<TDb>();
            TDb entity= _mapper.Map<TDb>(insert);
            set.Add(entity);

            await BeforeInsert(entity, insert);
            await _context.SaveChangesAsync(); 
            return _mapper.Map<T>(entity); 
        }

        public virtual async Task<T> Update(int id, TUpdate update)
        {
            var context=_context.Set<TDb>();
            var entity= await context.FindAsync(id);

            if(entity == null) {
                throw new Exception("User sa unesenim ID brojem nije pronađen.");
            }

            _mapper.Map(update, entity);

           await _context.SaveChangesAsync(); 
            return _mapper.Map<T>(entity);
        }

        public virtual async Task Delete (int ID)
        {
            var entity = await _context.Set<TDb>().FindAsync(ID);

            if (entity == null)
            {
                throw new Exception("User sa unesenim ID brojem nije pronađen.");
            }

            _context.Set<TDb>().Remove(entity);

            await DeleteCar(ID);

            await _context.SaveChangesAsync();

        }

        public virtual async Task DeleteCar(int id)
        {

        }
    }
}
