use sakila;
describe actor;


-- #1a
SELECT first_name, last_name from actor;

-- #1b
SELECT concat(first_name, " ", last_name) as 'Actor Name' from actor;

-- #2a
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

-- #2b
SELECT * from actor where last_name like "%GEN%";

-- #2c
SELECT * FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name, first_name;

-- #2d
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- #3a
ALTER TABLE actor
	ADD COLUMN middle_name VARCHAR (50) AFTER first_name;

-- #3b
ALTER TABLE actor 
	MODIFY COLUMN middle_name blob; 

-- #3c
ALTER TABLE actor
	DROP COLUMN middle_name;
    
-- #4a
SELECT last_name, count(*) from actor GROUP BY last_name;

-- #4b
SELECT last_name, count(2) from actor GROUP BY last_name HAVING count(*) > 1;

-- #4c
UPDATE actor
	SET first_name = 'HARPO',
		last_name = 'WILLIAMS'
	WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';
    
-- #4d
UPDATE actor 
SET first_name = CASE 
	WHEN (first_name = "HARPO") THEN 'GROUCHO'
    WHEN (first_name = 'GROUCHO') THEN 'MUCHO GROUCHO'
    ELSE first_name
END; 

-- #5a
SHOW CREATE TABLE sakila.actor;

-- #6a
SELECT staff.first_name, staff.last_name, address.address
	FROM address INNER JOIN staff ON staff.address_id = address.address_id;

-- #6b
SELECT staff.first_name, staff.last_name, SUM(amount) as 'Payment Sum'
	FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id GROUP BY first_name, last_name;
    
-- #6c
SELECT film.title, count(actor_id) as 'Actor Count'
	FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id GROUP BY film.title;
    
-- #6d
SELECT film.title, count(inventory_id) as 'Number of Copies' 
	FROM inventory INNER JOIN film on film.film_id = inventory.film_id 
		WHERE film.title = 'Hunchback Impossible';
        
-- #6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) as 'Total Amount Paid'
	FROM customer INNER JOIN payment on payment.customer_id = customer.customer_id
		GROUP BY customer.last_name ORDER BY customer.last_name;

-- #7a
SELECT film.title 
	FROM film INNER JOIN language ON film.language_id = language.language_id
		WHERE language.name = 'English' and film.title LIKE 'K%' OR film.title LIKE 'Q%';

-- #7b 
SELECT actor.first_name, actor.last_name 
	FROM film_actor 
		INNER JOIN actor
			ON actor.actor_id = film_actor.actor_id
		INNER JOIN film
			on film.film_id = film_actor.film_id
	WHERE film.title = 'Alone Trip';
    
-- #7c
SELECT customer.first_name, customer.last_name, customer.email 
	FROM customer INNER JOIN store on customer.store_id = store.store_id
    INNER JOIN address ON store.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
	WHERE country.country = 'Canada';

-- #7d
select * from film WHERE rating = 'G';

-- #7e
SELECT film.title AS 'Title', COUNT(inventory.film_id) AS 'Rental Count'
	FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
		GROUP BY film.title ORDER BY count(inventory.film_id) DESC;

-- #7f
SELECT staff_id as 'Store', SUM(payment.amount) as 'Payment'
	FROM payment GROUP BY staff_id;

-- #7g
SELECT store.store_id, city.city, country.country
	FROM store INNER JOIN address ON store.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id;

-- #7h
SELECT category.name AS 'Genre', sum(payment.amount) AS 'Payment Amount'
	FROM category INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN inventory ON film_category.film_id = inventory.film_id
    INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY category.name ORDER BY SUM(payment.amount) DESC LIMIT 5;

-- #8a
DROP VIEW IF EXISTS top_five_genres;

CREATE VIEW top_five_genres AS
SELECT category.name AS 'Genre', sum(payment.amount) AS 'Payment Amount'
	FROM category INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN inventory ON film_category.film_id = inventory.film_id
    INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id
    GROUP BY category.name ORDER BY SUM(payment.amount) DESC LIMIT 5;

-- #8b
SELECT * from top_five_genres;

-- #8c
DROP VIEW top_five_genres;

