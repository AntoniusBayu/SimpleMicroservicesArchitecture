using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Domain.DataAccess
{
    public class mstBrand
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string id { get; set; }
        [BsonElement("Brand")]
        public string BrandID { get; set; }
        [BsonElement("Country")]
        public string BrandName { get; set; }
    }
}
