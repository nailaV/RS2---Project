using eAutokuca.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Services
{
    public class AutomobiliService : IAutomobiliService
    {
        List<Automobili> automobilis = new List<Automobili>()
        {
            new Automobili()
            {
                AutomobilID = 1,
                Cijena=1000,
                GodinaProizvodnje=2012,
                PredjeniKilometri=12500,
                BrojSasije="aha678",
                Motor="Dizel",
                SnagaMotora="100kw",
                Mjenjac="Manuelni",
                Boja="Zelena",
                BrojVrata=5,
                Model="A6",
                Marka="Audi",
                Status="U dolasku"
            }
        };
        public IList<Automobili> Get()
        {
            return automobilis;
        }
    }
}
