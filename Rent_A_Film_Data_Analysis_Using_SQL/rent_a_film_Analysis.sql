Context:
You are working as a Data Engineer in Rent-A-Film, the management wants you to answers their questions to help other teams in your organization to drive decisions through data.

our aim is to answer the following questions:

>> \SQL;
>> \connect root@localhost;
>> create database rent_a_film;
>> show DATABASES;
>> use rent_a_film;

Question and Answers:
1. We want to run an Email Campaigns for customers of Store 2 (First, Last name, and Email address of customers from Store 2)
Ans: SELECT first_name,last_name,email FROM CUSTOMER WHERE STORE_ID=2;

2. List of the movies with a rental rate of 0.99$
Ans: select * from film where rental_rate=0.99 limit 10;
     select title from film where rental_rate=0.99 limit 10;

3. Objective is to show the rental rate and how many movies are in each rental rate categories
Ans: select rental_rate, count(title) as No_of_Movies from film group by rental_rate;

4. Which rating do we have the most films in?
Ans: select rating, count(rating) as highest_ratings from film group by rating order by count(rating) desc limit 1;
                                         or
     select rating, max(cnt) from (select rating, count(rating) as cnt from film group by rating order by count(rating) desc) as temp;

5. Which rating is most prevalent in each store?
Ans: select store_id, count(rating) from film, inventory where film.film_id=inventory.film_id group by film.rating, inventory.store_id;
     select store_id, rating, count(rating) from film, inventory where film.film_id=inventory.film_id group by film.rating, inventory.store_id order by count(rating) desc;
     select store_id, rating, max(freq) 
            from (select store_id,rating,count(rating) as 'freq' from film F, inventory I 
            where F.film_id = I.film_id group by store_id,rating order by store_id,freq desc) as temp group by store_id;

6. We want to mail the customers about the upcoming promotion
Ans: select first_name, last_name, email from customer limit 10;   # need to mail the customer requires email id for each so import the mail id.

7. List of films by Film Name, Category, Language
Ans: select title, category_id, name as Language from film F, film_category FC, language L where F.film_id=FC.film_id and F.language_id=L.language_id;
     or use join function
     select title, category_id, name as Language from film F inner join film_category FC on F.film_id=FC.film_id inner join language L on F.language_id=L.language_id;

8. How many times each movie has been rented out?
Ans: select * from rental limit 10;
     select * from inventory limit 10;
     select * from film limit 10;

     select title, count(title) from rental R inner join inventory I on R.inventory_id=I.inventory_id inner join film F on F.film_id=I.film_id group by title;

9. What is the Revenue per Movie?
Ans: select title, sum(amount) as 'revenue in $' from payment P inner join rental R on P.rental_id=R.rental_id 
            inner join inventory I on R.inventory_id=I.inventory_id 
                  inner join film F on I.inventory_id=F.film_id group by title;

10. Most Spending Customer so that we can send him/her rewards or debate points
Ans: select first_name, last_name, email, max(amount_spent) from (select first_name, last_name, email, sum(amount) as amount_spent 
            from customer C, payment P where C.customer_id=P.customer_id group by email order by amount_spent desc) as temp;
				or use joins
     SELECT FIRST_NAME,LAST_NAME,EMAIL,SUM(AMOUNT) AS 'AMOUNT_SPENT' 
            FROM CUSTOMER INNER JOIN PAYMENT ON PAYMENT.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID GROUP BY EMAIL ORDER BY AMOUNT_SPENT DESC LIMIT 1;

11. What Store has historically brought the most revenue?
Ans. select store_id, sum(amount) as 'total_revenue' from payment P inner join rental R on P.rental_id = R.rental_id 
     inner join inventory I on I.inventory_id = R.inventory_id group by store_id order by total_revenue desc limit 1;

12. How many rentals do we have for each month?
Ans: select month(rental_date) as month, count(rental_id) as Monthly_rentals from rental group by month(rental_date);

13. Rentals per Month (such Jan => How much, etc)
Ans: select month(rental_date) as month, count(rental_id) as Monthly_rentals from rental group by month(rental_date);

14. Which date the first movie was rented out?
Ans: select distinct date(rental_date) from rental order by rental_date limit 1;
			or
     select min(date(rental_date)) from rental;

15. Which date the last movie was rented out?
Ans: select max(date(rental_date)) as last_movie_rented from rental;
     select date(rental_date) from rental order by rental_date desc limit 1;

16. For each movie, when was the first time and last time it was rented out?
Ans: select title, min(rental_date) as first_time_rented, max(rental_date) as last_time_rented 
     from rental R, inventory I, film F where R.inventory_id=I.inventory_id and I.film_id=F.film_id group by title;
or
     SELECT TITLE,MIN(RENTAL_DATE),MAX(RENTAL_DATE) AS 'FIRST_LAST_DATE' FROM RENTAL
            INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
            INNER JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID GROUP BY TITLE;

17. What is the Last Rental Date of every customer?
Ans: select customer_id, max(date(rental_date) from rental where customer_id in (select customer_id from customer) group by customer_id;
                          or
     select first_name, last_name, max(date(rental_date)) from rental R, Customer C where R.customer_id=C.customer_id group by R.customer_id

18. What is our Revenue Per Month?
Ans: select month(payment_date), sum(amount) from payment group by month(payment_date);
     select month(payment_date), sum(amount) as monthly_revenue from payment group by year(payment_date), month(payment_date);
     select year(payment_date), month(payment_date), sum(amount) as monthly_revenue from payment group by year(payment_date), month(payment_date);

19. How many distinct Renters do we have per month?
ans: select year(rental_date) as year, month(rental_date) as month, count(distinct customer_id) as distinct_renters from rental group by month(rental_date);

20. Show the Number of Distinct Film Rented Each Month
Ans: select title, month(rental_date), count(distinct title) from film F, inventory I,rental R 
            where F.film_id=I.film_id and I.inventory_id=R.inventory_id group by year(rental_date), month(rental_date);
or
     select monthname(rental_date), count(distinct film_id) from inventory I,rental R 
            where I.inventory_id=R.inventory_id group by year(rental_date), month(rental_date);

21. Number of Rentals in Comedy, Sports, and Family
Ans: select name, count(name) as number_of_rentals from rental R inner join inventory I on R.inventory_id=I.inventory_ID 
            inner join film_category FC on I.film_id=FC.film_id inner join category C on C.category_id=FC.category_id group by C.name;

And using only category, film and film category table joining
     select name, count(name) as number_of_rentals from category C inner join film_category FC on C.category_id=FC.category_id 
            inner join film F on FC.film_id=F.film_id group by C.name;

22. Users who have been rented at least 3 times
Ans: SELECT first_name, last_name, count(rental.customer_id) FROM RENTAL INNER JOIN CUSTOMER ON RENTAL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID 
            group by rental.customer_id having count(rental.customer_id) >=3;
     SELECT first_name, last_name, count(C.customer_id) from customer C, rental R where C.customer_id=R.customer_id group by R.customer_id;

23. How much revenue has one single store made over PG13 and R-rated films?
Ans: select * from PAYMENT limit 10;
     SELECT * FROM RENTAL limit 10;
     SELECT STORE_ID,RATING,SUM(RENTAL_RATE) AS 'REVENUE'
     FROM PAYMENT
     INNER JOIN RENTAL ON RENTAL.RENTAL_ID = PAYMENT.RENTAL_ID
     INNER JOIN INVENTORY ON INVENTORY.INVENTORY_ID = RENTAL.INVENTORY_ID
     INNER JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
     GROUP BY STORE_ID, RATING
     HAVING RATING='PG-13' OR RATING='R';

24. Active User where active = 1
Ans: select first_name, last_name, email from customer where active=1;
     select * from customer where active=1;

25. Reward Users: who has rented at least 30 times
Ans: SELECT FIRST_NAME,LAST_NAME, EMAIL,COUNT(RENTAL_ID) AS 'FREQ'
     FROM RENTAL INNER JOIN CUSTOMER ON RENTAL.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
     GROUP BY RENTAL.CUSTOMER_ID HAVING FREQ >= 30;
     
26. Reward Users who are also active
ANS: SELECT FIRST_NAME,LAST_NAME, EMAIL,ACTIVE FROM CUSTOMER WHERE CUSTOMER.ACTIVE=1;

27. All Rewards Users with Phone?
Ans: SELECT FIRST_NAME,LAST_NAME, EMAIL, phone
     FROM CUSTOMER
     INNER JOIN ADDRESS ON CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
     WHERE PHONE IS not NULL;

