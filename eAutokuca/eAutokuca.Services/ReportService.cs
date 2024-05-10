using AutoMapper;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
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
    
    public class ReportService : IReportService
    {
        private readonly AutokucaContext _context;
        private readonly IMapper _mapper;
        public ReportService(AutokucaContext context, IMapper mapper) 
        {
            _context = context;
            _mapper = mapper;

        }


        public async Task<List<Models.Report>> GetAllReports(ReportSearchObject? search = null)
        {
            var entity = _context.Reports.Include("Automobil").AsQueryable();
            if (search.Mjesec != 13)
            {
                entity = entity.Where(x => x.DatumProdaje.Month == search.Mjesec);
            }
            await entity.ToListAsync();
            return _mapper.Map<List<Models.Report>>(entity);
        
        }

      

        public async Task<Models.Report> Insert(ReportInsert insert)
        {
            var entity = new Database.Report();
            entity.DatumProdaje=DateTime.Now;
            _mapper.Map(insert, entity);
            await _context.AddAsync(entity);
            await _context.SaveChangesAsync();
            var auto = await _context.Automobils.FindAsync(insert.AutomobilId);
            auto.Status = "Prodan";
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Report>(entity);
        }
    }
}
