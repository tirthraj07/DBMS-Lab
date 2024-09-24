/*
Create a MongoDB collection and insert every variety of documents

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

*/

db.teachers.insertOne({
    name: "John Doe",
    age: 27,
    qualifications: ["MTech", "Phd"],
    deptno: 1,
    deptname: "CSE",
    designation: "Assistant Professor",
    experience: {
        industry: 5,
        teaching: 3
    },
    salary : {
        basic: 50000,
        TA: 10000,
        DA: 20000,
        HRA: 15000
    },
    date_of_joining : new Date("2024-09-24"),
    appointment_nature: "Permanent",
    area_of_expertise: ["DBMS", "AIML"]
});

/*
te31242_db> db.teachers.find()
[
  {
    _id: ObjectId("66f247f551ac3a58c61a3c4b"),
    name: 'John Doe',
    age: 27,
    qualifications: [ 'MTech', 'Phd' ],
    deptno: 1,
    deptname: 'CSE',
    designation: 'Assistant Professor',
    experience: { industry: 5, teaching: 3 },
    salary: { basic: 50000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate("2024-09-24T00:00:00.000Z"),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'DBMS', 'AIML' ]
  }
]
*/

db.teachers.insertMany(
    [
        {
            name: "Alice Smith",
            age: 30,
            qualifications: ["MSc", "MBA"],
            deptno: 2,
            deptname: "IT Eng",
            designation: "Professor",
            experience: {
                industry: 6,
                teaching: 4
            },
            salary: {
                basic: 60000,
                TA: 12000,
                DA: 25000,
                HRA: 18000
            },
            date_of_joining: new Date("2022-01-15"),
            appointment_nature: "Permanent",
            area_of_expertise: ["Marketing", "Finance"]
        },
        {
            name: "Michael Brown",
            age: 35,
            qualifications: ["BTech", "MTech"],
            deptno: 3,
            deptname: "FE",
            designation: "Professor",
            experience: {
                industry: 10,
                teaching: 8
            },
            salary: {
                basic: 70000,
                TA: 15000,
                DA: 30000,
                HRA: 20000
            },
            date_of_joining: new Date("2018-08-01"),
            appointment_nature: "Permanent",
            area_of_expertise: ["Circuit Design", "Power Systems"]
        },
        {
            name: "Emily Johnson",
            age: 28,
            qualifications: ["BSc", "MSc"],
            deptno: 4,
            deptname: "ENTC",
            designation: "Lecturer",
            experience: {
                industry: 3,
                teaching: 2
            },
            salary: {
                basic: 45000,
                TA: 8000,
                DA: 15000,
                HRA: 12000
            },
            date_of_joining: new Date("2023-06-10"),
            appointment_nature: "adhoc",
            area_of_expertise: ["Algebra", "Calculus"]
        },
        {
            name: "David Wilson",
            age: 40,
            qualifications: ["MTech", "PhD"],
            deptno: 4,
            deptname: "ENTC",
            designation: "Senior Lecturer",
            experience: {
                industry: 12,
                teaching: 6
            },
            salary: {
                basic: 65000,
                TA: 11000,
                DA: 27000,
                HRA: 19000
            },
            date_of_joining: new Date("2015-03-20"),
            appointment_nature: "Permanent",
            area_of_expertise: ["Thermodynamics", "Fluid Mechanics"]
        }
    ]
)

/*
te31242_db> db.teachers.find()
[
  {
    _id: ObjectId("66f247f551ac3a58c61a3c4b"),
    name: 'John Doe',
    age: 27,
    qualifications: [ 'MTech', 'Phd' ],
    deptno: 1,
    deptname: 'CSE',
    designation: 'Assistant Professor',
    experience: { industry: 5, teaching: 3 },
    salary: { basic: 50000, TA: 10000, DA: 20000, HRA: 15000 },
    date_of_joining: ISODate("2024-09-24T00:00:00.000Z"),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'DBMS', 'AIML' ]
  },
  {
    _id: ObjectId("66f24ac651ac3a58c61a3c4c"),
    name: 'Alice Smith',
    age: 30,
    qualifications: [ 'MSc', 'MBA' ],
    deptno: 2,
    deptname: 'IT Eng',
    designation: 'Professor',
    experience: { industry: 6, teaching: 4 },
    salary: { basic: 60000, TA: 12000, DA: 25000, HRA: 18000 },
    date_of_joining: ISODate("2022-01-15T00:00:00.000Z"),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'Marketing', 'Finance' ]
  },
  {
    _id: ObjectId("66f24ac651ac3a58c61a3c4d"),
    name: 'Michael Brown',
    age: 35,
    qualifications: [ 'BTech', 'MTech' ],
    deptno: 3,
    deptname: 'FE',
    designation: 'Professor',
    experience: { industry: 10, teaching: 8 },
    salary: { basic: 70000, TA: 15000, DA: 30000, HRA: 20000 },
    date_of_joining: ISODate("2018-08-01T00:00:00.000Z"),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'Circuit Design', 'Power Systems' ]
  },
  {
    _id: ObjectId("66f24ac651ac3a58c61a3c4e"),
    name: 'Emily Johnson',
    age: 28,
    qualifications: [ 'BSc', 'MSc' ],
    deptno: 4,
    deptname: 'ENTC',
    designation: 'Lecturer',
    experience: { industry: 3, teaching: 2 },
    salary: { basic: 45000, TA: 8000, DA: 15000, HRA: 12000 },
    date_of_joining: ISODate("2023-06-10T00:00:00.000Z"),
    appointment_nature: 'adhoc',
    area_of_expertise: [ 'Algebra', 'Calculus' ]
  },
  {
    _id: ObjectId("66f24ac651ac3a58c61a3c4f"),
    name: 'David Wilson',
    age: 40,
    qualifications: [ 'MTech', 'PhD' ],
    deptno: 4,
    deptname: 'ENTC',
    designation: 'Senior Lecturer',
    experience: { industry: 12, teaching: 6 },
    salary: { basic: 65000, TA: 11000, DA: 27000, HRA: 19000 },
    date_of_joining: ISODate("2015-03-20T00:00:00.000Z"),
    appointment_nature: 'Permanent',
    area_of_expertise: [ 'Thermodynamics', 'Fluid Mechanics' ]
  }
]

*/
