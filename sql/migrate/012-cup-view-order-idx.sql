CREATE OR REPLACE VIEW public.cup AS
  SELECT
    act,
    art,
    block,
    deleted,
    id,
    idx,
    guy,
    ink,
    ire,
    lad,
    pip,
    per,
    (pip * per * ink) / NULLIF(art,0) * 100 AS ratio,
    (pip * per * ink) AS tab,
    time
  FROM (
    SELECT DISTINCT ON (cup_action.id)
      act,
      art,
      block,
      deleted,
      id,
      idx,
      guy,
      ink,
      ire,
      lad,
      (SELECT pip FROM block ORDER BY n DESC LIMIT 1),
      (SELECt per FROM block ORDER BY n DESC LIMIT 1) AS per,
      (SELECT time FROM block WHERE block.n = private.cup_action.block)
    FROM private.cup_action
    ORDER BY private.cup_action.id DESC, private.cup_action.block DESC, private.cup_action.idx DESC
  )
c;

comment on view cup is 'A CDP record';
comment on column cup.act is 'The most recent act';
comment on column cup.art is 'Outstanding debt DAI';
comment on column cup.block is 'Block number at last update';
comment on column cup_act.deleted is 'True if the cup has been deleted (shut)';
comment on column cup.id is 'The Cup ID';
comment on column cup.guy is 'msg.sender';
comment on column cup.ink is 'Locked collateral PETH';
comment on column cup.idx is 'Transaction index';
comment on column cup.ire is 'Outstanding debt DAI after fee';
comment on column cup.lad is 'The Cup owner';
comment on column cup.pip is 'USD/ETH price';
comment on column cup_act.per is 'ETH/PETH price';
comment on column cup.ratio is 'Collateralization ratio';
comment on column cup.tab is 'Deprecated';
comment on column cup.time is 'Timestamp at last update';
