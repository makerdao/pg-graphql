exports.up = (pgm) => {
  pgm.sql(`
    CREATE TABLE public.cups(
      id           BIGINT                   NOT NULL,
      tx_hash      CHARACTER VARYING(66)    UNIQUE NOT NULL,
      action       CHARACTER VARYING(4)     NOT NULL,
      lad          CHARACTER VARYING(66)    NOT NULL,
      ink          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      art          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      tab          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      ire          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      rap          CHARACTER VARYING(66)    NOT NULL DEFAULT 0,
      state        CHARACTER VARYING(10)    NOT NULL,
      block        BIGINT                   NOT NULL,
      timestamp    TIMESTAMPTZ              NOT NULL
    );
  `)
};

exports.down = (pgm) => {
  pgm.sql('DROP TABLE public.cups;');
};
