use shop;

-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине

select users.id, users.name, users.birthday_at, orders.id as 'order_id', orders.user_id
from users
join orders on users.id = orders.user_id;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.


select *
from products, catalogs
where products.id = catalog_id