-- Active: 1790169003103@@127.0.0.1@5432@chinook_dwh

CREATE DATABASE chinook_dwh;

CREATE TABLE Dim_Customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INTEGER,
    first_name VARCHAR(40),
    last_name VARCHAR(20),
    company VARCHAR(80),
    email VARCHAR(60),
    phone VARCHAR(24)
);

CREATE TABLE Dim_Track (
    track_key SERIAL PRIMARY KEY,
    track_id INTEGER,
    track_name VARCHAR(200),
    album_title VARCHAR(160),
    artist_name VARCHAR(120),
    genre_name VARCHAR(120),
    media_type VARCHAR(120),
    composer VARCHAR(220),
    milliseconds INTEGER,
    bytes INTEGER
);

CREATE TABLE Dim_Date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    day INTEGER,
    month INTEGER,
    quarter INTEGER,
    year INTEGER
);

CREATE TABLE dim_employee (
    employee_id INTEGER PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    job_title VARCHAR(30),
    city VARCHAR(40),
    country VARCHAR(40)
);

CREATE TABLE Dim_Billing_Location (
    billing_location_key SERIAL PRIMARY KEY,
    billing_address VARCHAR(70),
    billing_city VARCHAR(40),
    billing_state VARCHAR(40),
    billing_country VARCHAR(40),
    billing_postal_code VARCHAR(10)
);

CREATE TABLE Fact_Sales (
    sales_key SERIAL PRIMARY KEY,
    invoice_line_id INTEGER,
    invoice_id INTEGER,
    customer_key INTEGER REFERENCES Dim_Customer(customer_key),
    track_key INTEGER REFERENCES Dim_Track(track_key),
    date_key INTEGER REFERENCES Dim_Date(date_key),
    billing_location_key INTEGER REFERENCES Dim_Billing_Location(billing_location_key),
    quantity INTEGER,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2)
);

CREATE INDEX idx_sales_employee ON Fact_Sales(employee_id);
CREATE INDEX idx_sales_customer ON Fact_Sales(customer_key);
CREATE INDEX idx_sales_track ON Fact_Sales(track_key);
CREATE INDEX idx_sales_date ON Fact_Sales(date_key);
CREATE INDEX idx_sales_location ON Fact_Sales(billing_location_key);

CREATE INDEX idx_customer_id ON Dim_Customer(customer_id);
CREATE INDEX idx_track_id ON Dim_Track(track_id);
CREATE INDEX idx_date_year ON Dim_Date(year);
CREATE INDEX idx_location_country ON Dim_Billing_Location(billing_country);
CREATE INDEX idx_employee_last_name ON dim_employee(last_name);
CREATE INDEX idx_employee_country ON dim_employee(country);