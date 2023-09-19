namespace eAutokuca.Services
{
    public interface IService<T>
    {
        Task<List<T>> Get();
        Task<T> GetByID(int id);
    }
}