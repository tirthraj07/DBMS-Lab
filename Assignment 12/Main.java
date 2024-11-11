import com.mongodb.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.*;


/*
	Step 1: Goto https://repo1.maven.org/maven2/org/mongodb/mongo-java-driver/3.12.14/mongo-java-driver-3.12.14.jar
	Step 2: Create new Java Project in Eclipse
	Step 3: Project -> Properties -> Java Build Path -> Libraries -> ** Click on Class Path ** -> Add External Jar -> Select mongo-java-driver-3.12.14.jar -> Apply -> Apply and Close
	
	MAKE SURE YOU CLICK CLASS PATH not MODULE PATH
*/

public class Main{
	public static void createNewCollection(MongoDatabase db) {
		db.createCollection("myCollection");
		System.out.println("Collection 'myCollection' created");
	}
	
	public static void insertDocumentIntoCollection(MongoDatabase db) {
		MongoCollection<Document> myCollection = db.getCollection("myCollection");
		
		Document doc = new Document();
		doc.append("product", "book");
		doc.append("price", 220);
		doc.append("customer", "Tirthraj");
		
		myCollection.insertOne(doc);
		
		System.out.println("Document Inserted into DB");
	}
	
	public static void insertMultipleDocuments(MongoDatabase db) {
		MongoCollection<Document> myCollection = db.getCollection("myCollection");
		String[] customers = {"Mulay", "Vartak", "Nags", "Chotu Badmash"};
		int[] prices = {200,300,400,500};
		String[] products = {"Laptop", "Protein Powder", "Internship", "Complan"};
		
		List<Document> docs = new ArrayList<Document>();
		
		for (int i=0; i<customers.length; i++) {
			Document doc = new Document();
			doc.append("customer", customers[i]);
			doc.append("price", prices[i]);
			doc.append("product", products[i]);
			docs.add(doc);
		}
		
		myCollection.insertMany(docs);
		System.out.println("Inserted Multiple Docs");
		
	}
	
	public static void readAllDocuments(MongoDatabase db) {
		MongoCollection<Document> myCollection = db.getCollection("myCollection");
		MongoCursor<Document> docs = myCollection.find().cursor();
		while(docs.hasNext()) {
			Document doc = docs.next();
			ObjectId id = doc.getObjectId("_id");
			String customer = doc.getString("customer");
			String product = doc.getString("product");
			String price = Integer.toString(doc.getInteger("price"));
			System.out.println("_id : " + id.toString());
			System.out.println("customer : " + customer);
			System.out.println("product : " + product);
			System.out.println("price : " + price);
			System.out.println("------------");
		}
	}
	
	/*
		_id : 6728fbce8503ca5cc94db5b7
		customer : Tirthraj
		product : book
		price : 220
		------------
		_id : 6728fbce8503ca5cc94db5b8
		customer : Mulay
		product : Laptop
		price : 200
		------------
		_id : 6728fbce8503ca5cc94db5b9
		customer : Vartak
		product : Protein Powder
		price : 300
		------------
		_id : 6728fbce8503ca5cc94db5ba
		customer : Nags
		product : Internship
		price : 400
		------------
		_id : 6728fbce8503ca5cc94db5bb
		customer : Chotu Badmash
		product : Complan
		price : 500
		------------
	 */
	
	
	public static void deleteOneRecord(MongoDatabase db) {
	 	MongoCollection<Document> myCollection = db.getCollection("myCollection");
	 	myCollection.deleteOne(Filters.eq("customer", "Tirthraj"));	
	 	System.out.println("Deleted One Document");
	}
	
	public static void updateOneDocument(MongoDatabase db) {
		MongoCollection<Document> myCollection = db.getCollection("myCollection");
		myCollection.updateOne(
				Filters.eq("customer", "Nags"), 
				Updates.combine(
						Updates.set("product", "perfume"),
						Updates.set("price", 100)
				)
		);
		
		System.out.println("Document Updated Successfully");
		
	}
	
	public static void main(String[] args) {
		MongoClient mongo = null;
		MongoDatabase db = null;
		try {
			mongo = new MongoClient("localhost",27017);
			db = mongo.getDatabase("11_jdbc_connectivity");	
		}
		catch(Exception e) {
			e.printStackTrace();
			if(mongo != null) {
				mongo.close();
			}
			return;
		}
		
			
		createNewCollection(db);
		
		insertDocumentIntoCollection(db);
		
		insertMultipleDocuments(db);
		
		readAllDocuments(db);
		
		deleteOneRecord(db);
		
		readAllDocuments(db);
		
		updateOneDocument(db);
		
		readAllDocuments(db);
		
		mongo.close();
	}
}
