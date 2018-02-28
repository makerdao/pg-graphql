CREATE OR REPLACE FUNCTION cup_history(cup cup) RETURNS setof cup_act as $$
  SELECT *
  FROM cup_act
  WHERE cup_act.id = cup.id
  ORDER BY cup_act.block DESC
$$ LANGUAGE SQL stable;

DROP FUNCTION get_cup(id integer);

CREATE OR REPLACE FUNCTION get_cup(id int) RETURNS cup as $$
  SELECT *
  FROM cup
  WHERE cup.id = $1
  ORDER BY id DESC
  LIMIT 1
$$ LANGUAGE SQL stable;
