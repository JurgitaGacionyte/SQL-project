CREATE SCHEMA master_kebab;
USE master_kebab;

CREATE TABLE customer 
(
customer_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT
,username VARCHAR(50) NOT NULL
,first_name VARCHAR(50) NOT NULL
,last_name VARCHAR(50) NOT NULL
,email VARCHAR(100)
,phone VARCHAR(50) NOT NULL
,cust_password VARCHAR(50)
);

CREATE TABLE staff 
(
staff_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT
,first_name VARCHAR(50) NOT NULL
,last_name VARCHAR(50) NOT NULL
,job_role VARCHAR(50) NOT NULL
);

CREATE TABLE menu 
(
meal_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT
,meal_title VARCHAR(50) NOT NULL
,meal_type VARCHAR(50) NOT NULL
,price DECIMAL(6,2)
);

CREATE TABLE inventory 
(
table_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT
,table_seats INT
);

CREATE TABLE reservation 
(
reservation_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT
,customer_id INT NOT NULL
,order_id INT
,table_id INT NOT NULL
,reservation_start_time DATETIME
,reservation_finish_time DATETIME
,customer_quantity INT NOT NULL
);

CREATE TABLE customer_order 
(
order_ID INT NOT NULL
,customer_id INT NOT NULL
,table_id INT NOT NULL
,meal_id INT NOT NULL
,quantity INT NOT NULL
,price DECIMAL(10,2)
,order_start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,order_finish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,staff_id INT
);

/*-- StoredProcedure
DELIMITER // 
CREATE PROCEDURE AnyTablesLeft2(IN Rezervacijos_data DATETIME,IN Zmoniu_skaicius INT)
BEGIN
SELECT DISTINCT I.table_id, I.table_seats,
    CASE 
	WHEN R.reservation_start_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) 
    OR R.reservation_finish_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) THEN 'Užimtas'
	ELSE 'Laisvas'
	END AS `Staliukų statusas`
   FROM inventory AS I
LEFT JOIN reservation AS R ON R.table_id=I.table_id
WHERE I.table_seats >= Zmoniu_skaicius
ORDER BY table_id ASC
LIMIT 1;
END 
//DELIMITER ;
*/
DELIMITER // 
CREATE PROCEDURE AnyTablesLeft2(IN Rezervacijos_data DATETIME,IN Zmoniu_skaicius INT)
BEGIN
	SELECT DISTINCT I.table_id -- , I.table_seats,
		,CASE 
		WHEN R.reservation_start_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) 
		OR R.reservation_finish_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) THEN 'Užimtas'
		ELSE 'Laisvas'
		END AS `Staliukų statusas`
	   FROM inventory AS I
	LEFT JOIN reservation AS R ON R.table_id=I.table_id
	WHERE I.table_seats >= Zmoniu_skaicius
	ORDER BY table_id ASC
	LIMIT 1;
    
UPDATE reservation
SET reservation_start_time = Rezervacijos_data
WHERE table_id = (
SELECT table_id
FROM inventory AS I
LEFT JOIN reservation AS R ON R.table_id=I.table_id
WHERE I.table_seats >= Zmoniu_skaicius AND CASE 
	WHEN R.reservation_start_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) 
    OR R.reservation_finish_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) THEN 'Užimtas'
	ELSE 'Laisvas'
    END = 'Laisvas'
ORDER BY table_id ASC
LIMIT 1);
END 
//DELIMITER ;

CALL AnyTablesLeft2('2023-06-02 20:00',5);




/*
DELIMITER // 
CREATE PROCEDURE AnyTablesLeft2(IN Rezervacijos_data DATETIME,IN Zmoniu_skaicius INT)
-- UPDATE reservation AS R
-- SET R.reservation_start_time = Rezervacijos_data
-- WHERE condition = true
BEGIN
SELECT DISTINCT I.table_id -- , I.table_seats,
    ,CASE 
	WHEN R.reservation_start_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) 
    OR R.reservation_finish_time BETWEEN Rezervacijos_data AND DATE_ADD(Rezervacijos_data, INTERVAL 3 HOUR) THEN 'Užimtas'
	ELSE 'Laisvas'
	-- END AS `Staliukų statusas`
   FROM inventory AS I
LEFT JOIN reservation AS R ON R.table_id=I.table_id
WHERE I.table_seats >= Zmoniu_skaicius
ORDER BY table_id ASC
LIMIT 1;
END 
//DELIMITER ;
-- Sukurkite VIEW, nurodydami pajamas Eurais ir Procentais pagal patiekalą 
-- Sukurkite VIEW, nurodydami TOP 5 patiekalus pagal pajamas
-- Sukurkite VIEW, nurodydami rezervacijų kiekį pagal Dienas
-- Sukurkite VIEW, nurodydami kiek užsakymų yra aptarnavę padavėjais pagal vardą, pavardę
-- Sukurkite VIEW, nurodydami kurie staliukai yra dažniausiai rezervuojami
*/