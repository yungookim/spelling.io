CREATE EXTENSION pg_trgm;

DROP INDEX IF EXISTS word_trgm_idx CASCADE;
DROP TABLE IF EXISTS word_table CASCADE;


CREATE TABLE word_table (
	word     VARCHAR(100) NOT NULL PRIMARY KEY,
	occurrence INTEGER DEFAULT 0,
	used INTEGER DEFAULT 0
)
WITH (
  OIDS=FALSE
);

CREATE INDEX word_trgm_idx ON word_table USING gist (word gist_trgm_ops);
