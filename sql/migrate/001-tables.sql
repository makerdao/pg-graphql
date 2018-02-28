/* DROP SCHEMA IF EXISTS private CASCADE; */
/* DROP SCHEMA IF EXISTS public CASCADE; */

CREATE SCHEMA IF NOT EXISTS private;
CREATE SCHEMA IF NOT EXISTS public;

CREATE TYPE public.act AS enum (
  'open',
  'join',
  'exit',
  'lock',
  'free',
  'draw',
  'wipe',
  'shut',
  'bite'
);

CREATE TABLE public.block (
  n     integer primary key,
  time  timestamptz not null,
  pip   decimal,
  pep   decimal
);

CREATE TABLE private.cup_action (
  id         integer,
  tx         character varying(66) UNIQUE not null,
  act        public.act  not null,
  arg        character varying(66),
  lad        character varying(66) not null,
  ink        decimal not null default 0,
  art        decimal not null default 0,
  ire        decimal not null default 0,
  block      integer not null
);

CREATE INDEX cup_action_id_index ON private.cup_action(id);
CREATE INDEX cup_action_block_index ON private.cup_action(block);
CREATE INDEX cup_action_tx_index ON private.cup_action(tx);
