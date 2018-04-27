ALTER TABLE private.cup_action DROP CONSTRAINT "cup_action_tx_key";

CREATE UNIQUE INDEX cup_action_tx_act_arg_idx on private.cup_action(tx, act, arg);
