select * 
from (
	select artist_name, 
		main_genre, 
		first_played_month,
		min_streamed_total,
		min_streamed_in_month,
		hr_streamed_total,
		hr_streamed_in_month,
		ROW_NUMBER() OVER (PARTITION BY (first_played_month) ORDER BY min_streamed_in_month DESC) row_count
	from new_artists_streamed_monthly nasm 
	) a
where row_count =1

select * 
from (
	select album_name, 
		artist_name,
		main_genre,
		first_played_month, 
		min_played ,
		ROW_NUMBER() OVER (PARTITION BY (first_played_month) ORDER BY min_played DESC) row_count
	from main.new_albums_streamed_monthly nasm 
	) a
where row_count =1


SELECT * FROM streams s WHERE artist_name = 'TOOL' ORDER BY played_at limit 10