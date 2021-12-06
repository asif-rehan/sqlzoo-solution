-- 1. How many stops are in the database.

select count(*) from stops

-- 2. Find the id value for the stop 'Craiglockhart'

select id from stops where name='Craiglockhart'

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

select stops.id, stops.name from 
(select * from route where num='4' ) x
join stops on stops.id=x.stop

-- 4. Routes and stops. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
having count(*) >=2

-- 5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 and b.stop=149

-- 6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' and stopb.name='London Road'

-- 7. Using a self join. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

select distinct a.company, a.num
from  (select * from route join stops on stops.id=route.stop where stops.name='Haymarket') a 
join  (select * from route join stops on stops.id=route.stop where stops.name='Leith') b 
on  a.company=b.company and a.num=b.num

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

select x.company, x.num
from (select * from (select * from stops where stops.name='Craiglockhart') a join route r1 on a.id=r1.stop ) x
join (select * from (select * from stops where stops.name='Tollcross') b join route r2 on b.id=r2.stop ) y
on x.num=y.num and x.company=y.company

-- 9.
Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

select y.name, y.company, y.num
from (select * from (select * from stops where stops.name='Craiglockhart') s1 join (select * from route where route.company='LRT') r1 on s1.id=r1.stop) x
join (select * from stops s2 join route r2 on s2.id=r2.stop) y
on x.company=y.company and x.num=y.num

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.
-- Hint: Self-join twice to find buses that visit Craiglockhart and Lochend, then join those on matching stops

select leg1.num, leg1.company, leg2.name, leg2.num, leg2.company from 
    (select x.num, x.company, r3.name, r3.stop stop from  
        (select * from 
            (select * from stops where stops.name='Craiglockhart') s1 
            join 
            route r1 on r1.stop=s1.id) x 
        join 
            route r3
        on r3.company=x.company and r3.num=x.num) leg1
join 
      (select y.num, y.company, r4.name, r4.stop stop from  
              (select * from (select * from stops where stops.name='Lockend') s2 
               join 
               route r2 on r2.stop=s2.id) y 
         join 
            route r4
          on r4.company=y.company and r4.num=y.num) leg2
on leg1.stop=leg2.stop 
