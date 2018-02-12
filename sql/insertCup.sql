INSERT INTO cup_actions (
  id,
  lad,
  ink,
  art,
  ire,
  block,
  time,
  tx,
  act,
  arg
)
VALUES (
  ${cup.id},
  ${cup.lad},
  ${cup.ink},
  ${cup.art},
  ${cup.ire},
  ${cup.block},
  to_timestamp(${cup.time}),
  ${cup.tx},
  ${cup.act},
  ${cup.arg}
)
ON CONFLICT (
  tx
)
DO NOTHING
