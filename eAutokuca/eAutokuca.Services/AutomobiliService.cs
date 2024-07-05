using AutoMapper;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.AutomobiliStateMachine;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eAutokuca.Services
{
    public class AutomobiliService : BaseCrudService<Models.Automobil, Database.Automobil, AutomobilSearchObject, AutomobilInsert, AutomobilUpdate>, IAutomobiliService
    {
        public BaseState _baseState { get; set; }
        public AutomobiliService(BaseState baseState, AutokucaContext context, IMapper mapper) :
            base(context, mapper)
        {
            _baseState = baseState;
        }




        public override IQueryable<Database.Automobil> AddFilter(IQueryable<Database.Automobil> query, AutomobilSearchObject? search = null)
        {
            query = query.Where(x => x.Status == search.AktivniNeaktivni);
            return query;
        }


        public override async Task<Models.Automobil> Insert(AutomobilInsert insert)
        {   
            Database.Automobil entity=new ();

            _mapper.Map(insert, entity);
            if(!string.IsNullOrEmpty(insert?.slikaBase64))
            {
                entity.Slike=Convert.FromBase64String(insert.slikaBase64);
            }
            entity.Status = "Aktivan";

            await _context.AddAsync(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<Models.Automobil>(entity);


        }


        public async Task<Models.Automobil> Activate(int id)
        {
            var entity = await _context.Automobils.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);

            return await state.Activate(id);
        }

        public async Task<Models.Automobil> Hide(int id)
        {
            var entity = await _context.Automobils.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);

            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Automobils.FindAsync(id);
            var state=_baseState.CreateState(entity?.Status ?? "Initial");

            return await state.AllowedActions();
            
        }

        public async Task<List<string>> GetSveMarke()
        {
            var lista = new List<string>
            {
                "Sve marke"
            };

            var marke = await _context.Automobils.Select(x => x.Marka).Distinct().ToListAsync();
            foreach (var item in marke)
            {
                lista.Add(item);
            }

            return lista;
        }

        public async Task<List<string>> GetSveModele()
        {
            var lista = new List<string>
            {
                "Svi modeli"
            };

            var modeli=await _context.Automobils.Select(x=>x.Model).Distinct().ToListAsync();
            foreach (var item in modeli)
            {
                lista.Add(item);
            }

            return lista;
        }

        public async Task<PagedResult<Models.Automobil>> Filtriraj(AutomobilSearchObject? searchObject = null)
        {
            var query= _context.Automobils.OrderByDescending(x=>x.AutomobilId).AsQueryable();

            if(!string.IsNullOrWhiteSpace(searchObject?.AktivniNeaktivni))
            {
                query = query.Where(x => x.Status == searchObject.AktivniNeaktivni);
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Status))
            {
                query = query.Where(x => x.Status == searchObject.Status);
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.FTS))
            {
                query = query.Where(x => x.Model.Contains(searchObject.FTS) || x.Marka.Contains(searchObject.FTS) || x.Boja.Contains(searchObject.FTS));
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Marka))
            {
                if(searchObject.Marka!="Sve marke")
                {
                    query = query.Where(x => x.Marka == searchObject.Marka);
                }
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Boja))
            {
                if (searchObject.Model != "Sve boje")
                {
                    query = query.Where(x => x.Boja == searchObject.Boja);
                }
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Mjenjac))
            {
                if (searchObject.Mjenjac != "Svi")
                {
                    query = query.Where(x => x.Mjenjac == searchObject.Mjenjac);
                }
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.Motor))
            {
                if (searchObject.Motor != "Svi")
                {
                    query = query.Where(x => x.Motor == searchObject.Motor);
                }
            }
            if (searchObject?.PredjeniKilometri.HasValue == true)
            {
                query = query.Where(x => x.PredjeniKilometri > searchObject.PredjeniKilometri);
            }
            if (searchObject?.GodinaProizvodnje.HasValue == true)
            {
                query = query.Where(x => x.GodinaProizvodnje >= searchObject.GodinaProizvodnje);
            }

            var lista = new PagedResult<Models.Automobil>()
            {
                Count = await query.CountAsync(),
            };

            if(searchObject?.PageSize != null)
            {
                double? count = lista.Count;
                double? pageSize = searchObject.PageSize;
                if(count.HasValue && pageSize.HasValue)
                {
                    lista.TotalPages = (int)Math.Ceiling(count.Value / pageSize.Value);
                }
            }

            if(searchObject?.Page.HasValue==true && searchObject?.PageSize.HasValue==true)
            {
                query = query.Skip(searchObject.PageSize.Value * (searchObject.Page.Value - 1)).Take(searchObject.PageSize
                    .Value);
                lista.HasNext = searchObject.Page.Value < lista.TotalPages;
            }    

            var lista1=await query.ToListAsync();
            lista.Result = _mapper.Map<List<Models.Automobil>>(lista1);

            return lista;
        }

        public async Task deaktiviraj(int id)
        {
            var entity=await _context.Automobils.FindAsync(id);
            if(entity==null)
            {
                throw new Exception("Automobil ne postoji");
            }
            entity.Status = "Neaktivan";
            await _context.SaveChangesAsync();
        }

        public async Task aktiviraj(int id)
        {
            var entity = await _context.Automobils.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Automobil ne postoji");
            }
            entity.Status = "Aktivan";
            await _context.SaveChangesAsync();
        }


        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        public List<Models.Automobil> Recommend(int userId)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var rezervacija = _context.Rezervacijas.Include(x => x.Automobil).ToList();

                    if (rezervacija.Count == 0)
                    {
                        return new List<Models.Automobil>();
                    }

                    var data = new List<UserItemEntry>();

                    foreach (var x in rezervacija)
                    {
                        data.Add(new UserItemEntry()
                        {
                            UserId = (uint)x.KorisnikId,
                            ItemId = (uint)x.AutomobilId,
                            Rating = 1
                        });
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(UserItemEntry.UserId);
                    options.MatrixRowIndexColumnName = nameof(UserItemEntry.ItemId);
                    options.LabelColumnName = "Rating";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }
            }

            var cars = _context.Automobils.Where(x => x.Status == "Aktivan" && !_context.Rezervacijas.Any(y => y.KorisnikId == userId && y.AutomobilId == x.AutomobilId)).ToList();

            var predictionResult = new List<Tuple<Database.Automobil, float>>();

            foreach (var car in cars)
            {
                var predictionEngine = mlContext.Model.CreatePredictionEngine<UserItemEntry, UserBasedPrediction>(model);
                var prediction = predictionEngine.Predict(
                    new UserItemEntry()
                    {
                        UserId = (uint)userId,
                        ItemId = (uint)car.AutomobilId
                    });

                predictionResult.Add(new Tuple<Database.Automobil, float>(car, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(y => y.Item1).Take(3).ToList();

            return _mapper.Map<List<Models.Automobil>>(finalResult);
        }

        public class UserItemEntry
        {
            [KeyType(count: 10)]
            public uint UserId { get; set; }

            [KeyType(count: 10)]
            public uint ItemId { get; set; }

            public float Rating { get; set; }
        }

        public class UserBasedPrediction
        {
            public float Score { get; set; }
        }
    }
}
