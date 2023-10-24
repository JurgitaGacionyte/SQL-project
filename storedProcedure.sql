-- išrenka visus staliukus ir nurodo kuris iš jų laisvas, kuris užimtas

-- DELIMITER // 
-- CREATE PROCEDURE AnyTablesLeft(IN StaliukuStatusas VARCHAR(50))
-- BEGIN
SELECT DISTINCT I.table_id, I.table_seats,
    CASE 
	WHEN R.reservation_start_time BETWEEN '2023-06-02 19:00' AND DATE_ADD('2023-06-02 19:00', INTERVAL 3 HOUR) 
    OR R.reservation_finish_time BETWEEN '2023-06-02 19:00' AND DATE_ADD('2023-06-02 19:00', INTERVAL 3 HOUR) THEN 'Užimtas'
	ELSE 'Laisvas'
	END AS `Staliukų statusas`
    -- ,R.reservation_start_time, R.reservation_finish_time
FROM inventory AS I
LEFT JOIN reservation AS R ON R.table_id=I.table_id
ORDER BY table_id ASC;
-- END 
-- //DELIMITER ;

-- išrenka tuo metu rezervuotus staliukus ir jų neįkelia į pagrindinį selectą, case galbūt tuomet ir nereikia, tiek, 
-- kad gal gražiau ir aiškiau atrodo, kai yra prirašyta Laisvas

-- DELIMITER // 
-- CREATE PROCEDURE AnyTablesLeft(IN StaliukuStatusas VARCHAR(50))
-- BEGIN
SELECT DISTINCT I.table_id, I.table_seats,
    CASE 
	WHEN R.reservation_start_time BETWEEN '2023-06-03 20:00' AND DATE_ADD('2023-06-03 20:00', INTERVAL 3 HOUR) 
    OR R.reservation_finish_time BETWEEN '2023-06-03 20:00' AND DATE_ADD('2023-06-03 20:00', INTERVAL 3 HOUR) THEN 'Užimtas'
	ELSE 'Laisvas'
	END AS `Staliukų statusas`
    ,R.reservation_start_time, R.reservation_finish_time
FROM inventory AS I
LEFT JOIN reservation AS R ON R.table_id=I.table_id
WHERE I.table_id NOT IN (
SELECT R.table_id
FROM reservation AS R
WHERE R.reservation_start_time BETWEEN '2023-06-03 20:00' AND DATE_ADD('2023-06-03 20:00', INTERVAL 3 HOUR) 
OR R.reservation_finish_time BETWEEN '2023-06-03 20:00' AND DATE_ADD('2023-06-03 20:00', INTERVAL 3 HOUR))
ORDER BY table_id ASC;
-- END 
-- //DELIMITER ;

