INSERT INTO cups (
  id,
  lad,
  block,
  timestamp,
  tx_hash,
  action,
  state
)
VALUES (
  ${cup.id},
  ${cup.lad},
  ${cup.block},
  to_timestamp(${cup.timestamp}),
  ${cup.txHash},
  ${cup.action},
  ${cup.state}
)
ON CONFLICT (
  tx_hash
)
DO NOTHING
