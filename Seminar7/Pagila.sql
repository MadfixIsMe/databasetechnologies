
CREATE DATABASE pagila_dwh;

CREATE TABLE sdim_day (
    day_id INT PRIMARY KEY,
    day_number INT,
    day_name VARCHAR(20)
);

CREATE TABLE sdim_month (
    month_id INT PRIMARY KEY,
    month_number INT,
    month_name VARCHAR(20)
);

CREATE TABLE sdim_quarter (
    quarter_id INT PRIMARY KEY,
    quarter_number INT,
    quarter_label VARCHAR(20)
);

CREATE TABLE sdim_year (
    year_id INT PRIMARY KEY,
    year INT
);

CREATE TABLE sdim_country (
    country_id INT PRIMARY KEY,
    country VARCHAR(50)
);

CREATE TABLE sdim_city (
    city_id INT PRIMARY KEY,
    city VARCHAR(50),
    country_id INT,
    FOREIGN KEY (country_id)
        REFERENCES sdim_country(country_id)
);

CREATE TABLE sdim_address (
    address_id INT PRIMARY KEY,
    address VARCHAR(50),
    address2 VARCHAR(50),
    district VARCHAR(50),
    postal_code VARCHAR(10),
    city_id INT,
    FOREIGN KEY (city_id)
        REFERENCES sdim_city(city_id)
);

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    day_id INT,
    month_id INT,
    quarter_id INT,
    year_id INT,
    FOREIGN KEY (day_id)
        REFERENCES sdim_day(day_id),
    FOREIGN KEY (month_id)
        REFERENCES sdim_month(month_id),
    FOREIGN KEY (quarter_id)
        REFERENCES sdim_quarter(quarter_id),
    FOREIGN KEY (year_id)
        REFERENCES sdim_year(year_id)
);

CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id INT,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(50),
    active BOOLEAN,
    address_id INT,
    FOREIGN KEY (address_id)
        REFERENCES sdim_address(address_id)
);

CREATE TABLE dim_actor (
    actor_key INT PRIMARY KEY,
    actor_id INT,
    first_name VARCHAR(45),
    last_name VARCHAR(45)
);

CREATE TABLE dim_language (
    language_key INT PRIMARY KEY,
    language_id INT,
    language_name VARCHAR(20)
);

CREATE TABLE dim_category (
    category_key INT PRIMARY KEY,
    category_id INT,
    category_name VARCHAR(25)
);

CREATE TABLE dim_film (
    film_key INT PRIMARY KEY,
    film_id INT,
    title VARCHAR(255),
    description TEXT,
    release_year INT,
    rental_duration INT,
    rental_rate DECIMAL(4,2),
    length INT,
    replacement_cost DECIMAL(5,2),
    rating VARCHAR(10),
    language_key INT,
    FOREIGN KEY (language_key)
        REFERENCES dim_language(language_key)
);

CREATE TABLE bridge_film_actor (
    film_key INT,
    actor_key INT,
    PRIMARY KEY (film_key, actor_key),
    FOREIGN KEY (film_key)
        REFERENCES dim_film(film_key),
    FOREIGN KEY (actor_key)
        REFERENCES dim_actor(actor_key)
);

CREATE TABLE bridge_film_category (
    film_key INT,
    category_key INT,
    PRIMARY KEY (film_key, category_key),
    FOREIGN KEY (film_key)
        REFERENCES dim_film(film_key),
    FOREIGN KEY (category_key)
        REFERENCES dim_category(category_key)
);

CREATE TABLE dim_staff (
    staff_key INT PRIMARY KEY,
    staff_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    active BOOLEAN,
    address_id INT,
    FOREIGN KEY (address_id)
        REFERENCES sdim_address(address_id)
);

CREATE TABLE dim_store (
    store_key INT PRIMARY KEY,
    store_id INT,
    address_id INT,
    manager_staff_id INT,
    FOREIGN KEY (address_id)
        REFERENCES sdim_address(address_id)
);

CREATE TABLE dim_inventory (
    inventory_key INT PRIMARY KEY,
    inventory_id INT,
    film_key INT,
    store_key INT,
    FOREIGN KEY (film_key)
        REFERENCES dim_film(film_key),
    FOREIGN KEY (store_key)
        REFERENCES dim_store(store_key)
);

CREATE TABLE fact_rental (
    rental_id INT PRIMARY KEY,
    customer_key INT,
    inventory_key INT,
    staff_key INT,
    rental_date_id INT,
    return_date_id INT,
    rental_count INT,
    FOREIGN KEY (customer_key)
        REFERENCES dim_customer(customer_key),
    FOREIGN KEY (inventory_key)
        REFERENCES dim_inventory(inventory_key),
    FOREIGN KEY (staff_key)
        REFERENCES dim_staff(staff_key),
    FOREIGN KEY (rental_date_id)
        REFERENCES dim_date(date_id),
    FOREIGN KEY (return_date_id)
        REFERENCES dim_date(date_id)
);

CREATE TABLE fact_payment (
    payment_id INT PRIMARY KEY,
    rental_id INT,
    customer_key INT,
    staff_key INT,
    payment_date_id INT,
    amount DECIMAL(5,2),
    FOREIGN KEY (rental_id)
        REFERENCES fact_rental(rental_id),
    FOREIGN KEY (customer_key)
        REFERENCES dim_customer(customer_key),
    FOREIGN KEY (staff_key)
        REFERENCES dim_staff(staff_key),
    FOREIGN KEY (payment_date_id)
        REFERENCES dim_date(date_id)
);
