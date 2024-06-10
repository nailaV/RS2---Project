using eAutokuca.Models;
using eAutokuca.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eAutokuca.Controllers
{
    [Route("[controller]")]
    [ApiController]

    public class MailContoller : ControllerBase
    {
        public IMailService _service;

        public MailContoller(IMailService service)
        {
            _service = service;

            
        }

        [HttpPost]
        public async Task sendMail ([FromBody] MailObject obj)
        {
           await _service.startConnection(obj);
        }

    }
}
