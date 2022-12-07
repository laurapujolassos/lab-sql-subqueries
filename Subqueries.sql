# Lab | SQL Subqueries
# 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from sakila.film;
select * from sakila.inventory;
select * from sakila.film
where title = 'Hunchback Impossible';

select count(film_id) from sakila.inventory
where film_id in (select film_id from sakila.film
where title = 'Hunchback Impossible')
group by film_id; # 6 copies

#to see with join 
select inventory_id, i.film_id, title
from sakila.film f
left join sakila.inventory i on f.film_id = i.film_id
where title = 'Hunchback Impossible';

# 2. List all films whose length is longer than the average of all the films.

select title, avg (length)
from sakila.film
group by title
having avg(length) > (select avg(length) from sakila.film);

# 3. Use subqueries to display all actors who appear in the film Alone Trip.
select actor_id, film_id from sakila.film_actor
where film_id in (select film_id from sakila.film
where title = 'Alone Trip');

#to see with join 
select actor_id, f.film_id, title
from sakila.film f
left join sakila.film_actor fa on f.film_id = fa.film_id
where title = 'Alone Trip';

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select * from sakila.film_category;
select film_id, category_id from sakila.film_category
where category_id in (select category_id from sakila.category
where Name = 'Family');

# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select first_name, last_name, email from sakila.customer 
WHERE 
address_id in (select address_id from sakila.address 
where city_id in (select city_id from (select city_id from sakila.city
where country_id in (select country_id from (select country_id from sakila.country
where country = 'Canada' ) a1 ) ) a2 ));


# With joins
select first_name, last_name, email, country from sakila.customer c
join sakila.address a
on c.address_id= a.address_id
join sakila.city ci
on a.city_id= ci.city_id
join sakila.country co
on ci.country_id = co.country_id
where country = 'Canada'
order by last_name asc;
 
 # 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

# Most prolific actor
select count(film_id), actor_id
from sakila.film_actor
group by actor_id
order by count(film_id) desc
limit 1;

#answer
select title, f.film_id from sakila.film f
join sakila.film_actor a on f.film_id= a.film_id
where actor_id  in ( select actor_id from (select count(film_id), actor_id
from sakila.film_actor
group by actor_id
order by count(film_id) desc
limit 1) a1 );



select f.film_id, f.title, fa.actor_id
from sakila.film_actor fa
join sakila.film f
on fa.film_id=f.film_id
where actor_id= 107;

#7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.

select customer_id, first_name, last_name from sakila.customer
where customer_id in (select customer_id from (select sum(amount), customer_id 
from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1) a1 );

#answer
select f.film_id, title from sakila.film f
join sakila.inventory i on f.film_id= i.film_id
join sakila.rental r on i.inventory_id=r.inventory_id
where customer_id in (select customer_id from (select sum(amount), customer_id 
from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1) a1 );

#8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select avg(amount), customer_id
from sakila.payment
group by customer_id;

# Answer
select customer_id, sum(amount), avg(amount)
from sakila.payment
group by customer_id
having avg(amount) > (select avg(amount) from sakila.payment)
order by avg(amount) asc;
