
create database hotel_reservation_db;
use hotel_reservation_db;

-- parent table --> Hotels
create table hotels ( hotel_id varchar(20) primary key, 
	hotel_name varchar(100) not null,
    city varchar(50) not null,
    star_rating int,
    total_rooms int,
    opened_date date
);

-- guests --> parent table
create table guests (
    guest_id varchar(20) primary key,
    guest_name varchar(100) not null,
    city varchar(50),
    guest_type varchar(20),
    preferred_room_type varchar(20),
    loyalty_tier varchar(20),
    account_since date
);

-- staff --> parent table
create table staff (
    staff_id varchar(20) primary key,
    staff_name varchar(100) not null,
    hire_date date,
    rating decimal(3,2),
    department varchar(30),
    is_active varchar(3)
);

-- rooms --> depends on hotels
create table rooms (
    room_id varchar(20) primary key,
    hotel_id varchar(20),
    room_type varchar(20),
    floor_number int,
    max_occupancy int,
    price_per_night decimal(10,2),
    is_active varchar(3),
    foreign key (hotel_id) references hotels(hotel_id)
);

-- bookings --> depends on guests and hotels
create table bookings (
    booking_id varchar(20) primary key,
    guest_id varchar(20),
    hotel_id varchar(20),
    booking_date date,
    room_type_requested varchar(20),
    booking_channel varchar(30),
    nights_booked int,
    total_amount decimal(12,2),
    foreign key (guest_id) references guests(guest_id),
    foreign key (hotel_id) references hotels(hotel_id)
);

-- stays --> depends on bookings, rooms and staff
create table stays (
    stay_id varchar(20) primary key,
    booking_id varchar(20),
    room_id varchar(20),
    staff_id varchar(20),
    check_in_date date,
    check_out_date date,
    status varchar(20),
    nights_stayed int,
    service_requests int,
    stay_duration_hrs int,
    foreign key (booking_id) references bookings(booking_id),
    foreign key (room_id) references rooms(room_id),
    foreign key (staff_id) references staff(staff_id)
);

show tables;

select * from hotels;
select * from guests;
select * from staff;
select * from rooms;
select * from bookings;
select * from stays;
