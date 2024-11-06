use database ubioworo;

use schema curated_schema;


 show  tables;


// creat stteeam on the table 

create or replace stream  curated_stream_table on table "CURATED_CITY_BIKE_TABLE"
append_only=True
;

// select from the stream

select * from curated_stream_table;