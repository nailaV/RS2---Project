using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public interface IReportService
    {
        public Task<List<Models.Report>> GetAllReports(ReportSearchObject? search = null);
        public Task<Models.Report> Insert(ReportInsert insert);
        public  Task<List<string>> GetSveMarke();
    }
}
