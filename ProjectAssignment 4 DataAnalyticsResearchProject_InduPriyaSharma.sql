CREATE TABLE FinalProj
(
    SerialNumber varchar,
    ListYear int,
    DateRecorded date,
    Town varchar,
    AssessedValue decimal,
    SaleAmount decimal,
    SalesRatio decimal,
    PropertyType varchar,
    ResidentialType varchar
);


SELECT * FROM FinalProj;

SELECT COUNT(*) FROM FinalProj;

SELECT ListYear, MAX(SaleAmount) FROM FinalProj 
GROUP BY ListYear ORDER BY ListYear ASC;

SELECT ListYear, AVG(SaleAmount) FROM FinalProj 
GROUP BY ListYear ORDER BY ListYear ASC;

SELECT Town, MAX(SaleAmount) FROM FinalProj GROUP 
BY Town ORDER BY MAX(SaleAmount) DESC LIMIT 10;

SELECT Town, AVG(SaleAmount) FROM FinalProj GROUP 
BY Town ORDER BY AVG(SaleAmount) DESC LIMIT 10;

SELECT Town, MAX(SalesRatio) FROM FinalProj GROUP 
BY Town ORDER BY MAX(SalesRatio) DESC LIMIT 10;

SELECT Town, AVG(SalesRatio) FROM FinalProj GROUP 
BY Town ORDER BY AVG(SalesRatio) DESC LIMIT 10;

SELECT DISTINCT(ListYear), Town, SaleAmount FROM 
FinalProj WHERE (ListYear, SaleAmount) IN
(SELECT ListYear, MAX(SaleAmount) FROM FinalProj 
 GROUP BY ListYear )ORDER BY ListYear DESC;

SELECT DISTINCT(ListYear), Town, AssessedValue FROM 
FinalProj WHERE (ListYear, AssessedValue) IN
(SELECT ListYear, MAX(AssessedValue) FROM FinalProj 
 GROUP BY ListYear ) ORDER BY ListYear DESC;

SELECT DISTINCT(ListYear), Town, SalesRatio FROM 
FinalProj WHERE (ListYear, SalesRatio) IN
(SELECT ListYear, MAX(SalesRatio) FROM FinalProj 
 GROUP BY ListYear ) ORDER BY ListYear DESC;




