DROP TYPE IF EXISTS public.interval;
CREATE TYPE interval AS enum (
  'minute',
  'hour',
  'day',
  'week',
  'month',
  'year'
);

DROP TYPE IF EXISTS public.cup_history_interval CASCADE;
CREATE TYPE public.cup_history_interval AS (
  tick       timestamptz,
  min_pip    numeric,
  max_pip    numeric,
  min_tab    numeric,
  max_tab    numeric,
  min_ratio  numeric,
  max_ratio  numeric,
  act        act,
  arg        varchar,
  ink        numeric,
  art        numeric,
  time       timestamptz
);

CREATE OR REPLACE FUNCTION cup_history(id integer,tick char)
RETURNS SETOF cup_history_interval as $$
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
    WHERE private.cup_action.id = $1
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
$$ LANGUAGE SQL stable;

CREATE INDEX IF NOT EXISTS block_time_minute_index ON block(date_trunc('minute', time AT TIME ZONE 'UTC'));
CREATE INDEX IF NOT EXISTS block_time_hour_index ON block(date_trunc('hour', time AT TIME ZONE 'UTC'));
CREATE INDEX IF NOT EXISTS block_time_day_index ON block(date_trunc('day', time AT TIME ZONE 'UTC'));
