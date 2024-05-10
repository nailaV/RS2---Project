using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ReportController
    {
          IReportService _service;
           public ReportController( IReportService service) 
            {
                _service = service;
            }
        [HttpGet]
        public async Task<List<Models.Report>> GetAllReports([FromQuery] ReportSearchObject? search = null)
        {
            return await _service.GetAllReports(search);
        }

        [HttpPost]
        public async Task<Models.Report> Insert([FromBody] ReportInsert insert)
        {
            return await _service.Insert(insert);
        }

    }
}
