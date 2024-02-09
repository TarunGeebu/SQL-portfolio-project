--Q1. who is the senior most employee based on jobtitle?
select top 1*
from employee
order by levels desc


--Q2. which country has the most invoices?
select billing_country, count(billing_country) as totalinvoices
from invoice
group by billing_country
order by totalinvoices desc


--Q3. what are top 3 values of total invoice?
select distinct top 3 total
from invoice
order by total desc


--Q4. Which city has the best customers? return sum of all invoice totals and city names.
select billing_city, sum(total) as totalamount
from invoice
group by billing_city
order by totalamount desc


----Q5. What is the name of the best customer based on most money spent?
select top 1 invoice.customer_id, first_name, last_name, sum(total) as totalspent
from invoice
join customer
on invoice.customer_id = customer.customer_id
group by invoice.customer_id, first_name, last_name 
order by totalspent desc


--Q6. write a query to return the details of all rock music listeners. return the list in an alphabetical order by email.
select customer.first_name, customer.email, genre.name
from genre
join track 
on genre.genre_id = track.genre_id
join [invoice line]
on track.track_id = [invoice line].track_id
join invoice
on [invoice line].invoice_id = invoice.invoice_id
join customer 
on invoice.customer_id = customer.customer_id
where genre.name = 'rock'
group by customer.first_name, customer.email, genre.name
order by email

 --Q7. write a query that returns the artist name and total track count of the top 10 rock bands.  
 select top 10 artist.name, count(track.name) as totaltrack, genre.name
 from artist
 join album
 on artist.artist_id = album.artist_id
 join track
 on album.album_id = track.album_id
 join genre
 on track.genre_id = genre.genre_id
 where genre.name = 'rock'
 group by artist.name, genre.name
 order by totaltrack desc

--Q8. return the track names that have the song length longer than the avg song length. 
return name and miliseconds for each track and order by the longest track first.
select track.name, track.milliseconds
from track
where track.milliseconds >(select avg(milliseconds)
from track) 
order by milliseconds desc


--Q9. find how much each customer has spent on artists. write a query to return customer name,  artist name and total spent,
with cte as
(
select top 1 artist.artist_id, artist.name, sum([invoice line].unit_price * quantity) as totalspent
from artist
join album
on artist.artist_id = album.artist_id 
join track 
on album.album_id = track.album_id
join [invoice line]
on track.track_id = [invoice line].track_id
join invoice
on [invoice line].invoice_id = invoice.invoice_id
join customer 
on invoice.customer_id = customer.customer_id
group by artist.artist_id, artist.name
order by totalspent desc
)
select customer.first_name, cte.name, sum([invoice line].unit_price * quantity) as sales
from cte
join album
on cte.artist_id = album.artist_id 
join track 
on album.album_id = track.album_id
join [invoice line]
on track.track_id = [invoice line].track_id
join invoice
on [invoice line].invoice_id = invoice.invoice_id
join customer 
on invoice.customer_id = customer.customer_id
group by customer.first_name, cte.name
order by sales desc

--Q10. find the most popular genre for each country bsed on highest amount of purchases. 
write a query to return each country along with the top genre.
 return all genres for countries where the maximum number of purchases is shared.
with cte as
(
select top 10000000000  customer.country, genre.name as genrename, count(quantity) as totalpurchases,
ROW_NUMBER() over (partition by country order by count(quantity) desc) as rownumber
from customer
join invoice
on customer.customer_id = invoice.customer_id
join [invoice line]
on invoice.invoice_id = [invoice line].invoice_id
join track
on [invoice line].track_id = track.track_id
join genre
on track.genre_id = genre.genre_id
group by customer.country, genre.name
order by country asc, totalpurchases desc
)
select *
from cte
where rownumber = 1

--Q11. find the customer that has spent the most on music for each country.
 write a query that returns the country along with top customer and how much they have spent.
 return all customers where the top amount spent is shared.
with cte as
(
 select top 10000000 customer.first_name, billing_country, sum (total) as totalspent,
 row_number() over (partition by invoice.billing_country order by sum(total) desc) as rownumber
 from customer
 join invoice
 on customer.customer_id = invoice.customer_id
 group by customer.first_name, billing_country
 order by 2 asc, 3 desc
 )

 select *
 from cte 
 where rownumber = 1