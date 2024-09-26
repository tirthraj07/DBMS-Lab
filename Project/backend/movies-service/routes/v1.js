const express = require('express');
const v1_router = express.Router();
const { query } = require("../configuration/database")
const { 
    getMovies,
    getMovie,
    getGenres,
    getGenre,
    getMovieGenres,
    getMovieImages,
    addNewMovie,
    addNewGenres,
    addNewImages
 }  = require("../controller/v1/movies_controller")

v1_router.get('/movies', getMovies)
v1_router.get('/movies/:id', getMovie)
v1_router.get('/movies/:id/genres', getMovieGenres) // --TODO
v1_router.get('/movies/:id/images', getMovieImages)
v1_router.get('/genres', getGenres)
v1_router.get('/genres/:id', getGenre)

v1_router.post('/movies', addNewMovie)
v1_router.post('/movies/:id/genres', addNewGenres)  // --TODO
v1_router.post('/movies/:id/images', addNewImages)  // --TODO

module.exports = v1_router