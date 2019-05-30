using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Domain.DataAccess
{
    public class mstCamera
    {
        [BsonId]
        public ObjectId id { get; set; }
        [BsonElement("Brand")]
        public string Brand { get; set; }
        [BsonElement("Country")]
        public string Country { get; set; }
        [BsonElement("Rank")]
        public int Rank { get; set; }
    }
}
