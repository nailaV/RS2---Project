using eAutokuca.Models;

namespace eAutokuca.Services
{
    public interface IService<T, TSearch > where TSearch : class
    {
        Task<PagedResult<T>> Get(TSearch? search = null);
        Task<T> GetByID(int id);
    }
}