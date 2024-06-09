using AutoMapper;
using Azure.Core;
using eAutokuca.Models;
using eAutokuca.Models.Requests;
using eAutokuca.Models.SearchObjects;
using eAutokuca.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class AutodioService :BaseCrudService<Models.Autodio, Database.Autodio, AutodioSearchObject, AutodioInsert, AutodioUpdate>, IAutodioService
    {
        public AutodioService(AutokucaContext context, IMapper mapper):base(context,mapper) 
        {

        }

        public override async Task<Models.Autodio> Update(int id, AutodioUpdate update)
        {
            var entity = await _context.Autodios.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Korisnik ne postoji.");
            }
            if (!string.IsNullOrEmpty(update.Slika))
            {
                entity.Slika = Convert.FromBase64String(update.Slika);
            }
            entity.Opis=update.Opis;
            if (!string.IsNullOrEmpty(update.Naziv))
            {
                entity.Naziv = update.Naziv;
            }
            if (update.Cijena!=null)
            {
                entity.Cijena = update.Cijena.Value;
            }
            if (update.KolicinaNaStanju != null)
            {
                entity.KolicinaNaStanju = update.KolicinaNaStanju.Value;
            }


            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Autodio>(entity);
        }

        public async override Task<Models.Autodio> Insert(AutodioInsert insert)
        {
            var autodio=new Database.Autodio();
            _mapper.Map(insert, autodio);
            autodio.Status = "Dostupno";
            if (insert?.slikaBase64 != null)
            {
                autodio.Slika = Convert.FromBase64String(insert.slikaBase64!);
            }
            await _context.Autodios.AddAsync(autodio);
            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Autodio>(autodio);

        }



        public override IQueryable<Database.Autodio> AddFilter(IQueryable<Database.Autodio> query, AutodioSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            if(!string.IsNullOrWhiteSpace(search?.FullTextSearch))
            {
                query=query.Where(x=>x.Naziv.Contains(search.FullTextSearch));  
            }

            if(!string.IsNullOrWhiteSpace(search?.Status)) 
            {
                query=query.Where(x=>x.Status.StartsWith(search.Status));
            }

            query = query.Where(x => x.KolicinaNaStanju >= 1);

            return base.AddFilter(query, search);
        }

        public async Task nabavi(int id)
        {
            var entity = await _context.Autodios.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Autodio ne postoji");
            }
            entity.Status = "Dostupno";
            await _context.SaveChangesAsync();
        }

        public async Task prodaj(int id)
        {
            var entity = await _context.Autodios.FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Autodio ne postoji");
            }
            entity.Status = "Rasprodato";
            entity.KolicinaNaStanju = 0;
            await _context.SaveChangesAsync();
        }


        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        public  List<Models.Autodio> Recommend(int autodioID)
        {
            lock (isLocked) 
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();
                    var tmpData = _context.Narudzbas.Include("StavkeNarudzbes").ToList();

                    var data = new List<AutodioEntry>();
                    foreach (var x in tmpData)
                    {
                        if(x.StavkeNarudzbes.Count > 1)
                        {
                            var distinctItemId = x.StavkeNarudzbes.Select(y => y.AutodioId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = x.StavkeNarudzbes.Where(z => z.AutodioId != y);

                                foreach(var z in relatedItems)
                                {
                                    data.Add(new AutodioEntry()
                                    {
                                        AutodioID= (uint)y,
                                        CopurchaseAutodioID = (uint)z.AutodioId,
                                    });
                                }
                            });
                        }
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(AutodioEntry.AutodioID);
                    options.MatrixRowIndexColumnName = nameof(AutodioEntry.AutodioID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }
            }

            var products = _context.Autodios.Where(x => x.AutodioId != autodioID);

            var predictionResult = new List<Tuple<Database.Autodio, float>>();

            foreach(var product in products)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<AutodioEntry, Copurchase_prediction>(model);
                var prediction = predictionengine.Predict(
                                         new AutodioEntry()
                                         {
                                             AutodioID = (uint)autodioID,
                                             CopurchaseAutodioID = (uint)product.AutodioId
                                         });


                predictionResult.Add(new Tuple<Database.Autodio, float>(product, prediction.Score));
            }


            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return _mapper.Map<List<Models.Autodio>>(finalResult);
        }
    }


    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class AutodioEntry
    {
        [KeyType(count: 10)]
        public uint AutodioID { get; set; }

        [KeyType(count: 10)]
        public uint CopurchaseAutodioID { get; set; }

        public float Label { get; set; }
    }
}
