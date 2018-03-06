CREATE TABLE public.gov (
  block      integer not null,
  tx         character varying(66) UNIQUE not null,
  var        character varying(10) not null,
  arg        character varying(66),
  guy        character varying(66),
  cap        decimal not null default 0,
  mat        decimal not null default 0,
  tax        decimal not null default 0,
  fee        decimal not null default 0,
  axe        decimal not null default 0,
  gap        decimal not null default 0
);

CREATE INDEX gov_block_index ON public.gov(block);
CREATE INDEX gov_tx_index ON public.gov(tx);
