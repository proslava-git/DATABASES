use shop;

-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине

select users.id, users.name, users.birthday_at, orders.id as 'order_id', orders.user_id
from users
join orders on users.id = orders.user_id;

select
	users.id,
	users.name,
	count(*) as total_orders
from users
inner join orders on users.id = orders.user_id
group by orders.user_id
order by total_orders desc

-- Выведите список товаров products и разделов catalogs, который соответствует товару.
