
--DROP VIEW main.view_top_10_artists_5_years;
CREATE OR REPLACE VIEW main.view_top_10_artists_by_year AS
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY played_year ORDER BY yearly_duration DESC) AS yearly_artist_rank
FROM (
	SELECT bsd.artist_id,
		bsd.artist_name,
		bsd.played_year,
		top_ten.total_artist_rank,
		SUM(bsd.duration_hr) AS yearly_duration
	FROM (
		SELECT artist_id,
			total_duration,
			ROW_NUMBER() OVER(ORDER BY total_duration DESC) AS total_artist_rank
		FROM (
			SELECT artist_id,
				SUM(duration_hr) AS total_duration
			FROM main.view_basic_stream_data
			WHERE played_year > '2020-01-01'
				AND artist_name not like '%White Noise%'
			GROUP BY artist_id
			)
		) top_ten
	INNER JOIN main.view_basic_stream_data bsd
		ON bsd.artist_id = top_ten.artist_id
	WHERE total_artist_rank <= 7
	GROUP BY bsd.artist_id,
		bsd.artist_name,
		bsd.played_year,
		top_ten.total_artist_rank
	)