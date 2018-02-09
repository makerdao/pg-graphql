exports.up = (pgm) => {
  pgm.sql(`
    CREATE TABLE public.cups(
      id           BIGINT                   NOT NULL,
      tx           CHARACTER VARYING(66)    UNIQUE NOT NULL,
      act          CHARACTER VARYING(4)     NOT NULL,
      arg          CHARACTER VARYING(66),
      lad          CHARACTER VARYING(66)    NOT NULL,
      ink          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      art          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      ire          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      block        BIGINT                   NOT NULL,
      time         TIMESTAMPTZ              NOT NULL
    );
  `)
};

exports.down = (pgm) => {
  pgm.sql('DROP TABLE public.cups;');
};
