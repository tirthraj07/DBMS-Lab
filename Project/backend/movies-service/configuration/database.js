const mysql = require('mysql2');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const pool = mysql.createPool({
  host: process.env.DB_HOST, 
  user: process.env.DB_USER, 
  password: process.env.DB_PASSWORD, 
  database: process.env.DB_DATABASE
});
const poolPromise = pool.promise();

/**
 * Executes a SQL query and returns the result.
 * @param {string} sql - The SQL query string.
 * @param {Array} [params] - Optional array of query parameters for prepared statements.
 * @returns {Promise<*>} - Returns a promise that resolves with the query result.
 */
async function query(sql, params = []) {
  try {
    const [rows] = await poolPromise.query(sql, params);
    return rows;
  } catch (error) {
    console.error('Database query error:', error);
    throw error;
  }
}

module.exports = { query };
