using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    public class CarViewModel
    {
        public mstCar car { get; set; }
        public mstSparePart sparepart { get; set; }
    }
}
