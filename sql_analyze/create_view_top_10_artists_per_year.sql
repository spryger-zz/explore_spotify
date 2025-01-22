
--DROP VIEW main.view_top_10_artists_5_years;
CREATE OR REPLACE VIEW main.view_top_10_artists_per_year AS
SELECT *
FROM (
	SELECT artist_id,
			artist_name,
			played_year,
			duration_hr,
			ROW_NUMBER() OVER(PARTITION BY played_year ORDER BY duration_hr DESC) AS RowNumber
	FROM (
		SELECT artist_id,
			artist_name,
			played_year,
			SUM(duration_hr) AS duration_hr
		FROM main.view_basic_stream_data
		WHERE played_year > '2020-01-01'
		GROUP BY artist_id,
			artist_name,
			played_year
		)
	)
	WHERE RowNumber <= 10