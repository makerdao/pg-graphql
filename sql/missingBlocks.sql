SELECT s.i AS _n
FROM generate_series(${from},${to}) s(i)
WHERE NOT EXISTS (
  SELECT 1 FROM block WHERE n = s.i
)
