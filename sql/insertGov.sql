INSERT INTO gov (
  block,
  tx,
  var,
  arg,
  guy,
  cap,
  mat,
  tax,
  fee,
  axe,
  gap
)
VALUES (
  ${block},
  ${tx},
  ${var},
  ${arg},
  ${guy},
  ${cap},
  ${mat},
  ${tax},
  ${fee},
  ${axe},
  ${gap}
)
ON CONFLICT (tx)
DO NOTHING
