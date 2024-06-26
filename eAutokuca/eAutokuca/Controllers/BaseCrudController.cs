﻿using eAutokuca.Models;
using eAutokuca.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [Route("[controller]")]
    public class BaseCrudController<T, TSearch, TInsert, TUpdate> : BaseController<T, TSearch> where T : class where TSearch : class
    {
        protected new readonly ICrudService<T, TSearch, TInsert, TUpdate> _service;
        protected new readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseCrudController(ILogger<BaseController<T, TSearch>> logger, ICrudService<T, TSearch, TInsert, TUpdate> service) :
            base(logger, service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpPost]
        //[Authorize(Roles = "Admin")]
        public virtual async Task<T> Insert([FromBody] TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}/update")]
        public virtual async Task<T> Update(int id, [FromBody] TUpdate update)
        {
            return await _service.Update(id, update);
        }

        [HttpDelete("{ID}")]
        public virtual async Task Delete(int ID)
        {
            await _service.Delete(ID);
        }

     

    }
}
