### Assignment 9

#### Problem Statement

__Create a MongoDB collection and insert every variety of documents__
```
teachers : {
    name,
    age,
    qualifications,
    deptno,
    deptname,
    designation,
    experience : {
        industry,
        teaching
    },
    salary : {
        basic,
        TA,
        DA,
        HRA
    },
    date_of_joining,
    appointment_nature,
    area_of_expertise
}
```

### Assignment


__Connect to Mongodb__  

```bash
mongosh "mongodb://localhost:27017/my_db" -u tirthraj07 -p
```


__show collections__

```mongodb
db.createCollection("teacherCollection")
```

__insertOne and insertMany__
```mongodb
db.teacherCollection.insertOne({
    name: "Tirthraj Mahajan",
    age: 20,
    qualifications: ["BTech", "MS", "PhD"],
    deptno: 1,
    deptname: "Computer Engineering",
    designation: "Professor",
    experience : {
        industry : 10,
        teaching: 10
    },
    salary: {
        basic: 50000,
        TA: 10000,
        DA: 20000,
        HRA: 15000
    },
    date_of_joining: new Date("2024-09-24"),
    appointment_nature: "Permanent",
    area_of_expertise: ["DBMS", "AIML"]
});

db.teacherCollection.insertMany([
{
    name: "Aditya Mulay",
    age: 21,
    qualifications: ["BTech"],
    deptno: 2,
    deptname: "Information Technology",
    designation: "Assistant Professor",
    experience : {
        industry : 1,
        teaching: 5
    },
    salary: {
        basic: 60000,
        TA: 10000,
        DA: 20000,
        HRA: 15000
    },
    date_of_joining: new Date("2024-11-4"),
    appointment_nature: "Permanent",
    area_of_expertise: ["DBMS", "CNS"]
},
{
    name: "Arnav Vaidya",
    age: 20,
    qualifications: ["BTech", "MTech"],
    deptno: 2,
    deptname: "Information Technology",
    designation: "Professor",
    experience : {
        industry : 5,
        teaching: 1
    },
    salary: {
        basic: 70000,
        TA: 10000,
        DA: 20000,
        HRA: 15000
    },
    date_of_joining: new Date("2024-11-1"),
    appointment_nature: "Permanent",
    area_of_expertise: ["Cybersecurity", "CNS"]
},
{
    name: "Vardhan Dongre",
    age: 20,
    qualifications: ["BTech"],
    deptno: 3,
    deptname: "Electronics and Telecommunication",
    designation: "Professor",
    experience : {
        industry : 4,
        teaching: 3
    },
    salary: {
        basic: 30000,
        TA: 10000,
        DA: 20000,
        HRA: 15000
    },
    date_of_joining: new Date("2023-10-2"),
    appointment_nature: "Permanent",
    area_of_expertise: ["DELD", "CNS"]
}
])
```

__To find max 1 record - findOne__
```mongodb
db.teacherCollection.findOne()
{
  _id: ObjectId('6728824637f55b739c0d8190'),
  name: 'Tirthraj Mahajan',
  age: 20,
  qualifications: [ 'BTech', 'MS', 'PhD' ],
  deptno: 1,
  deptname: 'Computer Engineering',
  designation: 'Professor',
  experience: { industry: 10, teaching: 10 },
  salary: { basic: 50000, TA: 10000, DA: 20000, HRA: 15000 },
  date_of_joining: ISODate('2024-09-24T00:00:00.000Z'),
  appointment_nature: 'Permanent',
  area_of_expertise: [ 'DBMS', 'AIML' ]
}
```

__You can do projections like following__

```mongodb
db.teacherCollection.findOne({},{name:1, deptno:1})

{
  _id: ObjectId('6728824637f55b739c0d8190'),
  name: 'Tirthraj Mahajan',
  deptno: 1
}
```

__Apply Constraints__

```mongodb
db.teacherCollection.findOne({ deptno: 2 },{name:1, deptname:1})
{
  _id: ObjectId('6728861637f55b739c0d8191'),
  name: 'Aditya Mulay',
  deptname: 'Information Technology'
}
```

__Find many documents - find()__

```mongodb
db.teacherCollection.find({})
```

Find using _id

```mongodb
db.teacherCollection.find({_id: ObjectId('6728824637f55b739c0d8190')})
[
  {
    _id: ObjectId('6728824637f55b739c0d8190'),
    name: 'Tirthraj Mahajan',
    age: 20,
    qualifications: [ 'BTech', 'MS', 'PhD' ],
    deptno: 1,
    deptname: 'Computer Engineering',
    designation: 'Professor',
    experience: { industry: 10, teaching: 10 },
    salary: { basic: 50000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate('2024-09-24T00:00:00.000Z'),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'DBMS', 'AIML' ]
  }
]
```

With constraints

```mongodb
db.teacherCollection.find({deptno : {$eq: 2}, "salary.basic" : {$eq: 70000}})


[
  {
    _id: ObjectId('6728861637f55b739c0d8192'),
    name: 'Arnav Vaidya',
    age: 20,
    qualifications: [ 'BTech', 'MTech' ],
    deptno: 2,
    deptname: 'Information Technology',
    designation: 'Professor',
    experience: { industry: 5, teaching: 1 },
    salary: { basic: 70000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate('2024-10-31T18:30:00.000Z'),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'Cybersecurity', 'CNS' ]
  }
]
```

__Find record where deptno = 2 and salary = 70000__

```mongodb
db.teacherCollection.find({deptno : {$eq: 2}, "salary.basic" : {$eq: 70000}}, {name:1, age:1})

[
  {
    _id: ObjectId('6728861637f55b739c0d8192'),
    name: 'Arnav Vaidya',
    age: 20
  }
]
```

```mongodb
db.teacherCollection.find({deptno : {$eq: 2}, "salary.basic" : {$eq: 70000}}, {name:1, age:1, _id:0})


[ { name: 'Arnav Vaidya', age: 20 } ]

```

__If you don't want to use eq, you can simply do:__
```mongodb
db.teacherCollection.find({deptno : 2, "salary.basic": 70000}, {name:1, age:1, _id:0})
[ { name: 'Arnav Vaidya', age: 20 } ]
```


__Find all records that have area of expertise in DBMS and DEL__
```mongodb
db.teacherCollection.find({area_of_expertise: {$in: ["DBMS","DELD"]}})

[
  {
    _id: ObjectId('6728824637f55b739c0d8190'),
    name: 'Tirthraj Mahajan',
    age: 20,
    qualifications: [ 'BTech', 'MS', 'PhD' ],
    deptno: 1,
    deptname: 'Computer Engineering',
    designation: 'Professor',
    experience: { industry: 10, teaching: 10 },
    salary: { basic: 50000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate('2024-09-24T00:00:00.000Z'),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'DBMS', 'AIML' ]
  },
  {
    _id: ObjectId('6728861637f55b739c0d8191'),
    name: 'Aditya Mulay',
    age: 21,
    qualifications: [ 'BTech' ],
    deptno: 2,
    deptname: 'Information Technology',
    designation: 'Assistant Professor',
    experience: { industry: 1, teaching: 5 },
    salary: { basic: 60000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate('2024-11-03T18:30:00.000Z'),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'DBMS', 'CNS' ]
  },
  {
    _id: ObjectId('6728861637f55b739c0d8193'),
    name: 'Vardhan Dongre',
    age: 20,
    qualifications: [ 'BTech' ],
    deptno: 3,
    deptname: 'Electronics and Telecommunication',
    designation: 'Professor',
    experience: { industry: 4, teaching: 3 },
    salary: { basic: 30000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate('2023-10-01T18:30:00.000Z'),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'DELD', 'CNS' ]
  }
]
```

__Find all records that have area_of_expertise in BOTH DBMS and CNS__
```mongodb
db.teacherCollection.find({area_of_expertise: {$all: ["DBMS","CNS"]}})
[
  {
    _id: ObjectId('6728861637f55b739c0d8191'),
    name: 'Aditya Mulay',
    age: 21,
    qualifications: [ 'BTech' ],
    deptno: 2,
    deptname: 'Information Technology',
    designation: 'Assistant Professor',
    experience: { industry: 1, teaching: 5 },
    salary: { basic: 60000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate('2024-11-03T18:30:00.000Z'),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'DBMS', 'CNS' ]
  }
]
```

__Update one__

```mongodb
db.teacherCollection.updateOne(
    { _id: ObjectId('6728824637f55b739c0d8190') },
    {
    $set : {
            "salary.basic": 50000,
            "salary.HRA": 10000
        }
    }
)
```

__Using aggregation Pipeline__

```mongodb
db.teacherCollection.updateOne(
    { _id: ObjectId('6728824637f55b739c0d8190') },
    [
        {
            $set : {
                "salary.basic": { $multiply: ["$salary.basic", 1.15]},
                "salary.HRA": { $multiply: ["$salary.HRA", 1.15]}
            }
        }
    ]
)
```

<code>
If you want to perform calculations (like using $multiply) as part of an update operation, you need to wrap the $set operator in an array ([]) to indicate that you're using an aggregation pipeline.
For simple value assignments, you can use the standard $set without aggregation.
</code>
  

__delete__

```mongodb
db.teacherCollection.deleteMany({deptno:3})
```