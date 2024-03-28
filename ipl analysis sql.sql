create database ipl;
use ipl;
select * from deliveries;
select * from matches;


-- 1 WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?
select player_of_match,count(*) as total_awards from matches
group by player_of_match
order by total_awards desc
limit 5;

-- 2 HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?
select  season,winner as team,count(*) as no_of_match_won from matches
group by winner,season
order by no_of_match_won,season desc;

 -- 3  WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?
 select avg(strike_rate) as average_strike_rate from (
 select batsman,(sum(batsman_runs)/count(ball))*100 as strike_rate
 from deliveries group by batsman ) as batsman_stats;
 
 -- 4  WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTINGSECOND 
select batting_first,count(*) as matches_won
from( select
case when win_by_runs>0 then team1
else team2 end as batting_first  from matches  where winner!='tie') as batting_first_teams
group by batting_first;

-- 5 WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?
select max(strike_rate)  as maximium_strike_rate from (
select batsman,(sum(batsman_runs)/count(ball))*100 as strike_rate from deliveries
group by batsman
having sum(batsman_runs)>200
) as batsman_stats;

-- 6 HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?
select batsman,count(*) as dismissle_by_malinga from deliveries
 where bowler='malinga' 
 group by batsman;

 -- 7 WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN?
SELECT batsman, AVG((fours + sixes) / total_balls_faced * 100) AS average_percentage_boundaries
FROM (
    SELECT batsman, 
           SUM(CASE WHEN total_runs = 4 THEN 1 ELSE 0 END) AS fours,
           SUM(CASE WHEN total_runs = 6 THEN 1 ELSE 0 END) AS sixes,
           COUNT(ball) AS total_balls_faced
    FROM deliveries
    GROUP BY batsman
) AS batsman_stats
GROUP BY batsman; 

-- 8 WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
select season,batting_team,avg(fours+sixes) as avergae_of_boundaries from 
(
select season,batting_team,
      sum(case when total_runs= 4 then 1 else 0 end) as fours,
      sum(case when total_runs+ 6 then 1 else 0 end) as sixes
       from matches inner join deliveries  on matches.id=deliveries.match_id 
      group by season,batting_team,matches.id) as bound
      group by season,batting_team;
      
-- 9  WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?
select season,batting_team,max(totals) as max_runs  from (
select season,batting_team,sum(total_runs) as totals from deliveries inner join matches on matches.id=deliveries.match_id
group by season,batting_team) as parterns
group by season,batting_team
order by max_runs,season desc;

-- 10  HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?
select bowling_team,match_id as match_number,sum(extra_runs) as extras from deliveries
group by bowling_team,match_id;

-- 11  WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH?
SELECT match_id, bowler, COUNT(*) AS wickets_taken
FROM deliveries
WHERE dismissal_kind IN ('bowled', 'caught', 'caught and bowled', 'lbw', 'stumped')
GROUP BY match_id, bowler
ORDER BY wickets_taken DESC
limit 1;


-- 12 HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
select city,winner,count(*) as match_won from matches
group by city,winner
order by match_won desc;

--  13 HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?
 select season, toss_winner,count(*) as no_of_times from matches
group by season,toss_winner
order by season,no_of_times desc;

-- 14  HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?
select player_of_match,count(*) as no_of_times from matches
group by player_of_match
order by no_of_times desc;

-- 15  WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?
select match_id,inning,avg(total_runs) each_over from deliveries
group by match_id,inning;
 
-- 16 WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?
select batting_team,sum(total_runs) as total_score,match_id from deliveries
group by batting_team,match_id
order by total_score desc
limit 1;

-- 17 WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
select batsman,sum(total_runs) as most_runs,match_id from deliveries
group by batsman,match_id
order by most_runs desc 
limit  1;









