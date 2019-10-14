use vk;

-- выборка данных по пользователям

select
	firstname, lastname, email, phone, gender
from users
join profiles on users.id = profiles.user_id;

-- выьорка новостей по пользователю

select
	
from media
join users on media.user_id = user_id
where users.id = 1;

-- сообщения к пользователю

select
	m.body,
	firstname,
	lastname,
	m.created_at
from messages as m
join users as u on m.to_user_id = u.id
where u.id = 1;

-- сообщения от пользователя

select
	m.body,
	firstname,
	lastname,
	m.created_at
from messages as m
join users as u on m.from_user_id = u.id
where u.id = 1;

-- количество друзей у всех пользователей

select
	u.id,
	concat(u.firstname, ' ', u.lastname) as 'user name',
 	count(*) as friends_count
from users u
join friend_requests fr on 
	(u.id = fr.initiator_user_id or u.id = fr.target_user_id)
where fr.status = 'approved'
group by u.id
order by friends_count desc;

-- выбор новостей друзей пользователя

select
*
from media m
join friend_requests fr on m.user_id = fr.target_user_id -- все кому я подтвердил в друзья
where target_user_id = 1
	and status = 'approved'
union
select
*
from media m
join friend_requests fr on m.user_id = fr.initiator_user_id -- все кому я отправил в друзья
where initiator_user_id = 1
	and status = 'approved';


-- список медиафайлов с количеством лайков

select 
	count(*) as likes_count,
	m.filename,
	mt.name
from media m
join media_types mt on mt.id = m.media_type_id
join likes l on m.id = l.media_id
join users u on u.id = m.user_id
where u.id = 1
group by m.id

-- колшичество групп пользователя

select
	firstname, lastname,
	count(*) as 'groups count'
from users as u 
join users_communities uc on u.id = uc.user_id
group by u.id
order by count(*) desc;

-- среднее количество групп у всех пользователей

select
	avg(groups_count)
from (
	select
		firstname, lastname,
		count(*) as groups_count
	from users as u 
	join users_communities uc on u.id = uc.user_id
	group by u.id
	order by count(*) desc
) as list;


-- 3 пользователей у который самое большое количество лайков

select 
	firstname, lastname,
	m.filename,
	count(*) as likes_count
from media m
	join likes l on m.id = l.media_id
	join users u on u.id = m.user_id
group by m.id
order by likes_count desc
limit 3


-- в каком сообществе сколько пользователей

select
	c.name,
	count(*)
from users u 
join users_communities uc on u.id = uc.user_id
join communities c on uc.community_id = c.id
group by c.id;


-- из всех друзей найти того кто больше всех с ним общался

select
	from_user_id,
	concat(u.firstname, ' ', u.lastname) as name,
	count(*) as 'messages count'
from messages m
join users u on u.id = m.from_user_id
where to_user_id = 1
group by from_user_id
order by count(*) desc
limit 1;

-- подсчитать общее количество лайков 10 самых молодых пользователей
select count(*)
from likes
where media_id in (
	select id 
	from media 
	where user_id in (
		select
			user_id
		from profiles as p
		where year(curdate()) - year(birthday) < 10
)
);

-- кто больше поставил лайков м или ж

select
	gender,
	count(*)
from (
	select	
		user_id as user,
		(
			select gender
			from vk.profiles
			where user_id = user
		) as gender
	from likes
) as dummy
group by gender;








































