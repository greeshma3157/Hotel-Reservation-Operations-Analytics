-- Sprint 3: Basic Analysis / Data Exploration

use hotel_reservation_db;

-- 1. What is the total number of guests?
select count(*) from guests;
-- 2. What is the total number of bookings?
select count(*) from bookings;
-- 3. What is the total number of stays?
select count(*) from stays;
-- 4. What are the different room types available?
select room_type from rooms group by room_type;
-- 5. How many staff members are currently active?
select count(*) as active_staff from staff where is_active='Yes';
-- 6. What are the different booking channels?
select booking_channel from bookings group by booking_channel;
-- 7. What is the total booking amount across all bookings?
select sum(total_amount) as total_revenue from bookings;
-- 8. What is the average nights booked per booking?
select avg(nights_booked) as avg_nights_booked from bookings;
