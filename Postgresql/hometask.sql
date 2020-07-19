--1. -- done
CREATE DATABASE testdb WITH OWNER=shop ENCODING='UTF8';

--2. -- done
CREATE ROLE shop LOGIN CREATEDB PASSWORD 'shop';

--3. -- done
CREATE ROLE viewer LOGIN PASSWORD 'viewer'; # shop cant create new role in testdb - ERROR:  permission denied to create role

GRANT SELECT ON ALL TABLES IN SCHEMA public TO viewer; --ONLY AFTER CONNECT to <testdb> under postgres !
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO viewer;--ONLY AFTER CONNECT to <testdb> under postgres !!!!
-- ??? ask caiman is it ok? or it is better to use another method?

--4.-- done
CREATE TABLE "category" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL
);
--SELECT * FROM "category";
--DELETE FROM "category" WHERE title = 'Cars';

--5. --done
INSERT INTO "category" (title) VALUES
('Mobiles'),
('Conditioners'),
('Cars');

--6. --done
CREATE TABLE "item" (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES "category"(id) ON DELETE SET NULL,
    title VARCHAR(100) NOT NULL,
    price NUMERIC(8,2) NOT NULL
);
--SELECT * FROM "item";

--7. --done
INSERT INTO "item" (category_id, title, price) VALUES
(1, 'iPhone', 1.0),
(1, 'Xiaomi', 1.0),
(2, 'Mitsubishi', 1.0),
(2, 'Toshiba', 1.0),
(3, 'Seat', 1.0),
(3, 'BMW', 1.0);
--UPDATE "item" SET title = 'Huawei' WHERE title = 'Hueawei';

--8. --done
UPDATE "item" SET price = 3.5 WHERE id = 1;

--9. --done
UPDATE "item" SET price = price * 1.1;

--10. --done
DELETE FROM "item" WHERE id = 2;

--11. --done
SELECT * FROM "item" ORDER BY title;

--12. --done
SELECT * FROM "item" ORDER BY price DESC;

--13. --done
SELECT * FROM
( SELECT * FROM "item" ORDER BY PRICE DESC ) AS subTable
LIMIT 3;

--14. --done
SELECT * FROM
( SELECT * FROM "item" ORDER BY PRICE ) AS subTable
LIMIT 3;

--15. --done
SELECT * FROM
( SELECT * FROM "item" ORDER BY PRICE DESC ) AS subTable
LIMIT 3
OFFSET 3;

--16. --done
SELECT title FROM "item" WHERE
price = ( SELECT MAX(price) FROM "item" );

--17. --done
SELECT title FROM "item" WHERE
price = ( SELECT MIN(price) FROM "item" );

--18. --done
SELECT COUNT(id) as itemAmount FROM "item";

--19. --done
--SELECT AVG(price) as avgprice FROM "item";
SELECT CAST( AVG(price) as NUMERIC(8,2) ) as avgprice FROM "item";

--20. --done
CREATE VIEW maxView AS
    SELECT *
    FROM ( SELECT * FROM "item" ORDER BY PRICE DESC ) AS subTable
    LIMIT 3;
