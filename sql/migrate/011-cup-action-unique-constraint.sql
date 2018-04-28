DROP INDEX private.cup_action_tx_act_arg_idx;

ALTER TABLE private.cup_action ADD CONSTRAINT tx_act_arg_idx UNIQUE(tx, act, arg);
