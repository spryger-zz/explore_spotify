--SELECT * FROM main.view_basic_stream_data limit 10

SELECT 'Newest Stream' AS metric_name,
	CAST(MAX(played_at) as varchar) AS metric_value
FROM main.view_basic_stream_data
UNION
SELECT 'Oldest Stream' AS metric_name,
	CAST(MIN(played_at) as varchar) AS metric_value
FROM main.view_basic_stream_data
UNION
SELECT 'Count Streams' AS metric_name,
	CAST(COUNT(*) as varchar) AS metric_value
FROM main.view_basic_stream_data



SELECT 'Newest Stream' AS metric_name,
	CAST(MAX(played_at) as varchar) AS metric_value
FROM staging.staging_streams
UNION
SELECT 'Oldest Stream' AS metric_name,
	CAST(MIN(played_at) as varchar) AS metric_value
FROM staging.staging_streams
UNION
SELECT 'Count Raw Streams Table' AS metric_name,
	CAST(COUNT(*) as varchar) AS metric_value
FROM staging.raw_streams
UNION
SELECT 'Count Streams Table' AS metric_name,
	CAST(COUNT(*) as varchar) AS metric_value
FROM staging.staging_streams
UNION
SELECT 'Count Streams Table Tracks' AS metric_name,
	CAST(COUNT(DISTINCT track_id) as varchar) AS metric_value
FROM staging.staging_streams
UNION
SELECT 'Count Tracks Table' AS metric_name,
	CAST(COUNT(*) as varchar) AS metric_value
FROM staging.staging_tracks
UNION
SELECT 'Count Albums Table' AS metric_name,
	CAST(COUNT(*) as varchar) AS metric_value
FROM staging.staging_albums
UNION
SELECT 'Count Artists Table' AS metric_name,
	CAST(COUNT(*) as varchar) AS metric_value
FROM staging.staging_artists