/*

Queries:
1. How many classes does “Alice Jones” teach
2. Find the total no. of students enrolled for each class
3. Find the total no. of classes conducted by each professor and also the total cost to attend each of the professor’s classes

*/

db.createCollection("classes")

db.classes.insertMany([{
    class: "Philosophy 101",
    startDate: new Date(2016, 1, 10),
    students: [
        { fName: "Dale", lName: "Cooper", age: 42 },
        { fName: "Lucy", lName: "Moran", age: 35 },
        { fName: "Tommy", lName: "Hill", age: 44 }
    ],
    cost: 1600,
    professor: "Paul Slugman",
    topics: "Socrates,Plato,Aristotle,Francis Bacon",
    book:
    {
        isbn: "1133612105",
        title: "Philosophy : A Text With Readings",
        price: 165.42
    }
}
,{
    class: "College Algebra",
    startDate: new Date(2016, 1, 11),
    students: [
        { fName: "Dale", lName: "Cooper", age: 42 },
        { fName: "Laura", lName: "Palmer", age: 22 },
        { fName: "Donna", lName: "Hayward", age: 21 },
        { fName: "Shelly", lName: "Johnson", age: 24 }
    ],
    cost: 1500,
    professor: "Rhonda Smith",
    topics: "Rational Expressions,Linear Equations,Quadratic Equations",
    book:
    {
        isbn: "0321671791",
        title: "College Algebra",
        price: 179.40
    }
}
,{
    class: "Astronomy 101",
    startDate: new Date(2016, 1, 11),
    students: [
        { fName: "Bobby", lName: "Briggs", age: 21 },
        { fName: "Laura", lName: "Palmer", age: 22 },
        { fName: "Audrey", lName: "Horne", age: 20 }
    ],
    cost: 1650,
    professor: "Paul Slugman",
    topics: "Sun,Mercury,Venus,Earth,Moon,Mars",
    book:
    {
        isbn: "0321815351",
        title: "Astronomy: Beginning Guide to Univ",
        price: 129.45
    }
}
,{
    class: "Geology 101",
    startDate: new Date(2016, 1, 12),
    students: [
        { fName: "Andy", lName: "Brennan", age: 36 },
        { fName: "Laura", lName: "Palmer", age: 22 },
        { fName: "Audrey", lName: "Horne", age: 20 }
    ],
    cost: 1450,
    professor: "Alice Jones",
    topics: "Earth,Moon,Elements,Minerals",
    book:
    {
        isbn: "0321814061",
        title: "Earth : An Introduction to Physical Geology",
        price: 130.65
    }
}
,{
    class: "Biology 101",
    startDate: new Date(2016, 1, 11),
    students: [
        { fName: "Andy", lName: "Brennan", age: 36 },
        { fName: "James", lName: "Hurley", age: 25 },
        { fName: "Harry", lName: "Truman", age: 41 }
    ],
    cost: 1550,
    professor: "Alice Jones",
    topics: "Earth,Cell,Energy,Genetics,DNA",
    book:
    {
        isbn: "0547219474",
        title: "Holt McDougal Biology",
        price: 104.30
    }
}
,{
    class: "Chemistry 101",
    startDate: new Date(2016, 1, 13),
    students: [
        { fName: "Bobby", lName: "Briggs", age: 21 },
        { fName: "Donna", lName: "Hayward", age: 21 },
        { fName: "Audrey", lName: "Horne", age: 20 },
        { fName: "James", lName: "Hurley", age: 25 }
    ],
    cost: 1600,
    professor: "Alice Jones",
    topics: "Matter,Energy,Atom,Periodic Table",
    book:
    {
        isbn: "0547219474",
        title: "Chemistry : Matter and Change",
        price: 104.30
    }
}
])

// How many classes does “Alice Jones” teach

var map_function = function(){ emit( this.professor, 1 )}
var reduce_function = function(Class, Count) { return Array.sum(Count) }
db.classes.mapReduce(map_function, reduce_function, {
    query: {
        professor: "Alice Jones"
    },
    out: "resultCollection"
})

db.resultCollection.find()

// [ { _id: 'Alice Jones', value: 3 } ]


// Find the total no. of students enrolled for each class

var map_function = function(){ emit( this.class, this.students.length ) }
var reduce_function = function(Class, students){
    return Array.sum(students)
}

db.classes.mapReduce(map_function, reduce_function, {
    out: "resultCollection2"
})

db.resultCollection2.find();
// [
//     { _id: 'Astronomy 101', value: 3 },
//     { _id: 'Geology 101', value: 3 },
//     { _id: 'Biology 101', value: 3 },
//     { _id: 'Philosophy 101', value: 3 },
//     { _id: 'Chemistry 101', value: 4 },
//     { _id: 'College Algebra', value: 4 }
// ]


// Find the total no. of classes conducted by each professor and also the total cost to attend each of the professor’s classes


var map_function = function() { emit( this.professor, { cost: this.cost, count: 1 } ) }
var reduce_function = function( professor, values ){
    var value = { count: 0, cost:0 }
    for(let i=0; i<values.length; i++){
        value.cost += values[i].cost;
        value.count += values[i].count;
    }
    return value
}
db.classes.mapReduce(map_function, reduce_function, { out: 'resultCollection3' })

db.resultCollection3.find()

/*
[
  { _id: 'Rhonda Smith', value: { count: 1, cost: 1500 } },
  { _id: 'Alice Jones', value: { count: 3, cost: 4600 } },
  { _id: 'Paul Slugman', value: { count: 2, cost: 3250 } }
]
*/