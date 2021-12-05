-- 7. Alien cast list. Obtain the cast list for the film 'Alien'

select name from actor
join 
(select actorid 
from casting 
join
(select id from movie where title='Alien') b
on b.id=casting.movieid) c
on c.actorid=actor.id


-- 8. Harrison Ford movies List the films in which 'Harrison Ford' has appeared

select title from movie
join 
(select movieid from casting 
join 
(select id from actor where name='Harrison Ford') name
on name.id=casting.actorid) c
on c.movieid=movie.id


-- 9. Harrison Ford as a supporting actor. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

select title from movie
join 
(select movieid from casting 
join 
(select id from actor where name='Harrison Ford') name
on name.id=casting.actorid
where ord!=1) c
on c.movieid=movie.id

-- 10. Lead actors in 1962 movies. List the films together with the leading star for all 1962 films.

select title, name
from movie
join casting on movie.id=casting.movieid
join actor on casting.actorid=actor.id
where casting.ord=1 and movie.yr=1962


-- 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN (select * from actor WHERE name='Rock Hudson') actor  ON actorid=actor.id

GROUP BY yr
HAVING COUNT(title) > 2


-- 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.

select title, name from 
movie join casting on movie.id=casting.movieid and ord=1
join actor on actor.id=casting.actorid
where casting.movieid in 
(
  SELECT movieid FROM casting
      WHERE actorid = (
          SELECT id FROM actor WHERE name='Julie Andrews')
)

--14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
select x.title, count(*)
from 
(select * from movie where yr=1978) as x
join casting on casting.movieid=x.id
group by x.title
order by count(*) desc, title

-- 15. List all the people who have worked with 'Art Garfunkel'.

select name from actor join 
(select * from casting where movieid in (
    select movieid from casting where actorid = (
            select id from actor where name='Art Garfunkel')
) ) y
on y.actorid=actor.id
where actor.name!='Art Garfunkel'
