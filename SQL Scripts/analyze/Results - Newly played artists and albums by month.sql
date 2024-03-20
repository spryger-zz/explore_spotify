select * from (
select artist_name, first_played_month, ms_played ,
ROW_NUMBER() OVER (PARTITION BY (first_played_month) ORDER BY ms_played DESC) row_count
from new_artists_streamed_monthly nasm 
) a
where row_count =1

select * from (
select album_name, first_played_month, ms_played ,
ROW_NUMBER() OVER (PARTITION BY (first_played_month) ORDER BY ms_played DESC) row_count
from new_albums_streamed_monthly nasm 
) a
where row_count =1

