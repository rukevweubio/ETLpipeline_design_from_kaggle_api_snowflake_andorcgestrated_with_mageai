 use ubioworo;

  select current_database(),current_warehouse(),current_schema();

  show tables;


  // create or select from city tbale 
  select * from  "CITY_BIKE_DATASET" limit 20;

  // create three 
  create or  replace  schema curated_schema;
  create or replace  schema consumption_schema;

  // create or replace stage, file format, pipe, stream
   create or replace file format my_city_bike_csv
   type ='csv'
   field_delimiter =','
   skip_header=1;

// create stage  for the landing 

create or replace stage my_city_bike_stage
file_format=(format_name=my_city_bike_csv);


// create or reeplace stream to captiure the table chnage 
create or replace stream landing_zone_stream on table "CITY_BIKE_DATASET";

// show the ddl
show streams;
show stages;

show file formats ;

select get_ddl('table','CITY_BIKE_DATASET');



CREATE OR REPLACE TABLE curated_schema.curated_city_bike_table AS
SELECT * FROM "CITY_BIKE_DATASET";


// create stream on the landing table 
select * from landing_zone_stream;


//How many trips were made during a specific time period?



//What are the most popular bike stations for start and end locations?

select  "start_station_name" as station, count(*) as count
from 
    "CITY_BIKE_DATASET"
group by station
order by count desc limi 10;

////What are the most popular bike stations for locations?
select  "end_station_name" as station, count(*) as count
from 
    "CITY_BIKE_DATASET"
group by station
order by count desc limit 10;

// avearge duration of trip 

select  
    avg("trip_duration") as trip_duration 
from    
    "CITY_BIKE_DATASET";


//trip duration rnage 
SELECT
  CASE
    WHEN "trip_duration" < 100 THEN '0-20 minutes'
    WHEN "trip_duration" >= 100 AND "trip_duration" < 500 THEN '5-10 minutes'
    WHEN "trip_duration" >= 500 AND "trip_duration" < 1000 THEN '10-20 minutes'
    ELSE '20+ minutes'
  END AS duration_range,
  COUNT(*) AS trip_count
FROM "CITY_BIKE_DATASET"
GROUP BY duration_range
ORDER BY duration_range;

 
//Which times of the day are the most popular for bike trips?

select 
    DATE_PART(HOUR, TO_TIMESTAMP("start_time")) as hour_of_day,
    count(*) as count
from    
    "CITY_BIKE_DATASET"
group by 
    hour_of_day
ORDER BY 
    count desc ;

// are the bike used frequenly on weekdaya or weekend 
SELECT 
  CASE
    WHEN EXTRACT(DOW FROM to_timestamp("start_time") ) IN (0, 6) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  COUNT(*) AS total_trips
FROM "CITY_BIKE_DATASET"
GROUP BY day_type
ORDER BY day_type;

// what is the distribution of the uswr type 
select
    "user_type" as customer,
    count(*)
from   
    "CITY_BIKE_DATASET"
group by customer
order by count(*);
// How do subscribers and customers differ in terms of trip duration?

select  
    avg("trip_duration") as total_trip_duration,
    ("user_type") as custmer_type
from    
    "CITY_BIKE_DATASET"
group by custmer_type
order  by total_trip_duration desc;

// busy bike  start station
SELECT "start_station_name", COUNT(*) AS start_count
FROM "CITY_BIKE_DATASET"
GROUP BY "start_station_name"
ORDER BY start_count DESC
LIMIT 5;
// busy end station
SELECT "end_station_name", COUNT(*) AS end_count
FROM "CITY_BIKE_DATASET"
GROUP BY "end_station_name"
ORDER BY end_count DESC
LIMIT 5;
// bike used the most 
 select 
    "bike_id" as bike_id ,"start_station_name" as station_name,
    count(*) as count
from 
    "CITY_BIKE_DATASET"
GROUP BY bike_id, station_name
ORDER BY COUNT DESC limit 10