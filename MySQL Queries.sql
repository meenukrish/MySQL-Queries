/* MYSQL SQL QUERIES*/
/* */
USE sakila;
#1a.
	/*Display the first and last names of all actors from the table `actor`. */
	
    SELECT first_name AS "First Name", last_name AS "Last Name" FROM ACTOR;
#1b.
	/* Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. */
   
   SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS "Actor Name" FROM ACTOR;
#2a.
	/* You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
		What is one query would you use to obtain this information?*/
	
    SELECT actor_id AS ID, first_name AS "First Name" , last_name AS "Last Name" FROM ACTOR where first_name ="JOE";
#2b.
	/* Find all actors whose last name contain the letters `GEN`:*/
	
    SELECT first_name AS "First Name" , last_name AS "Last Name" FROM ACTOR WHERE last_name like '%GEN%';
#2c. 
	/*Find all actors whose last names contain the letters `LI`. 
    This time, order the rows by last name and first name, in that order */
    
    SELECT first_name AS "First Name" , last_name AS "Last Name" FROM ACTOR WHERE last_name like '%LI%';
#2d.
	/*Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China: */
    
    SELECT country_id AS "Country ID", country as "Country" FROM COUNTRY WHERE country in ('Afghanistan', 'Bangladesh', 'China');
#3a.
	/* You want to keep a description of each actor. 
    You don't think you will be performing queries on a description, 
    so create a column in the table `actor` named `description` and use the data type `BLOB` 
    (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).*/
    
    ALTER TABLE actor ADD COLUMN description blob;
    SELECT * FROM actor;
#3b. 
	/* Very quickly you realize that entering descriptions for each actor is too much effort. 
    Delete the `description` column.*/
    
    ALTER TABLE	actor DROP COLUMN description;
#4a.
	/* List the last names of actors, as well as how many actors have that last name. */
    SELECT last_name AS "Last Name" , COUNT(last_name) FROM actor GROUP BY last_name;  
#4b.
	/* List last names of actors and the number of actors who have that last name, 
    but only for names that are shared by at least two actors */
    
    SELECT last_name AS "Last Name" , COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 2;  
#4c. 
	/* The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
    Write a query to fix the record. */
    
    SET SQL_SAFE_UPDATES = 0;
    UPDATE actor SET first_name ="HARPO" WHERE first_name ="GROUCHO" AND last_name ="WILLIAMS" ;
    SET SQL_SAFE_UPDATES = 1;
    
#4d. 
	/* Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
    It turns out that `GROUCHO` was the correct name after all! 
    In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO` */
   
   SET SQL_SAFE_UPDATES = 0;
    UPDATE actor SET first_name ="GROUCHO" WHERE first_name ="HARPO" AND last_name ="WILLIAMS" ;
    SET SQL_SAFE_UPDATES = 1;
#5a. 
	/* You cannot locate the schema of the `address` table. Which query would you use to re-create it?*/
    
    SHOW CREATE TABLE address;
#6a. 
	/* Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
    Use the tables `staff` and `address`:*/
    
    SELECT staff.first_name AS "First Name", staff.last_name AS "Last Name", address.address AS "Address" 
    FROM address INNER JOIN staff USING(address_id); 
#6b. 
	/*Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
    Use tables `staff` and `payment`*/
    
	SELECT staff.first_name AS "First Name", staff.last_name AS "Last Name", SUM(payment.amount) AS "Total Amount" 
    FROM payment INNER JOIN staff USING(staff_id)
	WHERE payment.payment_date LIKE '2005-08-%'
	GROUP BY staff.staff_id; 

#6c. 
	/*List each film and the number of actors who are listed for that film. 
    Use tables `film_actor` and `film`. Use inner join*/
    
    SELECT film.title AS "Film Title" , COUNT(actor_id) AS "Number of Actors" 
    FROM FILM_ACTOR INNER JOIN FILM USING(film_id) GROUP BY film.film_id;
   
#6d.
	/*How many copies of the film `Hunchback Impossible` exist in the inventory system?*/
	SELECT COUNT(inventory_id) AS "Number of copies" FROM inventory WHERE film_id 
    IN (SELECT film_id FROM film WHERE title = "Hunchback Impossible");
    
#6e. 
	/*Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
    List the customers alphabetically by last name:*/
    
    SELECT customer.first_name AS "First Name", customer.last_name AS "Last Name", SUM(payment.amount) as "Total Amount Paid"
    FROM payment INNER JOIN customer USING(customer_id) 
    GROUP BY customer.customer_id ORDER BY customer.last_name ASC;
    
#7a. 
	/* The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
	   As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
       Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. */
       
       SELECT title AS "Film Title" FROM film WHERE 
       (title LIKE 'K%' OR title LIKE 'Q%') AND
       language_id in (SELECT language_id FROM language WHERE name ="English");
       
#7b.  
	/* Use subqueries to display all actors who appear in the film `Alone Trip`.*/
    SELECT first_name, last_name FROM ACTOR WHERE actor_id IN 
    (SELECT actor_id FROM film_actor WHERE film_id IN
    (SELECT film_id from film where title = "Alone Trip"));
    
#7c.  
	/* You want to run an email marketing campaign in Canada, 
    for which you will need the names and email addresses of all Canadian customers. 
    Use joins to retrieve this information.*/
    
    SELECT first_name as "First Name", last_name as "Last Name" , email as "Email address"  FROM customer 
    INNER JOIN address using(address_id)
    INNER JOIN city using (city_id)
    INNER JOIN country using (country_id) where country = "Canada";

#7d. 
	/* Sales have been lagging among young families, and you wish to target all family movies for a promotion.
    Identify all movies categorized as _family_ films.*/
   
    SELECT title AS "Family Movies" FROM film 
    INNER JOIN film_category USING(film_id)
    INNER JOIN category USING(category_id) WHERE category.name='Family';
    
#7e.  
	# Display the most frequently rented movies in descending order.   
    
   #title AS "Most Frequenty Rented Movies"
    
    SELECT film.title AS "Most Frequenty Rented Movies" from film 
    INNER JOIN inventory USING (film_id) 
    INNER JOIN rental USING (inventory_id) 
    GROUP BY film.film_id
    ORDER BY COUNT(rental_id) DESC;
   
#7f. 
	/*Write a query to display how much business, in dollars, each store brought in.*/
   # store -> customer -> payment
    
    SELECT store.store_id AS "Store ID", SUM(payment.amount) AS "Business in Dollars" FROM payment
    INNER JOIN staff USING(staff_id) 
    INNER JOIN store ON (store.manager_staff_id = staff.staff_id) GROUP BY store.store_id;

#7g.
	/* Write a query to display for each store its store ID, city, and country.*/
    
    SELECT store.store_id AS "Store ID" , city.city AS "City", country.country AS "Country" from store 
    INNER JOIN address USING (address_id)
    INNER JOIN city USING (city_id)
    INNER JOIN country USING (country_id);
    
#7h. 
	/* List the top five genres in gross revenue in descending order. 
    (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.) */
   
    SELECT category.name AS "Genre Name" FROM category
    INNER JOIN film_category using (category_id)
    INNER JOIN inventory using (film_id)
    INNER JOIN rental using (inventory_id)
    INNER JOIN payment USING (rental_id) 
    GROUP BY category.name
    ORDER BY SUM(payment.amount) DESC
    LIMIT 5;

#8a. 
	/* In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
    Use the solution from the problem above to create a view. */
    
    CREATE VIEW Top_Five_Genre_By_Gross_Revenue AS
    (SELECT category.name AS "Genre Name" FROM category
    INNER JOIN film_category using (category_id)
    INNER JOIN inventory using (film_id)
    INNER JOIN rental using (inventory_id)
    INNER JOIN payment USING (rental_id) 
    GROUP BY category.name
    ORDER BY SUM(payment.amount) DESC
    LIMIT 5);
    
#8b.  
	#How would you display the view that you created in 8a?
    SELECT * FROM Top_Five_Genre_By_Gross_Revenue;

#8c. 
	#You find that you no longer need the view `top_five_genres`. Write a query to delete it.
    
    DROP VIEW  Top_Five_Genre_By_Gross_Revenue;