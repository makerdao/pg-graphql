ALTER TABLE private.cup_action ADD COLUMN deleted boolean default false;

CREATE INDEX cup_action_deleted_index ON private.cup_action(deleted);
CREATE INDEX cup_action_act_index ON private.cup_action(act);

CREATE OR REPLACE FUNCTION exec_set_deleted() RETURNS trigger AS $shut$
  BEGIN
    UPDATE private.cup_action
    SET deleted = true
    WHERE private.cup_action.id = NEW.id;
    RETURN NULL;
  END;
$shut$ LANGUAGE plpgsql;

CREATE trigger shut
  AFTER INSERT ON private.cup_action
  FOR EACH ROW
  WHEN (NEW.act = 'shut')
  EXECUTE PROCEDURE exec_set_deleted();
