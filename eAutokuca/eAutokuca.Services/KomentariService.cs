using AutoMapper;
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
    public class KomentariService : BaseCrudService<Models.Komentari, Database.Komentari, KomentariSearchObject, KomentariInsert, KomentariUpdate>, IKomentariService
    {
        public KomentariService(AutokucaContext context, IMapper mapper) : base(context, mapper)
        {
        }


        public override IQueryable<Komentari> AddInclude(IQueryable<Komentari> query, KomentariSearchObject? search = null)
        {
            return query.Include("Automobil").Include("Korisnik");
        }

      
        public async Task<List<Models.Komentari>> getKomentareZaAuto(int autoId)
        {
            var auto = await _context.Automobils.Where(x => x.AutomobilId == autoId).FirstOrDefaultAsync();
            var result = await _context.Komentaris.Where(x => x.AutomobilId == auto.AutomobilId && x.Stanje=="Aktivan").ToListAsync();
            if(result.Count==0)
            {
                return new List<Models.Komentari>();
            }
            return _mapper.Map<List<Models.Komentari>>(result);
        }

        public async Task<Models.Komentari> dodajKomentar(KomentariInsert req)
        {
            var komentar = new Database.Komentari();
            komentar.DatumDodavanja = DateTime.Now;
            komentar.Stanje = "Aktivan";
            komentar.Sadrzaj = req.Sadrzaj;
            komentar.KorisnikId= req.KorisnikId;
            komentar.AutomobilId=req.AutomobilId;
            await _context.Komentaris.AddAsync(komentar);
            await _context.SaveChangesAsync();

            return _mapper.Map<Models.Komentari>(komentar); 
        }

        public async Task sakrijKomentar(int id)
        {
            var entity = await _context.Komentaris.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Komentar ne postoji");
            }
            entity.Stanje = "Obrisan";
            await _context.SaveChangesAsync();
        }

        public async Task<List<Models.Komentari>> getKomentareAdmin(int autoId)
        {
            var auto = await _context.Automobils.Where(x => x.AutomobilId == autoId).FirstOrDefaultAsync();
            var result = await _context.Komentaris.Where(x => x.AutomobilId == auto.AutomobilId).ToListAsync();
            if (result.Count == 0)
            {
                return new List<Models.Komentari>();
            }
            return _mapper.Map<List<Models.Komentari>>(result);
        }
    }
}
