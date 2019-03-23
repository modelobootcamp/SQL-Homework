show tables;
-- 1a. Display thetables first and last names of all actors from the table actor
SELECT first_name 'Frist Name', last_name 'Last Name'FROM actor;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT first_name, last_name FROM actor UPPER ORDER BY last_name LIMIT 5;
SELECT first_name, last_name FROM actor UPPER ORDER BY first_name ASC,  last_name DESC LIMIT 3;
SELECT CONCAT(first_name, ",  ", last_name) AS 'Actor Name' FROM actor UPPER;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know ONly the first name, "Joe." What is ONe query would you use to obtain this informatiON?
SELECT actor_id 'ID number', first_name 'first name', last_name 'last name'FROM actor WHERE first_name LIKE 'Joe';
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 2b. Find all actors whose last name cONtain the letters GEN:
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 2c. Find all actors whose last names cONtain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name AND first_name;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 3a. You want to keep a descriptiON of each actor. You dON't think you will be performing queries ON a descriptiON, so create a column in the table actor named descriptiON
-- and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

SELECT * FROM actor;
ALTER TABLE actor 
ADD COLUMN descriptiON BLOB;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 3b. Very quickly you realize that entering descriptiONs for each actor is too much effort. Delete the descriptiON column.
ALTER TABLE actor Drop COLUMN descriptiON;
DESCRIBE actor;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) as "Count of Last Name"
FROM actor
GROUP BY last_name;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT * from actor WHERE lower(last_name)='WILLIAMS'and lower(first_name) = 'groucho';
SELECT first_name, last_name from actor where first_name IN ('GROUCHO') and last_name IN ('WILLIAMS');
SELECT * from actor where first_name='GROUCHO' and last_name='WILLIAMS';
UPDATE actor SET first_name='HARPO' where first_name='GROUCHO' AND last_name = 'WILLIAMS';
SELECT * from actor WHERE lower(last_name)='WILLIAMS'and lower(first_name) = 'groucho';
SELECT * from actor WHERE lower(last_name)='WILLIAMS'and lower(first_name) = 'HARPO';
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name='GROUCHO' where first_name='HARPO' AND last_name = 'WILLIAMS';
SELECT * from actor WHERE lower(last_name)='WILLIAMS'and lower(first_name) = 'groucho';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
SELECT * FROM address;
CREATE TABLE IF NOT EXISTS`address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) CHARACTER SET utf8 NOT NULL,
  `address2` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `district` varchar(20) CHARACTER SET utf8 NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `phONe` varchar(20) CHARACTER SET utf8 NOT NULL,
  `locatiON` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_locatiON` (`locatiON`),
  SPATIAL KEY `idx_address_locatiON` (`locatiON`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE
);
SELECT * FROM address;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name 'First Name', staff.last_name 'Last Name', address.address 'Address', city.city, country.country 'Country'
FROM staff 
INNER JOIN address ON staff.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.first_name 'First Name', staff.last_name 'Last Name',  sum( payment.amount) 'Paid', payment.payment_date 'Date'
FROM staff 
INNER JOIN payment ON staff.staff_id=  payment.staff_id
WHERE payment.payment_date  BETWEEN '2005-08-01 12:00AM' AND '2005-08-31 11:59PM' 
GROUP BY payment.staff_id;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
-- Use inner JOIN.
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 6d How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name 'First Name', customer.last_name 'Last Name',  sum( payment.amount) 'Paid', payment.payment_date 'Date'
FROM customer
INNER JOIN payment ON customer.customer_id=  payment.customer_id
GROUP BY customer.last_name;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7a. The music of Queen and Kris KristoffersON have seen an unlikely resurgence. As an unintended cONsequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title ' titles of movies starting with the letters K and Q whose language is English' FROM film
WHERE language_id IN
(SELECT language_id 
FROM language
WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7b. Use subqueries to display all actors who appear in the film AlONe Trip.
SELECT last_name, first_name "all actors who appear in the film AlONe Trip" FROM actor
WHERE actor_id IN
(SELECT actor_id FROM film_actor
WHERE film_id IN 
(SELECT film_id FROM film
WHERE title = "AlONe Trip"));
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use JOINs to retrieve this informatiON.
SELECT customer.last_name, customer.first_name, customer.email 'names and email addresses of all Canadian customers'FROM customer
INNER JOIN customer_list ON customer.customer_id = customer_list.ID
WHERE customer_list.country = 'Canada';
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7d. Sales have been lagging amONg young families, and you wish to target all family movies for a promotiON. Identify all movies categorized as family films.
SELECT title 'all movies categorized as family films Rated "G" and "PG"'
FROM film
WHERE rating IN ('G', 'PG');
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7e. Display the most frequently rented movies in descending order.
SELECT title 'the most frequently rented movies in descending order', COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title  ORDER BY Count_of_Rented_Movies DESC;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id 'how much business, in dollars, each store brought in',  SUM(amount ) FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN payment p ON p.customer_id =  c.customer_id 
GROUP BY s.store_id;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, address, address2, district, city, postal_code, country from store s 
JOIN address a ON s.address_id = a.address_id 
JOIN city c ON a.city_id = c.city_id
JOIN country y ON c.country_id = y.country_id;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS "List the top five genres in gross revenue in descending order", SUM(p.amount) AS "gross"  FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Film_name1 AS SELECT name, SUM(p.amount) FROM category c
INNER JOIN film_category fc
INNER JOIN inventory i
ON i.film_id = fc.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
INNER JOIN payment p
GROUP BY name
LIMIT 5;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM name1;
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- --------------------------------------------------------------------------------  -- --------------------------------------------------------------------------------  
-- 8c. You find that you no lONger need the view top_five_genres. Write a query to delete it.
DROP VIEW name1;
