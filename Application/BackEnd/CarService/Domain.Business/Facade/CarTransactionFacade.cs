using Ninject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Domain.DataAccess;

namespace Domain.Business
{
    /// <summary>
    /// Ini namanya facade pattern
    /// Ini juga termasuk pattern dalam design pattern lhooo.......
    /// Singkatnya facade pattern ini memisahkan concern setiap business logic menjadi beberapa bagian kecil.
    /// Bingung? coba perhatikan method save dibawah.
    /// Ada 2 proses yang ingin kita insert. Mobil dan SparePart. Betul?
    /// Kebetulan Mobil mempunyai business logic sendiri dan SparePart juga punya sendiri
    /// andai logic itu kita tumpuk ke dalam 1 function. bayangin line of code jadi berapa tuh?
    /// Nah dengan facade pattern. Line of code jadi lebih ringkes. Lebih enak kan dibaca nya?
    /// Hayooo di googling facada pattern
    /// </summary>
    public class CarTransactionFacade
    {
        private IUnitofWork _uow;
        private IMstCarDomain _carDomain;
        private IMstSparePartDomain _SparePartDomain;

        public CarTransactionFacade(IUnitofWork uow, IMstCarDomain carDomain, IMstSparePartDomain SparePartDomain)
        {
            _uow = uow;
            _carDomain = carDomain;
            _SparePartDomain = SparePartDomain;
        }

        public void Save(CarViewModel vm)
        {
            try
            {
                _uow.Open(DBConnection.BMIERP);
                _uow.BeginTransaction();

                _carDomain.SaveDataFacade(vm.car, _uow);
                vm.sparepart.CarID = vm.car.AutoID;
                _SparePartDomain.SaveDataFacade(vm.sparepart, _uow);

                _uow.CommitTransaction();
            }
            catch (Exception)
            {
                _uow.RollbackTransaction();
                throw;
            }
            finally
            {
                _uow.Dispose();
            }
        }
    }
}
