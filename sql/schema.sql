DROP TABLE IF EXISTS cup_actions, pips, peps, pars CASCADE;

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

CREATE TABLE pips (
  block bigint unique not null,
  time  timestamptz not null,
  val   character varying(66)
);

CREATE TABLE peps (
  block bigint unique not null,
  time  timestamptz not null,
  val   character varying(66)
);

CREATE TABLE pars (
  block bigint unique not null,
  time  timestamptz not null,
  val   character varying(66)
);

CREATE VIEW cups AS
  SELECT * FROM (
    SELECT DISTINCT ON (id) id, tx, act, arg, lad, ink, art, ire, block, time, cup_pip(block) AS pip
    FROM cup_actions
    ORDER BY id DESC
  ) t;

CREATE OR REPLACE FUNCTION cup_pip(blk bigint) RETURNS text
AS $$ SELECT val FROM pips WHERE pips.block <= $1 ORDER BY block DESC LIMIT 1;
$$  LANGUAGE SQL;

CREATE OR REPLACE FUNCTION cup_pep(blk bigint) RETURNS text
AS $$ SELECT val FROM peps WHERE peps.block <= $1 ORDER BY block DESC LIMIT 1;
$$  LANGUAGE SQL;

CREATE OR REPLACE FUNCTION cup_par(blk bigint) RETURNS text
AS $$ SELECT val FROM pars WHERE pars.block <= $1 ORDER BY block DESC LIMIT 1;
$$  LANGUAGE SQL;
