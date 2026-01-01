CREATE TABLE Bookings(
	Date TIMESTAMP,
	Time TIME,
	Booking_ID VARCHAR(50), 
	Booking_Status VARCHAR(50),
	Customer_ID	VARCHAR(50),
	Vehicle_Type VARCHAR(50),
	Pickup_Location	VARCHAR(200),
	Drop_Location VARCHAR(200),
	V_TAT INT,
	C_TAT INT,
	Canceled_Rides_by_Customer VARCHAR(200),
	Canceled_Rides_by_Driver VARCHAR(200),
	Incomplete_Rides VARCHAR(15),
	Incomplete_Rides_Reason	VARCHAR(150),
	Booking_Value INT,
	Payment_Method FLOAT,
	Ride_Distance FLOAT,
	Driver_Ratings FLOAT,
	Customer_Rating FLOAT,
	Vehicle_Images TEXT
	)

ALTER TABLE Bookings
ALTER COLUMN Payment_Method TYPE VARCHAR(50);

ALTER TABLE Bookings
ADD COLUMN Extra_Column TEXT;

SELECT Extra_Column FROM Bookings;


SELECT * FROM Bookings;

SELECT DISTINCT Extra_Column FROM Bookings;

-- 1. Retrieve all successful bookings:

CREATE VIEW Successful_Bookings AS  --Created a view so that its temporarily stored on the sql database to avoid running the program again and again
SELECT * FROM Bookings
WHERE booking_status = 'Success';

SELECT * FROM Successful_Bookings;

-- 2. Find the average ride distance for each vehicle type:

CREATE VIEW ride_dist_each_vehicle
AS
SELECT 
	vehicle_type,
	ROUND(AVG(ride_distance)::NUMERIC, 2) AS Avg_Distance --you may also use CAST Function to temporarily change its datatype for this operation
FROM Bookings
GROUP BY 1
ORDER BY 2 DESC; 

-- 3. Get the total number of cancelled rides by customers:

CREATE VIEW Cancelled_By_Cust
AS
SELECT 
	COUNT(*) AS total_cancelled_rides_by_customer
FROM Bookings
WHERE Booking_Status ILIKE '%Canceled By Customer%';

SELECT * FROM Cancelled_By_Cust;

-- 4. List the top 5 customers who booked the highest number of rides:

CREATE VIEW top_5_bookers
AS
SELECT
	customer_id,
	COUNT(*) AS total_no_of_bookings
FROM Bookings
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT * FROM top_5_bookers;

-- 5. Get the number of rides cancelled by drivers due to personal and car reasons- 

CREATE VIEW rides_cancelled_due_to_pnc_reasons
AS
SELECT
	COUNT(*) AS Total_no_of_rides_cancelled
FROM Bookings
WHERE canceled_rides_by_driver = 'Personal & Car related issue';

SELECT * FROM rides_cancelled_due_to_pnc_reasons;

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:

CREATE VIEW ratings_for_sedan
AS
SELECT 
	vehicle_type,
	MAX(driver_ratings) AS Max_rating_for_Sedan,
	MIN(driver_ratings) AS Min_rating_for_Sedan
FROM Bookings
WHERE vehicle_type = 'Prime Sedan'
GROUP BY 1;

SELECT * FROM ratings_for_sedan;

-- 7. Retrieve all rides where payment was made using UPI:

CREATE VIEW All_UPI_Payments
AS
SELECT
	*
FROM Bookings
WHERE
	payment_method = 'UPI';

SELECT * FROM All_UPI_Payments;

-- 8. Find the average customer rating per vehicle type:

CREATE VIEW Avg_Crating_per_Vehicle
AS
SELECT
	vehicle_type,
	ROUND(AVG(customer_rating)::NUMERIC, 2) AS Avg_cust_rating_per_vehicle
FROM Bookings
GROUP BY 1;

SELECT * FROM Avg_Crating_per_Vehicle;

-- 9. Calculate the total booking value of rides completed successfully:

CREATE VIEW total_success_booking_value
AS
SELECT 
	SUM(booking_value) AS total_successful_ride_value
FROM Bookings
WHERE booking_status ILIKE 'Success';

SELECT * FROM total_success_booking_value;

-- 10. List all incomplete rides along with the reason: 

CREATE VIEW incomplete_ride_reasons
AS
SELECT 
	booking_id,
	incomplete_rides_reason
FROM Bookings
WHERE 
	incomplete_rides ILIKE 'yes';