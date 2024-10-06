const express = require('express');
const v1_router = express.Router();
const { query } = require('../configuration/database');
const Cryptography = require('../lib/crypto_utils')


v1_router.get('/seat-types', async (req, res) => {
    try {
        const result = await query('SELECT seat_type_id, seat_type_name FROM seat_types');
        res.json(result);
    } catch (err) {
        res.status(500).json({ "error": err.message });
    }
});

v1_router.route('/theatres')
    .get(async (req, res) => {
        try {
            const result = await query('SELECT * FROM theatres');
            res.json(result);
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    })
    .post(async (req, res) => {
        const { theatre_name, theatre_location } = req.body;
        try {
            if(!theatre_name, !theatre_location){
                res.status(400).json({error:"Insufficient Payload"})
            }

            const result = await query('INSERT INTO theatres (theatre_name, theatre_location) VALUES (?, ?)', [theatre_name, theatre_location]);
            const createdTheatre = await query('SELECT theatre_id, theatre_name, theatre_location FROM theatres WHERE theatre_id = ?', [result.insertId]);
            res.json(createdTheatre[0]);
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    });

// /theatres/:theatre_id (GET, PATCH)
v1_router.route('/theatres/:theatre_id')
    .get(async (req, res) => {
        const { theatre_id } = req.params;
        try {
            const result = await query('SELECT theatre_id, theatre_name, theatre_location FROM theatres WHERE theatre_id = ?', [theatre_id]);
            if (result.length === 0) {
                return res.status(404).json({ "error": "theatre not found" });
            }
            res.json(result[0]);
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    })
    .patch(async (req, res) => {
        const { theatre_id } = req.params;
        const { theatre_name, theatre_location } = req.body;
        try {
            const result = await query('SELECT theatre_id FROM theatres WHERE theatre_id = ?', [theatre_id]);
            if (result.length === 0) {
                return res.status(404).json({ "error": "theatre not found" });
            }
            await query('UPDATE theatres SET theatre_name = ?, theatre_location = ? WHERE theatre_id = ?', [theatre_name || result[0].theatre_name, theatre_location || result[0].theatre_location, theatre_id]);
            res.json({ "success": "Theatre updated successfully" });
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    });

// /theatres/:theatre_id/users (GET, POST)
v1_router.route('/theatres/:theatre_id/users')
    .get(async (req, res) => {
        const { theatre_id } = req.params;
        try {
            const result = await query('SELECT theatre_user_id, theatre_user_full_name, theatre_user_email FROM theatre_users WHERE theatre_id = ?', [theatre_id]);
            res.json(result);
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    })
    .post(async (req, res) => {
        const { theatre_user_full_name, theatre_user_email, theatre_user_password } = req.body;
        const { theatre_id } = req.params;
        try {
            if(!theatre_user_full_name || !theatre_user_email || !theatre_user_password){
                res.status(400).json({error:"Insufficient payload"})
            }

            const cryptograph = new Cryptography()
            
            const hashedPassword = cryptograph.generateSaltHash(theatre_user_password);

            await query('INSERT INTO theatre_users (theatre_user_full_name, theatre_user_email, theatre_user_password, theatre_id) VALUES (?, ?, ?, ?)', [theatre_user_full_name, theatre_user_email, hashedPassword, theatre_id]);
            res.json({ "success": "User created successfully" });
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    });

// /theatres/:theatre_id/screens (GET, POST)
v1_router.route('/theatres/:theatre_id/screens')
    .get(async (req, res) => {
        const { theatre_id } = req.params;
        try {
            const result = await query('SELECT theatre_id, theatre_name, screen_id, screen_name, screen_total_seats FROM screen_details WHERE theatre_id = ?', [theatre_id]);
            res.json(result);
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    })
    .post(async (req, res) => {
        const { screen_name, screen_total_seats } = req.body;
        const { theatre_id } = req.params;
        try {
            const result = await query('INSERT INTO screens (screen_name, screen_total_seats, theatre_id) VALUES (?, ?, ?)', [screen_name, screen_total_seats, theatre_id]);
            const createdScreen = {
                screen_id: result.insertId,
                theatre_id,
                screen_name,
                screen_total_seats
            };
            res.json({ "screen": createdScreen });
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    });

// /theatres/:theatre_id/screens/:screen_id (GET, PATCH)
v1_router.route('/theatres/:theatre_id/screens/:screen_id')
    .get(async (req, res) => {
        const { screen_id } = req.params;
        try {
            const result = await query('SELECT screen_name, screen_total_seats FROM screens WHERE screen_id = ?', [screen_id]);
            res.json(result[0]);
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    })
    .patch(async (req, res) => {
        const { screen_id } = req.params;
        const { screen_name, screen_total_seats } = req.body;
        try {
            await query('UPDATE screens SET screen_name = ?, screen_total_seats = ? WHERE screen_id = ?', [screen_name, screen_total_seats, screen_id]);
            res.json({ "success": "Screen updated successfully" });
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    });

// /theatres/:theatre_id/screens/:screen_id/seats (GET, POST)
v1_router.route('/theatres/:theatre_id/screens/:screen_id/seats')
    .get(async (req, res) => {
        const { screen_id } = req.params;
        try {
            const result = await query('SELECT * FROM seat_details WHERE screen_id = ?', [screen_id]);
            res.json(result);
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    })
    .post(async (req, res) => {
        const { screen_id } = req.params;
        const seats = req.body.seats; // Array of { row_num, seat_number, seat_type_id }
        try {
            for (let seat of seats) {
                await query('INSERT INTO seats (row_num, seat_number, seat_type_id, screen_id) VALUES (?, ?, ?, ?)', [seat.row_num, seat.seat_number, seat.seat_type_id, screen_id]);
            }
            res.json({ "success": "Seats added successfully" });
        } catch (err) {
            res.status(500).json({ "error": err.message });
        }
    });

module.exports = v1_router;
