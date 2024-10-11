const express = require('express');
const v1_router = express.Router();
const { query } = require('../configuration/database');

// Fetch booking details by booking_id
v1_router.get('/bookings/:booking_id', async (req, res) => {
    const { booking_id } = req.params;
    
    try {
        const bookingDetailsQuery = `
            SELECT * 
            FROM booking_details 
            WHERE booking_id = ?
        `;
        const bookingSeatsQuery = `
            SELECT seat_id 
            FROM booking_seats 
            WHERE booking_id = ?
        `;

        const bookingDetails = await query(bookingDetailsQuery, [booking_id]);
        const bookedSeats = await query(bookingSeatsQuery, [booking_id]);

        if (bookingDetails.length === 0) {
            return res.status(404).json({ error: "Booking not found" });
        }

        res.json({
            bookingDetails: bookingDetails[0],
            bookedSeats: bookedSeats.map(seat => seat.seat_id),
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Fetch bookings by customer_id
v1_router.get('/bookings/customer/:customer_id', async (req, res) => {
    const { customer_id } = req.params;

    try {
        const bookingsQuery = `
            SELECT * 
            FROM booking_details 
            WHERE customer_id = ?
        `;
        const bookings = await query(bookingsQuery, [customer_id]);

        if (bookings.length === 0) {
            return res.status(404).json([]);
        }

        res.json(bookings);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Fetch bookings by showtime_id
v1_router.get('/bookings/showtimes/:showtime_id', async (req, res) => {
    const { showtime_id } = req.params;

    try {
        const bookingsQuery = `
            SELECT * 
            FROM bookings 
            WHERE showtime_id = ?
        `;
        const bookings = await query(bookingsQuery, [showtime_id]);

        if (bookings.length === 0) {
            return res.status(404).json([]);
        }

        res.json(bookings);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

// Book seats for a showtime using stored procedure
v1_router.post('/bookings/showtimes/:showtime_id', async (req, res) => {
    const { showtime_id } = req.params;
    const { customer_id, seat_ids } = req.body;  // Expecting seat_ids as an array

    try {
        // Convert seat_ids to a comma-separated string
        const seatIdsStr = seat_ids.join(',');

        const procedureQuery = `
            CALL book_movie(?, ?, ?)
        `;
        await query(procedureQuery, [customer_id, showtime_id, seatIdsStr]);

        res.status(201).json({ message: "Booking successful" });
    } catch (error) {
        if (error.sqlState === '45000') {
            // Handle custom error from the stored procedure
            res.status(400).json({ error: error.sqlMessage });
        } else {
            console.error(error);
            res.status(500).json({ error: "Internal server error" });
        }
    }
});

// Fetch booked seats by showtime_id
v1_router.get('/bookings/showtimes/:showtime_id/seats', async (req, res) => {
    const { showtime_id } = req.params;

    try {
        const bookedSeatsQuery = `
            SELECT seat_id 
            FROM booking_seats 
            WHERE showtime_id = ?
        `;
        const bookedSeats = await query(bookedSeatsQuery, [showtime_id]);

        if (bookedSeats.length === 0) {
            return res.status(404).json([]);
        }

        res.json(bookedSeats.map(seat => seat.seat_id));
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal server error" });
    }
});

module.exports = v1_router;
