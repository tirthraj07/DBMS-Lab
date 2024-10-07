const express = require('express');
const v1_router = express.Router();
const { query } = require('../configuration/database');
const Cryptography = require('../lib/crypto_utils')



module.exports = v1_router;
