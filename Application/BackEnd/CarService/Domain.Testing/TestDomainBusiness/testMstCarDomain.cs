using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit;
using NUnit.Framework;
using Domain.Business;
using Domain.DataAccess;

namespace Domain.Testing
{
    [TestFixture]
    public class testMstCarDomain
    {
        private IMstCarDomain _IMstCarDomain {get; set;}

        [SetUp]
        public void Init(IMstCarDomain IMstCarDomain)
        {
            _IMstCarDomain = IMstCarDomain;
        }

        [Test]
        public void testAdd()
        {
            // Arrange
            var data = new mstCar();

            data.Name = "Test";
            data.IsActive = true;
            data.CreatedDate = DateTime.Now;

            // Act
            _IMstCarDomain.SaveData(data);

            // Assert
            Assert.That(data.AutoID > 0, Is.True);
        }

        [Test]
        public void GetData()
        {
            // Arrange
            var data = new List<mstCar>();

            // Act
            data = _IMstCarDomain.ReadAll();

            // Assert
            Assert.That(data.Count > 0, Is.True);
        }
    }
}
