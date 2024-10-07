const express = require('express');
const auth_router = express.Router();
const Cryptography = require('../lib/crypto_utils')
const JSON_WEB_TOKEN = require('../lib/jwt_utils')
const { query } = require('../configuration/database')



module.exports = auth_router;