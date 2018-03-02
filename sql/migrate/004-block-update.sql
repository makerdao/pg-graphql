ALTER TABLE block ADD COLUMN per decimal;

/* ALTER TABLE block ADD COLUMN updated_at timestamp with time zone DEFAULT now(); */

/* CREATE OR REPLACE FUNCTION block_changed() RETURNS TRIGGER */
/*   LANGUAGE plpgsql */
/*   AS $$ */
/* BEGIN */
/*   NEW.updated_at :=current_date; */
/*   RETURN NEW; */
/* END; */
/* $$; */


