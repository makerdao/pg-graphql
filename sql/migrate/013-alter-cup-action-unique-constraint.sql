CREATE INDEX cup_action_arg_index on private.cup_action(arg);

ALTER TABLE private.cup_action DROP CONSTRAINT tx_act_arg_idx;

ALTER TABLE private.cup_action ADD CONSTRAINT id_tx_act_arg_idx UNIQUE(id, tx, act, arg);
