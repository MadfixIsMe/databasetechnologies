-- Active: 1790169003103@@127.0.0.1@5432@movielens_dwh

CREATE DATABASE movielens_dwh;

CREATE TABLE Dim_User (
    user_key SERIAL PRIMARY KEY,
    user_id INTEGER,
    gender VARCHAR(10),
    age INTEGER,
    occupation VARCHAR(100),
    zip_code VARCHAR(20)
);

CREATE TABLE Dim_Movie (
    movie_key SERIAL PRIMARY KEY,
    movie_id INTEGER,
    title VARCHAR(255),
    release_year INTEGER,
    genres TEXT
);

CREATE TABLE Dim_Date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    day INTEGER,
    month INTEGER,
    quarter INTEGER,
    year INTEGER
);

CREATE TABLE Fact_Ratings (
    rating_key SERIAL PRIMARY KEY,
    user_key INTEGER REFERENCES Dim_User(user_key),
    movie_key INTEGER REFERENCES Dim_Movie(movie_key),
    date_key INTEGER REFERENCES Dim_Date(date_key),
    rating NUMERIC(2,1)
);

CREATE INDEX idx_fact_user ON Fact_Ratings(user_key);
CREATE INDEX idx_fact_movie ON Fact_Ratings(movie_key);
CREATE INDEX idx_fact_date ON Fact_Ratings(date_key);

CREATE INDEX idx_dim_user_id ON Dim_User(user_id);
CREATE INDEX idx_dim_movie_id ON Dim_Movie(movie_id);
CREATE INDEX idx_dim_date_year ON Dim_Date(year);
CREATE INDEX idx_dim_movie_genres ON Dim_Movie(genres);