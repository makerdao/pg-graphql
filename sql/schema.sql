--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3 (Ubuntu 10.3-1.pgdg14.04+1)
-- Dumped by pg_dump version 10.1

-- Started on 2018-04-27 01:47:39 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = private, pg_catalog;

DROP TRIGGER shut ON private.cup_action;
SET search_path = public, pg_catalog;

DROP INDEX public.gov_tx_index;
DROP INDEX public.gov_block_index;
DROP INDEX public.block_time_index;
SET search_path = private, pg_catalog;

DROP INDEX private.cup_action_tx_index;
DROP INDEX private.cup_action_tx_act_arg_idx;
DROP INDEX private.cup_action_id_index;
DROP INDEX private.cup_action_deleted_index;
DROP INDEX private.cup_action_block_index;
DROP INDEX private.cup_action_act_index;
SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.gov DROP CONSTRAINT gov_tx_key;
ALTER TABLE ONLY public.block DROP CONSTRAINT block_pkey;
DROP TABLE public.gov;
DROP FUNCTION public.get_cup(id integer);
DROP FUNCTION public.exec_set_deleted();
DROP FUNCTION public.cup_history(cup cup, tick tick_interval);
DROP FUNCTION public.cup_actions(cup cup);
DROP VIEW public.cup_act;
DROP VIEW public.cup;
DROP TABLE public.block;
SET search_path = private, pg_catalog;

DROP TABLE private.cup_action;
SET search_path = public, pg_catalog;

DROP TYPE public.tick_interval;
DROP TYPE public.history_interval;
DROP TYPE public.get_history_interval;
DROP TYPE public.cup_state;
DROP TYPE public.act;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
DROP SCHEMA private;
--
-- TOC entry 7 (class 2615 OID 9594966)
-- Name: private; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA private;


--
-- TOC entry 8 (class 2615 OID 9594967)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 1 (class 3079 OID 13809)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 607 (class 1247 OID 9594969)
-- Name: act; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE act AS ENUM (
    'open',
    'join',
    'exit',
    'lock',
    'free',
    'draw',
    'wipe',
    'shut',
    'bite',
    'give'
);


--
-- TOC entry 604 (class 1247 OID 11372699)
-- Name: cup_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE cup_state AS (
	tick timestamp with time zone,
	min_pip numeric,
	max_pip numeric,
	min_tab numeric,
	max_tab numeric,
	min_ratio numeric,
	max_ratio numeric,
	act act,
	arg character varying,
	ink numeric,
	art numeric,
	"time" timestamp with time zone
);


--
-- TOC entry 519 (class 1247 OID 11372535)
-- Name: get_history_interval; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE get_history_interval AS (
	tick timestamp with time zone,
	min_pip numeric,
	max_pip numeric,
	min_tab numeric,
	max_tab numeric,
	min_ratio numeric,
	max_ratio numeric,
	act act,
	arg character varying,
	ink numeric,
	art numeric,
	"time" timestamp with time zone
);


--
-- TOC entry 516 (class 1247 OID 11372520)
-- Name: history_interval; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE history_interval AS ENUM (
    'minute',
    'hour',
    'day',
    'week',
    'month',
    'year'
);


--
-- TOC entry 601 (class 1247 OID 11372684)
-- Name: tick_interval; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE tick_interval AS ENUM (
    'minute',
    'hour',
    'day',
    'week',
    'month',
    'quarter'
);


SET search_path = private, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 198 (class 1259 OID 9594995)
-- Name: cup_action; Type: TABLE; Schema: private; Owner: -
--

CREATE TABLE cup_action (
    id integer,
    tx character varying(66) NOT NULL,
    act public.act NOT NULL,
    arg character varying(66),
    lad character varying(66) NOT NULL,
    ink numeric DEFAULT 0 NOT NULL,
    art numeric DEFAULT 0 NOT NULL,
    ire numeric DEFAULT 0 NOT NULL,
    block integer NOT NULL,
    deleted boolean DEFAULT false,
    guy character varying(66)
);


SET search_path = public, pg_catalog;

--
-- TOC entry 197 (class 1259 OID 9594987)
-- Name: block; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE block (
    n integer NOT NULL,
    "time" timestamp with time zone NOT NULL,
    pip numeric,
    pep numeric,
    per numeric
);


--
-- TOC entry 201 (class 1259 OID 11158357)
-- Name: cup; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cup AS
 SELECT c.act,
    c.art,
    c.block,
    c.deleted,
    c.id,
    c.ink,
    c.ire,
    c.lad,
    c.pip,
    c.per,
    ((((c.pip * c.per) * c.ink) / NULLIF(c.art, (0)::numeric)) * (100)::numeric) AS ratio,
    ((c.pip * c.per) * c.ink) AS tab,
    c."time"
   FROM ( SELECT DISTINCT ON (cup_action.id) cup_action.act,
            cup_action.art,
            cup_action.block,
            cup_action.deleted,
            cup_action.id,
            cup_action.ink,
            cup_action.ire,
            cup_action.lad,
            ( SELECT block.pip
                   FROM block
                  ORDER BY block.n DESC
                 LIMIT 1) AS pip,
            ( SELECT block.per
                   FROM block
                  ORDER BY block.n DESC
                 LIMIT 1) AS per,
            ( SELECT block."time"
                   FROM block
                  WHERE (block.n = cup_action.block)) AS "time"
           FROM private.cup_action
          ORDER BY cup_action.id DESC, cup_action.block DESC) c;


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 201
-- Name: VIEW cup; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW cup IS 'A CDP record';


--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.act; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.act IS 'The most recent act';


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.art; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.art IS 'Outstanding debt DAI';


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.block; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.block IS 'Block number at last update';


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.id IS 'The Cup ID';


--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.ink; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.ink IS 'Locked collateral PETH';


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.ire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.ire IS 'Outstanding debt DAI after fee';


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.lad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.lad IS 'The Cup owner';


--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.pip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.pip IS 'USD/ETH price';


--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.ratio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.ratio IS 'Collateralization ratio';


--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup.tab; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.tab IS 'USD value of locked collateral';


--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN cup."time"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup."time" IS 'Timestamp at last update';


--
-- TOC entry 200 (class 1259 OID 11158352)
-- Name: cup_act; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cup_act AS
 SELECT cup_action.act,
    cup_action.arg,
    cup_action.art,
    cup_action.block,
    cup_action.deleted,
    cup_action.id,
    cup_action.ink,
    cup_action.ire,
    cup_action.lad,
    block.pip,
    block.per,
    ((((block.pip * block.per) * cup_action.ink) / NULLIF(cup_action.art, (0)::numeric)) * (100)::numeric) AS ratio,
    ((block.pip * block.per) * cup_action.ink) AS tab,
    block."time",
    cup_action.tx
   FROM (private.cup_action
     LEFT JOIN block ON ((block.n = cup_action.block)))
  ORDER BY cup_action.block DESC;


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 200
-- Name: VIEW cup_act; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW cup_act IS 'A CDP action';


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.act; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.act IS 'The action name';


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.arg; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.arg IS 'Data associated with the act';


--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.art; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.art IS 'Outstanding debt DAI at block';


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.block; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.block IS 'Tx block number';


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.deleted IS 'True if the cup has been deleted (shut)';


--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.id IS 'The Cup ID';


--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.ink; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.ink IS 'Locked collateral PETH at block';


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.ire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.ire IS 'Outstanding debt DAI after fee at block';


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.lad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.lad IS 'The Cup owner';


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.pip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.pip IS 'USD/ETH price at block';


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.per; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.per IS 'ETH/PETH price';


--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.ratio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.ratio IS 'Collateralization ratio at block';


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.tab; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.tab IS 'USD value of locked collateral at block';


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act."time"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act."time" IS 'Tx timestamp';


--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup_act.tx; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.tx IS 'Transaction hash';


--
-- TOC entry 214 (class 1255 OID 11372655)
-- Name: cup_actions(cup); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cup_actions(cup cup) RETURNS SETOF cup_act
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM cup_act
  WHERE cup_act.id = cup.id
  ORDER BY cup_act.block DESC
$$;


--
-- TOC entry 205 (class 1255 OID 11372700)
-- Name: cup_history(cup, tick_interval); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cup_history(cup cup, tick tick_interval) RETURNS SETOF cup_state
    LANGUAGE sql STABLE
    AS $_$
  WITH acts AS (
    SELECT
      act,
      arg,
      ink,
      art,
      time AS _time,
      LEAD(time) OVER (ORDER BY time ASC) AS next_time
    FROM private.cup_action
    LEFT JOIN block on block.n = private.cup_action.block
    WHERE private.cup_action.id = cup.id
  ), ticks AS (
    SELECT
      date_trunc($2::char, time) AS tick,
      min(pip) AS min_pip,
      max(pip) AS max_pip,
      avg(per) AS per
    FROM block
    WHERE time <= (SELECT max(_time) FROM acts)
    AND time >= (SELECT min(_time) FROM acts)
    GROUP BY tick
    ORDER BY tick DESC
  )

  SELECT
    tick,
    min_pip,
    max_pip,
    (min_pip * per * ink) AS min_tab,
    (max_pip * per * ink) AS max_tab,
    (min_pip * per * ink) / NULLIF(art,0) * 100 AS min_ratio,
    (max_pip * per * ink) / NULLIF(art,0) * 100 AS max_ratio,
    (CASE WHEN (date_trunc($2::char, _time) = tick) THEN act ELSE NULL END) AS act,
    (CASE WHEN (date_trunc($2::char, _time) = tick) THEN arg ELSE NULL END) AS arg,
    ink,
    art,
    (CASE WHEN (date_trunc($2::char, _time) = tick) THEN _time ELSE NULL END) AS time
  FROM (
    SELECT * FROM ticks
    LEFT OUTER JOIN (SELECT * FROM acts) as actions
    ON ticks.tick = date_trunc($2::char, actions._time)
    OR (
      ticks.tick < date_trunc($2::char, actions.next_time)
      AND ticks.tick > date_trunc($2::char, actions._time)
    )
    ORDER BY tick DESC, _time DESC
  ) AS ticks_actions;
$_$;


--
-- TOC entry 211 (class 1255 OID 10931018)
-- Name: exec_set_deleted(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION exec_set_deleted() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    UPDATE private.cup_action
    SET deleted = true
    WHERE private.cup_action.id = NEW.id;
    RETURN NULL;
  END;
$$;


--
-- TOC entry 209 (class 1255 OID 11158363)
-- Name: get_cup(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_cup(id integer) RETURNS cup
    LANGUAGE sql STABLE
    AS $_$
  SELECT *
  FROM cup
  WHERE cup.id = $1
  ORDER BY id DESC
  LIMIT 1
$_$;


--
-- TOC entry 199 (class 1259 OID 11059535)
-- Name: gov; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gov (
    block integer NOT NULL,
    tx character varying(66) NOT NULL,
    var character varying(10) NOT NULL,
    arg character varying(66),
    guy character varying(66),
    cap numeric DEFAULT 0 NOT NULL,
    mat numeric DEFAULT 0 NOT NULL,
    tax numeric DEFAULT 0 NOT NULL,
    fee numeric DEFAULT 0 NOT NULL,
    axe numeric DEFAULT 0 NOT NULL,
    gap numeric DEFAULT 0 NOT NULL
);


--
-- TOC entry 3604 (class 2606 OID 9594994)
-- Name: block block_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY block
    ADD CONSTRAINT block_pkey PRIMARY KEY (n);


--
-- TOC entry 3615 (class 2606 OID 11059548)
-- Name: gov gov_tx_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gov
    ADD CONSTRAINT gov_tx_key UNIQUE (tx);


SET search_path = private, pg_catalog;

--
-- TOC entry 3606 (class 1259 OID 10930893)
-- Name: cup_action_act_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_act_index ON private.cup_action USING btree (act);


--
-- TOC entry 3607 (class 1259 OID 9595007)
-- Name: cup_action_block_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_block_index ON private.cup_action USING btree (block);


--
-- TOC entry 3608 (class 1259 OID 10930892)
-- Name: cup_action_deleted_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_deleted_index ON private.cup_action USING btree (deleted);


--
-- TOC entry 3609 (class 1259 OID 9595006)
-- Name: cup_action_id_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_id_index ON private.cup_action USING btree (id);


--
-- TOC entry 3610 (class 1259 OID 13030425)
-- Name: cup_action_tx_act_arg_idx; Type: INDEX; Schema: private; Owner: -
--

CREATE UNIQUE INDEX cup_action_tx_act_arg_idx ON private.cup_action USING btree (tx, act, arg);


--
-- TOC entry 3611 (class 1259 OID 9595008)
-- Name: cup_action_tx_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_tx_index ON private.cup_action USING btree (tx);


SET search_path = public, pg_catalog;

--
-- TOC entry 3605 (class 1259 OID 11549365)
-- Name: block_time_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX block_time_index ON public.block USING btree ("time");


--
-- TOC entry 3612 (class 1259 OID 11059549)
-- Name: gov_block_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gov_block_index ON public.gov USING btree (block);


--
-- TOC entry 3613 (class 1259 OID 11059550)
-- Name: gov_tx_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gov_tx_index ON public.gov USING btree (tx);


SET search_path = private, pg_catalog;

--
-- TOC entry 3616 (class 2620 OID 10931019)
-- Name: cup_action shut; Type: TRIGGER; Schema: private; Owner: -
--

CREATE TRIGGER shut AFTER INSERT ON private.cup_action FOR EACH ROW WHEN ((new.act = 'shut'::public.act)) EXECUTE PROCEDURE public.exec_set_deleted();


-- Completed on 2018-04-27 01:48:50 UTC

--
-- PostgreSQL database dump complete
--

