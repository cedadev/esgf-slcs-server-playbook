DROP TABLE IF EXISTS "user";

CREATE TABLE "user" (
    id serial PRIMARY KEY,
    firstname character varying(100) NOT NULL,
    middlename character varying(100),
    lastname character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(100),
    dn character varying(300),
    openid character varying(200) NOT NULL UNIQUE,
    organization character varying(200),
    organization_type character varying(200),
    city character varying(100),
    state character varying(100),
    country character varying(100),
    status_code integer,
    verification_token character varying(100),
    notification_code integer DEFAULT 0
);

INSERT INTO "user" (
  username,
  password,
  firstname,
  lastname,
  email,
  openid
) VALUES (
  'another',
  MD5('changeme'),
  'Andy',
  'Other',
  'a.n.other@myinstitution.ac.uk',
  'https://esgf.llnl.gov/openid/A.N.Other'
);
