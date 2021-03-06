-- 1. Show the lastName, party and votes for the constituency 'S14000024' in 2017.

SELECT lastName, party, votes
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC

-- 2. Who won? You can use the RANK function to see the order of the candidates. If you RANK using (ORDER BY votes DESC) then the candidate with the most votes has rank 1.

Show the party and RANK for constituency S14000024 in 2017. List the output by party
select party, votes, rank() over(order by votes desc) 
from ge where constituency='S14000024' and yr=2017
order by party

-- 3. PARTITION BY. The 2015 election is a different PARTITION to the 2017 election. We only care about the order of votes for each year. Use PARTITION to show the ranking of each party in S14000021 in each year. Include yr, party, votes and ranking (the party with the most votes is 1).

select yr, party, votes, rank() over(partition by yr order by votes desc ) 
from ge
where constituency='S14000021' 
order by party, yr

-- 4. Edinburgh Constituency. Edinburgh constituencies are numbered S14000021 to S14000026.

Use PARTITION BY constituency to show the ranking of each party in Edinburgh in 2017. Order your results so the winners are shown first, then ordered by constituency.
SELECT constituency,party, votes,
rank() over(partition by constituency order by votes desc) rank
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017
ORDER BY rank, constituency

-- 5. Winners Only
You can use SELECT within SELECT to pick out only the winners in Edinburgh. Show the parties that won for each Edinburgh constituency in 2017.

select constituency,party from 
(SELECT constituency,party, votes, 
rank() over (partition by constituency order by votes desc) rank
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017 
ORDER BY constituency,votes DESC) x
where x.rank = 1

-- 6. Scottish seats. You can use COUNT and GROUP BY to see how each party did in Scotland. Scottish constituencies start with 'S'. Show how many seats for each party in Scotland in 2017.

select party, count(*) 
from 
    (select constituency,party from 
        (SELECT constituency,party, votes, 
          rank() over (partition by constituency order by votes desc) rank
            FROM ge
           WHERE LEFT(constituency, 1)='S'
             AND yr  = 2017 
          ORDER BY constituency,votes DESC) x
    where x.rank = 1) y
group by party


