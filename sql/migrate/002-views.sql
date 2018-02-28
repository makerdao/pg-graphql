DROP VIEW public.cup_act, public.cup CASCADE;

CREATE VIEW public.cup_act AS
  SELECT
    act,
    arg,
    art,
    block,
    id,
    ink,
    ire,
    lad,
    pip,
    (pip * ink) / NULLIF(art,0) * 100 AS ratio,
    (pip * ink) AS tab,
    time,
    tx
  FROM private.cup_action
  LEFT JOIN block on block.n = private.cup_action.block
  ORDER BY block DESC;

comment on view cup_act is 'A CDP action';
comment on column cup_act.act is 'The action name';
comment on column cup_act.arg is 'Data associated with the act';
comment on column cup_act.art is 'Outstanding debt at block';
comment on column cup_act.block is 'Tx block number';
comment on column cup_act.id is 'The Cup ID';
comment on column cup_act.ink is 'Locked collateral at block';
comment on column cup_act.ire is 'Outstanding debt including fee at block';
comment on column cup_act.lad is 'The Cup owner';
comment on column cup_act.pip is 'USD/ETH price at block';
comment on column cup_act.ratio is 'Collateralization ratio at block';
comment on column cup_act.tab is 'USD value of locked collateral at block';
comment on column cup_act.time is 'Tx timestamp';
comment on column cup_act.tx is 'Transaction hash';

CREATE VIEW public.cup AS
  SELECT
    act,
    arg,
    art,
    block,
    id,
    ink,
    ire,
    lad,
    pip,
    (pip * ink) / NULLIF(art,0) * 100 AS ratio,
    (pip * ink) AS tab,
    time
  FROM (
    SELECT DISTINCT ON (cup_action.id)
      act,
      arg,
      art,
      block,
      id,
      ink,
      ire,
      lad,
      (SELECT pip FROM block ORDER BY n DESC LIMIT 1),
      (SELECT time FROM block WHERE block.n = cup_action.id)
    FROM private.cup_action
    ORDER BY private.cup_action.id DESC
  )
c;

comment on view cup is 'A CDP record';
comment on column cup.act is 'The most recent act';
comment on column cup.arg is 'Data associated with the most recent act';
comment on column cup.art is 'Outstanding debt';
comment on column cup.block is 'Block number at last update';
comment on column cup.id is 'The Cup ID';
comment on column cup.ink is 'Locked collateral';
comment on column cup.ire is 'Outstanding debt including fee';
comment on column cup.lad is 'The Cup owner';
comment on column cup.pip is 'USD/ETH price';
comment on column cup.ratio is 'Collateralization ratio';
comment on column cup.tab is 'USD value of locked collateral';
comment on column cup.time is 'Timestamp at last update';
