-- CREATE VIEW PajamosEurIrProcentaisPagalPatiekalus AS
SELECT M.meal_title, SUM(CO.quantity*CO.price) AS 'Pajamos pagal patiekalą', (SUM(CO.quantity*CO.price)*100)/(SELECT SUM(CO.quantity*CO.price)FROM customer_order AS CO) AS 'Procentaliai pagal patiekalą'
FROM menu AS M
JOIN customer_order AS CO ON CO.meal_id=M.meal_id
GROUP BY M.meal_title
ORDER BY SUM(CO.quantity*CO.price) DESC;

-- CREATE VIEW TOP5MealsByIncome AS
SELECT M.meal_id, M.meal_title, SUM(CO.quantity*CO.price) AS 'Pajamos pagal patiekalą'
FROM menu AS M
JOIN customer_order AS CO ON CO.meal_id=M.meal_id
GROUP BY M.meal_id
ORDER BY SUM(CO.quantity*CO.price) DESC
LIMIT 5;

-- CREATE VIEW RezervacijuKiekisPagalDienas AS
SELECT DATE(reservation_start_time), COUNT(reservation_id)
FROM reservation
GROUP BY DATE(reservation_start_time);

-- CREATE VIEW DaznaiRetaiPasirenkamiPatiekalai AS
SELECT M.meal_id, M.meal_title, SUM(CO.quantity) AS 'Kiek kartų buvo pasirinktas'
, CASE
	WHEN SUM(CO.quantity) >= 3 THEN 'Dažnai'
    WHEN SUM(CO.quantity) < 3  THEN 'Retai'
END AS 'Pasirinkimo dažnumas'
FROM customer_order AS CO
JOIN menu AS M ON M.meal_id=CO.meal_id
GROUP BY M.meal_id
ORDER BY `Kiek kartų buvo pasirinktas` DESC;

-- CREATE VIEW KiekUzsakymuYraAptarnavePadavejai AS
SELECT S.staff_id, CONCAT(S.first_name,' ',S.last_name,' - ',S.job_role),COUNT(DISTINCT CO.order_ID) AS 'Užsakymų kiekis'
FROM staff AS S
LEFT JOIN customer_order AS CO ON CO.staff_id=S.staff_id
WHERE S.job_role = 'server'
GROUP BY S.staff_id
ORDER BY COUNT(DISTINCT CO.order_ID) DESC;

-- CREATE VIEW KurieStaliukaiDazniausiaiRezervuojami AS
SELECT I.table_id,I.table_seats, COUNT(R.reservation_id) AS 'Rezervacijos dažnumas'
FROM inventory AS I
JOIN reservation AS R ON R.table_id=I.table_id
WHERE R.reservation_start_time IS NOT NULL
GROUP BY I.table_id
ORDER BY `Rezervacijos dažnumas` DESC	
