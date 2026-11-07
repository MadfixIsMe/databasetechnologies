-- Active: 1790169003103@@127.0.0.1@5432@northwind_uloha
CREATE DATABASE Northwind_uloha;

CREATE TABLE sdim_day (
    day_id INT PRIMARY KEY,
    day INT,
    day_of_week VARCHAR(45)
);


CREATE TABLE sdim_month (
    month_id INT PRIMARY KEY,
    month INT,
    month_name VARCHAR(45)
);


CREATE TABLE sdim_quarter (
    quarter_id INT PRIMARY KEY,
    quarter VARCHAR(45),
    quarter_label VARCHAR(45)
);


CREATE TABLE sdim_shipper (
    shipper_id INT PRIMARY KEY,
    shipper_name VARCHAR(45)
);


CREATE TABLE sdim_supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(20),
    country VARCHAR(15)
);


CREATE TABLE sdim_category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(25)
);


CREATE TABLE sdim_address (
    address_id INT PRIMARY KEY,
    address VARCHAR(50)
);


CREATE TABLE sdim_city (
    city_id INT PRIMARY KEY,
    city VARCHAR(50)
);


CREATE TABLE sdim_country (
    country_id INT PRIMARY KEY,
    country VARCHAR(15)
);


CREATE TABLE dim_date (
    iddim_date INT PRIMARY KEY,
    order_date TIMESTAMP,
    day INT,
    week INT,
    month INT,
    year INT,
    quarter INT,

    FOREIGN KEY (day)
        REFERENCES sdim_day(day_id),

    FOREIGN KEY (month)
        REFERENCES sdim_month(month_id),

    FOREIGN KEY (quarter)
        REFERENCES sdim_quarter(quarter_id)
);


CREATE TABLE dim_employee (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(15),
    first_name VARCHAR(15)
);


CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    product_unit VARCHAR(25),
    sdim_supplier_supplier_id INT,
    sdim_category_category_id INT,

    FOREIGN KEY (sdim_supplier_supplier_id)
        REFERENCES sdim_supplier(supplier_id),

    FOREIGN KEY (sdim_category_category_id)
        REFERENCES sdim_category(category_id)
);


CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    sdim_address_address_id INT,
    sdim_city_city_id INT,
    sdim_country_country_id INT,

    FOREIGN KEY (sdim_address_address_id)
        REFERENCES sdim_address(address_id),

    FOREIGN KEY (sdim_city_city_id)
        REFERENCES sdim_city(city_id),

    FOREIGN KEY (sdim_country_country_id)
        REFERENCES sdim_country(country_id)
);

CREATE TABLE fact_order (
    order_id INT PRIMARY KEY,
    quantity INT,
    price DECIMAL(10,0),
    date_id INT,
    employee_id INT,
    shipper_id INT,
    product_id INT,
    customer_id INT,

    FOREIGN KEY (date_id)
        REFERENCES dim_date(iddim_date),

    FOREIGN KEY (employee_id)
        REFERENCES dim_employee(employee_id),

    FOREIGN KEY (shipper_id)
        REFERENCES dim_shipper(shipper_id),

    FOREIGN KEY (product_id)
        REFERENCES dim_product(product_id),

    FOREIGN KEY (customer_id)
        REFERENCES dim_customer(customer_id)
);