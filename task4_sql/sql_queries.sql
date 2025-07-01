select * from category
limit 10

select * from film
limit 10

select * from film_category
limit 10

select * from film_actor
limit 10

select * from payment
limit 10

select * from inventory
limit 10

select * from store limit 10


select * from rental


select * from actor limit 10 





--Вывести количество фильмов в каждой категории, отсортировать по убыванию.

select c.name as ctaegory_name, count(*) as count_films from film_category
join category c on c.category_id = film_category.category_id
group by ctaegory_name
order by count_films desc

--Вывести 10 актеров, чьи фильмы большего всего арендовали, отсортировать по убыванию.

select CONCAT(a.first_name,' ', a.last_name) as actor_name, count(i.*) as rent_count from actor a
join film_actor fa on fa.actor_id = a.actor_id
join inventory i on i.film_id = fa.film_id
group by a.first_name, a.last_name
order by rent_count desc
limit 10



--Вывести категорию фильмов, на которую потратили больше всего денег.

select c.name as category_name, sum(p.amount) as total_spent
from payment p
join rental r on r.rental_id =p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
group by c.name
order by total_spent desc


--Вывести названия фильмов, которых нет в inventory. Написать запрос без использования оператора IN.

select f.*,i.* from film f
left join inventory i on f.film_id = i.film_id  
where i.film_id isnull


--Вывести топ 3 актеров, которые больше всего появлялись в фильмах в категории “Children”. Если у нескольких актеров одинаковое кол-во фильмов, вывести всех.
with act_cnts as(
	select 
		CONCAT(a.first_name,' ', a.last_name) as actor_name, 
		count(*) as appearances
	from 
		category c
	join film_category fc on fc.category_id = c.category_id
	join film f on f.film_id = fc.film_id
	join film_actor fa on fa.film_id = f.film_id
	join actor a on a.actor_id = fa.actor_id
	where c.name = 'Children'
	group by a.first_name, a.last_name
	order by appearances desc
	
),
rank_act as(
	select *, rank() over (order by appearances desc) as ranking from act_cnts
)
select actor_name, appearances
from rank_act
where ranking<=3




--Вывести города с количеством активных и неактивных клиентов (активный — customer.active = 1). Отсортировать по количеству неактивных клиентов по убыванию.


with act_city as (
select 
	c.city,
	count(case when cst.active=1 then 1 end) as active,
	count(case when cst.active=0 then 1 end) as nonactive
	from city c
join address a on c.city_id = a.city_id
join customer cst on cst.address_id  = a.address_id
group by city
order by nonactive)

select city from act_city





--Вывести категорию фильмов, у которой самое большое кол-во часов суммарной аренды в городах (customer.address_id в этом city), и которые начинаются на букву “a”. То же самое сделать для городов в которых есть символ “-”. Написать все в одном запросе.


with rntl_hrs as(
select 
	c.name as category_name,
	sum(extract( hour from (r.return_date - r.rental_date))) as tot_rntl_hrs,
	ci.city as city
	from category c
	join film_category fc on fc.category_id = c.category_id
	join film f on f.film_id = fc.film_id
	join inventory i on i.film_id = f.film_id
	join rental r on r.inventory_id = i.inventory_id
	join customer cu on r.customer_id = cu.customer_id
    join address a on cu.address_id = a.address_id
    join city ci on a.city_id = ci.city_id
	group by c.category_id, c.name, ci.city
	
),
city_with_a as (
    select 
        category_name,
        tot_rntl_hrs,
        city
    from 
        rntl_hrs
    where 
        city ilike 'a%'
    order by
        tot_rntl_hrs desc
),
city_double as (
    select 
        category_name,
        tot_rntl_hrs,
        city
    from 
        rntl_hrs
    where 
        city like '%-%'
    order by 
        tot_rntl_hrs desc

)
select * from city_with_a
union
select * from city_double;





