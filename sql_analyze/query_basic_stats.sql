--SELECT * FROM main.view_basic_stream_data limit 10

SELECT 'Newest Stream' AS metric_name,
	MAX(played_at) AS metric_value
FROM main.view_basic_stream_data
UNION
SELECT 'Oldest Stream' AS metric_name,
	MIN(played_at) AS metric_value
FROM main.view_basic_stream_data