import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.Mongo;
import com.mongodb.WriteConcern;

import java.net.UnknownHostException;

class Day2Do2 {
  public static void main(String[] args) throws UnknownHostException {
    final Mongo m = new Mongo();
    m.setWriteConcern(WriteConcern.SAFE);
    
    final DB db = m.getDB("java");
    final DBCollection coll = db.getCollection("playing");

    for (int i = 0; i < 100; i++) {
      coll.insert(new BasicDBObject().append("value", i));
    }

    coll.createIndex(new BasicDBObject("value", 1));
  }
}
