CREATE TABLE IF NOT EXISTS streams (
	id SERIAL PRIMARY KEY,
	track_id VARCHAR NOT NULL,
	track_name VARCHAR,
	duration_ms INT8,
	played_at TIMESTAMP NOT NULL,
	context VARCHAR
);

ALTER TABLE streams
ADD CONSTRAINT streams_track_fkey FOREIGN KEY (track_id) REFERENCES tracks (id)