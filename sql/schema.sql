DROP TABLE IF EXISTS cup_actions, blocks CASCADE;

CREATE TABLE cup_actions (
  id    bigint not null,
  tx    character varying(66) unique not null,
  act   character varying(4)  not null,
  arg   character varying(66),
  lad   character varying(66) not null,
  ink   character varying(66) not null default 0,
  art   character varying(66) not null default 0,
  ire   character varying(66) not null default 0,
  block bigint not null
);

CREATE INDEX cup_actions_block_index ON cup_actions(block);

CREATE TABLE blocks (
  n bigint unique not null,
  time  timestamptz not null,
  pip   character varying(66),
  pep   character varying(66)
);

CREATE INDEX block_n_index ON blocks(n);

CREATE VIEW cup_history AS
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
    (pip::dec * ink::dec) / NULLIF(art::dec,0) * 100 AS ratio,
    (pip::dec * ink::dec) AS tab,
    time,
    tx
  FROM cup_actions
  LEFT JOIN blocks on blocks.n = cup_actions.block
  ORDER BY block DESC;

CREATE VIEW cups AS
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
    (pip::dec * ink::dec) / NULLIF(art::dec,0) * 100 AS ratio,
    (pip::dec * ink::dec) AS tab,
    time,
    tx
  FROM (
    SELECT DISTINCT ON (id) *
    FROM cup_actions
    LEFT JOIN blocks on blocks.n = cup_actions.block
    ORDER BY id DESC
  ) t;
