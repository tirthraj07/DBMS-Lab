## MONGODB

The MongoDB is an open-source document database and leading NoSQL database. MongoDB is written in C++. 
MongoDB is a cross-platform, document oriented database that provides, high performance, high availability, and easy scalability. MongoDB works on concept of collection and document.

### Database
Database is a physical container for collections. 
Each database gets its own set of files on the file system. 
A single MongoDB server typically has multiple databases.

### Collection
Collection is a group of MongoDB documents. It is the equivalent of an RDBMS table. 
A collection exists within a single database. 
__Collections do not enforce a schema__. Documents within a collection can have different fields. 
Typically, all documents in a collection are of similar or related purpose.

### Document
A document is a set of __key-value pairs__. Documents have dynamic schema. Dynamic schema means that documents in the same collection do not need to have the same set of fields or structure, and common fields in a collection's documents may hold different types of data.

<table>
    <tr>
        <td>RDBMS</td>
        <td>MongoDB</td>
    </tr>
    <tr>
        <td>Database</td>
        <td>Database</td>
    </tr>
    <tr>
        <td>Table</td>
        <td>Collection</td>
    </tr>
    <tr>
        <td>Row</td>
        <td>Document</td>
    </tr>
    <tr>
        <td>Coloumn</td>
        <td>Field</td>
    </tr>
    <tr>
        <td>Table Join</td>
        <td>Embedded Table</td>
    </tr>
    <tr>
        <td>Primary Key</td>
        <td>Primary Key (Default key _id provided by MongoDB itself)</td>
    </tr>
</table>

Example Collection

```json
{
   _id: ObjectId(7df78ad8902c)
   title: 'MongoDB Overview', 
   description: 'MongoDB is no sql database',
   by: 'tutorials point',
   url: 'http://www.tutorialspoint.com',
   tags: ['mongodb', 'database', 'NoSQL'],
   likes: 100, 
   comments: [	
      {
         user:'user1',
         message: 'My first comment',
         dateCreated: new Date(2011,1,20,2,15),
         like: 0 
      },
      {
         user:'user2',
         message: 'My second comments',
         dateCreated: new Date(2011,1,25,7,45),
         like: 5
      }
   ]
}
```

### MongoDB CRUD Operations

### Databases
#### Create Database

```bash
use dbname
```

#### Show Databases

```bash
show dbs
```

#### Drop Databases

```bash
use dbname
db.dropDatabase()
```

### Collections

#### Create Collection

```bash
db.createCollection("myCollection")
```

#### Show Collectiosn

```bash
show collections
```

#### Insert Documents

Insert one doccument

```bash
db.myCollection.insertOne({ name: "Alice", age: 25, city: "New York" })
```

Insert multiple doccument
```json
db.myCollection.insertMany([
  { name: "Bob", age: 30, city: "Los Angeles" },
  { name: "Charlie", age: 35, city: "Chicago" }
])
```

#### Find Documents

Find all documents
```bash
db.myCollection.find()
```

Find documents with a specific condition

```bash
db.myCollection.find({ age: { $gt: 28 } }) // Find documents where age is greater than 28
```

Find with Projection

```bash
db.myCollection.find({}, { name: 1, city: 1 }) // Only include name and city
```

__Comparison Operators in MongoDB__

<table>
    <tr>
        <td>Name
        <td>Description
    </tr>
    <tr>
        <td>$eq</td>
        <td>Matches values that are equal to a specified value.</td>
    </tr>
    <tr>
        <td>$gt</td>
        <td>Matches values that are greater than a specified value.</td>
    </tr>
    <tr>
        <td>$gte</td>
        <td>Matches values that are greater than or equal to a specified value.</td>
    </tr>
    <tr>
        <td>$in</td>
        <td>Matches any of the values specified in an array.</td>
    </tr>
    <tr>
        <td>$lt</td>
        <td>Matches values that are less than a specified value.</td>
    </tr>
    <tr>
        <td>$lte</td>
        <td>Matches values that are less than or equal to a specified value.</td>
    </tr>
    <tr>
        <td>$ne</td>
        <td>Matches all values that are not equal to a specified value.</td>
    </tr>
    <tr>
        <td>$nin</td>
        <td>Matches none of the values specified in an array.</td>
    </tr>
<table>

#### Update Collection

Update One Document
```json
db.myCollection.updateOne(
  { name: "Alice" }, // Filter
  { $set: { age: 26 } } // Update operation
)
```

Update Many Document

```json
db.myCollection.updateMany(
  { city: "Chicago" }, // Filter
  { $set: { city: "Houston" } } // Update operation
)
````
#### Delete Document

Delete one document

```bash
db.myCollection.deleteOne({ name: "Bob" })
```

Delete many document

```bash
db.myCollection.deleteMany({ age: { $lt: 30 } }) // Deletes all documents with age less than 30
```


#### Drop Collection

```bash
db.myCollection.drop()
```

