db.createCollection("users")

// Insert the following data https://gist.githubusercontent.com/hiteshchoudhary/a80d86b50a5d9c591198a23d79e1e467/raw/a9d8022cf95dee0de47efad29697fecea05f9a23/data.json
db.users.insertMany([])

// how many users are active?
db.users.aggregate([
    {
        $match: {isActive: true}
    },
    {
        $count: 'count of active users'
    }
])

// [ { 'count of active users': 516 } ]

// Group People Based on Gender

db.users.aggregate([
    {
        $group : {
            _id: "$gender"
        }
    }
])

// [ { _id: 'male' }, { _id: 'female' } ]


// What is the average age of all users

db.users.aggregate([
    {
        $group : {
            _id: null,              // Grouping by `null` to calculate the average over all documents
            averageAge: { $avg: "$age" }
        }

        
    }
])

// [ { _id: null, averageAge: 29.835 } ]

// What is the average age of males and females?


db.users.aggregate([
{
    $group: {
        _id : "$gender",
        averageAge: {
            $avg: "$age"
        }
    }
}])

// [
//     { _id: 'male', averageAge: 29.851926977687626 },
//     { _id: 'female', averageAge: 29.81854043392505 }
// ]


// find the most common favourite fruits

// Note: $count is used in its own stage
// So inorder to count, we have to $sum : 1
db.users.aggregate([

    {
        $group : {
            _id : "$favoriteFruit",
            count: {
                $sum: 1
            }
        }
    },
    {
        $sort : {
            count:-1        // -1: Descending, 1: Ascending
        }
    },
    {
        $limit: 1
    },
    {
        $project : { count:0 }  // Exclude the count field in the final output
    }
])


/*
After Stage 1:
[
  { _id: 'banana', count: 339 },
  { _id: 'apple', count: 338 },
  { _id: 'strawberry', count: 323 }
]

After Stage 2:
[
  { _id: 'banana', count: 339 },
  { _id: 'apple', count: 338 },
  { _id: 'strawberry', count: 323 }
]

After Stage 3:
[ { _id: 'banana', count: 339 } ]

After Stage 4:
[ { _id: 'banana' } ]

*/


// Count the Number of Males and Females

db.users.aggregate([
    {
        $group: {
            _id: "$gender",
            genderCount: {
                $sum: 1
            }   
        }
    }
])

/*
[
  { _id: 'female', genderCount: 507 },
  { _id: 'male', genderCount: 493 }
]
*/


// Which country has the highest number of registered users

db.users.aggregate([
    {
        $project : { 
            _id: 1,
            country: "$company.location.country" 
        }
    },
    {
        $group : {
            _id: "$country",
            count : {
                $sum : 1
            }
        }
    },
    {
        $sort : {
            count: -1
        }
    },
    {
        $limit: 1
    },
    {
        $project:{
            _id: 0,
            "Country with most registerd users": "$_id"
        }
    }
])

// OUTPUT
// [ { 'Country with most registerd users': 'Germany' } ]

/*
Stage 1:

[
  { _id: ObjectId('67289d7a65874e9c57d1e783'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e784'), country: 'Italy' },
  { _id: ObjectId('67289d7a65874e9c57d1e785'), country: 'France' },
  { _id: ObjectId('67289d7a65874e9c57d1e786'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e787'), country: 'Italy' },
  { _id: ObjectId('67289d7a65874e9c57d1e788'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e789'), country: 'Germany' },
  { _id: ObjectId('67289d7a65874e9c57d1e78a'), country: 'Italy' },
  { _id: ObjectId('67289d7a65874e9c57d1e78b'), country: 'Italy' },
  { _id: ObjectId('67289d7a65874e9c57d1e78c'), country: 'Germany' },
  { _id: ObjectId('67289d7a65874e9c57d1e78d'), country: 'France' },
  { _id: ObjectId('67289d7a65874e9c57d1e78e'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e78f'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e790'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e791'), country: 'France' },
  { _id: ObjectId('67289d7a65874e9c57d1e792'), country: 'France' },
  { _id: ObjectId('67289d7a65874e9c57d1e793'), country: 'France' },
  { _id: ObjectId('67289d7a65874e9c57d1e794'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e795'), country: 'USA' },
  { _id: ObjectId('67289d7a65874e9c57d1e796'), country: 'USA' }
]


After Stage 2:

[
  { _id: 'France', count: 245 },
  { _id: 'Italy', count: 239 },
  { _id: 'USA', count: 255 },
  { _id: 'Germany', count: 261 }
]

After Stage 3:

[
{ _id: 'Germany', count: 261 },
{ _id: 'USA', count: 255 },
{ _id: 'France', count: 245 },
{ _id: 'Italy', count: 239 }
]

After Stage 4:
[
{ _id: 'Germany', count: 261 }
]

After Stage 5:
[ { 'Country with most registerd users': 'Germany' } ]
*/


// Find total unique eye colour

db.users.aggregate([
    {
        $group: {
            _id: "$eyeColor"
        }
    },
    {
        $count: 'Total Unique Eye Colours'
    }
])


/*

After Stage 1:

[ { _id: 'brown' }, { _id: 'blue' }, { _id: 'green' } ]

After Stage 2:

[ { 'Total Unique Eye Colours': 3 } ]

*/


// Find the average number of tags per user

db.users.aggregate(
    {
        $unwind: "$tags"
    },
    {
        $group:{
            _id : "$_id",
            tag_count: {
                $sum: 1
            }
        }
    },
    {
        $group: {
            _id: null,
            average_no_of_tags_per_person: {
                $avg: "$tag_count"
            }
        }
    }
)

// Answer: [ { _id: null, average_no_of_tags_per_person: 3.556 } ]

// We can also do this to find the tag_count
db.users.aggregate(
    {
        $addFields : {
            tag_count: {
                $size: "$tags"
            }
        }
    },
    {
        $group: {
            _id: null,
            average_no_of_tags_per_person: {
                $avg: "$tag_count"
            }
        }
    }
)

// [ { _id: null, average_no_of_tags_per_person: 3.556 } ]

// You can also use project
db.users.aggregate(
    {
        $project : {
            tag_count: {
                $size: "$tags"
            }
        }
    },
    {
        $group: {
            _id: null,
            average_no_of_tags_per_person: {
                $avg: "$tag_count"
            }
        }
    }
)


// Handle the case where is tags does not exists
db.users.aggregate(
    {
        $addFields : {
            tag_count: {
                $size: {$ifNull: ["$tags", []]}
            }
        }
    },
    {
        $group: {
            _id: null,
            average_no_of_tags_per_person: {
                $avg: "$tag_count"
            }
        }
    }
)

// [ { _id: null, average_no_of_tags_per_person: 3.556 } ]


// How many users have 'enim' in their tags

db.users.aggregate(
    {
        $unwind: "$tags"
    },
    {
        $match: {tags: "enim"}
    },
    {
        $group: {
            _id: "$_id"
        }
    },
    {
        $count: "users with enim tag"
    }
)

// [ { 'users with enim tag': 62 } ]


// Now instead of unwinding, you can directly use the $match operator on array
db.users.aggregate(
    {
        $match: {tags: "enim"}
    },
    {
        $count: "users with enim tag"
    }
)
// [ { 'users with enim tag': 62 } ]


// Names of all users which are categorized by their favourite fruit

db.users.aggregate(
    {
        $group:{
            _id:"$favoriteFruit",
            array: {
                $push: "$name"
            }
        }
    }
)