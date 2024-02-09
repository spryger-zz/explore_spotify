

DROP VIEW IF EXISTS main.artists_genre_view;
CREATE VIEW main.artists_genre_view AS
SELECT ar.*,
	CASE WHEN g1.main_genre IS NOT NULL THEN g1.main_genre ELSE NULL END AS main_genre_1,
	CASE WHEN g2.main_genre IS NOT NULL THEN g2.main_genre ELSE NULL END AS main_genre_2,
	CASE WHEN g3.main_genre IS NOT NULL THEN g3.main_genre ELSE NULL END AS main_genre_3,
	CASE WHEN g4.main_genre IS NOT NULL THEN g4.main_genre ELSE NULL END AS main_genre_4,
	CASE WHEN g5.main_genre IS NOT NULL THEN g5.main_genre ELSE NULL END AS main_genre_5
FROM main.artists ar
LEFT JOIN builder.genres g1
	ON ar.genre_1 = g1.raw_genre 
LEFT JOIN builder.genres g2
	ON ar.genre_2 = g2.raw_genre 
LEFT JOIN builder.genres g3
	ON ar.genre_3 = g3.raw_genre 
LEFT JOIN builder.genres g4
	ON ar.genre_4 = g4.raw_genre 
LEFT JOIN builder.genres g5
	ON ar.genre_5 = g5.raw_genre;
	
	
SELECT * FROM main.artists_genres


INSERT INTO builder.genres(raw_genre,main_genre)
VALUES ('atlanta bass','Hip Hop')

UPDATE builder.genres
SET main_genre = 'Hip Hop'
WHERE raw_genre = 'miami bass'