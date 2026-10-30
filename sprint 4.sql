use hotel_reservation_db;

-- 4.1 Understand Booking Demand

select * from bookings;
select * from hotels;

-- Which hotel receives the highest number of bookings?
select h.hotel_id , h.hotel_name , count(*) as highest_booking_no 
from bookings b 
join hotels h 
on h.hotel_id = b.hotel_id
group by hotel_id
order by highest_booking_no desc
limit 1;

-- 2. Which booking channel generates the most bookings?
select booking_channel , count(*) as most_bookings 
from bookings b
group by booking_channel 
order by most_bookings desc
limit 1;

-- 3.Which room type has the highest booking demand?
select room_type_requested , count(*) as highest_booking_room 
from bookings b
group by room_type_requested
order by highest_booking_room desc
limit 1;

-- 4.which year has highest booking dates ?
select year(booking_date),count(*) as highest_booking_year from bookings
group by year(booking_date)
order by  highest_booking_year desc
limit 1 ;

-- 5.Which hotel, booking channel, or room type generates the highest total booking amount from which city?
select h.hotel_id, h.hotel_name, h.city,b.booking_channel, b.room_type_requested, sum(b.total_amount) as highest_booking_amount
from bookings b
join hotels h
on b.hotel_id = h.hotel_id
group by h.hotel_id, h.hotel_name, h.city, b.booking_channel, b.room_type_requested
order by highest_booking_amount desc
limit 1;


-- 4.2 Understand Guest Booking Behaviour

-- Compare guests based on the number of bookings they make.
-- Identify guests with a higher total booking amount.
-- Compare guest activity across hotels.
-- Look at differences between Individual and Corporate guests.
-- Examine guest booking patterns over time.

select *from bookings;
select *from guests;

-- 1. give top 5 guests have made the highest number of bookings?
select g.guest_id, g.guest_name ,count(*) as highest_bookings
from bookings b
join guests g
on b.guest_id = g.guest_id
group by g.guest_id
order by highest_bookings desc
limit 5;

-- 2. Which guests have generated the highest total booking amount?
select g.guest_id , g.guest_name, sum(b.total_amount) as highest_booking_amount
from bookings b
join guests g
on b.guest_id = g.guest_id 
group by g.guest_id
order by highest_booking_amount desc
limit 1;

-- 3.  Which 2 hotels have the highest number of unique guests?
select b.hotel_id,count(distinct guest_id) as highest_unique_guests
from bookings b
group by hotel_id
order by highest_unique_guests desc
limit 2;

-- 4. How does the average booking amount differ between Individual and Corporate guests?
select avg( case when guest_type = 'Individual' then total_amount end) as avg_of_individual, 
avg(case when guest_type = 'Corporate' then total_amount end) as avg_of_corporate,
abs(avg(case when guest_type = 'Individual' then total_amount end)-
avg(case when guest_type = 'Corporate' then total_amount end)) as difference 
from bookings b
join guests g 
on b.guest_id = g.guest_id;

-- 5.Which guest type generates the highest total booking revenue?
select guest_type, count(*) as highest_booking_revenue
 from bookings b
 join guests g 
 on b.guest_id = g.guest_id
 group by guest_type
 order by highest_booking_revenue desc
 limit 1;

-- 6.Which 5 guests have made bookings at multiple hotels?
select b.guest_id, guest_name, count(distinct b.hotel_id) as multiple_hotels
from guests g 
join bookings b 
on g.guest_id = b.guest_id
join hotels h
on b.hotel_id = h.hotel_id
group by b.guest_id
order by multiple_hotels desc
limit 5;

-- 4.3 Evaluate Stay Performance

--  1. How many stays are there for each stay status?
select status,count(*) as total_stays from stays group by status;

-- 2. What is the average stay duration for  stay status?
select status, avg(stay_duration_hrs) as avg_StayDuration from stays group by status;
select * from stays;

-- 3. How do stay outcomes compare across different status
select status, COUNT(*) as total_stays 
from stays 
group by status
order by total_stays desc;

-- 4. Which hotels have the highest number of completed and unsuccessful stays?
select h.hotel_name,s.status,COUNT(*) as total_stays
from stays s
join bookings b
on s.booking_id = b.booking_id
join hotels h
on b.hotel_id = h.hotel_id
where s.status in ('Checked-out', 'Cancelled', 'No-show')
group by h.hotel_name, s.status
order by total_stays desc;

-- 5.How does stay performance change over time?
select year(check_in_date) as year, status, COUNT(*) as total_stays
from stays
group by year(check_in_date), status
order by year, status;


-- 4.4 Understand Staff and Room Performance

-- 1.How many stays are handled by each staff member?
select staff_id,count(*) as total_stays 
from stays 
group by staff_id 
order by total_stays desc;

-- 2.How do stay outcomes vary across different staff members?
-- (Checked-out, No-show, Cancelled, In-progress)
select staff_id ,status,count(*) as total_stays 
from stays 
group by staff_id, status 
order by staff_id, total_stays desc;

-- 3.What is the average stay duration handled by each staff member?
select staff_id, avg(stay_duration_hrs) as avg_stay_duration from stays
group by staff_id order by  avg_stay_duration desc;

-- 4.How is room usage distributed across different room types?
select r.room_type, count(*) as total_stays 
from stays s 
join rooms r 
on s.room_id = r.room_id 
group by r.room_type 
order by total_stays desc;

-- 5.How do stay outcomes vary across different room types?
select r.room_type,s.status,count(*) as total_stays 
from stays s 
join rooms r 
on s.room_id=r.room_id 
group by r.room_type, s.status 
order by r.room_type,total_stays desc;


-- 4.5 Identify Booking and Stay Problems

-- 1. How many bookings resulted in each stay outcome?
select status,count(*) as total_stays 
from stays 
group by status 
order by total_stays desc;

-- 2. How many bookings resulted in cancellations or no-shows?
select status,count(*) as total_problem_bookings 
from stays 
where status in ('cancelled','No-show') 
group by status 
order by total_problem_bookings desc;

-- 3. Which bookings resulted in cancellations or no-shows?
select booking_id,status 
from stays 
where status in ('cancelled','No-show') 
order by status, booking_id;

-- 4. Do bookings with more service requests have more stay problems?
select service_requests, status, count(*) as total_stays 
from stays
group by service_requests, status 
order by service_requests, status;

-- 5. How do stay outcomes differ between low and high service-request bookings?
select
case
when service_requests = 0 then 'No requests'
when service_requests between 1 and 2 then 'Low requests'
else 'High requests'
end as request_level, status, count(*) as total_stays
from stays
group by request_level, status
order by request_level, total_stays desc;