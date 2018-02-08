INSERT INTO cups (
  id,
  lad,
  ink,
  art,
  ire,
  block,
  timestamp,
  tx_hash,
  action
)
VALUES (
  ${cup.id},
  ${cup.lad},
  ${cup.ink},
  ${cup.art},
  ${cup.ire},
  ${cup.block},
  to_timestamp(${cup.timestamp}),
  ${cup.txHash},
  ${cup.action}
)
ON CONFLICT (
  tx_hash
)
DO NOTHING
