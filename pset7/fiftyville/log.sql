-- Keep a log of any SQL queries you execute as you solve the mystery.

SELECT description FROM crime_scene_reports WHERE street = "Chamberlin Street" AND month = 7 AND day = 28;
-- -- -- description
-- Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse.
-- Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.

-- // Search for interviews on 28 July that mention courthouse, recall name and statement //

SELECT name, transcript FROM interviews WHERE transcript LIKE "%courthouse%"  AND year = 2020 AND month = 7 AND day = 28;
-- -- -- name | transcript
-- //Ruth//
-- Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away.
-- If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time frame.

-- //Eugene//
-- I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at the courthouse,
-- I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.

-- //Raymond//
-- As the thief was leaving the courthouse, they called someone who talked to them for less than a minute.
-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.

-- Follow ups;
-- Car;
SELECT license_plate FROM courthouse_security_logs WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 26;
-- -- -- license_plate
-- 5P2BI95          -- 94KL13X
-- 6P58WS2          -- 4328GD8
-- G412CB7          -- L93JTIZ
-- 322W7JE          -- 0NTHK55

-- Fifer ATM;
SELECT account_number FROM atm_transactions WHERE atm_location = "Fifer Street" AND month = 7 AND day = 28 AND transaction_type = "withdraw";
-- -- -- account_number
-- 28500762         -- 28296815
-- 76054385         -- 49610011
-- 16153065         -- 25506511
-- 81061156         -- 26013199

-- Phonecall;
SELECT caller, receiver FROM phone_calls WHERE month = 7 AND day = 28 AND duration < 60;
-- -- -- caller | receiver
-- (130) 555-0289 | (996) 555-8899          -- (499) 555-9472 | (892) 555-8872
-- (367) 555-5533 | (375) 555-8161          -- (499) 555-9472 | (717) 555-1342
-- (286) 555-6063 | (676) 555-6554          -- (770) 555-1861 | (725) 555-3243
-- (031) 555-6622 | (910) 555-3251          -- (826) 555-1652 | (066) 555-9701
-- (338) 555-6650 | (704) 555-2131

-- //Somewhere in this data are entries that all link to a smaller number of suspects//

SELECT name FROM people WHERE license_plate IN
   ...> (SELECT license_plate FROM courthouse_security_logs WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 26)
   ...> AND phone_number IN (SELECT caller FROM phone_calls WHERE month = 7 AND day = 28 AND duration < 60)
   ...> AND id IN (SELECT person_id FROM bank_accounts WHERE account_number IN
   ...> (SELECT account_number FROM atm_transactions WHERE atm_location = "Fifer Street" AND month = 7 AND day = 28 AND transaction_type = "withdraw"));
-- -- -- name
-- Russell
-- Ernest

-- // Two names left, check whether either passport number got on earliest flight next day//
SELECT id FROM flights WHERE month = 7 AND day = 29 AND origin_airport_id IN (SELECT id FROM airports WHERE city = "Fiftyville") ORDER BY hour DESC, minute;
-- -- -- id
-- 18           -- 53
-- 23           -- 43
-- 36

-- //Earliest flight is ID 36, hopefully will determine between the two supects//
SELECT name FROM people WHERE passport_number IN (SELECT passport_number FROM passengers WHERE flight_id = 36);
-- -- -- name
-- Bobby            -- Roger
-- Madison          -- Danielle
-- Evelyn           -- Edward
-- Ernest           -- Doris

-- //Ernest is only match, all other suspects eliminated. Where did he go?
SELECT full_name FROM airports WHERE id IN (SELECT destination_airport_id FROM flights WHERE id = 36);
-- -- -- full_name
-- Heathrow Airport

-- //So who did he call to assist with the flight?//
SELECT name FROM people WHERE phone_number IN (SELECT receiver FROM phone_calls WHERE month = 7 AND day = 28 AND duration < 60 AND caller IN (SELECT phone_number FROM people WHERE name = "Ernest"));
-- -- -- name
-- Berthold