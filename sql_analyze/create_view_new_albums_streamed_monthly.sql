CREATE VIEW new_albums_streamed_monthly AS
 WITH first_album_played_month AS (
         SELECT view_basic_stream_data.album_id,
            min(view_basic_stream_data.played_month) AS first_played_month,
            sum(view_basic_stream_data.duration_min) AS min_streamed_total,
            sum(view_basic_stream_data.duration_hr) AS hr_streamed_total
           FROM view_basic_stream_data
          GROUP BY view_basic_stream_data.album_id
        )
 SELECT data_table.album_name,
 	data_table.artist_name,
    data_table.main_genre,
    agg_table.first_played_month,
    round(agg_table.min_streamed_total, 2) AS min_streamed_total,
    round(sum(data_table.duration_min), 2) AS min_streamed_in_month,
    round(agg_table.hr_streamed_total, 2) AS hr_streamed_total,
    round(sum(data_table.duration_hr), 2) AS hr_streamed_in_month
   FROM first_album_played_month agg_table
     JOIN view_basic_stream_data data_table ON agg_table.album_id = data_table.album_id AND agg_table.first_played_month = data_table.played_month
  GROUP BY data_table.album_name, data_table.artist_name, data_table.main_genre, agg_table.first_played_month, agg_table.min_streamed_total, agg_table.hr_streamed_total
  ORDER BY agg_table.first_played_month, sum(data_table.duration_min) DESC;