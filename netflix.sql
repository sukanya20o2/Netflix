USE NETFLIX;
select * from netflix;

----- retrive all movies
select * from netflix where type = 'movie';
select * from netflix where type = 'TV Show';
select * from netflix where type = "movie"&"TV show";
--------- TV show released in 2021
select title,release_year 
from netflix where type = 'tv show' and  release_year = '2021';
--------- movies directed by  theodore melfi
select title,director 
from netflix
where type = 'movie' and director = 'kirsten jhonson';
---------- count no of tv shows from us
select count(*) from  netflix 
where type = 'TV show' and country = 'united states';
---------- getting all the movies with pg- 13 rating
select title from netflix 
where type= 'movie' and rating ='PG-13';
---------- Directore who dirctoed more than 3 movies
select director from netflix
where type = 'movie' and director is not null
group by director
having count(*) < 3;
---------- no of movies and tv shows released per year
select release_year,
sum(case when type = 'movie' then 1 else 0 end ) as movie_count,
sum(case when type = 'tv show' then 1 else 0 end ) as tv_count_show
from netflix
group by release_year
order by release_year;
-------- compare release years of consecutive title
select title, release_year,
lag(release_year,1) over ( order by release_year ) as previous_year,
lead(release_year ,1) over(order by release_year) as next_year
from netflix
order by release_year;
--------- top 5 titles with more cast members
select title,length(cast)-length(replace(cast,' ','')) + 1 as cast_count
from netflix
where cast is not null
order by cast_count desc 
limit 5 
offset 4;
--------- Find the most common genre combinations
select listed_in ,count(*) as count
from netflix
group by listed_in
order by count desc;
--- longest running tv show
select title,cast(substring(duration,1,instr(duration,' ') -1) as INT) as seasons
from netflix
where type = 'tv show'
order by seasons desc
limit 5;
--- select  a sequence of release years up to  with current year
with recursive cte as(
select min(release_year)  as year from netflix
union all
select year + 1 from cte 
where year < extract(year from current_date)
)
select year from cte;

----------- rank the title based on the release_year and rating
select title,release_year,rating,
rank() over (partition by rating order by release_year desc) as rank_1
from netflix
where rating is not null
order by rating,rank_1;
-------- top 5 countries with most shows
with cte as(
select country,
count(*) as show_count
from netflix
where country is not null
group by  country
)
select 
show_count,country
from cte
order by show_count desc 
limit 5;
--------- movies based on their duration
select title,
duration,
case
when duration like '%min' and cast(substring(duration, 1 , len(duration) -4) as int) < 90 then 'short movie'
when duration like '%min' and cast(substring(duration, 1 , len(duration) -4) as int) BETWEEN 90 AND 120 then 'average movie'
else'long movie'
end as movie_length
from netflix
where type = 'movie';
---------- commulative count of title added by year
with cte as(
select release_year,
count(*) as year_count
from netflix
group by release_year
order by release_year
)
select release_year,
year_count,
sum(year_count) over (order by release_year asc ) as commulative_count
from cte;

------------- top 5 directors with more title
select director, count(*) as count_title
from netflix
where director is not null
group by director
order by count_title desc
limit 5;

------------- list the title release after 2015 sorted by year
select title,release_year
from netflix
where release_year > 2015
order by release_year;

------ title by country and listed in
select country,listed_in,count(*) as total_titles
from netflix
where country is not null
group by country,listed_in
order by total_titles desc;
--------- count movies vs shows
select type,count(*) as count_total
from netflix
group by type;
-------- earliest and latest release year
select min(release_year) as earliest_year,max(release_year) as latest_year
from netflix;


