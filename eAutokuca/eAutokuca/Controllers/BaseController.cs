﻿using eAutokuca.Models;
using eAutokuca.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [Route("[controller]")]
    [Authorize]
    public class BaseController<T, TSearch> : ControllerBase where T : class where TSearch : class
    {
        protected readonly IService<T, TSearch> _service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch>> logger, IService<T, TSearch> service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet("getAll")]
        public async Task<PagedResult<T>> Get([FromQuery]TSearch search)
        {
            return await _service.Get(search);
        }

        [HttpGet("{id}/getByID")]
        public async Task<T> GetByID(int id)
        {
            return await _service.GetByID(id);
        }


    }
}
