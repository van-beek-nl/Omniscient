CREATE TABLE public.omniscient (
    id integer NOT NULL,
    json text NOT NULL,
    logidentifier text NOT NULL,
    processid integer
);

CREATE SEQUENCE public.omniscient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.omniscient_id_seq OWNED BY public.omniscient.id;
ALTER TABLE ONLY public.omniscient ALTER COLUMN id SET DEFAULT nextval('public.omniscient_id_seq'::regclass);

ALTER TABLE ONLY public.omniscient
    ADD CONSTRAINT omniscient_logidentifier_key UNIQUE (logidentifier);

ALTER TABLE ONLY public.omniscient
    ADD CONSTRAINT omniscient_pkey PRIMARY KEY (id);
