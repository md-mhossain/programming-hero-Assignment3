

-- -- check current database
SELECT current_database();


-- -- create database
CREATE DATABASE rental_system;


-- -- create users table
CREATE TYPE user_role AS ENUM ('customer', 'admin');
CREATE TABLE USERS (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role user_role DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- -- create vehicles table
CREATE TYPE car_type AS ENUM ('car', 'bike', 'truck');
CREATE TYPE vehicle_status AS ENUM ('available', 'rented', 'maintenance');
CREATE TABLE VEHICLES(
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type car_type NOT NULL,
    model VARCHAR(50) NOT NULL,
    registration_number VARCHAR(30) UNIQUE NOT NULL,
    rental_price DECIMAL(10, 2) NOT NULL,
    availability_status vehicle_status DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)


-- -- create bookings table
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');
CREATE TABLE BOOKINGS (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_status booking_status DEFAULT 'pending',
    total_cost DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES VEHICLES(vehicle_id)
);


-- -- insert sample data into users table
INSERT INTO users (name, email, password, phone, role)
VALUES
('John Doe', 'john.doe@example.com', 'hashed_password_1', '1234567890', 'customer'),
('Sarah Johnson', 'sarah.johnson@example.com', 'hashed_password_2', '9876543210', 'customer'),
('Michael Smith', 'michael.smith@example.com', 'hashed_password_3', '5551234567', 'customer'),
('Emily Davis', 'emily.davis@example.com', 'hashed_password_4', '4449876543', 'customer'),
('Admin User', 'admin@rental.com', 'hashed_password_admin', '1112223333', 'admin');


-- -- -- insert sample data into vehicles table
INSERT INTO vehicles (name, type, model, registration_number, rental_price, availability_status)
VALUES
('Toyota Camry', 'car', '2020', 'ABC123', 50.00, 'available'),
('Honda Civic', 'car', '2019', 'XYZ789', 45.00, 'available'),
('Ford F-150', 'truck', '2021', 'TRK456', 80.00, 'available'),
('Yamaha YZF-R3', 'bike', '2020', 'BIK321', 30.00, 'available'),
('Chevrolet Silverado', 'truck', '2022', 'TRK789', 90.00, 'available'),
('Toyota Corolla', 'car', '2022', 'DHA-1234', 60.00, 'available'),
('Honda Civic', 'car', '2021', 'DHA-5678', 75.00, 'rented'),
('Yamaha R15', 'bike', '2023', 'DHA-9012', 30.00, 'available'),
('Suzuki Gixxer', 'bike', '2022', 'DHA-3456', 28.00, 'maintenance'),
('Ford Ranger', 'truck', '2020', 'DHA-7890', 120.00, 'available'),
('Toyota Hilux', 'truck', '2021', 'DHA-1122', 130.00, 'rented'),
('Hyundai Tucson', 'car', '2023', 'DHA-3344', 85.00, 'available'),
('Kawasaki Ninja 400', 'bike', '2023', 'DHA-5566', 45.00, 'available'),
('Isuzu N-Series', 'truck', '2019', 'DHA-7788', 110.00, 'maintenance'),
('Tesla Model 3', 'car', '2024', 'DHA-9900', 150.00, 'available');


-- -- insert sample data into bookings table
INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, booking_status, total_cost)
VALUES
(1, 1, '2024-07-01', '2024-07-05', 'confirmed', 250.00),
(2, 2, '2024-07-10', '2024-07-12', 'pending', 90.00),
(3, 3, '2024-07-15', '2024-07-20', 'completed', 400.00),
(4, 4, '2024-07-18', '2024-07-22', 'cancelled', 120.00),
(1, 5, '2024-07-01', '2024-07-05', 'confirmed', 250.00),
(1, 5, '2024-07-10', '2024-07-12', 'pending', 90.00),
(1, 5, '2024-07-25', '2024-07-30', 'confirmed', 450.00);



-- -- Retrieve booking information customer, vehicle name using with inner join
select booking_id,
    u.name as customer_name,
    v.name as vehicle_name,
    start_date,
    end_date,
    booking_status as status
FROM BOOKINGS as b
    INNER JOIN users as u ON u.user_id = b.user_id
    INNER JOIN vehicles as v ON v.vehicle_id = b.vehicle_id;


-- -- Find all vehicles that have never been booked.
SELECT vehicle_id,
    name,
    type,
    model,
    registration_number,
    rental_price,
    availability_status as status
FROM vehicles as v
WHERE NOT EXISTS (
        SELECT *
        FROM bookings as b
        WHERE b.vehicle_id = v.vehicle_id
);


-- -- Retrieve all available vehicles of a specific type (e.g. cars).
SELECT vehicle_id,
    name,
    type,
    model,
    registration_number,
    rental_price,
    availability_status as status
FROM vehicles
WHERE type = 'car'
    AND availability_status = 'available';


-- --Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
SELECT name AS vehicle_name,
    COUNT(*) AS total_bookings
FROM vehicles
    JOIN bookings ON vehicles.vehicle_id = bookings.vehicle_id
GROUP BY name
HAVING COUNT(*) > 2;


-- -- rename column name with using alter
ALTER TABLE bookings
    RENAME COLUMN status TO booking_status;

ALTER TABLE vehicles
    RENAME COLUMN status TO availability_status;