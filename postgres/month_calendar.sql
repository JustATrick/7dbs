SELECT * FROM crosstab(
'
SELECT
    date_trunc(''week'', day) AS week,
    (extract(dow FROM day)::int + 6) % 7 AS day,
    NULLIF(COUNT(events.*),0)
  FROM (
    SELECT generate_series(first_of_month, first_of_month + ''1 month''::interval - ''1 day''::interval, ''1 day'') FROM (VALUES(''2012-02-01''::timestamp)) AS month(first_of_month)
  ) AS month_of_days(day)
  LEFT JOIN events ON (starts >= day AND starts < day + ''1 day'')
  GROUP BY week, day
  ORDER BY week, day
',
'SELECT * FROM generate_series(0,6)'
) AS (
  week date, Mon int, Tue int, Wed int, Thu int, Fri int, Sat int, Sun int
);
