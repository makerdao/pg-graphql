exports.up = (pgm) => {
  pgm.sql(`
    CREATE TABLE public.cups(
      id            BIGINT    UNIQUE        NOT NULL,
      lad           CHARACTER VARYING(66)   NOT NULL,
      ink           CHARACTER VARYING(66)   NOT NULL,
      art           CHARACTER VARYING(66)   NOT NULL,
      tab           CHARACTER VARYING(66)   NOT NULL,
      ire           CHARACTER VARYING(66)   NOT NULL,
      rap           CHARACTER VARYING(66)   NOT NULL,
      created       BIGINT                  NOT NULL,
      updated       BIGINT                  NOT NULL,
      created_time  TIMESTAMPTZ             NOT NULL,
      updated_time  TIMESTAMPTZ             NOT NULL
    );
  `)
};

exports.down = (pgm) => {
  pgm.sql('DROP TABLE public.cups;');
};
