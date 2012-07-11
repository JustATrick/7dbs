CREATE OR REPLACE FUNCTION top_5_search(term text) RETURNS SETOF movies AS $$
DECLARE
  matched text;
  type char(1);
BEGIN
  SELECT
      m, t
      INTO matched, type
  FROM (
    SELECT
        title AS m,
        'M' AS t
      FROM movies
      WHERE to_tsvector('english', title) @@ plainto_tsquery('english', term)
    UNION
    SELECT
        name AS m,
        'A' AS t
      FROM actors
      WHERE metaphone(name, 8) % metaphone(term, 8)
  ) AS candidates
  ORDER BY levenshtein(lower(m), lower(term))
  LIMIT 1;

  CASE
    WHEN type = 'M' THEN
      RETURN QUERY
        SELECT candidates.*
          FROM movies m
          JOIN movies candidates
            ON (cube_enlarge(m.genre, 5, 18) @> candidates.genre)
          WHERE m.title = matched
          ORDER BY cube_distance(m.genre, candidates.genre)
          LIMIT 5;
    WHEN type = 'A' THEN
      RETURN QUERY
        SELECT movies.*
          FROM movies
          NATURAL JOIN movies_actors
          NATURAL JOIN actors
          WHERE name = matched
          ORDER BY title
          LIMIT 5;
    ELSE
      RETURN QUERY
        SELECT * FROM movies WHERE false;
  END CASE;

  RETURN;
END
$$ LANGUAGE plpgsql;
