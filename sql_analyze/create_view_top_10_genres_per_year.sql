
--DROP VIEW main.view_top_10_artists_5_years;
CREATE OR REPLACE VIEW main.view_top_10_genres_per_year AS
SELECT *
FROM (
	SELECT main_genre,
			played_year,
			duration_hr,
			ROW_NUMBER() OVER(PARTITION BY played_year ORDER BY duration_hr DESC) AS RowNumber
	FROM (
		SELECT main_genre,
			played_year,
			SUM(duration_hr) AS duration_hr
		FROM main.view_basic_stream_data
		WHERE main_genre is not null
		AND main_genre <> 'White Noise'
		GROUP BY main_genre,
			played_year
		)
	)
	WHERE RowNumber <= 10