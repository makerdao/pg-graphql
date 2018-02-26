INSERT INTO private.cup_action (
  id,
  lad,
  ink,
  art,
  ire,
  block,
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
  ${cup.tx},
  ${cup.act},
  ${cup.arg}
)
ON CONFLICT (
  tx
)
DO NOTHING
