INSERT INTO blocks (
  n,
  time
)
VALUES (
  ${n},
  to_timestamp(${time})
)
ON CONFLICT (
  n
)
DO NOTHING
