--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2 (Ubuntu 10.2-1.pgdg14.04+1)
-- Dumped by pg_dump version 10.1

-- Started on 2018-03-05 02:29:32 UTC

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
DROP INDEX private.cup_action_tx_index;
DROP INDEX private.cup_action_id_index;
DROP INDEX private.cup_action_deleted_index;
DROP INDEX private.cup_action_block_index;
DROP INDEX private.cup_action_act_index;
SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.block DROP CONSTRAINT block_pkey;
SET search_path = private, pg_catalog;

ALTER TABLE ONLY private.cup_action DROP CONSTRAINT cup_action_tx_key;
SET search_path = public, pg_catalog;

DROP FUNCTION public.get_cup(id integer);
DROP FUNCTION public.exec_set_deleted();
DROP FUNCTION public.cup_history(cup cup);
DROP VIEW public.cup_act;
DROP VIEW public.cup;
DROP TABLE public.block;
SET search_path = private, pg_catalog;

DROP TABLE private.cup_action;
SET search_path = public, pg_catalog;

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
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 591 (class 1247 OID 9594969)
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
    'bite'
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
    deleted boolean DEFAULT false
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
-- TOC entry 200 (class 1259 OID 10931489)
-- Name: cup; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cup AS
 SELECT c.act,
    c.art,
    c.block,
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
            cup_action.id,
            cup_action.ink,
            cup_action.ire,
            cup_action.lad,
            ( SELECT block.pip
                   FROM block
                  ORDER BY block.n DESC
                 LIMIT 1) AS pip,
            ( SELECT (block.per / (1000000000)::numeric)
                   FROM block
                  ORDER BY block.n DESC
                 LIMIT 1) AS per,
            ( SELECT block."time"
                   FROM block
                  WHERE (block.n = cup_action.id)) AS "time"
           FROM private.cup_action
          ORDER BY cup_action.id DESC) c;


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 200
-- Name: VIEW cup; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW cup IS 'A CDP record';


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.act; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.act IS 'The most recent act';


--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.art; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.art IS 'Outstanding debt DAI';


--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.block; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.block IS 'Block number at last update';


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.id IS 'The Cup ID';


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.ink; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.ink IS 'Locked collateral PETH';


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.ire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.ire IS 'Outstanding debt DAI after fee';


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.lad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.lad IS 'The Cup owner';


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.pip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.pip IS 'USD/ETH price';


--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.ratio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.ratio IS 'Collateralization ratio';


--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup.tab; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup.tab IS 'USD value of locked collateral';


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 200
-- Name: COLUMN cup."time"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup."time" IS 'Timestamp at last update';


--
-- TOC entry 199 (class 1259 OID 10931478)
-- Name: cup_act; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cup_act AS
 SELECT cup_action.act,
    cup_action.arg,
    cup_action.art,
    cup_action.block,
    cup_action.id,
    cup_action.ink,
    cup_action.ire,
    cup_action.lad,
    block.pip,
    (block.per / (1000000000)::numeric) AS per,
    ((((block.pip * (block.per / (1000000000)::numeric)) * cup_action.ink) / NULLIF(cup_action.art, (0)::numeric)) * (100)::numeric) AS ratio,
    ((block.pip * (block.per / (1000000000)::numeric)) * cup_action.ink) AS tab,
    block."time",
    cup_action.tx
   FROM (private.cup_action
     LEFT JOIN block ON ((block.n = cup_action.block)))
  ORDER BY cup_action.block DESC;


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 199
-- Name: VIEW cup_act; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW cup_act IS 'A CDP action';


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.act; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.act IS 'The action name';


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.arg; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.arg IS 'Data associated with the act';


--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.art; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.art IS 'Outstanding debt DAI at block';


--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.block; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.block IS 'Tx block number';


--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.id IS 'The Cup ID';


--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.ink; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.ink IS 'Locked collateral PETH at block';


--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.ire; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.ire IS 'Outstanding debt DAI after fee at block';


--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.lad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.lad IS 'The Cup owner';


--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.pip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.pip IS 'USD/ETH price at block';


--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.per; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.per IS 'ETH/PETH price';


--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.ratio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.ratio IS 'Collateralization ratio at block';


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.tab; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.tab IS 'USD value of locked collateral at block';


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act."time"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act."time" IS 'Tx timestamp';


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN cup_act.tx; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN cup_act.tx IS 'Transaction hash';


--
-- TOC entry 206 (class 1255 OID 10931510)
-- Name: cup_history(cup); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION cup_history(cup cup) RETURNS SETOF cup_act
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM cup_act
  WHERE cup_act.id = cup.id
  ORDER BY cup_act.block DESC
$$;


--
-- TOC entry 207 (class 1255 OID 10931018)
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
-- TOC entry 211 (class 1255 OID 10931511)
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


SET search_path = private, pg_catalog;

--
-- TOC entry 3585 (class 2606 OID 9595005)
-- Name: cup_action cup_action_tx_key; Type: CONSTRAINT; Schema: private; Owner: -
--

ALTER TABLE ONLY cup_action
    ADD CONSTRAINT cup_action_tx_key UNIQUE (tx);


SET search_path = public, pg_catalog;

--
-- TOC entry 3578 (class 2606 OID 9594994)
-- Name: block block_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY block
    ADD CONSTRAINT block_pkey PRIMARY KEY (n);


SET search_path = private, pg_catalog;

--
-- TOC entry 3579 (class 1259 OID 10930893)
-- Name: cup_action_act_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_act_index ON cup_action USING btree (act);


--
-- TOC entry 3580 (class 1259 OID 9595007)
-- Name: cup_action_block_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_block_index ON cup_action USING btree (block);


--
-- TOC entry 3581 (class 1259 OID 10930892)
-- Name: cup_action_deleted_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_deleted_index ON cup_action USING btree (deleted);


--
-- TOC entry 3582 (class 1259 OID 9595006)
-- Name: cup_action_id_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_id_index ON cup_action USING btree (id);


--
-- TOC entry 3583 (class 1259 OID 9595008)
-- Name: cup_action_tx_index; Type: INDEX; Schema: private; Owner: -
--

CREATE INDEX cup_action_tx_index ON cup_action USING btree (tx);


--
-- TOC entry 3586 (class 2620 OID 10931019)
-- Name: cup_action shut; Type: TRIGGER; Schema: private; Owner: -
--

CREATE TRIGGER shut AFTER INSERT ON cup_action FOR EACH ROW WHEN ((new.act = 'shut'::public.act)) EXECUTE PROCEDURE public.exec_set_deleted();


-- Completed on 2018-03-05 02:30:38 UTC

--
-- PostgreSQL database dump complete
--

