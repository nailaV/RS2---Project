using AutoMapper;
using Azure.Core;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class KorisniciService : BaseCrudService<Models.Korisnik, Database.Korisnik,KorisnikSearchObject, KorisniciInsert, KorisniciUpdate>, IKorisniciService
    {
   
        public KorisniciService(AutokucaContext context, IMapper mapper):base(context, mapper) 
        {
            
        }

        public async override Task<Models.Korisnik> Insert(KorisniciInsert insert)
        {
            if(await _context.Korisniks.AnyAsync(x=>x.Username == insert.Username))
            {
                throw new Exception("Username se već koristi, molimo unesite drugi.");
            }
            if (await _context.Korisniks.AnyAsync(x => x.Email == insert.Email))
            {
                throw new Exception("Email se već koristi, molimo unesite drugi.");
            }
            if (await _context.Korisniks.AnyAsync(x => x.Telefon == insert.Telefon))
            {
                throw new Exception("Broj telefona se već koristi, molimo unesite drugi.");
            }

            var user = new Korisnik();
            _mapper.Map(insert, user);

            user.LozinkaSalt=GenerateSalt();
            user.LozinkaHash = GenerateHash(user.LozinkaSalt, insert.Password);
            user.DatumRegistracije=DateTime.Now;
            user.Stanje = true;
            if(insert?.slikaBase64!=null)
            {
                user.Slika=Convert.FromBase64String(insert.slikaBase64!);
            }
            await _context.Korisniks.AddAsync(user);
            await _context.SaveChangesAsync();
            var korisnikUloga = new KorisnikUloga() { KorisnikId = user.KorisnikId, UlogaId = 2 };
            await _context.KorisnikUlogas.AddAsync(korisnikUloga);
            await _context.SaveChangesAsync();


            return _mapper.Map<Models.Korisnik>(user);

        }
        public override async Task BeforeInsert(Korisnik entity, KorisniciInsert insert)
        {

            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
        }


        public Models.Korisnik Update(int id, KorisniciUpdate request)
        {
            var entity = _context.Korisniks.Find(id);
            _mapper.Map(request, entity);

            _context.SaveChanges();

            return _mapper.Map<Models.Korisnik>(entity);
        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override IQueryable<Korisnik> AddInclude(IQueryable<Korisnik> query, KorisnikSearchObject? search = null)
        {
            if (search?.UlogeIncluded == true)
            {
                query = query.Include("KorisnikUlogas.Uloga");
            }
            return base.AddInclude(query, search);
        }


        public async Task<Models.Korisnik> Login(string username, string password)
        {
            var entity = await _context.Korisniks.Include("KorisnikUlogas.Uloga").FirstOrDefaultAsync(x => x.Username == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return _mapper.Map<Models.Korisnik>(entity);
        }

        public async Task<Models.Korisnik> getByUsername(string username)
        {
            var result=await _context.Korisniks.Where(x=>x.Username == username).FirstOrDefaultAsync();

            return _mapper.Map<Models.Korisnik>(result);
        }

        public async Task<Models.Korisnik> promjenaPassworda(int id, KorisnikPasswordPromjena request)
        {
            var entity = await _context.Korisniks.FindAsync(id) ?? throw new Exception("Korisnik nije pronađen.");
            var hash = GenerateHash(entity.LozinkaSalt, request.StariPassword);

            if(hash != entity.LozinkaHash)
            {
                throw new Exception("Password se ne poklapa.");
            }
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.NoviPassword);
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Korisnik>(entity);

        }

        public async Task promjenaSlike(int id, PromjenaSlike request)
        {
            var entity = await _context.Korisniks.FindAsync(id);
            if(entity == null)
            {
                throw new Exception("Korisnik ne postoji.");
            }
            entity.Slika = Convert.FromBase64String(request.slika);
            await _context.SaveChangesAsync();
        }

        public async Task promijeniStanje(int id)
        {
            var entity = await _context.Korisniks.FindAsync(id);
            if( entity == null )
            {
                throw new Exception("Korisnik ne postoji");
            }
            entity.Stanje = !entity.Stanje;
            await _context.SaveChangesAsync();
           
        }

        public override IQueryable<Korisnik> AddFilter(IQueryable<Korisnik> query, KorisnikSearchObject? search = null)
        {
            query = query.Where(x => x.Stanje == search.AktivniNeaktivni);
            return query;
        }
    }
}
