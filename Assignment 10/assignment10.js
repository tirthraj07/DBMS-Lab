/*
 Practical No 10: MongoDB Aggregation and Indexing: Design and Develop MongoDB Queries using aggregation and
 indexing with suitable example using MongoDB

 Schema:
 {
    "product":"Toothbrush",
    "price":22,
    "customer":"Ayush"
 }

 Queries to solve:
    1.Find out how many toothbrushes were sold
    2.Find the list of all sold products
    3.Find the total amount of money spent by each customer
    4.Find how much has been spent on each product and sort it by amount spent
    5.Find the product with least earnings.
    6.Find how much money each customer has spent on toothbrushes and pizza
    7.Find the customer who has given highest business for the product toothbrush
*/


db.createCollection("orders");


// Reference Data from : https://github.com/Ayush-Bulbule/PICT-Lab/blob/main/TE_Sem_I/310246_DBMSLab/10MONGO.js

//2. Insert Documents

db.orders.insertMany([
    {
        "product": "toothbrush",
        "price": 21,
        "customer": "Ayush"
    },
    {
        "product": "toothbrush",
        "price": 21,
        "customer": "Durvesh"
    },
    {
        "product": "pizza",
        "price": 130,
        "customer": "Kushal"
    },
    {
        "product": "pizza",
        "price": 130,
        "customer": "Ayush"
    },
    {
        "product": "tea",
        "price": 20,
        "customer": "Karan"
    },
    {
        "product": "tea",
        "price": 20,
        "customer": "Yash"
    }
]);

// 1.Find out how many toothbrushes were sold

db.orders.aggregate([
    {
        $match: {
            product: "toothbrush"
        }
    },
    {
        $count: "no of toothbrush sold"
    }
])


// [ { 'no of toothbrush sold': 2 } ]

// Find the list of all sold products

db.orders.aggregate([
    {
        $group: {
            _id: "$product",
            count: {
                $sum: 1
            }
        }
    }
])

/*
[
  { _id: 'tea', count: 2 },
  { _id: 'pizza', count: 2 },
  { _id: 'toothbrush', count: 2 }
]
*/

// Find the total amount of money spent by each customer

db.orders.aggregate([
    {
        $group:{
            _id: "$customer",
            total_price: {
                $sum: "$price"
            }
        }
    }
])

/*
[
  { _id: 'Kushal', total_price: 130 },
  { _id: 'Yash', total_price: 20 },
  { _id: 'Durvesh', total_price: 21 },
  { _id: 'Karan', total_price: 20 },
  { _id: 'Ayush', total_price: 151 }
]
*/

// Find how much has been spent on each product and sort it by amount spent
db.orders.aggregate([
    {
        $group: {
            _id : "$product",
            no_of_products_sold : {
                $sum: 1
            },
            total_amount : {
                $sum: "$price"
            }
        }
    },
    {
        $sort: {
            total_amount: -1
        }
    }
])

/*
[
  { _id: 'pizza', no_of_products_sold: 2, total_amount: 260 },
  { _id: 'toothbrush', no_of_products_sold: 2, total_amount: 42 },
  { _id: 'tea', no_of_products_sold: 2, total_amount: 40 }
]
*/

// Find the product with least earnings.
db.orders.aggregate([
    {
        $group: {
            _id : "$product",
            no_of_products_sold : {
                $sum: 1
            },
            total_amount : {
                $sum: "$price"
            }
        }
    },
    {
        $sort: {
            total_amount: 1
        }
    },
    {
        $limit: 1
    }
])

// [ { _id: 'tea', no_of_products_sold: 2, total_amount: 40 } ]

// Find how much money each customer has spent on toothbrushes and pizza

db.orders.aggregate([
    {
        $match: {
            $or : [
                {product: "toothbrush"},
                {product: "pizza"}
            ]
        }
    },
    {
        $group : {
            _id: "$customer",
            total_money : {
                $sum: "$price"
            }
        }
    }
])

/*
[
    { _id: 'Durvesh', total_money: 21 },
    { _id: 'Ayush', total_money: 151 },
    { _id: 'Kushal', total_money: 130 }
]
*/

// Find the customers who has given highest business for the product toothbrush

db.orders.aggregate([
    {
        $match: {
            product: "toothbrush"
        }
    },
    {
        $group:{
            _id: "$customer",
            total_amount: {
                $sum: "$price"
            }
        }
    },
    {
        $sort:{
            total_amount: -1
        }
    },
    {
        $group:{
            _id:"$total_amount",
            top_customers: {$push : "$_id"}
        }
    },
    {
        $sort: {
            _id: -1
        }
    },
    {
        $limit:1
    }
])

// [ { _id: 21, top_customers: [ 'Durvesh', 'Ayush' ] } ]