create database credit_card;
use credit_card;
-- checking for duplicates
SELECT 
    City,
    Date,
    `Card Type`,
    `Exp Type`,
    Gender,
    Amount,
    COUNT(*) AS duplicate_count
FROM 
    creditcard
GROUP BY 
    City, Date, `Card Type`, `Exp Type`, Gender, Amount
HAVING 
    COUNT(*) > 1;
alter table creditcard rename column `index` to id;
alter table creditcard modify id int primary key;
select * from creditcard;
-- covetered date formate to sql date formate
UPDATE credit_card.creditcard SET Date = DATE_FORMAT(STR_TO_DATE(Date, '%d-%b-%Y'), '%d-%m-%Y');

UPDATE creditcard
SET Date = STR_TO_DATE(Date, '%d-%m-%Y');
-- cahnging date formate from text to date
ALTER TABLE creditcard
Modify COLUMN Date DATE;

-- Feature Engineering
alter table creditcard add column (month varchar(20) ,year int, day varchar(20));

UPDATE creditcard 
SET month = DATE_FORMAT(Date, '%M');

Update creditcard
set year=year(Date);

Update creditcard
set day=DATE_FORMAT(Date,'%W'); 

alter table creditcard add column( Seasons varchar(50));
update creditcard set Seasons = (case WHEN month IN ('March', 'April', 'May') THEN 'Spring'
        WHEN month IN ('June', 'July', 'August') THEN 'Summer'
        WHEN month IN ('September', 'October', 'November') THEN 'Autumn'
        ELSE 'Winter'
    END);
 
 -- extracting India from city column
 select substring_index(trim(City), ',', 1) from creditcard;
 update creditcard set City = substring_index(trim(City), ',', 1);
 update creditcard
 set City = trim(replace(City, 'Greater ', ''));
 
-- Business Related Questions
-- 1. what is lowest and highest amount spend on the expenses?
SELECT 
    `Exp Type`, avg(Amount)
FROM
    creditcard
GROUP BY `Exp Type`
ORDER BY avg(Amount) DESC
LIMIT 1;
 SELECT 
    `Exp Type`, avg(Amount)
FROM
    creditcard
GROUP BY `Exp Type`
ORDER BY avg(Amount) ASC
LIMIT 1;

-- 2. Who is one that spends the most and on what?
select Gender, avg(Amount), `Exp Type` from creditcard group by Gender, `Exp Type` order by avg(Amount) desc limit 1;

-- 3. What is least spent expense according to gender?

SELECT distinct `Exp Type`, Gender, avg(Amount) AS TotalAmount
FROM creditcard
GROUP BY `Exp Type`, Gender
ORDER BY TotalAmount limit 1;

-- 4. In which month does the expenses is high?
select distinct(month), avg(Amount) from creditcard group by month order by avg(Amount) desc limit 1;

-- 5. In which years does the spendings in at highest and the lowest?
SELECT year, sum(Amount) AS TotalAmount
FROM creditcard
GROUP BY year
ORDER BY TotalAmount ASC
LIMIT 1;
SELECT year, sum(Amount) AS TotalAmount
FROM creditcard
GROUP BY year
ORDER BY TotalAmount DESC
LIMIT 1;
-- 6. Is weekdays or weekend the most spending time?
SELECT 
    CASE 
        WHEN day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'Weekday'
        WHEN day IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Other' -- Handle any other days if present in your data
    END AS DayType,
    avg(Amount) AS TotalAmount
FROM creditcard
GROUP BY 
    (CASE 
        WHEN day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'Weekday'
        WHEN day IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Other' -- Handle any other days if present in your data
    END) order by TotalAmount asc;


-- 7. In which season does people spend the most?
select distinct(Seasons),avg(Amount) from creditcard
group by Seasons order by avg(Amount) desc limit 1 ;

-- 8. Which is most commonly used card?
select `Card Type` , count(*) as usage_count from creditcard group by `Card Type` order by usage_count desc limit 1;

-- 9.Which city has the highest transcactions?
SELECT City, count(*) as TotalSpent
FROM creditcard
GROUP BY City
ORDER BY TotalSpent DESC limit 1;

-- 10. What is the average amount spent grouped by gender and season?
SELECT Gender, Seasons, AVG(Amount) AS AvgAmount
FROM creditcard
GROUP BY Gender, Seasons;

-- 11. How many transactions occurred in each city for each year?
SELECT  City,year,COUNT(*) AS TransactionCount
FROM creditcard
GROUP BY City, year limit 5;

-- 12. What are the top 5 cities based on the total amount spent?
SELECT City, SUM(Amount) AS TotalAmount
FROM creditcard GROUP BY City ORDER BY TotalAmount DESc LIMIT 5;

-- 13. What are the peak spending days for each season? 
SELECT 
    Seasons, 
    day, 
    SUM(Amount) AS TotalAmount
FROM creditcard
GROUP BY Seasons, day
ORDER BY Seasons asc,TotalAmount DESC;

-- 14.  How do yearly spending patterns differ across various card types?
SELECT 
    year, 
    `Card Type`, 
    SUM(Amount) AS TotalAmount,
    AVG(Amount) AS AvgAmount,
    COUNT(*) AS TransactionCount
FROM creditcard
GROUP BY year, `Card Type`
ORDER BY year, `Card Type`;

-- 15. How can we segment customers based on their spending habits, and which segments are most valuable?
SELECT Gender, `Card Type`, SUM(Amount) AS TotalAmount, COUNT(*) AS TransactionCount,
       ROUND(AVG(Amount), 2) AS AvgTransactionAmount,
       ROUND(SUM(Amount) / COUNT(*) * 100, 2) AS ValueIndex
FROM creditcard
GROUP BY Gender, `Card Type`
ORDER BY TotalAmount DESC, ValueIndex DESC;

-- 16. What are the peak spending days, and how do they compare to other days in terms of total and average spending?
SELECT day, SUM(Amount) AS TotalAmount, AVG(Amount) AS AvgAmount, COUNT(*) AS TransactionCount
FROM creditcard
GROUP BY day
ORDER BY TotalAmount DESC;

-- 17. How does the use of different card types vary with seasons, and which card type is preferred in each season?
SELECT `Card Type`, Seasons, SUM(Amount) AS TotalAmount, AVG(Amount) AS AvgAmount
FROM creditcard GROUP BY `Card Type`, Seasons
ORDER BY Seasons, TotalAmount DESC;