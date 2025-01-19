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
SELECT 'Count Streams' AS metric_name,
	CAST(COUNT(*) as varchar) AS metric_value
FROM staging.staging_streams