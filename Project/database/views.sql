-- PUBLIC
CREATE VIEW public_customer_view AS 
    SELECT
        customer_id,
        customer_full_name,
        customer_email,
        customer_phone
    FROM
        customers;

CREATE VIEW movie_details AS
    SELECT
        movies.movie_id,
        movies.movie_title,
        movies.movie_director_name,
        movies.movie_description,
        movies.movie_duration,
        movies.movie_rating,
        movie_genres.movie_genre_name
    FROM
        movies
    LEFT JOIN
        movie_genres
    ON movies.movie_genre_id = movie_genres.movie_genre_id;

CREATE VIEW movie_image_details AS
    SELECT
        movies.movie_id,
        movies.movie_title,
        movie_images.movie_image_location
    FROM
        movie_images
    INNER JOIN
        movies
    ON
        movie_images.movie_id = movies.movie_id;


-- PRIVATE
