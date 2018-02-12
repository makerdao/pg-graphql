DROP TABLE IF EXISTS cup_actions;
DROP VIEW IF EXISTS cups;

CREATE TABLE cup_actions (
  id    bigint not null,
  tx    character varying(66) unique not null,
  act   character varying(4)  not null,
  arg   character varying(66),
  lad   character varying(66) not null,
  ink   character varying(66) not null default 0,
  art   character varying(66) not null default 0,
  ire   character varying(66) not null default 0,
  block bigint not null,
  time  timestamptz not null
);

CREATE VIEW cups AS
  SELECT * FROM (
    SELECT DISTINCT ON (id) *
    FROM cup_actions
    ORDER BY id DESC
  ) t
