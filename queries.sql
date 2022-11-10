-- a) How much do spend on average per month:
--    - users aged between 18 to 25?
--    - users aged between 26 to 35?

WITH users_expenses
	AS
	(
		SELECT date_part('year', p.date) as year,
			   date_part('month', p.date) as month,
			   u.user_id, u.age,
			   SUM(price) as user_expense
		FROM users u JOIN purchases p ON u.user_id = p.user_id
			   JOIN items i ON i.item_id = p.item_id
		WHERE u.age BETWEEN 18 AND 25
		GROUP BY year, month, u.user_id
	)
SELECT AVG(user_expense) as avg_per_month
FROM users_expenses;


WITH users_expenses
	AS
	(
		SELECT date_part('year', p.date) as year,
			   date_part('month', p.date) as month,
			   u.user_id, u.age,
			   SUM(price) as user_expense
		FROM users u JOIN purchases p ON u.user_id = p.user_id
			   JOIN items i ON i.item_id = p.item_id
		WHERE u.age BETWEEN 26 AND 35
		GROUP BY year, month, u.user_id
	)
SELECT AVG(user_expense) as avg_per_month
FROM users_expenses;


------------------------------------------------------------------------------------
-- b) In which month of the year the income from users older than 35 is the largest?

SELECT date_part('month', p.date) as month,
       SUM(price) as income
FROM users u JOIN purchases p ON u.user_id = p.user_id
             JOIN items i ON i.item_id = p.item_id
WHERE u.age >= 35
GROUP BY month
ORDER BY income DESC LIMIT 1;


------------------------------------------------------------------------------------
-- c) Which product provides the largest contribution to revenue over the last year?

WITH items_income
	AS
	(
		SELECT i.item_id, SUM(i.price) as single_item_sum,
		 	   SUM(i.price) OVER() as total
		FROM purchases p JOIN items i ON i.item_id = p.item_id
		WHERE date_part('year', p.date) = date_part('year', (CURRENT_DATE - INTERVAL '1 YEAR'))
		GROUP BY i.item_id
	)
SELECT item_id,
	   single_item_sum * 100 / total as portion
FROM items_income
ORDER BY portion DESC LIMIT 1;


------------------------------------------------------------------------------------
-- d) Find out top 3 items by revenue and their share of total revenue for any year:

WITH items_income
	AS
	(
		SELECT i.item_id, SUM(i.price) as single_item_sum,
			   date_part('year', p.date) as year,
			   ROW_NUMBER() OVER(PARTITION BY date_part('year', p.date) ORDER BY SUM(i.price) DESC) as range,
			   SUM(i.price) OVER(PARTITION BY date_part('year', p.date)) as total_per_year
		FROM purchases p JOIN items i ON i.item_id = p.item_id
		GROUP BY year, i.item_id
	)
SELECT item_id, year,
	   single_item_sum,
	   total_per_year,
	   single_item_sum / total_per_year as portion
FROM items_income
WHERE range <= 3;

