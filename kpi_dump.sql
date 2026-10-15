--
-- PostgreSQL database dump
--

\restrict uaHQaqe9CUWob9FlN1TXuTCi7ecG8llU4AV2G0EzKpfVmXIDTTz6b8pxIzGeM3u

-- Dumped from database version 16.15 (Debian 16.15-1.pgdg13+2)
-- Dumped by pg_dump version 16.15 (Debian 16.15-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.evaluation_scores DROP CONSTRAINT IF EXISTS fk_evaluations_scores;
DROP INDEX IF EXISTS public.idx_users_manager_id;
DROP INDEX IF EXISTS public.idx_users_employee_code;
DROP INDEX IF EXISTS public.idx_users_email;
DROP INDEX IF EXISTS public.idx_transfer_requests_employee_id;
DROP INDEX IF EXISTS public.idx_transfer_requests_cycle_id;
DROP INDEX IF EXISTS public.idx_transfer_evaluation;
DROP INDEX IF EXISTS public.idx_training_plans_evaluation_id;
DROP INDEX IF EXISTS public.idx_training_plans_employee_id;
DROP INDEX IF EXISTS public.idx_task_emp_due;
DROP INDEX IF EXISTS public.idx_salary_emp_date;
DROP INDEX IF EXISTS public.idx_promotion_requests_employee_id;
DROP INDEX IF EXISTS public.idx_promotion_requests_cycle_id;
DROP INDEX IF EXISTS public.idx_promotion_evaluation;
DROP INDEX IF EXISTS public.idx_evaluations_evaluator_id;
DROP INDEX IF EXISTS public.idx_evaluation_scores_evaluation_id;
DROP INDEX IF EXISTS public.idx_cycle_employee_type;
DROP INDEX IF EXISTS public.idx_criteria_department;
DROP INDEX IF EXISTS public.idx_bonus_evaluation_id;
DROP INDEX IF EXISTS public.idx_bonus_employee_id;
DROP INDEX IF EXISTS public.idx_bonus_cycle_id;
DROP INDEX IF EXISTS public.idx_audit_logs_user_id;
DROP INDEX IF EXISTS public.idx_audit_logs_entity_id;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.transfer_requests DROP CONSTRAINT IF EXISTS transfer_requests_pkey;
ALTER TABLE IF EXISTS ONLY public.training_plans DROP CONSTRAINT IF EXISTS training_plans_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks DROP CONSTRAINT IF EXISTS tasks_pkey;
ALTER TABLE IF EXISTS ONLY public.salary_records DROP CONSTRAINT IF EXISTS salary_records_pkey;
ALTER TABLE IF EXISTS ONLY public.promotion_requests DROP CONSTRAINT IF EXISTS promotion_requests_pkey;
ALTER TABLE IF EXISTS ONLY public.positions DROP CONSTRAINT IF EXISTS positions_pkey;
ALTER TABLE IF EXISTS ONLY public.positions DROP CONSTRAINT IF EXISTS positions_name_key;
ALTER TABLE IF EXISTS ONLY public.levels DROP CONSTRAINT IF EXISTS levels_pkey;
ALTER TABLE IF EXISTS ONLY public.levels DROP CONSTRAINT IF EXISTS levels_name_key;
ALTER TABLE IF EXISTS ONLY public.evaluations DROP CONSTRAINT IF EXISTS evaluations_pkey;
ALTER TABLE IF EXISTS ONLY public.evaluation_scores DROP CONSTRAINT IF EXISTS evaluation_scores_pkey;
ALTER TABLE IF EXISTS ONLY public.evaluation_cycles DROP CONSTRAINT IF EXISTS evaluation_cycles_pkey;
ALTER TABLE IF EXISTS ONLY public.departments DROP CONSTRAINT IF EXISTS departments_pkey;
ALTER TABLE IF EXISTS ONLY public.departments DROP CONSTRAINT IF EXISTS departments_name_key;
ALTER TABLE IF EXISTS ONLY public.criteria DROP CONSTRAINT IF EXISTS criteria_pkey;
ALTER TABLE IF EXISTS ONLY public.bonus DROP CONSTRAINT IF EXISTS bonus_pkey;
ALTER TABLE IF EXISTS ONLY public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.transfer_requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.training_plans ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.tasks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.salary_records ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.promotion_requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.positions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.levels ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.evaluations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.evaluation_scores ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.evaluation_cycles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.departments ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.criteria ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bonus ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.audit_logs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.transfer_requests_id_seq;
DROP TABLE IF EXISTS public.transfer_requests;
DROP SEQUENCE IF EXISTS public.training_plans_id_seq;
DROP TABLE IF EXISTS public.training_plans;
DROP SEQUENCE IF EXISTS public.tasks_id_seq;
DROP TABLE IF EXISTS public.tasks;
DROP SEQUENCE IF EXISTS public.salary_records_id_seq;
DROP TABLE IF EXISTS public.salary_records;
DROP SEQUENCE IF EXISTS public.promotion_requests_id_seq;
DROP TABLE IF EXISTS public.promotion_requests;
DROP SEQUENCE IF EXISTS public.positions_id_seq;
DROP TABLE IF EXISTS public.positions;
DROP SEQUENCE IF EXISTS public.levels_id_seq;
DROP TABLE IF EXISTS public.levels;
DROP SEQUENCE IF EXISTS public.evaluations_id_seq;
DROP TABLE IF EXISTS public.evaluations;
DROP SEQUENCE IF EXISTS public.evaluation_scores_id_seq;
DROP TABLE IF EXISTS public.evaluation_scores;
DROP SEQUENCE IF EXISTS public.evaluation_cycles_id_seq;
DROP TABLE IF EXISTS public.evaluation_cycles;
DROP SEQUENCE IF EXISTS public.departments_id_seq;
DROP TABLE IF EXISTS public.departments;
DROP SEQUENCE IF EXISTS public.criteria_id_seq;
DROP TABLE IF EXISTS public.criteria;
DROP SEQUENCE IF EXISTS public.bonus_id_seq;
DROP TABLE IF EXISTS public.bonus;
DROP SEQUENCE IF EXISTS public.audit_logs_id_seq;
DROP TABLE IF EXISTS public.audit_logs;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    action character varying(50) NOT NULL,
    entity character varying(50) NOT NULL,
    entity_id bigint,
    detail text,
    created_at timestamp with time zone
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: bonus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bonus (
    id bigint NOT NULL,
    evaluation_id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    base_salary numeric,
    total_score numeric,
    suggested_amount numeric,
    amount numeric,
    status character varying(20) DEFAULT 'pending_approval'::character varying,
    note text,
    decision_note text,
    created_by bigint NOT NULL,
    decided_by bigint,
    decided_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    paid_by bigint,
    paid_at timestamp with time zone,
    payment_note text
);


--
-- Name: bonus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bonus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bonus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bonus_id_seq OWNED BY public.bonus.id;


--
-- Name: criteria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.criteria (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    weight numeric DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true,
    rubric text,
    department character varying(100),
    level character varying(50),
    source character varying(30) DEFAULT 'manual'::character varying
);


--
-- Name: criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.criteria_id_seq OWNED BY public.criteria.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: evaluation_cycles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evaluation_cycles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    status character varying(20) DEFAULT 'open'::character varying,
    created_at timestamp with time zone
);


--
-- Name: evaluation_cycles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evaluation_cycles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluation_cycles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.evaluation_cycles_id_seq OWNED BY public.evaluation_cycles.id;


--
-- Name: evaluation_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evaluation_scores (
    id bigint NOT NULL,
    evaluation_id bigint NOT NULL,
    criteria_id bigint NOT NULL,
    score bigint NOT NULL,
    comment text,
    weight numeric,
    source character varying(30),
    metric numeric,
    detail text
);


--
-- Name: evaluation_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evaluation_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluation_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.evaluation_scores_id_seq OWNED BY public.evaluation_scores.id;


--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.evaluations (
    id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    type character varying(20) DEFAULT 'supervisor'::character varying NOT NULL,
    evaluator_id bigint NOT NULL,
    status character varying(20) DEFAULT 'draft'::character varying,
    total_score numeric,
    comment text,
    employee_feedback text,
    approved_by bigint,
    submitted_at timestamp with time zone,
    approved_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.evaluations_id_seq OWNED BY public.evaluations.id;


--
-- Name: levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.levels (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.levels_id_seq OWNED BY public.levels.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- Name: promotion_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_requests (
    id bigint NOT NULL,
    evaluation_id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    from_position character varying(100),
    to_position character varying(100) NOT NULL,
    from_level character varying(50),
    to_level character varying(50),
    status character varying(20) DEFAULT 'pending_approval'::character varying NOT NULL,
    note text,
    decision_note text,
    created_by bigint NOT NULL,
    decided_by bigint,
    decided_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: promotion_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.promotion_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: promotion_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.promotion_requests_id_seq OWNED BY public.promotion_requests.id;


--
-- Name: salary_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_records (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    amount numeric NOT NULL,
    effective_date timestamp with time zone NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp with time zone
);


--
-- Name: salary_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.salary_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: salary_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.salary_records_id_seq OWNED BY public.salary_records.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    title character varying(255) NOT NULL,
    due_date timestamp with time zone NOT NULL,
    completed_at timestamp with time zone,
    status character varying(20) DEFAULT 'todo'::character varying NOT NULL,
    reviewed boolean DEFAULT false NOT NULL,
    revisions bigint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: training_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_plans (
    id bigint NOT NULL,
    evaluation_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    topic character varying(255) NOT NULL,
    reason text,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    status character varying(20) DEFAULT 'planned'::character varying NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: training_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.training_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.training_plans_id_seq OWNED BY public.training_plans.id;


--
-- Name: transfer_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfer_requests (
    id bigint NOT NULL,
    evaluation_id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    from_department character varying(100),
    to_department character varying(100) NOT NULL,
    effective_date timestamp with time zone,
    status character varying(20) DEFAULT 'pending_approval'::character varying NOT NULL,
    note text,
    decision_note text,
    created_by bigint NOT NULL,
    decided_by bigint,
    decided_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: transfer_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transfer_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transfer_requests_id_seq OWNED BY public.transfer_requests.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    employee_code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    role character varying(20) DEFAULT 'employee'::character varying NOT NULL,
    department character varying(100),
    "position" character varying(100),
    manager_id bigint,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    level character varying(50)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: bonus id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bonus ALTER COLUMN id SET DEFAULT nextval('public.bonus_id_seq'::regclass);


--
-- Name: criteria id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criteria ALTER COLUMN id SET DEFAULT nextval('public.criteria_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: evaluation_cycles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_cycles ALTER COLUMN id SET DEFAULT nextval('public.evaluation_cycles_id_seq'::regclass);


--
-- Name: evaluation_scores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_scores ALTER COLUMN id SET DEFAULT nextval('public.evaluation_scores_id_seq'::regclass);


--
-- Name: evaluations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluations ALTER COLUMN id SET DEFAULT nextval('public.evaluations_id_seq'::regclass);


--
-- Name: levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels ALTER COLUMN id SET DEFAULT nextval('public.levels_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- Name: promotion_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_requests ALTER COLUMN id SET DEFAULT nextval('public.promotion_requests_id_seq'::regclass);


--
-- Name: salary_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_records ALTER COLUMN id SET DEFAULT nextval('public.salary_records_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: training_plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_plans ALTER COLUMN id SET DEFAULT nextval('public.training_plans_id_seq'::regclass);


--
-- Name: transfer_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfer_requests ALTER COLUMN id SET DEFAULT nextval('public.transfer_requests_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_logs (id, user_id, action, entity, entity_id, detail, created_at) FROM stdin;
1	4	create	evaluation	1	สร้างแบบประเมิน type=supervisor	2026-10-14 02:36:00.091255+00
2	4	create	evaluation	2	สร้างแบบประเมิน type=supervisor	2026-10-14 03:15:13.443051+00
3	12	create	evaluation	3	สร้างแบบประเมิน type=supervisor	2026-10-14 09:47:35.750045+00
4	12	update	evaluation	3		2026-10-14 09:55:47.914043+00
5	12	update	evaluation	3		2026-10-14 09:55:54.061994+00
6	12	submit	evaluation	3		2026-10-14 09:55:54.184015+00
7	13	create	evaluation	4	สร้างแบบประเมิน type=supervisor	2026-10-14 09:59:54.717367+00
8	4	create	evaluation	5	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.811257+00
9	5	create	evaluation	6	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.816027+00
10	5	create	evaluation	7	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.822312+00
11	5	create	evaluation	8	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.828271+00
12	12	create	evaluation	9	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.836063+00
13	12	create	evaluation	10	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.84384+00
14	12	create	evaluation	11	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.85332+00
15	12	create	evaluation	12	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.861971+00
16	12	create	evaluation	13	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.867478+00
17	12	create	evaluation	14	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.872316+00
18	12	create	evaluation	15	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.877242+00
19	12	create	evaluation	16	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.88482+00
20	12	create	evaluation	17	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.889647+00
21	12	create	evaluation	18	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.894472+00
22	12	create	evaluation	19	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.899407+00
23	12	create	evaluation	20	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.904123+00
24	12	create	evaluation	21	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.909183+00
25	12	create	evaluation	22	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.914036+00
26	12	create	evaluation	23	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.91902+00
27	12	create	evaluation	24	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.924969+00
28	12	create	evaluation	25	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.930219+00
29	12	create	evaluation	26	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.939281+00
30	12	create	evaluation	27	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.944591+00
31	13	create	evaluation	28	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.949694+00
32	13	create	evaluation	29	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.954483+00
33	13	create	evaluation	30	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.959309+00
34	13	create	evaluation	31	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.964488+00
35	13	create	evaluation	32	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.970158+00
36	13	create	evaluation	33	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.975233+00
37	13	create	evaluation	34	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.982483+00
38	13	create	evaluation	35	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.987228+00
39	13	create	evaluation	36	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.992025+00
40	13	create	evaluation	37	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:09.997184+00
41	13	create	evaluation	38	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.002056+00
42	13	create	evaluation	39	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.006951+00
43	13	create	evaluation	40	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.011888+00
44	13	create	evaluation	41	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.016952+00
45	13	create	evaluation	42	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.021754+00
46	13	create	evaluation	43	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.026733+00
47	13	create	evaluation	44	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.035714+00
48	13	create	evaluation	45	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.041656+00
49	13	create	evaluation	46	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.071461+00
50	14	create	evaluation	47	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.077119+00
51	14	create	evaluation	48	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.084656+00
52	14	create	evaluation	49	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.095695+00
53	14	create	evaluation	50	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.104187+00
54	14	create	evaluation	51	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.124385+00
55	14	create	evaluation	52	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.138236+00
56	14	create	evaluation	53	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.146275+00
57	14	create	evaluation	54	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.151466+00
58	14	create	evaluation	55	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.156667+00
59	14	create	evaluation	56	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.161659+00
60	14	create	evaluation	57	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.166594+00
61	14	create	evaluation	58	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.171324+00
62	14	create	evaluation	59	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.176242+00
63	14	create	evaluation	60	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.181257+00
64	14	create	evaluation	61	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.186031+00
65	14	create	evaluation	62	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.190913+00
66	14	create	evaluation	63	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.195917+00
67	14	create	evaluation	64	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.200826+00
68	14	create	evaluation	65	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.205627+00
69	14	create	evaluation	66	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.210627+00
70	15	create	evaluation	67	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.215538+00
71	15	create	evaluation	68	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.221343+00
72	15	create	evaluation	69	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.226344+00
73	15	create	evaluation	70	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.231275+00
74	15	create	evaluation	71	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.243002+00
75	15	create	evaluation	72	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.251342+00
76	15	create	evaluation	73	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.256501+00
77	15	create	evaluation	74	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.261556+00
78	15	create	evaluation	75	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.268475+00
79	15	create	evaluation	76	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.273454+00
80	15	create	evaluation	77	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.278443+00
81	15	create	evaluation	78	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.283221+00
82	15	create	evaluation	79	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.288048+00
83	15	create	evaluation	80	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.292876+00
84	15	create	evaluation	81	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.297471+00
85	15	create	evaluation	82	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.30222+00
86	15	create	evaluation	83	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.307172+00
87	15	create	evaluation	84	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.312112+00
88	15	create	evaluation	85	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.316983+00
89	15	create	evaluation	86	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.32174+00
90	16	create	evaluation	87	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.326523+00
91	16	create	evaluation	88	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.331345+00
92	16	create	evaluation	89	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.344592+00
93	16	create	evaluation	90	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.351589+00
94	16	create	evaluation	91	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.356437+00
95	16	create	evaluation	92	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.361236+00
96	16	create	evaluation	93	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.366119+00
97	16	create	evaluation	94	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.370962+00
98	16	create	evaluation	95	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.375871+00
99	16	create	evaluation	96	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.380712+00
100	16	create	evaluation	97	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.385394+00
101	16	create	evaluation	98	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.39027+00
102	16	create	evaluation	99	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.395317+00
103	16	create	evaluation	100	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.400006+00
104	16	create	evaluation	101	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.40504+00
105	16	create	evaluation	102	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.409754+00
106	16	create	evaluation	103	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.414583+00
107	16	create	evaluation	104	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.419505+00
108	16	create	evaluation	105	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.424225+00
109	16	create	evaluation	106	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.428852+00
110	17	create	evaluation	107	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.436847+00
111	17	create	evaluation	108	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.447434+00
112	17	create	evaluation	109	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.452444+00
113	17	create	evaluation	110	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.457382+00
114	17	create	evaluation	111	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.462127+00
115	17	create	evaluation	112	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.471399+00
116	17	create	evaluation	113	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.478432+00
117	17	create	evaluation	114	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.483245+00
118	17	create	evaluation	115	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.488066+00
119	17	create	evaluation	116	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.492956+00
120	17	create	evaluation	117	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.497772+00
121	17	create	evaluation	118	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.502703+00
122	17	create	evaluation	119	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.507841+00
123	17	create	evaluation	120	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.51259+00
124	17	create	evaluation	121	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.517479+00
125	17	create	evaluation	122	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.522485+00
126	17	create	evaluation	123	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.527281+00
127	17	create	evaluation	124	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.532988+00
128	17	create	evaluation	125	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.539408+00
129	17	create	evaluation	126	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.546016+00
130	18	create	evaluation	127	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.55014+00
131	18	create	evaluation	128	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.556467+00
132	18	create	evaluation	129	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.565346+00
133	18	create	evaluation	130	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.57003+00
134	18	create	evaluation	131	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.574335+00
135	18	create	evaluation	132	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.578557+00
136	18	create	evaluation	133	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.582653+00
137	18	create	evaluation	134	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.590263+00
138	18	create	evaluation	135	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.595845+00
139	18	create	evaluation	136	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.604059+00
140	18	create	evaluation	137	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.608133+00
141	18	create	evaluation	138	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.612362+00
142	18	create	evaluation	139	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.616954+00
143	18	create	evaluation	140	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.621954+00
144	18	create	evaluation	141	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.63605+00
145	18	create	evaluation	142	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.640578+00
146	18	create	evaluation	143	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.64643+00
147	18	create	evaluation	144	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.652159+00
148	18	create	evaluation	145	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.659668+00
149	18	create	evaluation	146	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.665739+00
150	19	create	evaluation	147	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.672444+00
151	19	create	evaluation	148	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.677886+00
152	19	create	evaluation	149	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.681915+00
153	19	create	evaluation	150	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.685933+00
154	19	create	evaluation	151	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.690111+00
155	19	create	evaluation	152	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.694181+00
156	19	create	evaluation	153	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.698317+00
157	19	create	evaluation	154	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.702398+00
158	19	create	evaluation	155	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.706585+00
159	19	create	evaluation	156	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.710656+00
160	19	create	evaluation	157	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.714787+00
161	19	create	evaluation	158	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.719224+00
162	19	create	evaluation	159	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.723221+00
163	19	create	evaluation	160	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.727287+00
164	19	create	evaluation	161	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.731395+00
165	19	create	evaluation	162	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.737299+00
166	19	create	evaluation	163	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.741341+00
167	19	create	evaluation	164	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.745399+00
168	19	create	evaluation	165	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.749679+00
169	19	create	evaluation	166	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.760996+00
170	20	create	evaluation	167	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.773254+00
171	20	create	evaluation	168	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.778712+00
172	20	create	evaluation	169	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.786687+00
173	20	create	evaluation	170	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.793219+00
174	20	create	evaluation	171	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.799492+00
175	20	create	evaluation	172	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.803736+00
176	20	create	evaluation	173	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.807771+00
177	20	create	evaluation	174	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.811765+00
178	20	create	evaluation	175	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.815941+00
179	20	create	evaluation	176	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.820028+00
180	20	create	evaluation	177	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.82403+00
181	20	create	evaluation	178	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.828245+00
182	20	create	evaluation	179	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.832958+00
183	20	create	evaluation	180	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.836851+00
184	20	create	evaluation	181	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.846195+00
185	20	create	evaluation	182	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.854009+00
186	20	create	evaluation	183	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.860815+00
187	20	create	evaluation	184	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.864902+00
188	20	create	evaluation	185	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.869149+00
189	20	create	evaluation	186	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.873507+00
190	21	create	evaluation	187	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.878407+00
191	21	create	evaluation	188	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.883244+00
192	21	create	evaluation	189	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.888206+00
193	21	create	evaluation	190	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.892932+00
194	21	create	evaluation	191	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.89775+00
195	21	create	evaluation	192	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.902404+00
196	21	create	evaluation	193	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.908317+00
197	21	create	evaluation	194	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.913058+00
198	21	create	evaluation	195	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.917619+00
199	21	create	evaluation	196	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.922277+00
200	21	create	evaluation	197	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.927033+00
201	21	create	evaluation	198	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.931642+00
202	21	create	evaluation	199	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.939093+00
203	21	create	evaluation	200	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.944171+00
204	21	create	evaluation	201	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.948954+00
205	21	create	evaluation	202	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.956202+00
206	21	create	evaluation	203	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.961676+00
207	21	create	evaluation	204	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.967117+00
208	21	create	evaluation	205	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.976757+00
209	21	create	evaluation	206	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.981416+00
210	22	create	evaluation	207	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.98614+00
211	22	create	evaluation	208	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.99095+00
212	22	create	evaluation	209	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:10.995974+00
213	22	create	evaluation	210	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.000668+00
214	22	create	evaluation	211	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.005383+00
215	22	create	evaluation	212	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.010364+00
216	22	create	evaluation	213	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.015228+00
217	22	create	evaluation	214	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.019932+00
218	22	create	evaluation	215	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.026071+00
219	22	create	evaluation	216	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.030706+00
220	22	create	evaluation	217	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.037899+00
221	22	create	evaluation	218	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.04403+00
222	22	create	evaluation	219	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.052007+00
223	22	create	evaluation	220	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.057599+00
224	22	create	evaluation	221	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.06242+00
225	22	create	evaluation	222	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.068987+00
226	22	create	evaluation	223	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.081373+00
227	22	create	evaluation	224	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.086421+00
228	22	create	evaluation	225	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.091231+00
229	22	create	evaluation	226	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.096285+00
230	23	create	evaluation	227	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.100881+00
231	23	create	evaluation	228	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.10548+00
232	23	create	evaluation	229	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.110305+00
233	23	create	evaluation	230	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.115222+00
234	23	create	evaluation	231	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.119631+00
235	23	create	evaluation	232	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.124427+00
236	23	create	evaluation	233	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.129501+00
237	23	create	evaluation	234	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.140129+00
238	23	create	evaluation	235	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.145407+00
239	23	create	evaluation	236	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.154284+00
240	23	create	evaluation	237	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.160113+00
241	23	create	evaluation	238	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.165125+00
242	23	create	evaluation	239	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.170026+00
243	23	create	evaluation	240	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.17482+00
244	23	create	evaluation	241	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.179621+00
245	23	create	evaluation	242	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.188811+00
246	23	create	evaluation	243	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.202576+00
247	23	create	evaluation	244	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.212406+00
248	23	create	evaluation	245	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.220566+00
249	23	create	evaluation	246	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.23006+00
250	24	create	evaluation	247	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.236916+00
251	24	create	evaluation	248	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.242717+00
252	24	create	evaluation	249	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.254444+00
253	24	create	evaluation	250	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.259094+00
254	24	create	evaluation	251	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.263642+00
255	24	create	evaluation	252	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.268378+00
256	24	create	evaluation	253	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.274026+00
257	24	create	evaluation	254	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.278926+00
258	24	create	evaluation	255	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.283648+00
259	24	create	evaluation	256	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.287767+00
260	24	create	evaluation	257	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.294204+00
261	24	create	evaluation	258	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.299165+00
262	24	create	evaluation	259	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.303786+00
263	24	create	evaluation	260	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.308552+00
264	24	create	evaluation	261	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.316991+00
265	24	create	evaluation	262	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.32144+00
266	24	create	evaluation	263	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.326137+00
267	24	create	evaluation	264	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.330973+00
268	24	create	evaluation	265	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.343712+00
269	24	create	evaluation	266	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.349157+00
270	25	create	evaluation	267	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.358518+00
271	25	create	evaluation	268	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.363086+00
272	25	create	evaluation	269	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.367591+00
273	25	create	evaluation	270	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.37238+00
274	25	create	evaluation	271	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.376803+00
275	25	create	evaluation	272	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.381319+00
276	25	create	evaluation	273	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.385859+00
277	25	create	evaluation	274	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.390452+00
278	25	create	evaluation	275	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.395319+00
279	25	create	evaluation	276	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.400032+00
280	25	create	evaluation	277	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.406196+00
281	25	create	evaluation	278	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.41099+00
282	25	create	evaluation	279	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.416043+00
283	25	create	evaluation	280	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.420734+00
284	25	create	evaluation	281	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.425177+00
285	25	create	evaluation	282	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.430091+00
286	25	create	evaluation	283	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.436415+00
287	25	create	evaluation	284	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.445304+00
288	25	create	evaluation	285	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.450218+00
289	25	create	evaluation	286	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.458275+00
290	26	create	evaluation	287	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.479758+00
291	26	create	evaluation	288	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.488575+00
292	26	create	evaluation	289	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.498168+00
293	26	create	evaluation	290	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.502911+00
294	26	create	evaluation	291	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.509395+00
295	26	create	evaluation	292	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.5188+00
296	26	create	evaluation	293	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.529767+00
297	26	create	evaluation	294	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.549795+00
298	26	create	evaluation	295	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.56762+00
299	26	create	evaluation	296	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.573831+00
300	26	create	evaluation	297	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.578902+00
301	26	create	evaluation	298	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.583751+00
302	26	create	evaluation	299	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.589736+00
303	26	create	evaluation	300	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.594804+00
304	26	create	evaluation	301	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.599634+00
305	26	create	evaluation	302	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.604602+00
306	26	create	evaluation	303	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.609473+00
307	26	create	evaluation	304	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.61437+00
308	26	create	evaluation	305	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.61937+00
309	26	create	evaluation	306	สร้างแบบประเมิน type=supervisor	2026-10-14 10:04:11.623777+00
310	1	generate_drafts	cycle	3		2026-10-14 10:04:11.625011+00
311	1	generate_drafts	cycle	3		2026-10-14 10:04:12.00053+00
312	1	generate_drafts	cycle	3		2026-10-14 10:10:44.36188+00
313	5	create	evaluation	307	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.31526+00
314	5	create	evaluation	308	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.321325+00
315	5	create	evaluation	309	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.328185+00
316	18	create	evaluation	310	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.442719+00
317	18	create	evaluation	311	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.447961+00
318	18	create	evaluation	312	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.453164+00
319	18	create	evaluation	313	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.458055+00
320	18	create	evaluation	314	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.464389+00
321	18	create	evaluation	315	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.469528+00
322	18	create	evaluation	316	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.475507+00
323	18	create	evaluation	317	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.481949+00
324	18	create	evaluation	318	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.486818+00
325	18	create	evaluation	319	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.491738+00
326	18	create	evaluation	320	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.50202+00
327	18	create	evaluation	321	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.509239+00
328	18	create	evaluation	322	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.521306+00
329	18	create	evaluation	323	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.538+00
330	18	create	evaluation	324	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.557731+00
331	18	create	evaluation	325	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.592506+00
332	18	create	evaluation	326	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.60076+00
333	18	create	evaluation	327	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.608926+00
334	18	create	evaluation	328	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.615245+00
335	18	create	evaluation	329	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.621915+00
336	19	create	evaluation	330	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.628931+00
337	19	create	evaluation	331	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.635739+00
338	19	create	evaluation	332	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.640415+00
339	19	create	evaluation	333	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.645468+00
340	19	create	evaluation	334	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.652195+00
341	19	create	evaluation	335	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.662395+00
342	19	create	evaluation	336	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.668799+00
343	19	create	evaluation	337	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.674481+00
344	19	create	evaluation	338	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.67943+00
345	19	create	evaluation	339	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.684054+00
346	19	create	evaluation	340	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.688961+00
347	19	create	evaluation	341	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.695834+00
348	19	create	evaluation	342	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.701438+00
349	19	create	evaluation	343	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.706251+00
350	19	create	evaluation	344	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.711297+00
351	19	create	evaluation	345	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.716098+00
352	19	create	evaluation	346	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.720949+00
353	19	create	evaluation	347	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.725907+00
354	19	create	evaluation	348	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.730908+00
355	19	create	evaluation	349	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.738459+00
356	20	create	evaluation	350	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.743495+00
357	20	create	evaluation	351	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.748559+00
358	20	create	evaluation	352	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.753518+00
359	20	create	evaluation	353	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.764983+00
360	20	create	evaluation	354	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.770696+00
361	20	create	evaluation	355	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.775567+00
362	20	create	evaluation	356	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.780785+00
363	20	create	evaluation	357	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.785483+00
364	20	create	evaluation	358	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.790254+00
365	20	create	evaluation	359	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.795286+00
366	20	create	evaluation	360	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.800123+00
367	20	create	evaluation	361	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.805087+00
368	20	create	evaluation	362	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.809527+00
369	20	create	evaluation	363	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.814434+00
370	20	create	evaluation	364	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.818629+00
371	20	create	evaluation	365	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.823337+00
372	20	create	evaluation	366	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.82825+00
373	20	create	evaluation	367	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.833818+00
374	20	create	evaluation	368	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.838513+00
375	20	create	evaluation	369	สร้างแบบประเมิน type=supervisor	2026-10-14 10:33:46.843113+00
376	1	generate_drafts	cycle	3		2026-10-14 10:33:46.963545+00
377	18	update	evaluation	314		2026-10-14 10:39:59.044007+00
378	18	update	evaluation	314		2026-10-14 10:40:08.425407+00
379	18	submit	evaluation	314		2026-10-14 10:40:08.544851+00
380	1	approve	evaluation	314		2026-10-14 15:50:08.308382+00
381	1	approve	evaluation	3		2026-10-14 15:50:08.316247+00
382	12	update	evaluation	9		2026-10-14 15:59:17.660654+00
383	12	submit	evaluation	9		2026-10-14 15:59:17.775646+00
384	12	update	evaluation	10		2026-10-14 15:59:33.00441+00
385	12	submit	evaluation	10		2026-10-14 15:59:33.133074+00
386	12	update	evaluation	11		2026-10-14 15:59:56.783086+00
387	12	submit	evaluation	11		2026-10-14 15:59:56.878944+00
388	1	reject	evaluation	11	ทำงานหนักมาก เสนอให้ยกบริษัทให้	2026-10-14 16:01:38.237658+00
389	1	approve	evaluation	10		2026-10-14 16:03:24.679765+00
390	1	approve	evaluation	9		2026-10-14 16:03:24.683497+00
391	12	create	evaluation	370	สร้างแบบประเมิน type=self	2026-10-14 17:46:33.572583+00
392	12	submit	evaluation	370		2026-10-14 17:46:33.678848+00
393	12	update	evaluation	12		2026-10-15 02:58:04.811233+00
394	12	submit	evaluation	12		2026-10-15 02:58:04.921934+00
395	1	create	bonus	1		2026-10-15 03:38:40.633677+00
396	2	approve	bonus	1		2026-10-15 03:40:23.201207+00
397	4	update	evaluation	1		2026-10-15 03:59:49.507915+00
398	4	update	evaluation	1		2026-10-15 04:00:37.877361+00
399	4	update	evaluation	1		2026-10-15 04:01:18.38939+00
400	4	submit	evaluation	1		2026-10-15 04:01:18.486202+00
401	1	approve	evaluation	1		2026-10-15 04:03:52.87816+00
402	1	create	bonus	308		2026-10-15 05:55:40.76955+00
403	2	approve	bonus	308		2026-10-15 05:56:54.204609+00
\.


--
-- Data for Name: bonus; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bonus (id, evaluation_id, cycle_id, employee_id, base_salary, total_score, suggested_amount, amount, status, note, decision_note, created_by, decided_by, decided_at, created_at, updated_at, paid_by, paid_at, payment_note) FROM stdin;
1	3	3	27	25000	2.92	12500	12500	paid			1	2	2026-10-15 03:40:23.199043+00	2026-10-15 03:38:40.628691+00	2026-10-15 03:53:19.203628+00	3	2026-10-15 03:53:19.203071+00	
308	1	3	6	25000	4.69	50000	50000	approved			1	2	2026-10-15 05:56:54.202311+00	2026-10-15 05:55:40.767192+00	2026-10-15 05:56:54.202607+00	\N	\N	
\.


--
-- Data for Name: criteria; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.criteria (id, name, description, weight, is_active, rubric, department, level, source) FROM stdin;
1	ความรับผิดชอบ	ส่งมอบงานตรงเวลาและรับผิดชอบต่อหน้าที่	20	t	5 = ส่งตรงเวลาทุกงานและรับงานเพิ่มเอง, 3 = ส่งล่าช้าเป็นบางครั้ง, 1 = ส่งล่าช้าบ่อยหรือต้องตามงานตลอด			manual
2	การทำงานเป็นทีม	ร่วมมือ สื่อสาร และสนับสนุนเพื่อนร่วมงาน	15	t	5 = ช่วยทีมสำเร็จอย่างสม่ำเสมอ, 3 = ร่วมมือตามที่ได้รับมอบหมาย, 1 = ทำงานแยกจากทีมหรือเกิดความขัดแย้งบ่อย			manual
3	การพัฒนาตนเอง	เรียนรู้ทักษะใหม่และปรับปรุงการทำงานอย่างต่อเนื่อง	10	t	5 = พัฒนาทักษะใหม่และนำมาใช้งานได้จริงหลายครั้ง, 3 = เรียนรู้ตามที่งานต้องการ, 1 = ไม่มีการพัฒนาในรอบนี้			manual
6	ผลลัพธ์แคมเปญ	ผลลัพธ์เทียบกับเป้าหมายของแคมเปญ	30	t	5 = เกินเป้าหมายตั้งแต่ 10% ขึ้นไป, 3 = ได้ตามเป้าหมาย, 1 = ต่ำกว่าเป้าหมายมาก	การตลาด		manual
7	ความคิดสร้างสรรค์	เสนอแนวคิดใหม่ที่นำไปใช้ได้จริง	25	t	5 = เสนอแนวคิดที่ถูกนำไปใช้หลายครั้ง, 3 = มีแนวคิดใหม่เป็นบางครั้ง, 1 = ทำตามแบบเดิมเท่านั้น	การตลาด		manual
8	การเป็นพี่เลี้ยง	ให้คำปรึกษาและช่วยพัฒนาเพื่อนร่วมงานรุ่นน้อง	10	t	5 = พี่เลี้ยงให้น้องทำงานเองได้หลายคน, 3 = ตอบคำถามเมื่อถูกขอ, 1 = ไม่ช่วยเหลือน้อง		senior	manual
4	คุณภาพโค้ดและการทดสอบ	ความถูกต้องและความน่าเชื่อถือของงานที่ส่งมอบ	30	f	5 = ไม่พบบั๊กหลังส่งมอบและมีการทดสอบครบ, 3 = พบบั๊กเล็กน้อยแก้ได้ทัน, 1 = พบบั๊กบ่อยกระทบงานอื่น	พัฒนาซอฟต์แวร์		manual
9	ความสำเร็จของงาน (อัตโนมัติ)	งานที่ทำสำเร็จ ÷ งานที่ครบกำหนดในรอบ	30	t	5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)	พัฒนาซอฟต์แวร์		auto_completion
10	ส่งงานตรงเวลา (อัตโนมัติ)	งานที่ส่งตรงเวลา ÷ งานที่สำเร็จ	25	t	5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)	พัฒนาซอฟต์แวร์		auto_ontime
11	คุณภาพงานผ่านตรวจครั้งแรก (อัตโนมัติ)	งานที่ผ่านตรวจครั้งแรก ÷ งานที่ตรวจแล้ว	20	t	5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)	พัฒนาซอฟต์แวร์		auto_quality
12	ความสำเร็จของงาน (อัตโนมัติ)	งานที่ทำสำเร็จ ÷ งานที่ครบกำหนดในรอบ	20	t	5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)	การตลาด		auto_completion
13	ส่งงานตรงเวลา (อัตโนมัติ)	งานที่ส่งตรงเวลา ÷ งานที่สำเร็จ	15	t	5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)	การตลาด		auto_ontime
14	คุณภาพงานผ่านตรวจครั้งแรก (อัตโนมัติ)	งานที่ผ่านตรวจครั้งแรก ÷ งานที่ตรวจแล้ว	10	t	5 = ≥90%, 4 = ≥80%, 3 = ≥70%, 2 = ≥60%, 1 = ต่ำกว่า 60% (ระบบคำนวณจากข้อมูลงาน)	การตลาด		auto_quality
5	การส่งมอบตามสเปก	ฟีเจอร์ครบตามข้อกำหนดที่ตกลงไว้	25	f	5 = ครบทุกข้อและเกินสเปก, 3 = ครบข้อหลัก ขาดข้อรองบางส่วน, 1 = ขาดข้อหลักหรือแก้ไขซ้ำหลายรอบ	พัฒนาซอฟต์แวร์		manual
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.departments (id, name) FROM stdin;
1	บัญชี
2	การตลาด
3	พัฒนาซอฟต์แวร์
4	บริหาร
5	ทรัพยากรบุคคล
\.


--
-- Data for Name: evaluation_cycles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.evaluation_cycles (id, name, start_date, end_date, status, created_at) FROM stdin;
1	ครึ่งปีหลัง 2025	2025-07-01 00:00:00+00	2025-12-31 00:00:00+00	closed	2026-10-14 01:52:15.183347+00
2	ครึ่งปีแรก 2026	2026-01-01 00:00:00+00	2026-06-30 00:00:00+00	closed	2026-10-14 01:52:15.185032+00
3	ครึ่งปีหลัง 2026	2026-07-01 00:00:00+00	2026-12-31 00:00:00+00	open	2026-10-14 01:52:15.186322+00
\.


--
-- Data for Name: evaluation_scores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.evaluation_scores (id, evaluation_id, criteria_id, score, comment, weight, source, metric, detail) FROM stdin;
8	2	1	4		20	manual	0	
9	2	2	4		15	manual	0	
10	2	3	4		10	manual	0	
11	2	9	4		30	auto_completion	80	16/20 งาน (80.0%)
12	2	10	4		25	auto_ontime	87.5	14/16 งาน (87.5%)
13	2	11	3		20	auto_quality	75	12/16 งาน (75.0%)
1884	307	1	0		20	manual	0	
1885	307	2	0		15	manual	0	
1886	307	3	0		10	manual	0	
1887	307	6	0		30	manual	0	
1888	307	7	0		25	manual	0	
1889	307	8	0		10	manual	0	
1890	307	12	0		20	manual	0	
1891	307	13	0		15	manual	0	
1892	307	14	0		10	manual	0	
1893	308	1	0		20	manual	0	
1894	308	2	0		15	manual	0	
1895	308	3	0		10	manual	0	
1896	308	6	0		30	manual	0	
1897	308	7	0		25	manual	0	
1898	308	12	0		20	manual	0	
1899	308	13	0		15	manual	0	
1900	308	14	0		10	manual	0	
1901	309	1	0		20	manual	0	
32	3	1	5		20	manual	0	
33	3	2	3		15	manual	0	
34	3	3	5		10	manual	0	
35	3	9	3		30	auto_completion	75	12/16 งาน (75.0%)
36	3	10	1		25	auto_ontime	50	6/12 งาน (50.0%)
37	3	11	2		20	auto_quality	66.67	8/12 งาน (66.7%)
38	4	1	5		20	manual	0	
39	4	2	5		15	manual	0	
40	4	3	5		10	manual	0	
41	4	9	0		30	manual	0	
42	4	10	0		25	manual	0	
43	4	11	0		20	manual	0	
44	5	1	0		20	manual	0	
45	5	2	0		15	manual	0	
46	5	3	0		10	manual	0	
47	5	9	2		30	auto_completion	66.67	12/18 งาน (66.7%)
48	5	10	3		25	auto_ontime	75	9/12 งาน (75.0%)
49	5	11	1		20	auto_quality	50	6/12 งาน (50.0%)
1902	309	2	0		15	manual	0	
1903	309	3	0		10	manual	0	
1904	309	6	0		30	manual	0	
1905	309	7	0		25	manual	0	
90	13	1	0		20	manual	0	
91	13	2	0		15	manual	0	
92	13	3	0		10	manual	0	
93	13	8	0		10	manual	0	
94	13	9	3		30	auto_completion	72.73	16/22 งาน (72.7%)
95	13	10	2		25	auto_ontime	68.75	11/16 งาน (68.8%)
96	13	11	1		20	auto_quality	50	8/16 งาน (50.0%)
97	14	1	0		20	manual	0	
98	14	2	0		15	manual	0	
99	14	3	0		10	manual	0	
100	14	8	0		10	manual	0	
101	14	9	2		30	auto_completion	60	9/15 งาน (60.0%)
102	14	10	3		25	auto_ontime	77.78	7/9 งาน (77.8%)
103	14	11	1		20	auto_quality	44.44	4/9 งาน (44.4%)
104	15	1	0		20	manual	0	
105	15	2	0		15	manual	0	
106	15	3	0		10	manual	0	
107	15	8	0		10	manual	0	
108	15	9	1		30	auto_completion	52.38	11/21 งาน (52.4%)
109	15	10	1		25	auto_ontime	45.45	5/11 งาน (45.5%)
110	15	11	1		20	auto_quality	45.45	5/11 งาน (45.5%)
111	16	1	0		20	manual	0	
112	16	2	0		15	manual	0	
113	16	3	0		10	manual	0	
114	16	9	5		30	auto_completion	100	18/18 งาน (100.0%)
115	16	10	4		25	auto_ontime	88.89	16/18 งาน (88.9%)
116	16	11	4		20	auto_quality	83.33	15/18 งาน (83.3%)
117	17	1	0		20	manual	0	
118	17	2	0		15	manual	0	
119	17	3	0		10	manual	0	
120	17	9	4		30	auto_completion	82.61	19/23 งาน (82.6%)
121	17	10	3		25	auto_ontime	73.68	14/19 งาน (73.7%)
122	17	11	3		20	auto_quality	73.68	14/19 งาน (73.7%)
123	18	1	0		20	manual	0	
124	18	2	0		15	manual	0	
125	18	3	0		10	manual	0	
126	18	9	5		30	auto_completion	100	21/21 งาน (100.0%)
127	18	10	3		25	auto_ontime	71.43	15/21 งาน (71.4%)
128	18	11	4		20	auto_quality	85.71	18/21 งาน (85.7%)
129	19	1	0		20	manual	0	
130	19	2	0		15	manual	0	
131	19	3	0		10	manual	0	
132	19	9	5		30	auto_completion	100	17/17 งาน (100.0%)
133	19	10	5		25	auto_ontime	94.12	16/17 งาน (94.1%)
134	19	11	5		20	auto_quality	100	17/17 งาน (100.0%)
135	20	1	0		20	manual	0	
136	20	2	0		15	manual	0	
137	20	3	0		10	manual	0	
138	20	9	3		30	auto_completion	73.68	14/19 งาน (73.7%)
139	20	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
140	20	11	5		20	auto_quality	92.86	13/14 งาน (92.9%)
141	21	1	0		20	manual	0	
142	21	2	0		15	manual	0	
143	21	3	0		10	manual	0	
144	21	9	3		30	auto_completion	70	14/20 งาน (70.0%)
145	21	10	1		25	auto_ontime	57.14	8/14 งาน (57.1%)
146	21	11	1		20	auto_quality	57.14	8/14 งาน (57.1%)
147	22	1	0		20	manual	0	
148	22	2	0		15	manual	0	
149	22	3	0		10	manual	0	
150	22	9	5		30	auto_completion	94.12	16/17 งาน (94.1%)
151	22	10	5		25	auto_ontime	100	16/16 งาน (100.0%)
152	22	11	5		20	auto_quality	93.75	15/16 งาน (93.8%)
153	23	1	0		20	manual	0	
154	23	2	0		15	manual	0	
155	23	3	0		10	manual	0	
156	23	8	0		10	manual	0	
157	23	9	5		30	auto_completion	92	23/25 งาน (92.0%)
158	23	10	3		25	auto_ontime	78.26	18/23 งาน (78.3%)
159	23	11	3		20	auto_quality	73.91	17/23 งาน (73.9%)
160	24	1	0		20	manual	0	
161	24	2	0		15	manual	0	
162	24	3	0		10	manual	0	
163	24	8	0		10	manual	0	
164	24	9	3		30	auto_completion	76.19	16/21 งาน (76.2%)
165	24	10	2		25	auto_ontime	68.75	11/16 งาน (68.8%)
166	24	11	1		20	auto_quality	56.25	9/16 งาน (56.2%)
167	25	1	0		20	manual	0	
168	25	2	0		15	manual	0	
169	25	3	0		10	manual	0	
170	25	8	0		10	manual	0	
171	25	9	5		30	auto_completion	91.67	22/24 งาน (91.7%)
172	25	10	5		25	auto_ontime	90.91	20/22 งาน (90.9%)
173	25	11	4		20	auto_quality	86.36	19/22 งาน (86.4%)
174	26	1	0		20	manual	0	
175	26	2	0		15	manual	0	
176	26	3	0		10	manual	0	
177	26	9	4		30	auto_completion	84.21	16/19 งาน (84.2%)
178	26	10	5		25	auto_ontime	93.75	15/16 งาน (93.8%)
179	26	11	4		20	auto_quality	81.25	13/16 งาน (81.2%)
180	27	1	0		20	manual	0	
181	27	2	0		15	manual	0	
182	27	3	0		10	manual	0	
183	27	9	4		30	auto_completion	88.89	16/18 งาน (88.9%)
184	27	10	4		25	auto_ontime	87.5	14/16 งาน (87.5%)
185	27	11	4		20	auto_quality	87.5	14/16 งาน (87.5%)
186	28	1	0		20	manual	0	
187	28	2	0		15	manual	0	
188	28	3	0		10	manual	0	
189	28	9	5		30	auto_completion	100	18/18 งาน (100.0%)
190	28	10	4		25	auto_ontime	88.89	16/18 งาน (88.9%)
191	28	11	5		20	auto_quality	100	18/18 งาน (100.0%)
192	29	1	0		20	manual	0	
193	29	2	0		15	manual	0	
194	29	3	0		10	manual	0	
195	29	9	4		30	auto_completion	85.71	18/21 งาน (85.7%)
196	29	10	5		25	auto_ontime	94.44	17/18 งาน (94.4%)
197	29	11	4		20	auto_quality	88.89	16/18 งาน (88.9%)
198	30	1	0		20	manual	0	
199	30	2	0		15	manual	0	
200	30	3	0		10	manual	0	
201	30	9	5		30	auto_completion	100	20/20 งาน (100.0%)
202	30	10	5		25	auto_ontime	95	19/20 งาน (95.0%)
203	30	11	5		20	auto_quality	95	19/20 งาน (95.0%)
204	31	1	0		20	manual	0	
205	31	2	0		15	manual	0	
206	31	3	0		10	manual	0	
207	31	9	5		30	auto_completion	100	22/22 งาน (100.0%)
208	31	10	3		25	auto_ontime	77.27	17/22 งาน (77.3%)
209	31	11	5		20	auto_quality	90.91	20/22 งาน (90.9%)
210	32	1	0		20	manual	0	
211	32	2	0		15	manual	0	
212	32	3	0		10	manual	0	
213	32	8	0		10	manual	0	
214	32	9	3		30	auto_completion	76	19/25 งาน (76.0%)
215	32	10	3		25	auto_ontime	73.68	14/19 งาน (73.7%)
216	32	11	1		20	auto_quality	52.63	10/19 งาน (52.6%)
217	33	1	0		20	manual	0	
218	33	2	0		15	manual	0	
219	33	3	0		10	manual	0	
220	33	8	0		10	manual	0	
221	33	9	5		30	auto_completion	92	23/25 งาน (92.0%)
222	33	10	5		25	auto_ontime	95.65	22/23 งาน (95.7%)
223	33	11	5		20	auto_quality	91.3	21/23 งาน (91.3%)
224	34	1	0		20	manual	0	
225	34	2	0		15	manual	0	
226	34	3	0		10	manual	0	
227	34	8	0		10	manual	0	
228	34	9	1		30	auto_completion	50	10/20 งาน (50.0%)
229	34	10	1		25	auto_ontime	50	5/10 งาน (50.0%)
230	34	11	1		20	auto_quality	50	5/10 งาน (50.0%)
231	35	1	0		20	manual	0	
232	35	2	0		15	manual	0	
233	35	3	0		10	manual	0	
234	35	9	3		30	auto_completion	78.95	15/19 งาน (79.0%)
235	35	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
236	35	11	1		20	auto_quality	46.67	7/15 งาน (46.7%)
237	36	1	0		20	manual	0	
238	36	2	0		15	manual	0	
239	36	3	0		10	manual	0	
240	36	9	3		30	auto_completion	75	12/16 งาน (75.0%)
241	36	10	4		25	auto_ontime	83.33	10/12 งาน (83.3%)
242	36	11	3		20	auto_quality	75	9/12 งาน (75.0%)
243	37	1	0		20	manual	0	
244	37	2	0		15	manual	0	
245	37	3	0		10	manual	0	
246	37	9	3		30	auto_completion	72	18/25 งาน (72.0%)
247	37	10	5		25	auto_ontime	94.44	17/18 งาน (94.4%)
248	37	11	3		20	auto_quality	72.22	13/18 งาน (72.2%)
249	38	1	0		20	manual	0	
250	38	2	0		15	manual	0	
251	38	3	0		10	manual	0	
252	38	9	5		30	auto_completion	93.33	14/15 งาน (93.3%)
253	38	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
254	38	11	1		20	auto_quality	50	7/14 งาน (50.0%)
255	39	1	0		20	manual	0	
256	39	2	0		15	manual	0	
257	39	3	0		10	manual	0	
258	39	9	5		30	auto_completion	95	19/20 งาน (95.0%)
259	39	10	4		25	auto_ontime	84.21	16/19 งาน (84.2%)
260	39	11	4		20	auto_quality	89.47	17/19 งาน (89.5%)
261	40	1	0		20	manual	0	
262	40	2	0		15	manual	0	
263	40	3	0		10	manual	0	
264	40	9	5		30	auto_completion	100	17/17 งาน (100.0%)
265	40	10	3		25	auto_ontime	76.47	13/17 งาน (76.5%)
266	40	11	5		20	auto_quality	94.12	16/17 งาน (94.1%)
267	41	1	0		20	manual	0	
268	41	2	0		15	manual	0	
269	41	3	0		10	manual	0	
270	41	9	5		30	auto_completion	92	23/25 งาน (92.0%)
271	41	10	4		25	auto_ontime	82.61	19/23 งาน (82.6%)
272	41	11	2		20	auto_quality	60.87	14/23 งาน (60.9%)
273	42	1	0		20	manual	0	
274	42	2	0		15	manual	0	
275	42	3	0		10	manual	0	
276	42	8	0		10	manual	0	
277	42	9	4		30	auto_completion	88.24	15/17 งาน (88.2%)
278	42	10	4		25	auto_ontime	80	12/15 งาน (80.0%)
279	42	11	4		20	auto_quality	86.67	13/15 งาน (86.7%)
280	43	1	0		20	manual	0	
281	43	2	0		15	manual	0	
282	43	3	0		10	manual	0	
283	43	8	0		10	manual	0	
284	43	9	4		30	auto_completion	86.67	13/15 งาน (86.7%)
285	43	10	5		25	auto_ontime	92.31	12/13 งาน (92.3%)
286	43	11	3		20	auto_quality	76.92	10/13 งาน (76.9%)
287	44	1	0		20	manual	0	
288	44	2	0		15	manual	0	
289	44	3	0		10	manual	0	
290	44	8	0		10	manual	0	
291	44	9	5		30	auto_completion	100	15/15 งาน (100.0%)
292	44	10	5		25	auto_ontime	100	15/15 งาน (100.0%)
293	44	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
294	45	1	0		20	manual	0	
295	45	2	0		15	manual	0	
296	45	3	0		10	manual	0	
297	45	9	1		30	auto_completion	47.83	11/23 งาน (47.8%)
298	45	10	3		25	auto_ontime	72.73	8/11 งาน (72.7%)
299	45	11	1		20	auto_quality	45.45	5/11 งาน (45.5%)
300	46	1	0		20	manual	0	
301	46	2	0		15	manual	0	
302	46	3	0		10	manual	0	
303	46	9	1		30	auto_completion	57.89	11/19 งาน (57.9%)
304	46	10	1		25	auto_ontime	54.55	6/11 งาน (54.5%)
305	46	11	1		20	auto_quality	45.45	5/11 งาน (45.5%)
306	47	1	0		20	manual	0	
307	47	2	0		15	manual	0	
308	47	3	0		10	manual	0	
309	47	9	4		30	auto_completion	88.24	15/17 งาน (88.2%)
310	47	10	5		25	auto_ontime	93.33	14/15 งาน (93.3%)
311	47	11	5		20	auto_quality	100	15/15 งาน (100.0%)
312	48	1	0		20	manual	0	
313	48	2	0		15	manual	0	
314	48	3	0		10	manual	0	
315	48	9	5		30	auto_completion	100	24/24 งาน (100.0%)
316	48	10	5		25	auto_ontime	95.83	23/24 งาน (95.8%)
317	48	11	4		20	auto_quality	83.33	20/24 งาน (83.3%)
318	49	1	0		20	manual	0	
319	49	2	0		15	manual	0	
320	49	3	0		10	manual	0	
321	49	9	5		30	auto_completion	95.45	21/22 งาน (95.5%)
322	49	10	5		25	auto_ontime	100	21/21 งาน (100.0%)
323	49	11	4		20	auto_quality	80.95	17/21 งาน (81.0%)
324	50	1	0		20	manual	0	
325	50	2	0		15	manual	0	
326	50	3	0		10	manual	0	
327	50	9	3		30	auto_completion	77.27	17/22 งาน (77.3%)
328	50	10	2		25	auto_ontime	64.71	11/17 งาน (64.7%)
329	50	11	5		20	auto_quality	94.12	16/17 งาน (94.1%)
330	51	1	0		20	manual	0	
331	51	2	0		15	manual	0	
332	51	3	0		10	manual	0	
333	51	9	4		30	auto_completion	82.35	14/17 งาน (82.3%)
334	51	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
335	51	11	2		20	auto_quality	64.29	9/14 งาน (64.3%)
336	52	1	0		20	manual	0	
337	52	2	0		15	manual	0	
338	52	3	0		10	manual	0	
339	52	8	0		10	manual	0	
340	52	9	4		30	auto_completion	83.33	20/24 งาน (83.3%)
341	52	10	3		25	auto_ontime	70	14/20 งาน (70.0%)
342	52	11	3		20	auto_quality	75	15/20 งาน (75.0%)
343	53	1	0		20	manual	0	
344	53	2	0		15	manual	0	
345	53	3	0		10	manual	0	
346	53	8	0		10	manual	0	
347	53	9	5		30	auto_completion	96	24/25 งาน (96.0%)
348	53	10	4		25	auto_ontime	87.5	21/24 งาน (87.5%)
349	53	11	5		20	auto_quality	91.67	22/24 งาน (91.7%)
350	54	1	0		20	manual	0	
351	54	2	0		15	manual	0	
352	54	3	0		10	manual	0	
353	54	8	0		10	manual	0	
354	54	9	4		30	auto_completion	80	16/20 งาน (80.0%)
355	54	10	5		25	auto_ontime	93.75	15/16 งาน (93.8%)
356	54	11	4		20	auto_quality	87.5	14/16 งาน (87.5%)
357	55	1	0		20	manual	0	
358	55	2	0		15	manual	0	
359	55	3	0		10	manual	0	
360	55	9	5		30	auto_completion	100	25/25 งาน (100.0%)
361	55	10	5		25	auto_ontime	92	23/25 งาน (92.0%)
362	55	11	5		20	auto_quality	96	24/25 งาน (96.0%)
363	56	1	0		20	manual	0	
364	56	2	0		15	manual	0	
365	56	3	0		10	manual	0	
366	56	9	0		30	manual	0	
367	56	10	0		25	manual	0	
368	56	11	0		20	manual	0	
369	57	1	0		20	manual	0	
370	57	2	0		15	manual	0	
371	57	3	0		10	manual	0	
372	57	9	5		30	auto_completion	90.48	19/21 งาน (90.5%)
373	57	10	4		25	auto_ontime	84.21	16/19 งาน (84.2%)
374	57	11	3		20	auto_quality	78.95	15/19 งาน (79.0%)
375	58	1	0		20	manual	0	
376	58	2	0		15	manual	0	
377	58	3	0		10	manual	0	
378	58	9	4		30	auto_completion	87.5	14/16 งาน (87.5%)
379	58	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
380	58	11	1		20	auto_quality	50	7/14 งาน (50.0%)
381	59	1	0		20	manual	0	
382	59	2	0		15	manual	0	
383	59	3	0		10	manual	0	
384	59	9	3		30	auto_completion	77.27	17/22 งาน (77.3%)
385	59	10	4		25	auto_ontime	88.24	15/17 งาน (88.2%)
386	59	11	2		20	auto_quality	64.71	11/17 งาน (64.7%)
387	60	1	0		20	manual	0	
388	60	2	0		15	manual	0	
389	60	3	0		10	manual	0	
390	60	9	4		30	auto_completion	86.67	13/15 งาน (86.7%)
391	60	10	4		25	auto_ontime	84.62	11/13 งาน (84.6%)
392	60	11	3		20	auto_quality	76.92	10/13 งาน (76.9%)
393	61	1	0		20	manual	0	
394	61	2	0		15	manual	0	
395	61	3	0		10	manual	0	
396	61	9	5		30	auto_completion	100	21/21 งาน (100.0%)
397	61	10	5		25	auto_ontime	90.48	19/21 งาน (90.5%)
398	61	11	4		20	auto_quality	85.71	18/21 งาน (85.7%)
399	62	1	0		20	manual	0	
400	62	2	0		15	manual	0	
401	62	3	0		10	manual	0	
402	62	8	0		10	manual	0	
403	62	9	4		30	auto_completion	80	12/15 งาน (80.0%)
404	62	10	5		25	auto_ontime	91.67	11/12 งาน (91.7%)
405	62	11	1		20	auto_quality	58.33	7/12 งาน (58.3%)
406	63	1	0		20	manual	0	
407	63	2	0		15	manual	0	
408	63	3	0		10	manual	0	
409	63	8	0		10	manual	0	
410	63	9	1		30	auto_completion	56.25	9/16 งาน (56.2%)
411	63	10	2		25	auto_ontime	66.67	6/9 งาน (66.7%)
412	63	11	1		20	auto_quality	33.33	3/9 งาน (33.3%)
413	64	1	0		20	manual	0	
414	64	2	0		15	manual	0	
415	64	3	0		10	manual	0	
416	64	8	0		10	manual	0	
417	64	9	3		30	auto_completion	70.83	17/24 งาน (70.8%)
418	64	10	4		25	auto_ontime	88.24	15/17 งาน (88.2%)
419	64	11	3		20	auto_quality	70.59	12/17 งาน (70.6%)
420	65	1	0		20	manual	0	
421	65	2	0		15	manual	0	
422	65	3	0		10	manual	0	
423	65	9	2		30	auto_completion	63.64	14/22 งาน (63.6%)
424	65	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
425	65	11	3		20	auto_quality	71.43	10/14 งาน (71.4%)
426	66	1	0		20	manual	0	
427	66	2	0		15	manual	0	
428	66	3	0		10	manual	0	
429	66	9	5		30	auto_completion	100	21/21 งาน (100.0%)
430	66	10	5		25	auto_ontime	90.48	19/21 งาน (90.5%)
431	66	11	5		20	auto_quality	90.48	19/21 งาน (90.5%)
432	67	1	0		20	manual	0	
433	67	2	0		15	manual	0	
434	67	3	0		10	manual	0	
435	67	9	5		30	auto_completion	91.3	21/23 งาน (91.3%)
436	67	10	3		25	auto_ontime	71.43	15/21 งาน (71.4%)
437	67	11	4		20	auto_quality	85.71	18/21 งาน (85.7%)
438	68	1	0		20	manual	0	
439	68	2	0		15	manual	0	
440	68	3	0		10	manual	0	
441	68	9	3		30	auto_completion	75	15/20 งาน (75.0%)
442	68	10	3		25	auto_ontime	73.33	11/15 งาน (73.3%)
443	68	11	1		20	auto_quality	33.33	5/15 งาน (33.3%)
444	69	1	0		20	manual	0	
445	69	2	0		15	manual	0	
446	69	3	0		10	manual	0	
447	69	9	5		30	auto_completion	100	19/19 งาน (100.0%)
448	69	10	5		25	auto_ontime	94.74	18/19 งาน (94.7%)
449	69	11	4		20	auto_quality	89.47	17/19 งาน (89.5%)
450	70	1	0		20	manual	0	
451	70	2	0		15	manual	0	
452	70	3	0		10	manual	0	
453	70	9	3		30	auto_completion	77.78	14/18 งาน (77.8%)
454	70	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
455	70	11	5		20	auto_quality	92.86	13/14 งาน (92.9%)
456	71	1	0		20	manual	0	
457	71	2	0		15	manual	0	
458	71	3	0		10	manual	0	
459	71	9	5		30	auto_completion	100	25/25 งาน (100.0%)
460	71	10	5		25	auto_ontime	96	24/25 งาน (96.0%)
461	71	11	5		20	auto_quality	96	24/25 งาน (96.0%)
462	72	1	0		20	manual	0	
463	72	2	0		15	manual	0	
464	72	3	0		10	manual	0	
465	72	8	0		10	manual	0	
466	72	9	1		30	auto_completion	47.62	10/21 งาน (47.6%)
467	72	10	4		25	auto_ontime	80	8/10 งาน (80.0%)
468	72	11	1		20	auto_quality	50	5/10 งาน (50.0%)
469	73	1	0		20	manual	0	
470	73	2	0		15	manual	0	
471	73	3	0		10	manual	0	
472	73	8	0		10	manual	0	
473	73	9	4		30	auto_completion	88	22/25 งาน (88.0%)
474	73	10	4		25	auto_ontime	81.82	18/22 งาน (81.8%)
475	73	11	3		20	auto_quality	77.27	17/22 งาน (77.3%)
476	74	1	0		20	manual	0	
477	74	2	0		15	manual	0	
478	74	3	0		10	manual	0	
479	74	8	0		10	manual	0	
480	74	9	2		30	auto_completion	63.64	14/22 งาน (63.6%)
481	74	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
482	74	11	2		20	auto_quality	64.29	9/14 งาน (64.3%)
483	75	1	0		20	manual	0	
484	75	2	0		15	manual	0	
485	75	3	0		10	manual	0	
486	75	9	1		30	auto_completion	52	13/25 งาน (52.0%)
487	75	10	3		25	auto_ontime	76.92	10/13 งาน (76.9%)
488	75	11	1		20	auto_quality	46.15	6/13 งาน (46.1%)
489	76	1	0		20	manual	0	
490	76	2	0		15	manual	0	
491	76	3	0		10	manual	0	
492	76	9	4		30	auto_completion	86.36	19/22 งาน (86.4%)
493	76	10	4		25	auto_ontime	84.21	16/19 งาน (84.2%)
494	76	11	4		20	auto_quality	89.47	17/19 งาน (89.5%)
495	77	1	0		20	manual	0	
496	77	2	0		15	manual	0	
497	77	3	0		10	manual	0	
498	77	9	5		30	auto_completion	95.45	21/22 งาน (95.5%)
499	77	10	5		25	auto_ontime	95.24	20/21 งาน (95.2%)
500	77	11	4		20	auto_quality	85.71	18/21 งาน (85.7%)
501	78	1	0		20	manual	0	
502	78	2	0		15	manual	0	
503	78	3	0		10	manual	0	
504	78	9	5		30	auto_completion	94.12	16/17 งาน (94.1%)
505	78	10	5		25	auto_ontime	93.75	15/16 งาน (93.8%)
506	78	11	5		20	auto_quality	93.75	15/16 งาน (93.8%)
507	79	1	0		20	manual	0	
508	79	2	0		15	manual	0	
509	79	3	0		10	manual	0	
510	79	9	5		30	auto_completion	100	15/15 งาน (100.0%)
511	79	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
512	79	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
513	80	1	0		20	manual	0	
514	80	2	0		15	manual	0	
515	80	3	0		10	manual	0	
516	80	9	5		30	auto_completion	94.74	18/19 งาน (94.7%)
517	80	10	5		25	auto_ontime	100	18/18 งาน (100.0%)
518	80	11	4		20	auto_quality	83.33	15/18 งาน (83.3%)
519	81	1	0		20	manual	0	
520	81	2	0		15	manual	0	
521	81	3	0		10	manual	0	
522	81	9	0		30	manual	0	
523	81	10	0		25	manual	0	
524	81	11	0		20	manual	0	
525	82	1	0		20	manual	0	
526	82	2	0		15	manual	0	
527	82	3	0		10	manual	0	
528	82	8	0		10	manual	0	
529	82	9	4		30	auto_completion	82.35	14/17 งาน (82.3%)
530	82	10	3		25	auto_ontime	78.57	11/14 งาน (78.6%)
531	82	11	2		20	auto_quality	64.29	9/14 งาน (64.3%)
532	83	1	0		20	manual	0	
533	83	2	0		15	manual	0	
534	83	3	0		10	manual	0	
535	83	8	0		10	manual	0	
536	83	9	4		30	auto_completion	87.5	21/24 งาน (87.5%)
537	83	10	4		25	auto_ontime	80.95	17/21 งาน (81.0%)
538	83	11	4		20	auto_quality	80.95	17/21 งาน (81.0%)
539	84	1	0		20	manual	0	
540	84	2	0		15	manual	0	
541	84	3	0		10	manual	0	
542	84	8	0		10	manual	0	
543	84	9	5		30	auto_completion	100	16/16 งาน (100.0%)
544	84	10	5		25	auto_ontime	100	16/16 งาน (100.0%)
545	84	11	5		20	auto_quality	93.75	15/16 งาน (93.8%)
546	85	1	0		20	manual	0	
547	85	2	0		15	manual	0	
548	85	3	0		10	manual	0	
549	85	9	4		30	auto_completion	83.33	20/24 งาน (83.3%)
550	85	10	4		25	auto_ontime	85	17/20 งาน (85.0%)
551	85	11	1		20	auto_quality	55	11/20 งาน (55.0%)
552	86	1	0		20	manual	0	
553	86	2	0		15	manual	0	
554	86	3	0		10	manual	0	
555	86	9	4		30	auto_completion	87.5	14/16 งาน (87.5%)
556	86	10	5		25	auto_ontime	92.86	13/14 งาน (92.9%)
557	86	11	4		20	auto_quality	85.71	12/14 งาน (85.7%)
558	87	1	0		20	manual	0	
559	87	2	0		15	manual	0	
560	87	3	0		10	manual	0	
561	87	9	3		30	auto_completion	73.33	11/15 งาน (73.3%)
562	87	10	5		25	auto_ontime	90.91	10/11 งาน (90.9%)
563	87	11	4		20	auto_quality	81.82	9/11 งาน (81.8%)
564	88	1	0		20	manual	0	
565	88	2	0		15	manual	0	
566	88	3	0		10	manual	0	
567	88	9	4		30	auto_completion	85	17/20 งาน (85.0%)
568	88	10	3		25	auto_ontime	70.59	12/17 งาน (70.6%)
569	88	11	4		20	auto_quality	82.35	14/17 งาน (82.3%)
570	89	1	0		20	manual	0	
571	89	2	0		15	manual	0	
572	89	3	0		10	manual	0	
573	89	9	5		30	auto_completion	94.44	17/18 งาน (94.4%)
574	89	10	5		25	auto_ontime	94.12	16/17 งาน (94.1%)
575	89	11	4		20	auto_quality	88.24	15/17 งาน (88.2%)
576	90	1	0		20	manual	0	
577	90	2	0		15	manual	0	
578	90	3	0		10	manual	0	
579	90	9	5		30	auto_completion	93.75	15/16 งาน (93.8%)
580	90	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
581	90	11	2		20	auto_quality	66.67	10/15 งาน (66.7%)
582	91	1	0		20	manual	0	
583	91	2	0		15	manual	0	
584	91	3	0		10	manual	0	
585	91	9	3		30	auto_completion	71.43	15/21 งาน (71.4%)
586	91	10	3		25	auto_ontime	73.33	11/15 งาน (73.3%)
587	91	11	4		20	auto_quality	80	12/15 งาน (80.0%)
588	92	1	0		20	manual	0	
589	92	2	0		15	manual	0	
590	92	3	0		10	manual	0	
591	92	8	0		10	manual	0	
592	92	9	4		30	auto_completion	88.24	15/17 งาน (88.2%)
593	92	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
594	92	11	4		20	auto_quality	86.67	13/15 งาน (86.7%)
595	93	1	0		20	manual	0	
596	93	2	0		15	manual	0	
597	93	3	0		10	manual	0	
598	93	8	0		10	manual	0	
599	93	9	3		30	auto_completion	70.59	12/17 งาน (70.6%)
600	93	10	5		25	auto_ontime	100	12/12 งาน (100.0%)
601	93	11	2		20	auto_quality	66.67	8/12 งาน (66.7%)
602	94	1	0		20	manual	0	
603	94	2	0		15	manual	0	
604	94	3	0		10	manual	0	
605	94	8	0		10	manual	0	
606	94	9	1		30	auto_completion	52.63	10/19 งาน (52.6%)
607	94	10	5		25	auto_ontime	90	9/10 งาน (90.0%)
608	94	11	1		20	auto_quality	50	5/10 งาน (50.0%)
609	95	1	0		20	manual	0	
610	95	2	0		15	manual	0	
611	95	3	0		10	manual	0	
612	95	9	5		30	auto_completion	100	15/15 งาน (100.0%)
613	95	10	5		25	auto_ontime	100	15/15 งาน (100.0%)
614	95	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
615	96	1	0		20	manual	0	
616	96	2	0		15	manual	0	
617	96	3	0		10	manual	0	
618	96	9	5		30	auto_completion	94.74	18/19 งาน (94.7%)
619	96	10	3		25	auto_ontime	72.22	13/18 งาน (72.2%)
620	96	11	3		20	auto_quality	72.22	13/18 งาน (72.2%)
621	97	1	0		20	manual	0	
622	97	2	0		15	manual	0	
623	97	3	0		10	manual	0	
624	97	9	5		30	auto_completion	100	24/24 งาน (100.0%)
625	97	10	4		25	auto_ontime	83.33	20/24 งาน (83.3%)
626	97	11	3		20	auto_quality	79.17	19/24 งาน (79.2%)
627	98	1	0		20	manual	0	
628	98	2	0		15	manual	0	
629	98	3	0		10	manual	0	
630	98	9	3		30	auto_completion	76.19	16/21 งาน (76.2%)
631	98	10	2		25	auto_ontime	62.5	10/16 งาน (62.5%)
632	98	11	1		20	auto_quality	56.25	9/16 งาน (56.2%)
633	99	1	0		20	manual	0	
634	99	2	0		15	manual	0	
635	99	3	0		10	manual	0	
636	99	9	1		30	auto_completion	58.33	14/24 งาน (58.3%)
637	99	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
638	99	11	1		20	auto_quality	57.14	8/14 งาน (57.1%)
639	100	1	0		20	manual	0	
640	100	2	0		15	manual	0	
641	100	3	0		10	manual	0	
642	100	9	5		30	auto_completion	100	16/16 งาน (100.0%)
643	100	10	3		25	auto_ontime	75	12/16 งาน (75.0%)
644	100	11	4		20	auto_quality	81.25	13/16 งาน (81.2%)
645	101	1	0		20	manual	0	
646	101	2	0		15	manual	0	
647	101	3	0		10	manual	0	
648	101	9	2		30	auto_completion	65.22	15/23 งาน (65.2%)
649	101	10	1		25	auto_ontime	46.67	7/15 งาน (46.7%)
650	101	11	2		20	auto_quality	66.67	10/15 งาน (66.7%)
651	102	1	0		20	manual	0	
652	102	2	0		15	manual	0	
653	102	3	0		10	manual	0	
654	102	8	0		10	manual	0	
655	102	9	4		30	auto_completion	81.25	13/16 งาน (81.2%)
656	102	10	3		25	auto_ontime	76.92	10/13 งาน (76.9%)
657	102	11	1		20	auto_quality	30.77	4/13 งาน (30.8%)
658	103	1	0		20	manual	0	
659	103	2	0		15	manual	0	
660	103	3	0		10	manual	0	
661	103	8	0		10	manual	0	
662	103	9	4		30	auto_completion	80.95	17/21 งาน (81.0%)
663	103	10	4		25	auto_ontime	88.24	15/17 งาน (88.2%)
664	103	11	3		20	auto_quality	76.47	13/17 งาน (76.5%)
665	104	1	0		20	manual	0	
666	104	2	0		15	manual	0	
667	104	3	0		10	manual	0	
668	104	8	0		10	manual	0	
669	104	9	4		30	auto_completion	80	12/15 งาน (80.0%)
670	104	10	1		25	auto_ontime	58.33	7/12 งาน (58.3%)
671	104	11	1		20	auto_quality	58.33	7/12 งาน (58.3%)
672	105	1	0		20	manual	0	
673	105	2	0		15	manual	0	
674	105	3	0		10	manual	0	
675	105	9	5		30	auto_completion	100	15/15 งาน (100.0%)
676	105	10	5		25	auto_ontime	93.33	14/15 งาน (93.3%)
677	105	11	4		20	auto_quality	86.67	13/15 งาน (86.7%)
678	106	1	0		20	manual	0	
679	106	2	0		15	manual	0	
680	106	3	0		10	manual	0	
681	106	9	0		30	manual	0	
682	106	10	0		25	manual	0	
683	106	11	0		20	manual	0	
684	107	1	0		20	manual	0	
685	107	2	0		15	manual	0	
686	107	3	0		10	manual	0	
687	107	9	5		30	auto_completion	100	15/15 งาน (100.0%)
688	107	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
689	107	11	4		20	auto_quality	86.67	13/15 งาน (86.7%)
690	108	1	0		20	manual	0	
691	108	2	0		15	manual	0	
692	108	3	0		10	manual	0	
693	108	9	1		30	auto_completion	59.09	13/22 งาน (59.1%)
694	108	10	1		25	auto_ontime	53.85	7/13 งาน (53.9%)
695	108	11	1		20	auto_quality	53.85	7/13 งาน (53.9%)
696	109	1	0		20	manual	0	
697	109	2	0		15	manual	0	
698	109	3	0		10	manual	0	
699	109	9	1		30	auto_completion	58.82	10/17 งาน (58.8%)
700	109	10	4		25	auto_ontime	80	8/10 งาน (80.0%)
701	109	11	1		20	auto_quality	50	5/10 งาน (50.0%)
702	110	1	0		20	manual	0	
703	110	2	0		15	manual	0	
704	110	3	0		10	manual	0	
705	110	9	3		30	auto_completion	77.78	14/18 งาน (77.8%)
706	110	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
707	110	11	2		20	auto_quality	64.29	9/14 งาน (64.3%)
708	111	1	0		20	manual	0	
709	111	2	0		15	manual	0	
710	111	3	0		10	manual	0	
711	111	9	4		30	auto_completion	87.5	14/16 งาน (87.5%)
712	111	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
713	111	11	5		20	auto_quality	92.86	13/14 งาน (92.9%)
714	112	1	0		20	manual	0	
715	112	2	0		15	manual	0	
716	112	3	0		10	manual	0	
717	112	8	0		10	manual	0	
718	112	9	2		30	auto_completion	66.67	14/21 งาน (66.7%)
719	112	10	1		25	auto_ontime	42.86	6/14 งาน (42.9%)
720	112	11	1		20	auto_quality	50	7/14 งาน (50.0%)
721	113	1	0		20	manual	0	
722	113	2	0		15	manual	0	
723	113	3	0		10	manual	0	
724	113	8	0		10	manual	0	
725	113	9	5		30	auto_completion	100	22/22 งาน (100.0%)
726	113	10	5		25	auto_ontime	90.91	20/22 งาน (90.9%)
727	113	11	4		20	auto_quality	86.36	19/22 งาน (86.4%)
728	114	1	0		20	manual	0	
729	114	2	0		15	manual	0	
730	114	3	0		10	manual	0	
731	114	8	0		10	manual	0	
732	114	9	2		30	auto_completion	66.67	14/21 งาน (66.7%)
733	114	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
734	114	11	1		20	auto_quality	57.14	8/14 งาน (57.1%)
735	115	1	0		20	manual	0	
736	115	2	0		15	manual	0	
737	115	3	0		10	manual	0	
738	115	9	4		30	auto_completion	80.95	17/21 งาน (81.0%)
739	115	10	4		25	auto_ontime	82.35	14/17 งาน (82.3%)
740	115	11	4		20	auto_quality	88.24	15/17 งาน (88.2%)
741	116	1	0		20	manual	0	
742	116	2	0		15	manual	0	
743	116	3	0		10	manual	0	
744	116	9	3		30	auto_completion	73.33	11/15 งาน (73.3%)
745	116	10	2		25	auto_ontime	63.64	7/11 งาน (63.6%)
746	116	11	4		20	auto_quality	81.82	9/11 งาน (81.8%)
747	117	1	0		20	manual	0	
748	117	2	0		15	manual	0	
749	117	3	0		10	manual	0	
750	117	9	4		30	auto_completion	89.47	17/19 งาน (89.5%)
751	117	10	4		25	auto_ontime	82.35	14/17 งาน (82.3%)
752	117	11	4		20	auto_quality	88.24	15/17 งาน (88.2%)
753	118	1	0		20	manual	0	
754	118	2	0		15	manual	0	
755	118	3	0		10	manual	0	
756	118	9	1		30	auto_completion	59.09	13/22 งาน (59.1%)
757	118	10	1		25	auto_ontime	46.15	6/13 งาน (46.1%)
758	118	11	2		20	auto_quality	61.54	8/13 งาน (61.5%)
759	119	1	0		20	manual	0	
760	119	2	0		15	manual	0	
761	119	3	0		10	manual	0	
762	119	9	2		30	auto_completion	60	15/25 งาน (60.0%)
763	119	10	2		25	auto_ontime	60	9/15 งาน (60.0%)
764	119	11	3		20	auto_quality	73.33	11/15 งาน (73.3%)
765	120	1	0		20	manual	0	
766	120	2	0		15	manual	0	
767	120	3	0		10	manual	0	
768	120	9	2		30	auto_completion	68.18	15/22 งาน (68.2%)
769	120	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
770	120	11	3		20	auto_quality	73.33	11/15 งาน (73.3%)
771	121	1	0		20	manual	0	
772	121	2	0		15	manual	0	
773	121	3	0		10	manual	0	
774	121	9	5		30	auto_completion	100	16/16 งาน (100.0%)
775	121	10	5		25	auto_ontime	100	16/16 งาน (100.0%)
776	121	11	4		20	auto_quality	87.5	14/16 งาน (87.5%)
777	122	1	0		20	manual	0	
778	122	2	0		15	manual	0	
779	122	3	0		10	manual	0	
780	122	8	0		10	manual	0	
781	122	9	2		30	auto_completion	62.5	15/24 งาน (62.5%)
782	122	10	3		25	auto_ontime	73.33	11/15 งาน (73.3%)
783	122	11	1		20	auto_quality	40	6/15 งาน (40.0%)
784	123	1	0		20	manual	0	
785	123	2	0		15	manual	0	
786	123	3	0		10	manual	0	
787	123	8	0		10	manual	0	
788	123	9	3		30	auto_completion	77.27	17/22 งาน (77.3%)
789	123	10	2		25	auto_ontime	64.71	11/17 งาน (64.7%)
790	123	11	1		20	auto_quality	35.29	6/17 งาน (35.3%)
791	124	1	0		20	manual	0	
792	124	2	0		15	manual	0	
793	124	3	0		10	manual	0	
794	124	8	0		10	manual	0	
795	124	9	5		30	auto_completion	100	21/21 งาน (100.0%)
796	124	10	4		25	auto_ontime	85.71	18/21 งาน (85.7%)
797	124	11	5		20	auto_quality	90.48	19/21 งาน (90.5%)
798	125	1	0		20	manual	0	
799	125	2	0		15	manual	0	
800	125	3	0		10	manual	0	
801	125	9	4		30	auto_completion	83.33	20/24 งาน (83.3%)
802	125	10	4		25	auto_ontime	80	16/20 งาน (80.0%)
803	125	11	4		20	auto_quality	85	17/20 งาน (85.0%)
804	126	1	0		20	manual	0	
805	126	2	0		15	manual	0	
806	126	3	0		10	manual	0	
807	126	9	4		30	auto_completion	82.61	19/23 งาน (82.6%)
808	126	10	3		25	auto_ontime	73.68	14/19 งาน (73.7%)
809	126	11	2		20	auto_quality	63.16	12/19 งาน (63.2%)
1128	187	1	0		20	manual	0	
1129	187	2	0		15	manual	0	
1130	187	3	0		10	manual	0	
1131	187	9	5		30	auto_completion	100	25/25 งาน (100.0%)
1132	187	10	5		25	auto_ontime	96	24/25 งาน (96.0%)
1133	187	11	4		20	auto_quality	88	22/25 งาน (88.0%)
1134	188	1	0		20	manual	0	
1135	188	2	0		15	manual	0	
1136	188	3	0		10	manual	0	
1137	188	9	5		30	auto_completion	95.45	21/22 งาน (95.5%)
1138	188	10	5		25	auto_ontime	90.48	19/21 งาน (90.5%)
1139	188	11	3		20	auto_quality	71.43	15/21 งาน (71.4%)
1140	189	1	0		20	manual	0	
1141	189	2	0		15	manual	0	
1142	189	3	0		10	manual	0	
1143	189	9	3		30	auto_completion	76.19	16/21 งาน (76.2%)
1144	189	10	2		25	auto_ontime	68.75	11/16 งาน (68.8%)
1145	189	11	4		20	auto_quality	81.25	13/16 งาน (81.2%)
1146	190	1	0		20	manual	0	
1147	190	2	0		15	manual	0	
1148	190	3	0		10	manual	0	
1149	190	9	5		30	auto_completion	100	25/25 งาน (100.0%)
1150	190	10	5		25	auto_ontime	96	24/25 งาน (96.0%)
1151	190	11	4		20	auto_quality	84	21/25 งาน (84.0%)
1152	191	1	0		20	manual	0	
1153	191	2	0		15	manual	0	
1154	191	3	0		10	manual	0	
1155	191	9	5		30	auto_completion	100	19/19 งาน (100.0%)
1156	191	10	5		25	auto_ontime	94.74	18/19 งาน (94.7%)
1157	191	11	4		20	auto_quality	89.47	17/19 งาน (89.5%)
1158	192	1	0		20	manual	0	
1159	192	2	0		15	manual	0	
1160	192	3	0		10	manual	0	
1161	192	8	0		10	manual	0	
1162	192	9	5		30	auto_completion	100	22/22 งาน (100.0%)
1411	232	2	0		15	manual	0	
1163	192	10	3		25	auto_ontime	77.27	17/22 งาน (77.3%)
1164	192	11	5		20	auto_quality	100	22/22 งาน (100.0%)
1165	193	1	0		20	manual	0	
1166	193	2	0		15	manual	0	
1167	193	3	0		10	manual	0	
1168	193	8	0		10	manual	0	
1169	193	9	4		30	auto_completion	87.5	14/16 งาน (87.5%)
1170	193	10	5		25	auto_ontime	92.86	13/14 งาน (92.9%)
1171	193	11	4		20	auto_quality	85.71	12/14 งาน (85.7%)
1172	194	1	0		20	manual	0	
1173	194	2	0		15	manual	0	
1174	194	3	0		10	manual	0	
1175	194	8	0		10	manual	0	
1176	194	9	3		30	auto_completion	78.95	15/19 งาน (79.0%)
1177	194	10	2		25	auto_ontime	60	9/15 งาน (60.0%)
1178	194	11	2		20	auto_quality	66.67	10/15 งาน (66.7%)
1179	195	1	0		20	manual	0	
1180	195	2	0		15	manual	0	
1181	195	3	0		10	manual	0	
1182	195	9	5		30	auto_completion	95.45	21/22 งาน (95.5%)
1183	195	10	5		25	auto_ontime	90.48	19/21 งาน (90.5%)
1184	195	11	5		20	auto_quality	100	21/21 งาน (100.0%)
1185	196	1	0		20	manual	0	
1186	196	2	0		15	manual	0	
1187	196	3	0		10	manual	0	
1188	196	9	1		30	auto_completion	50	10/20 งาน (50.0%)
1189	196	10	1		25	auto_ontime	50	5/10 งาน (50.0%)
1190	196	11	2		20	auto_quality	60	6/10 งาน (60.0%)
1191	197	1	0		20	manual	0	
1192	197	2	0		15	manual	0	
1193	197	3	0		10	manual	0	
1194	197	9	4		30	auto_completion	82.35	14/17 งาน (82.3%)
1195	197	10	3		25	auto_ontime	78.57	11/14 งาน (78.6%)
1196	197	11	3		20	auto_quality	71.43	10/14 งาน (71.4%)
1197	198	1	0		20	manual	0	
1198	198	2	0		15	manual	0	
1199	198	3	0		10	manual	0	
1200	198	9	4		30	auto_completion	85.71	18/21 งาน (85.7%)
1201	198	10	4		25	auto_ontime	83.33	15/18 งาน (83.3%)
1202	198	11	2		20	auto_quality	66.67	12/18 งาน (66.7%)
1203	199	1	0		20	manual	0	
1204	199	2	0		15	manual	0	
1205	199	3	0		10	manual	0	
1206	199	9	4		30	auto_completion	83.33	20/24 งาน (83.3%)
1207	199	10	5		25	auto_ontime	90	18/20 งาน (90.0%)
1208	199	11	4		20	auto_quality	80	16/20 งาน (80.0%)
1209	200	1	0		20	manual	0	
1210	200	2	0		15	manual	0	
1211	200	3	0		10	manual	0	
1212	200	9	4		30	auto_completion	87.5	14/16 งาน (87.5%)
1213	200	10	5		25	auto_ontime	92.86	13/14 งาน (92.9%)
1214	200	11	5		20	auto_quality	100	14/14 งาน (100.0%)
1215	201	1	0		20	manual	0	
1216	201	2	0		15	manual	0	
1217	201	3	0		10	manual	0	
1218	201	9	3		30	auto_completion	77.27	17/22 งาน (77.3%)
1219	201	10	4		25	auto_ontime	82.35	14/17 งาน (82.3%)
1220	201	11	3		20	auto_quality	76.47	13/17 งาน (76.5%)
1221	202	1	0		20	manual	0	
1222	202	2	0		15	manual	0	
1223	202	3	0		10	manual	0	
1224	202	8	0		10	manual	0	
1225	202	9	5		30	auto_completion	93.33	14/15 งาน (93.3%)
1226	202	10	5		25	auto_ontime	100	14/14 งาน (100.0%)
1227	202	11	5		20	auto_quality	100	14/14 งาน (100.0%)
1228	203	1	0		20	manual	0	
1229	203	2	0		15	manual	0	
1230	203	3	0		10	manual	0	
1231	203	8	0		10	manual	0	
1232	203	9	4		30	auto_completion	85.71	18/21 งาน (85.7%)
1233	203	10	5		25	auto_ontime	94.44	17/18 งาน (94.4%)
1234	203	11	4		20	auto_quality	88.89	16/18 งาน (88.9%)
1235	204	1	0		20	manual	0	
1236	204	2	0		15	manual	0	
1237	204	3	0		10	manual	0	
1238	204	8	0		10	manual	0	
1239	204	9	5		30	auto_completion	94.44	17/18 งาน (94.4%)
1240	204	10	2		25	auto_ontime	64.71	11/17 งาน (64.7%)
1241	204	11	3		20	auto_quality	76.47	13/17 งาน (76.5%)
1242	205	1	0		20	manual	0	
1243	205	2	0		15	manual	0	
1244	205	3	0		10	manual	0	
1412	232	3	0		10	manual	0	
1245	205	9	5		30	auto_completion	100	17/17 งาน (100.0%)
1246	205	10	5		25	auto_ontime	94.12	16/17 งาน (94.1%)
1247	205	11	3		20	auto_quality	76.47	13/17 งาน (76.5%)
1248	206	1	0		20	manual	0	
1249	206	2	0		15	manual	0	
1250	206	3	0		10	manual	0	
1251	206	9	0		30	manual	0	
1252	206	10	0		25	manual	0	
1253	206	11	0		20	manual	0	
1254	207	1	0		20	manual	0	
1255	207	2	0		15	manual	0	
1256	207	3	0		10	manual	0	
1257	207	9	4		30	auto_completion	84.21	16/19 งาน (84.2%)
1258	207	10	1		25	auto_ontime	56.25	9/16 งาน (56.2%)
1259	207	11	2		20	auto_quality	62.5	10/16 งาน (62.5%)
1260	208	1	0		20	manual	0	
1261	208	2	0		15	manual	0	
1262	208	3	0		10	manual	0	
1263	208	9	4		30	auto_completion	85.71	18/21 งาน (85.7%)
1264	208	10	4		25	auto_ontime	83.33	15/18 งาน (83.3%)
1265	208	11	1		20	auto_quality	55.56	10/18 งาน (55.6%)
1266	209	1	0		20	manual	0	
1267	209	2	0		15	manual	0	
1268	209	3	0		10	manual	0	
1269	209	9	5		30	auto_completion	94.44	17/18 งาน (94.4%)
1270	209	10	3		25	auto_ontime	76.47	13/17 งาน (76.5%)
1271	209	11	5		20	auto_quality	94.12	16/17 งาน (94.1%)
1272	210	1	0		20	manual	0	
1273	210	2	0		15	manual	0	
1274	210	3	0		10	manual	0	
1275	210	9	5		30	auto_completion	90	18/20 งาน (90.0%)
1276	210	10	3		25	auto_ontime	72.22	13/18 งาน (72.2%)
1277	210	11	3		20	auto_quality	72.22	13/18 งาน (72.2%)
1278	211	1	0		20	manual	0	
1279	211	2	0		15	manual	0	
1280	211	3	0		10	manual	0	
1281	211	9	2		30	auto_completion	68.75	11/16 งาน (68.8%)
1282	211	10	1		25	auto_ontime	54.55	6/11 งาน (54.5%)
1283	211	11	5		20	auto_quality	100	11/11 งาน (100.0%)
1284	212	1	0		20	manual	0	
1285	212	2	0		15	manual	0	
1286	212	3	0		10	manual	0	
1287	212	8	0		10	manual	0	
1288	212	9	4		30	auto_completion	86.67	13/15 งาน (86.7%)
1289	212	10	5		25	auto_ontime	92.31	12/13 งาน (92.3%)
1290	212	11	4		20	auto_quality	84.62	11/13 งาน (84.6%)
1291	213	1	0		20	manual	0	
1292	213	2	0		15	manual	0	
1293	213	3	0		10	manual	0	
1294	213	8	0		10	manual	0	
1295	213	9	5		30	auto_completion	90	18/20 งาน (90.0%)
1296	213	10	3		25	auto_ontime	72.22	13/18 งาน (72.2%)
1297	213	11	1		20	auto_quality	55.56	10/18 งาน (55.6%)
1298	214	1	0		20	manual	0	
1299	214	2	0		15	manual	0	
1300	214	3	0		10	manual	0	
1301	214	8	0		10	manual	0	
1302	214	9	3		30	auto_completion	75	12/16 งาน (75.0%)
1303	214	10	2		25	auto_ontime	66.67	8/12 งาน (66.7%)
1304	214	11	3		20	auto_quality	75	9/12 งาน (75.0%)
1305	215	1	0		20	manual	0	
1306	215	2	0		15	manual	0	
1307	215	3	0		10	manual	0	
1308	215	9	5		30	auto_completion	100	22/22 งาน (100.0%)
1309	215	10	5		25	auto_ontime	95.45	21/22 งาน (95.5%)
1310	215	11	5		20	auto_quality	90.91	20/22 งาน (90.9%)
1311	216	1	0		20	manual	0	
1312	216	2	0		15	manual	0	
1313	216	3	0		10	manual	0	
1314	216	9	5		30	auto_completion	93.33	14/15 งาน (93.3%)
1315	216	10	3		25	auto_ontime	78.57	11/14 งาน (78.6%)
1316	216	11	5		20	auto_quality	92.86	13/14 งาน (92.9%)
1317	217	1	0		20	manual	0	
1318	217	2	0		15	manual	0	
1319	217	3	0		10	manual	0	
1320	217	9	3		30	auto_completion	78.26	18/23 งาน (78.3%)
1321	217	10	2		25	auto_ontime	66.67	12/18 งาน (66.7%)
1322	217	11	3		20	auto_quality	72.22	13/18 งาน (72.2%)
1323	218	1	0		20	manual	0	
1324	218	2	0		15	manual	0	
1325	218	3	0		10	manual	0	
1326	218	9	5		30	auto_completion	91.3	21/23 งาน (91.3%)
1327	218	10	3		25	auto_ontime	76.19	16/21 งาน (76.2%)
1328	218	11	4		20	auto_quality	80.95	17/21 งาน (81.0%)
1329	219	1	0		20	manual	0	
1330	219	2	0		15	manual	0	
1331	219	3	0		10	manual	0	
1332	219	9	4		30	auto_completion	86.36	19/22 งาน (86.4%)
1333	219	10	2		25	auto_ontime	63.16	12/19 งาน (63.2%)
1334	219	11	2		20	auto_quality	68.42	13/19 งาน (68.4%)
1335	220	1	0		20	manual	0	
1336	220	2	0		15	manual	0	
1337	220	3	0		10	manual	0	
1338	220	9	5		30	auto_completion	92	23/25 งาน (92.0%)
1339	220	10	4		25	auto_ontime	86.96	20/23 งาน (87.0%)
1340	220	11	4		20	auto_quality	82.61	19/23 งาน (82.6%)
1341	221	1	0		20	manual	0	
1342	221	2	0		15	manual	0	
1343	221	3	0		10	manual	0	
1344	221	9	5		30	auto_completion	100	15/15 งาน (100.0%)
1345	221	10	4		25	auto_ontime	80	12/15 งาน (80.0%)
1346	221	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
1347	222	1	0		20	manual	0	
1348	222	2	0		15	manual	0	
1349	222	3	0		10	manual	0	
1350	222	8	0		10	manual	0	
1351	222	9	5		30	auto_completion	100	22/22 งาน (100.0%)
1352	222	10	5		25	auto_ontime	90.91	20/22 งาน (90.9%)
1353	222	11	5		20	auto_quality	90.91	20/22 งาน (90.9%)
1354	223	1	0		20	manual	0	
1355	223	2	0		15	manual	0	
1356	223	3	0		10	manual	0	
1357	223	8	0		10	manual	0	
1358	223	9	5		30	auto_completion	93.33	14/15 งาน (93.3%)
1359	223	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
1360	223	11	5		20	auto_quality	100	14/14 งาน (100.0%)
1361	224	1	0		20	manual	0	
1362	224	2	0		15	manual	0	
1363	224	3	0		10	manual	0	
1364	224	8	0		10	manual	0	
1365	224	9	5		30	auto_completion	95.65	22/23 งาน (95.7%)
1366	224	10	5		25	auto_ontime	95.45	21/22 งาน (95.5%)
1367	224	11	3		20	auto_quality	72.73	16/22 งาน (72.7%)
1368	225	1	0		20	manual	0	
1369	225	2	0		15	manual	0	
1370	225	3	0		10	manual	0	
1371	225	9	5		30	auto_completion	100	23/23 งาน (100.0%)
1372	225	10	5		25	auto_ontime	95.65	22/23 งาน (95.7%)
1373	225	11	5		20	auto_quality	91.3	21/23 งาน (91.3%)
1374	226	1	0		20	manual	0	
1375	226	2	0		15	manual	0	
1376	226	3	0		10	manual	0	
1377	226	9	4		30	auto_completion	84	21/25 งาน (84.0%)
1378	226	10	4		25	auto_ontime	80.95	17/21 งาน (81.0%)
1379	226	11	2		20	auto_quality	66.67	14/21 งาน (66.7%)
1380	227	1	0		20	manual	0	
1381	227	2	0		15	manual	0	
1382	227	3	0		10	manual	0	
1383	227	9	5		30	auto_completion	100	15/15 งาน (100.0%)
1384	227	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
1385	227	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
1386	228	1	0		20	manual	0	
1387	228	2	0		15	manual	0	
1388	228	3	0		10	manual	0	
1389	228	9	3		30	auto_completion	73.33	11/15 งาน (73.3%)
1390	228	10	5		25	auto_ontime	100	11/11 งาน (100.0%)
1391	228	11	1		20	auto_quality	45.45	5/11 งาน (45.5%)
1392	229	1	0		20	manual	0	
1393	229	2	0		15	manual	0	
1394	229	3	0		10	manual	0	
1395	229	9	5		30	auto_completion	100	20/20 งาน (100.0%)
1396	229	10	5		25	auto_ontime	95	19/20 งาน (95.0%)
1397	229	11	4		20	auto_quality	85	17/20 งาน (85.0%)
1398	230	1	0		20	manual	0	
1399	230	2	0		15	manual	0	
1400	230	3	0		10	manual	0	
1401	230	9	5		30	auto_completion	100	21/21 งาน (100.0%)
1402	230	10	4		25	auto_ontime	85.71	18/21 งาน (85.7%)
1403	230	11	5		20	auto_quality	90.48	19/21 งาน (90.5%)
1404	231	1	0		20	manual	0	
1405	231	2	0		15	manual	0	
1406	231	3	0		10	manual	0	
1407	231	9	0		30	manual	0	
1408	231	10	0		25	manual	0	
1409	231	11	0		20	manual	0	
1410	232	1	0		20	manual	0	
1413	232	8	0		10	manual	0	
1414	232	9	5		30	auto_completion	90	18/20 งาน (90.0%)
1415	232	10	3		25	auto_ontime	77.78	14/18 งาน (77.8%)
1416	232	11	4		20	auto_quality	88.89	16/18 งาน (88.9%)
1417	233	1	0		20	manual	0	
1418	233	2	0		15	manual	0	
1419	233	3	0		10	manual	0	
1420	233	8	0		10	manual	0	
1421	233	9	3		30	auto_completion	73.68	14/19 งาน (73.7%)
1422	233	10	3		25	auto_ontime	78.57	11/14 งาน (78.6%)
1423	233	11	1		20	auto_quality	57.14	8/14 งาน (57.1%)
1424	234	1	0		20	manual	0	
1425	234	2	0		15	manual	0	
1426	234	3	0		10	manual	0	
1427	234	8	0		10	manual	0	
1428	234	9	5		30	auto_completion	93.75	15/16 งาน (93.8%)
1429	234	10	5		25	auto_ontime	93.33	14/15 งาน (93.3%)
1430	234	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
1431	235	1	0		20	manual	0	
1432	235	2	0		15	manual	0	
1433	235	3	0		10	manual	0	
1434	235	9	3		30	auto_completion	71.43	15/21 งาน (71.4%)
1435	235	10	3		25	auto_ontime	73.33	11/15 งาน (73.3%)
1436	235	11	1		20	auto_quality	46.67	7/15 งาน (46.7%)
1437	236	1	0		20	manual	0	
1438	236	2	0		15	manual	0	
1439	236	3	0		10	manual	0	
1440	236	9	3		30	auto_completion	78.95	15/19 งาน (79.0%)
1441	236	10	2		25	auto_ontime	66.67	10/15 งาน (66.7%)
1442	236	11	1		20	auto_quality	33.33	5/15 งาน (33.3%)
1443	237	1	0		20	manual	0	
1444	237	2	0		15	manual	0	
1445	237	3	0		10	manual	0	
1446	237	9	5		30	auto_completion	100	20/20 งาน (100.0%)
1447	237	10	5		25	auto_ontime	90	18/20 งาน (90.0%)
1448	237	11	5		20	auto_quality	90	18/20 งาน (90.0%)
1449	238	1	0		20	manual	0	
1450	238	2	0		15	manual	0	
1451	238	3	0		10	manual	0	
1452	238	9	5		30	auto_completion	100	23/23 งาน (100.0%)
1453	238	10	5		25	auto_ontime	95.65	22/23 งาน (95.7%)
1454	238	11	4		20	auto_quality	86.96	20/23 งาน (87.0%)
1455	239	1	0		20	manual	0	
1456	239	2	0		15	manual	0	
1457	239	3	0		10	manual	0	
1458	239	9	3		30	auto_completion	71.43	15/21 งาน (71.4%)
1459	239	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
1460	239	11	3		20	auto_quality	73.33	11/15 งาน (73.3%)
1461	240	1	0		20	manual	0	
1462	240	2	0		15	manual	0	
1463	240	3	0		10	manual	0	
1464	240	9	5		30	auto_completion	96	24/25 งาน (96.0%)
1465	240	10	4		25	auto_ontime	83.33	20/24 งาน (83.3%)
1466	240	11	5		20	auto_quality	95.83	23/24 งาน (95.8%)
1467	241	1	0		20	manual	0	
1468	241	2	0		15	manual	0	
1469	241	3	0		10	manual	0	
1470	241	9	5		30	auto_completion	100	19/19 งาน (100.0%)
1471	241	10	5		25	auto_ontime	94.74	18/19 งาน (94.7%)
1472	241	11	4		20	auto_quality	89.47	17/19 งาน (89.5%)
1473	242	1	0		20	manual	0	
1474	242	2	0		15	manual	0	
1475	242	3	0		10	manual	0	
1476	242	8	0		10	manual	0	
1477	242	9	3		30	auto_completion	78.95	15/19 งาน (79.0%)
1478	242	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
1479	242	11	4		20	auto_quality	86.67	13/15 งาน (86.7%)
1480	243	1	0		20	manual	0	
1481	243	2	0		15	manual	0	
1482	243	3	0		10	manual	0	
1483	243	8	0		10	manual	0	
1484	243	9	1		30	auto_completion	50	12/24 งาน (50.0%)
1485	243	10	3		25	auto_ontime	75	9/12 งาน (75.0%)
1486	243	11	1		20	auto_quality	33.33	4/12 งาน (33.3%)
1487	244	1	0		20	manual	0	
1488	244	2	0		15	manual	0	
1489	244	3	0		10	manual	0	
1490	244	8	0		10	manual	0	
1491	244	9	5		30	auto_completion	93.75	15/16 งาน (93.8%)
1492	244	10	2		25	auto_ontime	66.67	10/15 งาน (66.7%)
1493	244	11	3		20	auto_quality	73.33	11/15 งาน (73.3%)
1494	245	1	0		20	manual	0	
1495	245	2	0		15	manual	0	
1496	245	3	0		10	manual	0	
1497	245	9	5		30	auto_completion	95.65	22/23 งาน (95.7%)
1498	245	10	5		25	auto_ontime	95.45	21/22 งาน (95.5%)
1499	245	11	5		20	auto_quality	95.45	21/22 งาน (95.5%)
1500	246	1	0		20	manual	0	
1501	246	2	0		15	manual	0	
1502	246	3	0		10	manual	0	
1503	246	9	5		30	auto_completion	90.91	20/22 งาน (90.9%)
1504	246	10	5		25	auto_ontime	90	18/20 งาน (90.0%)
1505	246	11	3		20	auto_quality	75	15/20 งาน (75.0%)
1506	247	1	0		20	manual	0	
1507	247	2	0		15	manual	0	
1508	247	3	0		10	manual	0	
1509	247	9	1		30	auto_completion	57.14	12/21 งาน (57.1%)
1510	247	10	4		25	auto_ontime	83.33	10/12 งาน (83.3%)
1511	247	11	1		20	auto_quality	33.33	4/12 งาน (33.3%)
1512	248	1	0		20	manual	0	
1513	248	2	0		15	manual	0	
1514	248	3	0		10	manual	0	
1515	248	9	3		30	auto_completion	72	18/25 งาน (72.0%)
1516	248	10	5		25	auto_ontime	100	18/18 งาน (100.0%)
1517	248	11	4		20	auto_quality	83.33	15/18 งาน (83.3%)
1518	249	1	0		20	manual	0	
1519	249	2	0		15	manual	0	
1520	249	3	0		10	manual	0	
1521	249	9	4		30	auto_completion	88.24	15/17 งาน (88.2%)
1522	249	10	3		25	auto_ontime	73.33	11/15 งาน (73.3%)
1523	249	11	2		20	auto_quality	66.67	10/15 งาน (66.7%)
1524	250	1	0		20	manual	0	
1525	250	2	0		15	manual	0	
1526	250	3	0		10	manual	0	
1527	250	9	4		30	auto_completion	82.35	14/17 งาน (82.3%)
1528	250	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
1529	250	11	2		20	auto_quality	64.29	9/14 งาน (64.3%)
1530	251	1	0		20	manual	0	
1531	251	2	0		15	manual	0	
1532	251	3	0		10	manual	0	
1533	251	9	5		30	auto_completion	90.48	19/21 งาน (90.5%)
1534	251	10	4		25	auto_ontime	84.21	16/19 งาน (84.2%)
1535	251	11	3		20	auto_quality	78.95	15/19 งาน (79.0%)
1536	252	1	0		20	manual	0	
1537	252	2	0		15	manual	0	
1538	252	3	0		10	manual	0	
1539	252	8	0		10	manual	0	
1540	252	9	3		30	auto_completion	70.59	12/17 งาน (70.6%)
1541	252	10	2		25	auto_ontime	66.67	8/12 งาน (66.7%)
1542	252	11	4		20	auto_quality	83.33	10/12 งาน (83.3%)
1543	253	1	0		20	manual	0	
1544	253	2	0		15	manual	0	
1545	253	3	0		10	manual	0	
1546	253	8	0		10	manual	0	
1547	253	9	4		30	auto_completion	89.47	17/19 งาน (89.5%)
1548	253	10	4		25	auto_ontime	88.24	15/17 งาน (88.2%)
1549	253	11	2		20	auto_quality	64.71	11/17 งาน (64.7%)
1550	254	1	0		20	manual	0	
1551	254	2	0		15	manual	0	
1552	254	3	0		10	manual	0	
1553	254	8	0		10	manual	0	
1554	254	9	2		30	auto_completion	60.87	14/23 งาน (60.9%)
1555	254	10	3		25	auto_ontime	78.57	11/14 งาน (78.6%)
1556	254	11	1		20	auto_quality	57.14	8/14 งาน (57.1%)
1557	255	1	0		20	manual	0	
1558	255	2	0		15	manual	0	
1559	255	3	0		10	manual	0	
1560	255	9	5		30	auto_completion	100	15/15 งาน (100.0%)
1561	255	10	5		25	auto_ontime	100	15/15 งาน (100.0%)
1562	255	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
1563	256	1	0		20	manual	0	
1564	256	2	0		15	manual	0	
1565	256	3	0		10	manual	0	
1566	256	9	0		30	manual	0	
1567	256	10	0		25	manual	0	
1568	256	11	0		20	manual	0	
1569	257	1	0		20	manual	0	
1570	257	2	0		15	manual	0	
1571	257	3	0		10	manual	0	
1572	257	9	3		30	auto_completion	75	18/24 งาน (75.0%)
1573	257	10	3		25	auto_ontime	72.22	13/18 งาน (72.2%)
1574	257	11	3		20	auto_quality	72.22	13/18 งาน (72.2%)
1575	258	1	0		20	manual	0	
1576	258	2	0		15	manual	0	
1577	258	3	0		10	manual	0	
1578	258	9	1		30	auto_completion	59.09	13/22 งาน (59.1%)
1579	258	10	2		25	auto_ontime	69.23	9/13 งาน (69.2%)
1580	258	11	2		20	auto_quality	69.23	9/13 งาน (69.2%)
1581	259	1	0		20	manual	0	
1582	259	2	0		15	manual	0	
1583	259	3	0		10	manual	0	
1584	259	9	2		30	auto_completion	66.67	14/21 งาน (66.7%)
1585	259	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
1586	259	11	1		20	auto_quality	42.86	6/14 งาน (42.9%)
1587	260	1	0		20	manual	0	
1588	260	2	0		15	manual	0	
1589	260	3	0		10	manual	0	
1590	260	9	1		30	auto_completion	59.09	13/22 งาน (59.1%)
1591	260	10	3		25	auto_ontime	76.92	10/13 งาน (76.9%)
1592	260	11	2		20	auto_quality	69.23	9/13 งาน (69.2%)
1593	261	1	0		20	manual	0	
1594	261	2	0		15	manual	0	
1595	261	3	0		10	manual	0	
1596	261	9	5		30	auto_completion	100	15/15 งาน (100.0%)
1597	261	10	4		25	auto_ontime	80	12/15 งาน (80.0%)
1598	261	11	2		20	auto_quality	66.67	10/15 งาน (66.7%)
1599	262	1	0		20	manual	0	
1600	262	2	0		15	manual	0	
1601	262	3	0		10	manual	0	
1602	262	8	0		10	manual	0	
1603	262	9	5		30	auto_completion	90.48	19/21 งาน (90.5%)
1604	262	10	4		25	auto_ontime	89.47	17/19 งาน (89.5%)
1605	262	11	2		20	auto_quality	63.16	12/19 งาน (63.2%)
1606	263	1	0		20	manual	0	
1607	263	2	0		15	manual	0	
1608	263	3	0		10	manual	0	
1609	263	8	0		10	manual	0	
1610	263	9	5		30	auto_completion	95	19/20 งาน (95.0%)
1611	263	10	4		25	auto_ontime	84.21	16/19 งาน (84.2%)
1612	263	11	5		20	auto_quality	94.74	18/19 งาน (94.7%)
1613	264	1	0		20	manual	0	
1614	264	2	0		15	manual	0	
1615	264	3	0		10	manual	0	
1616	264	8	0		10	manual	0	
1617	264	9	2		30	auto_completion	60	15/25 งาน (60.0%)
1618	264	10	3		25	auto_ontime	73.33	11/15 งาน (73.3%)
1619	264	11	3		20	auto_quality	73.33	11/15 งาน (73.3%)
1620	265	1	0		20	manual	0	
1621	265	2	0		15	manual	0	
1622	265	3	0		10	manual	0	
1623	265	9	4		30	auto_completion	86.36	19/22 งาน (86.4%)
1624	265	10	4		25	auto_ontime	89.47	17/19 งาน (89.5%)
1625	265	11	2		20	auto_quality	68.42	13/19 งาน (68.4%)
1626	266	1	0		20	manual	0	
1627	266	2	0		15	manual	0	
1628	266	3	0		10	manual	0	
1629	266	9	3		30	auto_completion	73.33	11/15 งาน (73.3%)
1630	266	10	4		25	auto_ontime	81.82	9/11 งาน (81.8%)
1631	266	11	5		20	auto_quality	90.91	10/11 งาน (90.9%)
1632	267	1	0		20	manual	0	
1633	267	2	0		15	manual	0	
1634	267	3	0		10	manual	0	
1635	267	9	5		30	auto_completion	100	21/21 งาน (100.0%)
1636	267	10	5		25	auto_ontime	90.48	19/21 งาน (90.5%)
1637	267	11	4		20	auto_quality	85.71	18/21 งาน (85.7%)
1638	268	1	0		20	manual	0	
1639	268	2	0		15	manual	0	
1640	268	3	0		10	manual	0	
1641	268	9	4		30	auto_completion	88.24	15/17 งาน (88.2%)
1642	268	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
1643	268	11	2		20	auto_quality	66.67	10/15 งาน (66.7%)
1644	269	1	0		20	manual	0	
1645	269	2	0		15	manual	0	
1646	269	3	0		10	manual	0	
1647	269	9	5		30	auto_completion	100	16/16 งาน (100.0%)
1648	269	10	5		25	auto_ontime	100	16/16 งาน (100.0%)
1649	269	11	5		20	auto_quality	93.75	15/16 งาน (93.8%)
1650	270	1	0		20	manual	0	
1651	270	2	0		15	manual	0	
1652	270	3	0		10	manual	0	
1653	270	9	4		30	auto_completion	83.33	20/24 งาน (83.3%)
1654	270	10	3		25	auto_ontime	70	14/20 งาน (70.0%)
1655	270	11	1		20	auto_quality	55	11/20 งาน (55.0%)
1656	271	1	0		20	manual	0	
1657	271	2	0		15	manual	0	
1658	271	3	0		10	manual	0	
1659	271	9	5		30	auto_completion	100	15/15 งาน (100.0%)
1660	271	10	5		25	auto_ontime	93.33	14/15 งาน (93.3%)
1661	271	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
1662	272	1	0		20	manual	0	
1663	272	2	0		15	manual	0	
1664	272	3	0		10	manual	0	
1665	272	8	0		10	manual	0	
1666	272	9	3		30	auto_completion	78.95	15/19 งาน (79.0%)
1667	272	10	2		25	auto_ontime	66.67	10/15 งาน (66.7%)
1668	272	11	1		20	auto_quality	46.67	7/15 งาน (46.7%)
1669	273	1	0		20	manual	0	
1670	273	2	0		15	manual	0	
1671	273	3	0		10	manual	0	
1672	273	8	0		10	manual	0	
1673	273	9	3		30	auto_completion	73.33	11/15 งาน (73.3%)
1674	273	10	2		25	auto_ontime	63.64	7/11 งาน (63.6%)
1675	273	11	1		20	auto_quality	45.45	5/11 งาน (45.5%)
1676	274	1	0		20	manual	0	
1677	274	2	0		15	manual	0	
1678	274	3	0		10	manual	0	
1679	274	8	0		10	manual	0	
1680	274	9	2		30	auto_completion	60	9/15 งาน (60.0%)
1681	274	10	1		25	auto_ontime	44.44	4/9 งาน (44.4%)
1682	274	11	1		20	auto_quality	33.33	3/9 งาน (33.3%)
1683	275	1	0		20	manual	0	
1684	275	2	0		15	manual	0	
1685	275	3	0		10	manual	0	
1686	275	9	4		30	auto_completion	85.71	18/21 งาน (85.7%)
1687	275	10	3		25	auto_ontime	77.78	14/18 งาน (77.8%)
1688	275	11	3		20	auto_quality	77.78	14/18 งาน (77.8%)
1689	276	1	0		20	manual	0	
1690	276	2	0		15	manual	0	
1691	276	3	0		10	manual	0	
1692	276	9	3		30	auto_completion	73.68	14/19 งาน (73.7%)
1693	276	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
1694	276	11	3		20	auto_quality	78.57	11/14 งาน (78.6%)
1695	277	1	0		20	manual	0	
1696	277	2	0		15	manual	0	
1697	277	3	0		10	manual	0	
1698	277	9	4		30	auto_completion	88	22/25 งาน (88.0%)
1699	277	10	3		25	auto_ontime	77.27	17/22 งาน (77.3%)
1700	277	11	5		20	auto_quality	90.91	20/22 งาน (90.9%)
1701	278	1	0		20	manual	0	
1702	278	2	0		15	manual	0	
1703	278	3	0		10	manual	0	
1704	278	9	5		30	auto_completion	90.91	20/22 งาน (90.9%)
1705	278	10	4		25	auto_ontime	85	17/20 งาน (85.0%)
1706	278	11	3		20	auto_quality	75	15/20 งาน (75.0%)
1707	279	1	0		20	manual	0	
1708	279	2	0		15	manual	0	
1709	279	3	0		10	manual	0	
1710	279	9	5		30	auto_completion	95.45	21/22 งาน (95.5%)
1711	279	10	1		25	auto_ontime	52.38	11/21 งาน (52.4%)
1712	279	11	2		20	auto_quality	66.67	14/21 งาน (66.7%)
1713	280	1	0		20	manual	0	
1714	280	2	0		15	manual	0	
1715	280	3	0		10	manual	0	
1716	280	9	4		30	auto_completion	80	12/15 งาน (80.0%)
1717	280	10	4		25	auto_ontime	83.33	10/12 งาน (83.3%)
1718	280	11	1		20	auto_quality	58.33	7/12 งาน (58.3%)
1719	281	1	0		20	manual	0	
1720	281	2	0		15	manual	0	
1721	281	3	0		10	manual	0	
1722	281	9	0		30	manual	0	
1723	281	10	0		25	manual	0	
1724	281	11	0		20	manual	0	
1725	282	1	0		20	manual	0	
1726	282	2	0		15	manual	0	
1727	282	3	0		10	manual	0	
1728	282	8	0		10	manual	0	
1729	282	9	5		30	auto_completion	93.75	15/16 งาน (93.8%)
1730	282	10	4		25	auto_ontime	86.67	13/15 งาน (86.7%)
1731	282	11	4		20	auto_quality	80	12/15 งาน (80.0%)
1732	283	1	0		20	manual	0	
1733	283	2	0		15	manual	0	
1734	283	3	0		10	manual	0	
1735	283	8	0		10	manual	0	
1736	283	9	3		30	auto_completion	76.19	16/21 งาน (76.2%)
1737	283	10	4		25	auto_ontime	87.5	14/16 งาน (87.5%)
1738	283	11	2		20	auto_quality	62.5	10/16 งาน (62.5%)
1739	284	1	0		20	manual	0	
1740	284	2	0		15	manual	0	
1741	284	3	0		10	manual	0	
1742	284	8	0		10	manual	0	
1743	284	9	2		30	auto_completion	63.16	12/19 งาน (63.2%)
1744	284	10	2		25	auto_ontime	66.67	8/12 งาน (66.7%)
1745	284	11	2		20	auto_quality	66.67	8/12 งาน (66.7%)
1746	285	1	0		20	manual	0	
1747	285	2	0		15	manual	0	
1748	285	3	0		10	manual	0	
1749	285	9	3		30	auto_completion	73.68	14/19 งาน (73.7%)
1750	285	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
1751	285	11	3		20	auto_quality	78.57	11/14 งาน (78.6%)
1752	286	1	0		20	manual	0	
1753	286	2	0		15	manual	0	
1754	286	3	0		10	manual	0	
1755	286	9	4		30	auto_completion	86.67	13/15 งาน (86.7%)
1756	286	10	4		25	auto_ontime	84.62	11/13 งาน (84.6%)
1757	286	11	1		20	auto_quality	53.85	7/13 งาน (53.9%)
1758	287	1	0		20	manual	0	
1759	287	2	0		15	manual	0	
1760	287	3	0		10	manual	0	
1761	287	9	5		30	auto_completion	100	25/25 งาน (100.0%)
1762	287	10	5		25	auto_ontime	96	24/25 งาน (96.0%)
1763	287	11	5		20	auto_quality	96	24/25 งาน (96.0%)
1764	288	1	0		20	manual	0	
1765	288	2	0		15	manual	0	
1766	288	3	0		10	manual	0	
1767	288	9	5		30	auto_completion	100	17/17 งาน (100.0%)
1768	288	10	3		25	auto_ontime	76.47	13/17 งาน (76.5%)
1769	288	11	4		20	auto_quality	82.35	14/17 งาน (82.3%)
1770	289	1	0		20	manual	0	
1771	289	2	0		15	manual	0	
1772	289	3	0		10	manual	0	
1773	289	9	5		30	auto_completion	93.33	14/15 งาน (93.3%)
1774	289	10	5		25	auto_ontime	100	14/14 งาน (100.0%)
1775	289	11	2		20	auto_quality	64.29	9/14 งาน (64.3%)
1776	290	1	0		20	manual	0	
1777	290	2	0		15	manual	0	
1778	290	3	0		10	manual	0	
1779	290	9	3		30	auto_completion	72.22	13/18 งาน (72.2%)
1780	290	10	2		25	auto_ontime	69.23	9/13 งาน (69.2%)
1781	290	11	1		20	auto_quality	30.77	4/13 งาน (30.8%)
1782	291	1	0		20	manual	0	
1783	291	2	0		15	manual	0	
1784	291	3	0		10	manual	0	
1785	291	9	4		30	auto_completion	81.25	13/16 งาน (81.2%)
1786	291	10	2		25	auto_ontime	69.23	9/13 งาน (69.2%)
1787	291	11	3		20	auto_quality	76.92	10/13 งาน (76.9%)
1788	292	1	0		20	manual	0	
1789	292	2	0		15	manual	0	
1790	292	3	0		10	manual	0	
1791	292	8	0		10	manual	0	
1792	292	9	3		30	auto_completion	78.95	15/19 งาน (79.0%)
1793	292	10	3		25	auto_ontime	73.33	11/15 งาน (73.3%)
1794	292	11	2		20	auto_quality	60	9/15 งาน (60.0%)
1795	293	1	0		20	manual	0	
1796	293	2	0		15	manual	0	
1797	293	3	0		10	manual	0	
1798	293	8	0		10	manual	0	
1799	293	9	3		30	auto_completion	73.68	14/19 งาน (73.7%)
1800	293	10	2		25	auto_ontime	64.29	9/14 งาน (64.3%)
1801	293	11	1		20	auto_quality	50	7/14 งาน (50.0%)
1802	294	1	0		20	manual	0	
1803	294	2	0		15	manual	0	
1804	294	3	0		10	manual	0	
1805	294	8	0		10	manual	0	
1806	294	9	5		30	auto_completion	100	19/19 งาน (100.0%)
1807	294	10	4		25	auto_ontime	84.21	16/19 งาน (84.2%)
1808	294	11	3		20	auto_quality	78.95	15/19 งาน (79.0%)
1809	295	1	0		20	manual	0	
1810	295	2	0		15	manual	0	
1811	295	3	0		10	manual	0	
1812	295	9	5		30	auto_completion	90	18/20 งาน (90.0%)
1813	295	10	4		25	auto_ontime	83.33	15/18 งาน (83.3%)
1814	295	11	1		20	auto_quality	55.56	10/18 งาน (55.6%)
1815	296	1	0		20	manual	0	
1816	296	2	0		15	manual	0	
1817	296	3	0		10	manual	0	
1818	296	9	3		30	auto_completion	73.68	14/19 งาน (73.7%)
1819	296	10	4		25	auto_ontime	85.71	12/14 งาน (85.7%)
1820	296	11	2		20	auto_quality	64.29	9/14 งาน (64.3%)
1821	297	1	0		20	manual	0	
1822	297	2	0		15	manual	0	
1823	297	3	0		10	manual	0	
1824	297	9	1		30	auto_completion	55.56	10/18 งาน (55.6%)
1825	297	10	4		25	auto_ontime	80	8/10 งาน (80.0%)
1826	297	11	1		20	auto_quality	50	5/10 งาน (50.0%)
1827	298	1	0		20	manual	0	
1828	298	2	0		15	manual	0	
1829	298	3	0		10	manual	0	
1830	298	9	5		30	auto_completion	92	23/25 งาน (92.0%)
1831	298	10	3		25	auto_ontime	78.26	18/23 งาน (78.3%)
1832	298	11	4		20	auto_quality	82.61	19/23 งาน (82.6%)
1833	299	1	0		20	manual	0	
1834	299	2	0		15	manual	0	
1835	299	3	0		10	manual	0	
1836	299	9	5		30	auto_completion	100	23/23 งาน (100.0%)
1837	299	10	4		25	auto_ontime	82.61	19/23 งาน (82.6%)
1838	299	11	5		20	auto_quality	100	23/23 งาน (100.0%)
1839	300	1	0		20	manual	0	
1840	300	2	0		15	manual	0	
1841	300	3	0		10	manual	0	
1842	300	9	4		30	auto_completion	89.47	17/19 งาน (89.5%)
1843	300	10	4		25	auto_ontime	82.35	14/17 งาน (82.3%)
1844	300	11	3		20	auto_quality	70.59	12/17 งาน (70.6%)
1845	301	1	0		20	manual	0	
1846	301	2	0		15	manual	0	
1847	301	3	0		10	manual	0	
1848	301	9	5		30	auto_completion	90	18/20 งาน (90.0%)
1849	301	10	3		25	auto_ontime	72.22	13/18 งาน (72.2%)
1850	301	11	4		20	auto_quality	83.33	15/18 งาน (83.3%)
1851	302	1	0		20	manual	0	
1852	302	2	0		15	manual	0	
1853	302	3	0		10	manual	0	
1854	302	8	0		10	manual	0	
1855	302	9	5		30	auto_completion	95.83	23/24 งาน (95.8%)
1856	302	10	5		25	auto_ontime	91.3	21/23 งาน (91.3%)
1857	302	11	4		20	auto_quality	82.61	19/23 งาน (82.6%)
1858	303	1	0		20	manual	0	
1859	303	2	0		15	manual	0	
1860	303	3	0		10	manual	0	
1861	303	8	0		10	manual	0	
1862	303	9	4		30	auto_completion	89.47	17/19 งาน (89.5%)
1863	303	10	4		25	auto_ontime	88.24	15/17 งาน (88.2%)
1864	303	11	3		20	auto_quality	76.47	13/17 งาน (76.5%)
1865	304	1	0		20	manual	0	
1866	304	2	0		15	manual	0	
1867	304	3	0		10	manual	0	
1868	304	8	0		10	manual	0	
1869	304	9	4		30	auto_completion	86.96	20/23 งาน (87.0%)
1870	304	10	3		25	auto_ontime	70	14/20 งาน (70.0%)
1871	304	11	4		20	auto_quality	80	16/20 งาน (80.0%)
1872	305	1	0		20	manual	0	
1873	305	2	0		15	manual	0	
1874	305	3	0		10	manual	0	
1875	305	9	4		30	auto_completion	86.36	19/22 งาน (86.4%)
1876	305	10	3		25	auto_ontime	73.68	14/19 งาน (73.7%)
1877	305	11	2		20	auto_quality	68.42	13/19 งาน (68.4%)
1878	306	1	0		20	manual	0	
1879	306	2	0		15	manual	0	
1880	306	3	0		10	manual	0	
1881	306	9	0		30	manual	0	
1882	306	10	0		25	manual	0	
1883	306	11	0		20	manual	0	
1906	309	12	0		20	manual	0	
1907	309	13	0		15	manual	0	
1908	309	14	0		10	manual	0	
1909	310	1	0		20	manual	0	
1910	310	2	0		15	manual	0	
1911	310	3	0		10	manual	0	
1912	310	6	0		30	manual	0	
1913	310	7	0		25	manual	0	
1914	310	12	5		20	auto_completion	100	16/16 งาน (100.0%)
1915	310	13	5		15	auto_ontime	93.75	15/16 งาน (93.8%)
1916	310	14	3		10	auto_quality	75	12/16 งาน (75.0%)
1917	311	1	0		20	manual	0	
1918	311	2	0		15	manual	0	
1919	311	3	0		10	manual	0	
1920	311	6	0		30	manual	0	
1921	311	7	0		25	manual	0	
1922	311	12	4		20	auto_completion	80	16/20 งาน (80.0%)
1923	311	13	2		15	auto_ontime	68.75	11/16 งาน (68.8%)
1924	311	14	2		10	auto_quality	62.5	10/16 งาน (62.5%)
1925	312	1	0		20	manual	0	
1926	312	2	0		15	manual	0	
1927	312	3	0		10	manual	0	
1928	312	6	0		30	manual	0	
1929	312	7	0		25	manual	0	
1930	312	12	4		20	auto_completion	86.67	13/15 งาน (86.7%)
1931	312	13	2		15	auto_ontime	69.23	9/13 งาน (69.2%)
1932	312	14	1		10	auto_quality	53.85	7/13 งาน (53.9%)
1933	313	1	0		20	manual	0	
1934	313	2	0		15	manual	0	
1935	313	3	0		10	manual	0	
1936	313	6	0		30	manual	0	
1937	313	7	0		25	manual	0	
1938	313	12	2		20	auto_completion	65	13/20 งาน (65.0%)
1939	313	13	2		15	auto_ontime	69.23	9/13 งาน (69.2%)
1940	313	14	1		10	auto_quality	23.08	3/13 งาน (23.1%)
1949	315	1	0		20	manual	0	
1950	315	2	0		15	manual	0	
1951	315	3	0		10	manual	0	
1952	315	6	0		30	manual	0	
1953	315	7	0		25	manual	0	
1954	315	8	0		10	manual	0	
1955	315	12	2		20	auto_completion	65	13/20 งาน (65.0%)
1956	315	13	2		15	auto_ontime	61.54	8/13 งาน (61.5%)
1957	315	14	1		10	auto_quality	38.46	5/13 งาน (38.5%)
1958	316	1	0		20	manual	0	
1959	316	2	0		15	manual	0	
1960	316	3	0		10	manual	0	
1961	316	6	0		30	manual	0	
1962	316	7	0		25	manual	0	
1963	316	8	0		10	manual	0	
1964	316	12	4		20	auto_completion	87.5	21/24 งาน (87.5%)
1965	316	13	4		15	auto_ontime	80.95	17/21 งาน (81.0%)
1966	316	14	5		10	auto_quality	95.24	20/21 งาน (95.2%)
1967	317	1	0		20	manual	0	
1968	317	2	0		15	manual	0	
1969	317	3	0		10	manual	0	
1970	317	6	0		30	manual	0	
1971	317	7	0		25	manual	0	
1972	317	8	0		10	manual	0	
1973	317	12	5		20	auto_completion	95.83	23/24 งาน (95.8%)
1974	317	13	4		15	auto_ontime	86.96	20/23 งาน (87.0%)
1975	317	14	5		10	auto_quality	91.3	21/23 งาน (91.3%)
1976	318	1	0		20	manual	0	
1977	318	2	0		15	manual	0	
1978	318	3	0		10	manual	0	
1979	318	6	0		30	manual	0	
1980	318	7	0		25	manual	0	
1981	318	12	2		20	auto_completion	60	9/15 งาน (60.0%)
1982	318	13	1		15	auto_ontime	55.56	5/9 งาน (55.6%)
1983	318	14	1		10	auto_quality	22.22	2/9 งาน (22.2%)
1984	319	1	0		20	manual	0	
1985	319	2	0		15	manual	0	
1986	319	3	0		10	manual	0	
1987	319	6	0		30	manual	0	
1988	319	7	0		25	manual	0	
1989	319	12	3		20	auto_completion	76.47	13/17 งาน (76.5%)
1990	319	13	1		15	auto_ontime	46.15	6/13 งาน (46.1%)
1991	319	14	1		10	auto_quality	30.77	4/13 งาน (30.8%)
1992	320	1	0		20	manual	0	
1993	320	2	0		15	manual	0	
1994	320	3	0		10	manual	0	
1995	320	6	0		30	manual	0	
1996	320	7	0		25	manual	0	
1997	320	12	4		20	auto_completion	89.47	17/19 งาน (89.5%)
1998	320	13	1		15	auto_ontime	58.82	10/17 งาน (58.8%)
1999	320	14	4		10	auto_quality	88.24	15/17 งาน (88.2%)
2000	321	1	0		20	manual	0	
2001	321	2	0		15	manual	0	
2002	321	3	0		10	manual	0	
2003	321	6	0		30	manual	0	
2004	321	7	0		25	manual	0	
2005	321	12	2		20	auto_completion	69.57	16/23 งาน (69.6%)
2006	321	13	3		15	auto_ontime	75	12/16 งาน (75.0%)
2007	321	14	2		10	auto_quality	68.75	11/16 งาน (68.8%)
2008	322	1	0		20	manual	0	
2009	322	2	0		15	manual	0	
2010	322	3	0		10	manual	0	
2011	322	6	0		30	manual	0	
2012	322	7	0		25	manual	0	
2013	322	12	5		20	auto_completion	96	24/25 งาน (96.0%)
2014	322	13	5		15	auto_ontime	91.67	22/24 งาน (91.7%)
2015	322	14	5		10	auto_quality	91.67	22/24 งาน (91.7%)
2016	323	1	0		20	manual	0	
2017	323	2	0		15	manual	0	
2018	323	3	0		10	manual	0	
2019	323	6	0		30	manual	0	
2020	323	7	0		25	manual	0	
2021	323	12	4		20	auto_completion	88	22/25 งาน (88.0%)
2022	323	13	3		15	auto_ontime	77.27	17/22 งาน (77.3%)
2023	323	14	3		10	auto_quality	77.27	17/22 งาน (77.3%)
2024	324	1	0		20	manual	0	
2025	324	2	0		15	manual	0	
2026	324	3	0		10	manual	0	
2027	324	6	0		30	manual	0	
2028	324	7	0		25	manual	0	
2029	324	12	5		20	auto_completion	95.65	22/23 งาน (95.7%)
2030	324	13	5		15	auto_ontime	90.91	20/22 งาน (90.9%)
2031	324	14	4		10	auto_quality	86.36	19/22 งาน (86.4%)
2032	325	1	0		20	manual	0	
2033	325	2	0		15	manual	0	
2034	325	3	0		10	manual	0	
2035	325	6	0		30	manual	0	
2036	325	7	0		25	manual	0	
2037	325	8	0		10	manual	0	
2038	325	12	5		20	auto_completion	94.74	18/19 งาน (94.7%)
2039	325	13	4		15	auto_ontime	83.33	15/18 งาน (83.3%)
2040	325	14	3		10	auto_quality	77.78	14/18 งาน (77.8%)
2041	326	1	0		20	manual	0	
2042	326	2	0		15	manual	0	
2043	326	3	0		10	manual	0	
2044	326	6	0		30	manual	0	
2045	326	7	0		25	manual	0	
2046	326	8	0		10	manual	0	
2047	326	12	5		20	auto_completion	90.91	20/22 งาน (90.9%)
2048	326	13	5		15	auto_ontime	90	18/20 งาน (90.0%)
2049	326	14	5		10	auto_quality	90	18/20 งาน (90.0%)
2050	327	1	0		20	manual	0	
2051	327	2	0		15	manual	0	
2052	327	3	0		10	manual	0	
2053	327	6	0		30	manual	0	
2054	327	7	0		25	manual	0	
2055	327	8	0		10	manual	0	
2056	327	12	3		20	auto_completion	77.78	14/18 งาน (77.8%)
2057	327	13	3		15	auto_ontime	78.57	11/14 งาน (78.6%)
2058	327	14	4		10	auto_quality	85.71	12/14 งาน (85.7%)
2059	328	1	0		20	manual	0	
2060	328	2	0		15	manual	0	
2061	328	3	0		10	manual	0	
2062	328	6	0		30	manual	0	
2063	328	7	0		25	manual	0	
2064	328	12	5		20	auto_completion	93.75	15/16 งาน (93.8%)
2065	328	13	4		15	auto_ontime	86.67	13/15 งาน (86.7%)
2066	328	14	4		10	auto_quality	86.67	13/15 งาน (86.7%)
2067	329	1	0		20	manual	0	
2068	329	2	0		15	manual	0	
2069	329	3	0		10	manual	0	
2070	329	6	0		30	manual	0	
2071	329	7	0		25	manual	0	
2072	329	12	3		20	auto_completion	71.43	15/21 งาน (71.4%)
2073	329	13	3		15	auto_ontime	73.33	11/15 งาน (73.3%)
2074	329	14	2		10	auto_quality	66.67	10/15 งาน (66.7%)
2075	330	1	0		20	manual	0	
2076	330	2	0		15	manual	0	
2077	330	3	0		10	manual	0	
2078	330	6	0		30	manual	0	
2079	330	7	0		25	manual	0	
2080	330	12	5		20	auto_completion	100	22/22 งาน (100.0%)
2081	330	13	5		15	auto_ontime	90.91	20/22 งาน (90.9%)
2082	330	14	5		10	auto_quality	90.91	20/22 งาน (90.9%)
2083	331	1	0		20	manual	0	
2084	331	2	0		15	manual	0	
2085	331	3	0		10	manual	0	
2086	331	6	0		30	manual	0	
2087	331	7	0		25	manual	0	
2088	331	12	5		20	auto_completion	100	16/16 งาน (100.0%)
2089	331	13	4		15	auto_ontime	81.25	13/16 งาน (81.2%)
2090	331	14	5		10	auto_quality	100	16/16 งาน (100.0%)
2091	332	1	0		20	manual	0	
2092	332	2	0		15	manual	0	
2093	332	3	0		10	manual	0	
2094	332	6	0		30	manual	0	
2095	332	7	0		25	manual	0	
2096	332	12	2		20	auto_completion	68.42	13/19 งาน (68.4%)
2097	332	13	2		15	auto_ontime	61.54	8/13 งาน (61.5%)
2098	332	14	1		10	auto_quality	46.15	6/13 งาน (46.1%)
2099	333	1	0		20	manual	0	
2100	333	2	0		15	manual	0	
2101	333	3	0		10	manual	0	
2102	333	6	0		30	manual	0	
2103	333	7	0		25	manual	0	
2104	333	12	5		20	auto_completion	92	23/25 งาน (92.0%)
2105	333	13	3		15	auto_ontime	73.91	17/23 งาน (73.9%)
2106	333	14	4		10	auto_quality	82.61	19/23 งาน (82.6%)
2107	334	1	0		20	manual	0	
2108	334	2	0		15	manual	0	
2109	334	3	0		10	manual	0	
2110	334	6	0		30	manual	0	
2111	334	7	0		25	manual	0	
2112	334	12	4		20	auto_completion	87.5	14/16 งาน (87.5%)
2113	334	13	3		15	auto_ontime	78.57	11/14 งาน (78.6%)
2114	334	14	3		10	auto_quality	78.57	11/14 งาน (78.6%)
2115	335	1	0		20	manual	0	
2116	335	2	0		15	manual	0	
2117	335	3	0		10	manual	0	
2118	335	6	0		30	manual	0	
2119	335	7	0		25	manual	0	
2120	335	8	0		10	manual	0	
2121	335	12	2		20	auto_completion	60	15/25 งาน (60.0%)
2122	335	13	3		15	auto_ontime	73.33	11/15 งาน (73.3%)
2123	335	14	1		10	auto_quality	40	6/15 งาน (40.0%)
2124	336	1	0		20	manual	0	
2125	336	2	0		15	manual	0	
2126	336	3	0		10	manual	0	
2127	336	6	0		30	manual	0	
2128	336	7	0		25	manual	0	
2129	336	8	0		10	manual	0	
2130	336	12	4		20	auto_completion	83.33	20/24 งาน (83.3%)
2131	336	13	4		15	auto_ontime	80	16/20 งาน (80.0%)
2132	336	14	5		10	auto_quality	90	18/20 งาน (90.0%)
2133	337	1	0		20	manual	0	
2134	337	2	0		15	manual	0	
2135	337	3	0		10	manual	0	
2136	337	6	0		30	manual	0	
2137	337	7	0		25	manual	0	
2138	337	8	0		10	manual	0	
2139	337	12	4		20	auto_completion	85	17/20 งาน (85.0%)
2140	337	13	3		15	auto_ontime	76.47	13/17 งาน (76.5%)
2141	337	14	3		10	auto_quality	70.59	12/17 งาน (70.6%)
2142	338	1	0		20	manual	0	
2143	338	2	0		15	manual	0	
2144	338	3	0		10	manual	0	
2145	338	6	0		30	manual	0	
2146	338	7	0		25	manual	0	
2147	338	12	3		20	auto_completion	72.73	16/22 งาน (72.7%)
2148	338	13	2		15	auto_ontime	62.5	10/16 งาน (62.5%)
2149	338	14	1		10	auto_quality	37.5	6/16 งาน (37.5%)
2150	339	1	0		20	manual	0	
2151	339	2	0		15	manual	0	
2152	339	3	0		10	manual	0	
2153	339	6	0		30	manual	0	
2154	339	7	0		25	manual	0	
2155	339	12	0		20	manual	0	
2156	339	13	0		15	manual	0	
2157	339	14	0		10	manual	0	
2158	340	1	0		20	manual	0	
2159	340	2	0		15	manual	0	
2160	340	3	0		10	manual	0	
2161	340	6	0		30	manual	0	
2162	340	7	0		25	manual	0	
2163	340	12	3		20	auto_completion	73.91	17/23 งาน (73.9%)
2164	340	13	3		15	auto_ontime	76.47	13/17 งาน (76.5%)
2165	340	14	3		10	auto_quality	70.59	12/17 งาน (70.6%)
2166	341	1	0		20	manual	0	
2167	341	2	0		15	manual	0	
2168	341	3	0		10	manual	0	
2169	341	6	0		30	manual	0	
2170	341	7	0		25	manual	0	
2171	341	12	5		20	auto_completion	100	21/21 งาน (100.0%)
2172	341	13	5		15	auto_ontime	90.48	19/21 งาน (90.5%)
2173	341	14	5		10	auto_quality	100	21/21 งาน (100.0%)
2174	342	1	0		20	manual	0	
2175	342	2	0		15	manual	0	
2176	342	3	0		10	manual	0	
2177	342	6	0		30	manual	0	
2178	342	7	0		25	manual	0	
2179	342	12	3		20	auto_completion	73.33	11/15 งาน (73.3%)
2180	342	13	2		15	auto_ontime	63.64	7/11 งาน (63.6%)
2181	342	14	3		10	auto_quality	72.73	8/11 งาน (72.7%)
2182	343	1	0		20	manual	0	
2183	343	2	0		15	manual	0	
2184	343	3	0		10	manual	0	
2185	343	6	0		30	manual	0	
2186	343	7	0		25	manual	0	
2187	343	12	4		20	auto_completion	82.35	14/17 งาน (82.3%)
2188	343	13	5		15	auto_ontime	92.86	13/14 งาน (92.9%)
2189	343	14	5		10	auto_quality	92.86	13/14 งาน (92.9%)
2190	344	1	0		20	manual	0	
2191	344	2	0		15	manual	0	
2192	344	3	0		10	manual	0	
2193	344	6	0		30	manual	0	
2194	344	7	0		25	manual	0	
2195	344	12	3		20	auto_completion	75	18/24 งาน (75.0%)
2196	344	13	1		15	auto_ontime	50	9/18 งาน (50.0%)
2197	344	14	2		10	auto_quality	61.11	11/18 งาน (61.1%)
2198	345	1	0		20	manual	0	
2199	345	2	0		15	manual	0	
2200	345	3	0		10	manual	0	
2201	345	6	0		30	manual	0	
2202	345	7	0		25	manual	0	
2203	345	8	0		10	manual	0	
2204	345	12	4		20	auto_completion	89.47	17/19 งาน (89.5%)
2205	345	13	3		15	auto_ontime	76.47	13/17 งาน (76.5%)
2206	345	14	3		10	auto_quality	76.47	13/17 งาน (76.5%)
2207	346	1	0		20	manual	0	
2208	346	2	0		15	manual	0	
2209	346	3	0		10	manual	0	
2210	346	6	0		30	manual	0	
2211	346	7	0		25	manual	0	
2212	346	8	0		10	manual	0	
2213	346	12	1		20	auto_completion	58.82	10/17 งาน (58.8%)
2214	346	13	3		15	auto_ontime	70	7/10 งาน (70.0%)
2215	346	14	2		10	auto_quality	60	6/10 งาน (60.0%)
2216	347	1	0		20	manual	0	
2217	347	2	0		15	manual	0	
2218	347	3	0		10	manual	0	
2219	347	6	0		30	manual	0	
2220	347	7	0		25	manual	0	
2221	347	8	0		10	manual	0	
2222	347	12	5		20	auto_completion	91.67	22/24 งาน (91.7%)
2223	347	13	4		15	auto_ontime	86.36	19/22 งาน (86.4%)
2224	347	14	5		10	auto_quality	90.91	20/22 งาน (90.9%)
2225	348	1	0		20	manual	0	
2226	348	2	0		15	manual	0	
2227	348	3	0		10	manual	0	
2228	348	6	0		30	manual	0	
2229	348	7	0		25	manual	0	
2230	348	12	5		20	auto_completion	94.44	17/18 งาน (94.4%)
2231	348	13	4		15	auto_ontime	88.24	15/17 งาน (88.2%)
2232	348	14	4		10	auto_quality	82.35	14/17 งาน (82.3%)
2233	349	1	0		20	manual	0	
2234	349	2	0		15	manual	0	
2235	349	3	0		10	manual	0	
2236	349	6	0		30	manual	0	
2237	349	7	0		25	manual	0	
2238	349	12	5		20	auto_completion	93.75	15/16 งาน (93.8%)
2239	349	13	4		15	auto_ontime	80	12/15 งาน (80.0%)
2240	349	14	3		10	auto_quality	73.33	11/15 งาน (73.3%)
2241	350	1	0		20	manual	0	
2242	350	2	0		15	manual	0	
2243	350	3	0		10	manual	0	
2244	350	6	0		30	manual	0	
2245	350	7	0		25	manual	0	
2246	350	12	5		20	auto_completion	95.24	20/21 งาน (95.2%)
2247	350	13	5		15	auto_ontime	95	19/20 งาน (95.0%)
2248	350	14	3		10	auto_quality	75	15/20 งาน (75.0%)
2249	351	1	0		20	manual	0	
2250	351	2	0		15	manual	0	
2251	351	3	0		10	manual	0	
2252	351	6	0		30	manual	0	
2253	351	7	0		25	manual	0	
2254	351	12	5		20	auto_completion	100	18/18 งาน (100.0%)
2255	351	13	5		15	auto_ontime	94.44	17/18 งาน (94.4%)
2256	351	14	4		10	auto_quality	88.89	16/18 งาน (88.9%)
2257	352	1	0		20	manual	0	
2258	352	2	0		15	manual	0	
2259	352	3	0		10	manual	0	
2260	352	6	0		30	manual	0	
2261	352	7	0		25	manual	0	
2262	352	12	5		20	auto_completion	100	18/18 งาน (100.0%)
2263	352	13	5		15	auto_ontime	100	18/18 งาน (100.0%)
2264	352	14	4		10	auto_quality	88.89	16/18 งาน (88.9%)
2265	353	1	0		20	manual	0	
2266	353	2	0		15	manual	0	
2267	353	3	0		10	manual	0	
2268	353	6	0		30	manual	0	
2269	353	7	0		25	manual	0	
2270	353	12	5		20	auto_completion	90.91	20/22 งาน (90.9%)
2271	353	13	5		15	auto_ontime	100	20/20 งาน (100.0%)
2272	353	14	5		10	auto_quality	90	18/20 งาน (90.0%)
2273	354	1	0		20	manual	0	
2274	354	2	0		15	manual	0	
2275	354	3	0		10	manual	0	
2276	354	6	0		30	manual	0	
2277	354	7	0		25	manual	0	
2278	354	12	4		20	auto_completion	86.96	20/23 งาน (87.0%)
2279	354	13	4		15	auto_ontime	85	17/20 งาน (85.0%)
2280	354	14	4		10	auto_quality	80	16/20 งาน (80.0%)
2281	355	1	0		20	manual	0	
2282	355	2	0		15	manual	0	
2283	355	3	0		10	manual	0	
2284	355	6	0		30	manual	0	
2285	355	7	0		25	manual	0	
2286	355	8	0		10	manual	0	
2287	355	12	5		20	auto_completion	95.24	20/21 งาน (95.2%)
2288	355	13	5		15	auto_ontime	90	18/20 งาน (90.0%)
2289	355	14	4		10	auto_quality	85	17/20 งาน (85.0%)
2290	356	1	0		20	manual	0	
2291	356	2	0		15	manual	0	
2292	356	3	0		10	manual	0	
2293	356	6	0		30	manual	0	
2294	356	7	0		25	manual	0	
2295	356	8	0		10	manual	0	
2296	356	12	5		20	auto_completion	91.67	22/24 งาน (91.7%)
2297	356	13	4		15	auto_ontime	86.36	19/22 งาน (86.4%)
2298	356	14	3		10	auto_quality	72.73	16/22 งาน (72.7%)
2299	357	1	0		20	manual	0	
2300	357	2	0		15	manual	0	
2301	357	3	0		10	manual	0	
2302	357	6	0		30	manual	0	
2303	357	7	0		25	manual	0	
2304	357	8	0		10	manual	0	
2305	357	12	5		20	auto_completion	93.33	14/15 งาน (93.3%)
2306	357	13	4		15	auto_ontime	85.71	12/14 งาน (85.7%)
2307	357	14	5		10	auto_quality	100	14/14 งาน (100.0%)
2308	358	1	0		20	manual	0	
2309	358	2	0		15	manual	0	
2310	358	3	0		10	manual	0	
2311	358	6	0		30	manual	0	
2312	358	7	0		25	manual	0	
2313	358	12	5		20	auto_completion	100	18/18 งาน (100.0%)
2314	358	13	4		15	auto_ontime	88.89	16/18 งาน (88.9%)
2315	358	14	5		10	auto_quality	94.44	17/18 งาน (94.4%)
2316	359	1	0		20	manual	0	
2317	359	2	0		15	manual	0	
2318	359	3	0		10	manual	0	
2319	359	6	0		30	manual	0	
2320	359	7	0		25	manual	0	
2321	359	12	4		20	auto_completion	89.47	17/19 งาน (89.5%)
2322	359	13	3		15	auto_ontime	76.47	13/17 งาน (76.5%)
2323	359	14	3		10	auto_quality	76.47	13/17 งาน (76.5%)
2324	360	1	0		20	manual	0	
2325	360	2	0		15	manual	0	
2326	360	3	0		10	manual	0	
2327	360	6	0		30	manual	0	
2328	360	7	0		25	manual	0	
2329	360	12	5		20	auto_completion	95.83	23/24 งาน (95.8%)
2330	360	13	5		15	auto_ontime	95.65	22/23 งาน (95.7%)
2331	360	14	5		10	auto_quality	95.65	22/23 งาน (95.7%)
2332	361	1	0		20	manual	0	
2333	361	2	0		15	manual	0	
2334	361	3	0		10	manual	0	
2335	361	6	0		30	manual	0	
2336	361	7	0		25	manual	0	
2337	361	12	1		20	auto_completion	59.09	13/22 งาน (59.1%)
2338	361	13	1		15	auto_ontime	53.85	7/13 งาน (53.9%)
2339	361	14	1		10	auto_quality	46.15	6/13 งาน (46.1%)
2340	362	1	0		20	manual	0	
2341	362	2	0		15	manual	0	
2342	362	3	0		10	manual	0	
2343	362	6	0		30	manual	0	
2344	362	7	0		25	manual	0	
2345	362	12	5		20	auto_completion	100	16/16 งาน (100.0%)
2346	362	13	4		15	auto_ontime	87.5	14/16 งาน (87.5%)
2347	362	14	2		10	auto_quality	68.75	11/16 งาน (68.8%)
2348	363	1	0		20	manual	0	
2349	363	2	0		15	manual	0	
2350	363	3	0		10	manual	0	
2351	363	6	0		30	manual	0	
2352	363	7	0		25	manual	0	
2353	363	12	2		20	auto_completion	66.67	14/21 งาน (66.7%)
2354	363	13	4		15	auto_ontime	85.71	12/14 งาน (85.7%)
2355	363	14	3		10	auto_quality	71.43	10/14 งาน (71.4%)
2356	364	1	0		20	manual	0	
2357	364	2	0		15	manual	0	
2358	364	3	0		10	manual	0	
2359	364	6	0		30	manual	0	
2360	364	7	0		25	manual	0	
2361	364	12	0		20	manual	0	
2362	364	13	0		15	manual	0	
2363	364	14	0		10	manual	0	
2364	365	1	0		20	manual	0	
2365	365	2	0		15	manual	0	
2366	365	3	0		10	manual	0	
2367	365	6	0		30	manual	0	
2368	365	7	0		25	manual	0	
2369	365	8	0		10	manual	0	
2370	365	12	2		20	auto_completion	63.64	14/22 งาน (63.6%)
2371	365	13	3		15	auto_ontime	71.43	10/14 งาน (71.4%)
2372	365	14	1		10	auto_quality	42.86	6/14 งาน (42.9%)
2373	366	1	0		20	manual	0	
2374	366	2	0		15	manual	0	
2375	366	3	0		10	manual	0	
2376	366	6	0		30	manual	0	
2377	366	7	0		25	manual	0	
2378	366	8	0		10	manual	0	
2379	366	12	2		20	auto_completion	63.16	12/19 งาน (63.2%)
2380	366	13	2		15	auto_ontime	66.67	8/12 งาน (66.7%)
2381	366	14	4		10	auto_quality	83.33	10/12 งาน (83.3%)
2382	367	1	0		20	manual	0	
2383	367	2	0		15	manual	0	
2384	367	3	0		10	manual	0	
2385	367	6	0		30	manual	0	
2386	367	7	0		25	manual	0	
2387	367	8	0		10	manual	0	
2388	367	12	5		20	auto_completion	90	18/20 งาน (90.0%)
2389	367	13	5		15	auto_ontime	94.44	17/18 งาน (94.4%)
2390	367	14	4		10	auto_quality	83.33	15/18 งาน (83.3%)
2391	368	1	0		20	manual	0	
2392	368	2	0		15	manual	0	
2393	368	3	0		10	manual	0	
2394	368	6	0		30	manual	0	
2395	368	7	0		25	manual	0	
2396	368	12	5		20	auto_completion	93.33	14/15 งาน (93.3%)
2397	368	13	4		15	auto_ontime	85.71	12/14 งาน (85.7%)
2398	368	14	2		10	auto_quality	64.29	9/14 งาน (64.3%)
2399	369	1	0		20	manual	0	
2400	369	2	0		15	manual	0	
2401	369	3	0		10	manual	0	
2402	369	6	0		30	manual	0	
2403	369	7	0		25	manual	0	
2404	369	12	2		20	auto_completion	66.67	12/18 งาน (66.7%)
2405	369	13	1		15	auto_ontime	58.33	7/12 งาน (58.3%)
2406	369	14	2		10	auto_quality	66.67	8/12 งาน (66.7%)
2423	314	1	4		20	manual	0	
2424	314	2	4		15	manual	0	
2425	314	3	5		10	manual	0	
2426	314	6	5		30	manual	0	
2427	314	7	5		25	manual	0	
2428	314	12	5		20	manual	0	
2429	314	13	5		15	manual	0	
2430	314	14	5		10	manual	0	
2437	9	1	5		20	manual	0	
2438	9	2	5		15	manual	0	
2439	9	3	5		10	manual	0	
2440	9	9	2		30	auto_completion	68.75	11/16 งาน (68.8%)
2441	9	10	1		25	auto_ontime	45.45	5/11 งาน (45.5%)
2442	9	11	1		20	auto_quality	54.55	6/11 งาน (54.5%)
2449	10	1	5		20	manual	0	
2450	10	2	5		15	manual	0	
2451	10	3	5		10	manual	0	
2452	10	9	5		30	auto_completion	95.24	20/21 งาน (95.2%)
2453	10	10	5		25	auto_ontime	90	18/20 งาน (90.0%)
2454	10	11	5		20	auto_quality	90	18/20 งาน (90.0%)
2461	11	1	5		20	manual	0	
2462	11	2	5		15	manual	0	
2463	11	3	5		10	manual	0	
2464	11	9	5		30	auto_completion	100	19/19 งาน (100.0%)
2465	11	10	5		25	auto_ontime	100	19/19 งาน (100.0%)
2466	11	11	5		20	auto_quality	100	19/19 งาน (100.0%)
2473	370	1	5		20	manual	0	
2474	370	2	5		15	manual	0	
2475	370	3	5		10	manual	0	
2476	370	9	5		30	manual	0	
2477	370	10	5		25	manual	0	
2478	370	11	5		20	manual	0	
2485	12	1	5		20	manual	0	
2486	12	2	5		15	manual	0	
2487	12	3	5		10	manual	0	
2488	12	9	5		30	auto_completion	100	15/15 งาน (100.0%)
2489	12	10	5		25	auto_ontime	100	15/15 งาน (100.0%)
2490	12	11	5		20	auto_quality	93.33	14/15 งาน (93.3%)
2512	1	1	4		20	manual	0	
2513	1	2	5		15	manual	0	
2514	1	3	3		10	manual	0	
2515	1	8	5		10	manual	0	
2516	1	9	5		30	auto_completion	100	20/20 งาน (100.0%)
2517	1	10	5		25	auto_ontime	90	18/20 งาน (90.0%)
2518	1	11	5		20	auto_quality	90	18/20 งาน (90.0%)
\.


--
-- Data for Name: evaluations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.evaluations (id, cycle_id, employee_id, type, evaluator_id, status, total_score, comment, employee_feedback, approved_by, submitted_at, approved_at, created_at, updated_at) FROM stdin;
2	3	7	supervisor	4	draft	3.83			\N	\N	\N	2026-10-14 03:15:13.439889+00	2026-10-14 03:15:13.439889+00
61	3	81	supervisor	14	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.184347+00	2026-10-14 10:04:10.184347+00
62	3	82	supervisor	14	draft	3.53			\N	\N	\N	2026-10-14 10:04:10.189083+00	2026-10-14 10:04:10.189083+00
63	3	83	supervisor	14	draft	1.33			\N	\N	\N	2026-10-14 10:04:10.193914+00	2026-10-14 10:04:10.193914+00
4	3	51	supervisor	13	draft	5			\N	\N	\N	2026-10-14 09:59:54.714492+00	2026-10-14 09:59:54.714492+00
5	3	8	supervisor	4	draft	2.07			\N	\N	\N	2026-10-14 10:04:09.806771+00	2026-10-14 10:04:09.806771+00
13	3	32	supervisor	12	draft	2.13			\N	\N	\N	2026-10-14 10:04:09.865222+00	2026-10-14 10:04:09.865222+00
14	3	33	supervisor	12	draft	2.07			\N	\N	\N	2026-10-14 10:04:09.870506+00	2026-10-14 10:04:09.870506+00
15	3	34	supervisor	12	draft	1			\N	\N	\N	2026-10-14 10:04:09.87541+00	2026-10-14 10:04:09.87541+00
16	3	35	supervisor	12	draft	4.4			\N	\N	\N	2026-10-14 10:04:09.881381+00	2026-10-14 10:04:09.881381+00
17	3	36	supervisor	12	draft	3.4			\N	\N	\N	2026-10-14 10:04:09.887904+00	2026-10-14 10:04:09.887904+00
18	3	37	supervisor	12	draft	4.07			\N	\N	\N	2026-10-14 10:04:09.892718+00	2026-10-14 10:04:09.892718+00
19	3	38	supervisor	12	draft	5			\N	\N	\N	2026-10-14 10:04:09.897461+00	2026-10-14 10:04:09.897461+00
20	3	39	supervisor	12	draft	3.2			\N	\N	\N	2026-10-14 10:04:09.902386+00	2026-10-14 10:04:09.902386+00
21	3	40	supervisor	12	draft	1.8			\N	\N	\N	2026-10-14 10:04:09.907429+00	2026-10-14 10:04:09.907429+00
22	3	41	supervisor	12	draft	5			\N	\N	\N	2026-10-14 10:04:09.912154+00	2026-10-14 10:04:09.912154+00
23	3	42	supervisor	12	draft	3.8			\N	\N	\N	2026-10-14 10:04:09.917248+00	2026-10-14 10:04:09.917248+00
24	3	43	supervisor	12	draft	2.13			\N	\N	\N	2026-10-14 10:04:09.923151+00	2026-10-14 10:04:09.923151+00
25	3	44	supervisor	12	draft	4.73			\N	\N	\N	2026-10-14 10:04:09.928169+00	2026-10-14 10:04:09.928169+00
26	3	45	supervisor	12	draft	4.33			\N	\N	\N	2026-10-14 10:04:09.933771+00	2026-10-14 10:04:09.933771+00
27	3	46	supervisor	12	draft	4			\N	\N	\N	2026-10-14 10:04:09.942612+00	2026-10-14 10:04:09.942612+00
28	3	47	supervisor	13	draft	4.67			\N	\N	\N	2026-10-14 10:04:09.947994+00	2026-10-14 10:04:09.947994+00
29	3	48	supervisor	13	draft	4.33			\N	\N	\N	2026-10-14 10:04:09.952961+00	2026-10-14 10:04:09.952961+00
30	3	49	supervisor	13	draft	5			\N	\N	\N	2026-10-14 10:04:09.957575+00	2026-10-14 10:04:09.957575+00
31	3	50	supervisor	13	draft	4.33			\N	\N	\N	2026-10-14 10:04:09.962529+00	2026-10-14 10:04:09.962529+00
32	3	52	supervisor	13	draft	2.47			\N	\N	\N	2026-10-14 10:04:09.968422+00	2026-10-14 10:04:09.968422+00
33	3	53	supervisor	13	draft	5			\N	\N	\N	2026-10-14 10:04:09.973448+00	2026-10-14 10:04:09.973448+00
34	3	54	supervisor	13	draft	1			\N	\N	\N	2026-10-14 10:04:09.980303+00	2026-10-14 10:04:09.980303+00
35	3	55	supervisor	13	draft	2.8			\N	\N	\N	2026-10-14 10:04:09.98552+00	2026-10-14 10:04:09.98552+00
36	3	56	supervisor	13	draft	3.33			\N	\N	\N	2026-10-14 10:04:09.990297+00	2026-10-14 10:04:09.990297+00
37	3	57	supervisor	13	draft	3.67			\N	\N	\N	2026-10-14 10:04:09.995249+00	2026-10-14 10:04:09.995249+00
38	3	58	supervisor	13	draft	2.93			\N	\N	\N	2026-10-14 10:04:10.000254+00	2026-10-14 10:04:10.000254+00
39	3	59	supervisor	13	draft	4.4			\N	\N	\N	2026-10-14 10:04:10.005161+00	2026-10-14 10:04:10.005161+00
40	3	60	supervisor	13	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.009987+00	2026-10-14 10:04:10.009987+00
41	3	61	supervisor	13	draft	3.87			\N	\N	\N	2026-10-14 10:04:10.015104+00	2026-10-14 10:04:10.015104+00
42	3	62	supervisor	13	draft	4			\N	\N	\N	2026-10-14 10:04:10.019949+00	2026-10-14 10:04:10.019949+00
43	3	63	supervisor	13	draft	4.07			\N	\N	\N	2026-10-14 10:04:10.024959+00	2026-10-14 10:04:10.024959+00
44	3	64	supervisor	13	draft	5			\N	\N	\N	2026-10-14 10:04:10.03083+00	2026-10-14 10:04:10.03083+00
45	3	65	supervisor	13	draft	1.67			\N	\N	\N	2026-10-14 10:04:10.039662+00	2026-10-14 10:04:10.039662+00
46	3	66	supervisor	13	draft	1			\N	\N	\N	2026-10-14 10:04:10.04899+00	2026-10-14 10:04:10.04899+00
47	3	67	supervisor	14	draft	4.6			\N	\N	\N	2026-10-14 10:04:10.075045+00	2026-10-14 10:04:10.075045+00
48	3	68	supervisor	14	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.082751+00	2026-10-14 10:04:10.082751+00
49	3	69	supervisor	14	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.092769+00	2026-10-14 10:04:10.092769+00
50	3	70	supervisor	14	draft	3.2			\N	\N	\N	2026-10-14 10:04:10.100969+00	2026-10-14 10:04:10.100969+00
51	3	71	supervisor	14	draft	2.8			\N	\N	\N	2026-10-14 10:04:10.121273+00	2026-10-14 10:04:10.121273+00
52	3	72	supervisor	14	draft	3.4			\N	\N	\N	2026-10-14 10:04:10.131772+00	2026-10-14 10:04:10.131772+00
53	3	73	supervisor	14	draft	4.67			\N	\N	\N	2026-10-14 10:04:10.144417+00	2026-10-14 10:04:10.144417+00
54	3	74	supervisor	14	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.149499+00	2026-10-14 10:04:10.149499+00
55	3	75	supervisor	14	draft	5			\N	\N	\N	2026-10-14 10:04:10.155056+00	2026-10-14 10:04:10.155056+00
56	3	76	supervisor	14	draft	0			\N	\N	\N	2026-10-14 10:04:10.159951+00	2026-10-14 10:04:10.159951+00
57	3	77	supervisor	14	draft	4.13			\N	\N	\N	2026-10-14 10:04:10.164723+00	2026-10-14 10:04:10.164723+00
58	3	78	supervisor	14	draft	3.2			\N	\N	\N	2026-10-14 10:04:10.169574+00	2026-10-14 10:04:10.169574+00
59	3	79	supervisor	14	draft	3.07			\N	\N	\N	2026-10-14 10:04:10.174522+00	2026-10-14 10:04:10.174522+00
60	3	80	supervisor	14	draft	3.73			\N	\N	\N	2026-10-14 10:04:10.179325+00	2026-10-14 10:04:10.179325+00
64	3	84	supervisor	14	draft	3.33			\N	\N	\N	2026-10-14 10:04:10.19902+00	2026-10-14 10:04:10.19902+00
65	3	85	supervisor	14	draft	2.27			\N	\N	\N	2026-10-14 10:04:10.203924+00	2026-10-14 10:04:10.203924+00
66	3	86	supervisor	14	draft	5			\N	\N	\N	2026-10-14 10:04:10.208736+00	2026-10-14 10:04:10.208736+00
67	3	87	supervisor	15	draft	4.07			\N	\N	\N	2026-10-14 10:04:10.213841+00	2026-10-14 10:04:10.213841+00
68	3	88	supervisor	15	draft	2.47			\N	\N	\N	2026-10-14 10:04:10.219629+00	2026-10-14 10:04:10.219629+00
69	3	89	supervisor	15	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.224446+00	2026-10-14 10:04:10.224446+00
70	3	90	supervisor	15	draft	3.87			\N	\N	\N	2026-10-14 10:04:10.229508+00	2026-10-14 10:04:10.229508+00
71	3	91	supervisor	15	draft	5			\N	\N	\N	2026-10-14 10:04:10.240711+00	2026-10-14 10:04:10.240711+00
72	3	92	supervisor	15	draft	2			\N	\N	\N	2026-10-14 10:04:10.249502+00	2026-10-14 10:04:10.249502+00
73	3	93	supervisor	15	draft	3.73			\N	\N	\N	2026-10-14 10:04:10.254823+00	2026-10-14 10:04:10.254823+00
12	3	31	supervisor	12	submitted	5			\N	2026-10-15 02:58:04.916099+00	\N	2026-10-14 10:04:09.859398+00	2026-10-15 02:58:04.916541+00
9	3	28	supervisor	12	approved	2.75			1	2026-10-14 15:59:17.774006+00	2026-10-14 16:03:24.681717+00	2026-10-14 10:04:09.832617+00	2026-10-14 16:03:24.682135+00
10	3	29	supervisor	12	approved	5			1	2026-10-14 15:59:33.131643+00	2026-10-14 16:03:24.677974+00	2026-10-14 10:04:09.841444+00	2026-10-14 16:03:24.678207+00
1	3	6	supervisor	4	approved	4.69			1	2026-10-15 04:01:18.484522+00	2026-10-15 04:03:52.875723+00	2026-10-14 02:36:00.087599+00	2026-10-15 04:03:52.875978+00
74	3	94	supervisor	15	draft	2.67			\N	\N	\N	2026-10-14 10:04:10.259866+00	2026-10-14 10:04:10.259866+00
75	3	95	supervisor	15	draft	1.67			\N	\N	\N	2026-10-14 10:04:10.266207+00	2026-10-14 10:04:10.266207+00
76	3	96	supervisor	15	draft	4			\N	\N	\N	2026-10-14 10:04:10.271757+00	2026-10-14 10:04:10.271757+00
77	3	97	supervisor	15	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.276645+00	2026-10-14 10:04:10.276645+00
78	3	98	supervisor	15	draft	5			\N	\N	\N	2026-10-14 10:04:10.2815+00	2026-10-14 10:04:10.2815+00
79	3	99	supervisor	15	draft	4.67			\N	\N	\N	2026-10-14 10:04:10.286334+00	2026-10-14 10:04:10.286334+00
80	3	100	supervisor	15	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.291215+00	2026-10-14 10:04:10.291215+00
81	3	101	supervisor	15	draft	0			\N	\N	\N	2026-10-14 10:04:10.295657+00	2026-10-14 10:04:10.295657+00
82	3	102	supervisor	15	draft	3.13			\N	\N	\N	2026-10-14 10:04:10.300466+00	2026-10-14 10:04:10.300466+00
83	3	103	supervisor	15	draft	4			\N	\N	\N	2026-10-14 10:04:10.305396+00	2026-10-14 10:04:10.305396+00
84	3	104	supervisor	15	draft	5			\N	\N	\N	2026-10-14 10:04:10.310374+00	2026-10-14 10:04:10.310374+00
85	3	105	supervisor	15	draft	3.2			\N	\N	\N	2026-10-14 10:04:10.315254+00	2026-10-14 10:04:10.315254+00
86	3	106	supervisor	15	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.319964+00	2026-10-14 10:04:10.319964+00
87	3	107	supervisor	16	draft	3.93			\N	\N	\N	2026-10-14 10:04:10.324907+00	2026-10-14 10:04:10.324907+00
88	3	108	supervisor	16	draft	3.67			\N	\N	\N	2026-10-14 10:04:10.32961+00	2026-10-14 10:04:10.32961+00
89	3	109	supervisor	16	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.341424+00	2026-10-14 10:04:10.341424+00
90	3	110	supervisor	16	draft	3.87			\N	\N	\N	2026-10-14 10:04:10.349925+00	2026-10-14 10:04:10.349925+00
91	3	111	supervisor	16	draft	3.27			\N	\N	\N	2026-10-14 10:04:10.354602+00	2026-10-14 10:04:10.354602+00
92	3	112	supervisor	16	draft	4			\N	\N	\N	2026-10-14 10:04:10.359496+00	2026-10-14 10:04:10.359496+00
93	3	113	supervisor	16	draft	3.4			\N	\N	\N	2026-10-14 10:04:10.364391+00	2026-10-14 10:04:10.364391+00
94	3	114	supervisor	16	draft	2.33			\N	\N	\N	2026-10-14 10:04:10.369177+00	2026-10-14 10:04:10.369177+00
95	3	115	supervisor	16	draft	5			\N	\N	\N	2026-10-14 10:04:10.373983+00	2026-10-14 10:04:10.373983+00
96	3	116	supervisor	16	draft	3.8			\N	\N	\N	2026-10-14 10:04:10.378963+00	2026-10-14 10:04:10.378963+00
97	3	117	supervisor	16	draft	4.13			\N	\N	\N	2026-10-14 10:04:10.383711+00	2026-10-14 10:04:10.383711+00
98	3	118	supervisor	16	draft	2.13			\N	\N	\N	2026-10-14 10:04:10.38843+00	2026-10-14 10:04:10.38843+00
99	3	119	supervisor	16	draft	2			\N	\N	\N	2026-10-14 10:04:10.393577+00	2026-10-14 10:04:10.393577+00
100	3	120	supervisor	16	draft	4.07			\N	\N	\N	2026-10-14 10:04:10.398266+00	2026-10-14 10:04:10.398266+00
101	3	121	supervisor	16	draft	1.67			\N	\N	\N	2026-10-14 10:04:10.403157+00	2026-10-14 10:04:10.403157+00
102	3	122	supervisor	16	draft	2.87			\N	\N	\N	2026-10-14 10:04:10.408009+00	2026-10-14 10:04:10.408009+00
103	3	123	supervisor	16	draft	3.73			\N	\N	\N	2026-10-14 10:04:10.412853+00	2026-10-14 10:04:10.412853+00
104	3	124	supervisor	16	draft	2.2			\N	\N	\N	2026-10-14 10:04:10.417499+00	2026-10-14 10:04:10.417499+00
105	3	125	supervisor	16	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.422474+00	2026-10-14 10:04:10.422474+00
106	3	126	supervisor	16	draft	0			\N	\N	\N	2026-10-14 10:04:10.427125+00	2026-10-14 10:04:10.427125+00
107	3	127	supervisor	17	draft	4.4			\N	\N	\N	2026-10-14 10:04:10.431859+00	2026-10-14 10:04:10.431859+00
108	3	128	supervisor	17	draft	1			\N	\N	\N	2026-10-14 10:04:10.44318+00	2026-10-14 10:04:10.44318+00
109	3	129	supervisor	17	draft	2			\N	\N	\N	2026-10-14 10:04:10.450671+00	2026-10-14 10:04:10.450671+00
110	3	130	supervisor	17	draft	2.4			\N	\N	\N	2026-10-14 10:04:10.455515+00	2026-10-14 10:04:10.455515+00
111	3	131	supervisor	17	draft	3.6			\N	\N	\N	2026-10-14 10:04:10.460418+00	2026-10-14 10:04:10.460418+00
112	3	132	supervisor	17	draft	1.4			\N	\N	\N	2026-10-14 10:04:10.466308+00	2026-10-14 10:04:10.466308+00
113	3	133	supervisor	17	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.476484+00	2026-10-14 10:04:10.476484+00
114	3	134	supervisor	17	draft	1.73			\N	\N	\N	2026-10-14 10:04:10.481522+00	2026-10-14 10:04:10.481522+00
115	3	135	supervisor	17	draft	4			\N	\N	\N	2026-10-14 10:04:10.486337+00	2026-10-14 10:04:10.486337+00
116	3	136	supervisor	17	draft	2.93			\N	\N	\N	2026-10-14 10:04:10.491048+00	2026-10-14 10:04:10.491048+00
117	3	137	supervisor	17	draft	4			\N	\N	\N	2026-10-14 10:04:10.496056+00	2026-10-14 10:04:10.496056+00
118	3	138	supervisor	17	draft	1.27			\N	\N	\N	2026-10-14 10:04:10.500941+00	2026-10-14 10:04:10.500941+00
119	3	139	supervisor	17	draft	2.27			\N	\N	\N	2026-10-14 10:04:10.505875+00	2026-10-14 10:04:10.505875+00
120	3	140	supervisor	17	draft	2.93			\N	\N	\N	2026-10-14 10:04:10.51096+00	2026-10-14 10:04:10.51096+00
121	3	141	supervisor	17	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.515633+00	2026-10-14 10:04:10.515633+00
122	3	142	supervisor	17	draft	2.07			\N	\N	\N	2026-10-14 10:04:10.520613+00	2026-10-14 10:04:10.520613+00
123	3	143	supervisor	17	draft	2.13			\N	\N	\N	2026-10-14 10:04:10.525598+00	2026-10-14 10:04:10.525598+00
124	3	144	supervisor	17	draft	4.67			\N	\N	\N	2026-10-14 10:04:10.530354+00	2026-10-14 10:04:10.530354+00
125	3	145	supervisor	17	draft	4			\N	\N	\N	2026-10-14 10:04:10.536334+00	2026-10-14 10:04:10.536334+00
126	3	146	supervisor	17	draft	3.13			\N	\N	\N	2026-10-14 10:04:10.542765+00	2026-10-14 10:04:10.542765+00
187	3	207	supervisor	21	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.876707+00	2026-10-14 10:04:10.876707+00
188	3	208	supervisor	21	draft	4.47			\N	\N	\N	2026-10-14 10:04:10.881483+00	2026-10-14 10:04:10.881483+00
189	3	209	supervisor	21	draft	2.93			\N	\N	\N	2026-10-14 10:04:10.886499+00	2026-10-14 10:04:10.886499+00
190	3	210	supervisor	21	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.891299+00	2026-10-14 10:04:10.891299+00
191	3	211	supervisor	21	draft	4.73			\N	\N	\N	2026-10-14 10:04:10.895913+00	2026-10-14 10:04:10.895913+00
192	3	212	supervisor	21	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.900753+00	2026-10-14 10:04:10.900753+00
193	3	213	supervisor	21	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.905271+00	2026-10-14 10:04:10.905271+00
194	3	214	supervisor	21	draft	2.4			\N	\N	\N	2026-10-14 10:04:10.911216+00	2026-10-14 10:04:10.911216+00
195	3	215	supervisor	21	draft	5			\N	\N	\N	2026-10-14 10:04:10.916059+00	2026-10-14 10:04:10.916059+00
196	3	216	supervisor	21	draft	1.27			\N	\N	\N	2026-10-14 10:04:10.920551+00	2026-10-14 10:04:10.920551+00
197	3	217	supervisor	21	draft	3.4			\N	\N	\N	2026-10-14 10:04:10.925213+00	2026-10-14 10:04:10.925213+00
198	3	218	supervisor	21	draft	3.47			\N	\N	\N	2026-10-14 10:04:10.929996+00	2026-10-14 10:04:10.929996+00
199	3	219	supervisor	21	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.935423+00	2026-10-14 10:04:10.935423+00
200	3	220	supervisor	21	draft	4.6			\N	\N	\N	2026-10-14 10:04:10.942182+00	2026-10-14 10:04:10.942182+00
201	3	221	supervisor	21	draft	3.33			\N	\N	\N	2026-10-14 10:04:10.947277+00	2026-10-14 10:04:10.947277+00
202	3	222	supervisor	21	draft	5			\N	\N	\N	2026-10-14 10:04:10.954501+00	2026-10-14 10:04:10.954501+00
203	3	223	supervisor	21	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.959719+00	2026-10-14 10:04:10.959719+00
204	3	224	supervisor	21	draft	3.47			\N	\N	\N	2026-10-14 10:04:10.965325+00	2026-10-14 10:04:10.965325+00
205	3	225	supervisor	21	draft	4.47			\N	\N	\N	2026-10-14 10:04:10.974981+00	2026-10-14 10:04:10.974981+00
206	3	226	supervisor	21	draft	0			\N	\N	\N	2026-10-14 10:04:10.979564+00	2026-10-14 10:04:10.979564+00
207	3	227	supervisor	22	draft	2.47			\N	\N	\N	2026-10-14 10:04:10.984457+00	2026-10-14 10:04:10.984457+00
208	3	228	supervisor	22	draft	3.2			\N	\N	\N	2026-10-14 10:04:10.989183+00	2026-10-14 10:04:10.989183+00
209	3	229	supervisor	22	draft	4.33			\N	\N	\N	2026-10-14 10:04:10.994048+00	2026-10-14 10:04:10.994048+00
210	3	230	supervisor	22	draft	3.8			\N	\N	\N	2026-10-14 10:04:10.99899+00	2026-10-14 10:04:10.99899+00
211	3	231	supervisor	22	draft	2.47			\N	\N	\N	2026-10-14 10:04:11.003623+00	2026-10-14 10:04:11.003623+00
212	3	232	supervisor	22	draft	4.33			\N	\N	\N	2026-10-14 10:04:11.00843+00	2026-10-14 10:04:11.00843+00
213	3	233	supervisor	22	draft	3.27			\N	\N	\N	2026-10-14 10:04:11.013396+00	2026-10-14 10:04:11.013396+00
214	3	234	supervisor	22	draft	2.67			\N	\N	\N	2026-10-14 10:04:11.018205+00	2026-10-14 10:04:11.018205+00
215	3	235	supervisor	22	draft	5			\N	\N	\N	2026-10-14 10:04:11.024288+00	2026-10-14 10:04:11.024288+00
216	3	236	supervisor	22	draft	4.33			\N	\N	\N	2026-10-14 10:04:11.029016+00	2026-10-14 10:04:11.029016+00
217	3	237	supervisor	22	draft	2.67			\N	\N	\N	2026-10-14 10:04:11.036244+00	2026-10-14 10:04:11.036244+00
218	3	238	supervisor	22	draft	4.07			\N	\N	\N	2026-10-14 10:04:11.041257+00	2026-10-14 10:04:11.041257+00
219	3	239	supervisor	22	draft	2.8			\N	\N	\N	2026-10-14 10:04:11.047528+00	2026-10-14 10:04:11.047528+00
220	3	240	supervisor	22	draft	4.4			\N	\N	\N	2026-10-14 10:04:11.055893+00	2026-10-14 10:04:11.055893+00
221	3	241	supervisor	22	draft	4.67			\N	\N	\N	2026-10-14 10:04:11.060507+00	2026-10-14 10:04:11.060507+00
222	3	242	supervisor	22	draft	5			\N	\N	\N	2026-10-14 10:04:11.065566+00	2026-10-14 10:04:11.065566+00
223	3	243	supervisor	22	draft	4.67			\N	\N	\N	2026-10-14 10:04:11.079572+00	2026-10-14 10:04:11.079572+00
224	3	244	supervisor	22	draft	4.47			\N	\N	\N	2026-10-14 10:04:11.084706+00	2026-10-14 10:04:11.084706+00
225	3	245	supervisor	22	draft	5			\N	\N	\N	2026-10-14 10:04:11.089516+00	2026-10-14 10:04:11.089516+00
226	3	246	supervisor	22	draft	3.47			\N	\N	\N	2026-10-14 10:04:11.094385+00	2026-10-14 10:04:11.094385+00
227	3	247	supervisor	23	draft	4.67			\N	\N	\N	2026-10-14 10:04:11.099234+00	2026-10-14 10:04:11.099234+00
228	3	248	supervisor	23	draft	3.13			\N	\N	\N	2026-10-14 10:04:11.10375+00	2026-10-14 10:04:11.10375+00
229	3	249	supervisor	23	draft	4.73			\N	\N	\N	2026-10-14 10:04:11.108576+00	2026-10-14 10:04:11.108576+00
230	3	250	supervisor	23	draft	4.67			\N	\N	\N	2026-10-14 10:04:11.113461+00	2026-10-14 10:04:11.113461+00
231	3	251	supervisor	23	draft	0			\N	\N	\N	2026-10-14 10:04:11.117927+00	2026-10-14 10:04:11.117927+00
232	3	252	supervisor	23	draft	4.07			\N	\N	\N	2026-10-14 10:04:11.122718+00	2026-10-14 10:04:11.122718+00
233	3	253	supervisor	23	draft	2.47			\N	\N	\N	2026-10-14 10:04:11.127693+00	2026-10-14 10:04:11.127693+00
234	3	254	supervisor	23	draft	5			\N	\N	\N	2026-10-14 10:04:11.132622+00	2026-10-14 10:04:11.132622+00
235	3	255	supervisor	23	draft	2.47			\N	\N	\N	2026-10-14 10:04:11.143555+00	2026-10-14 10:04:11.143555+00
236	3	256	supervisor	23	draft	2.13			\N	\N	\N	2026-10-14 10:04:11.152657+00	2026-10-14 10:04:11.152657+00
237	3	257	supervisor	23	draft	5			\N	\N	\N	2026-10-14 10:04:11.158386+00	2026-10-14 10:04:11.158386+00
238	3	258	supervisor	23	draft	4.73			\N	\N	\N	2026-10-14 10:04:11.163237+00	2026-10-14 10:04:11.163237+00
239	3	259	supervisor	23	draft	3.33			\N	\N	\N	2026-10-14 10:04:11.168266+00	2026-10-14 10:04:11.168266+00
240	3	260	supervisor	23	draft	4.67			\N	\N	\N	2026-10-14 10:04:11.173142+00	2026-10-14 10:04:11.173142+00
241	3	261	supervisor	23	draft	4.73			\N	\N	\N	2026-10-14 10:04:11.177827+00	2026-10-14 10:04:11.177827+00
242	3	262	supervisor	23	draft	3.6			\N	\N	\N	2026-10-14 10:04:11.184596+00	2026-10-14 10:04:11.184596+00
243	3	263	supervisor	23	draft	1.67			\N	\N	\N	2026-10-14 10:04:11.196875+00	2026-10-14 10:04:11.196875+00
244	3	264	supervisor	23	draft	3.47			\N	\N	\N	2026-10-14 10:04:11.208806+00	2026-10-14 10:04:11.208806+00
245	3	265	supervisor	23	draft	5			\N	\N	\N	2026-10-14 10:04:11.217134+00	2026-10-14 10:04:11.217134+00
246	3	266	supervisor	23	draft	4.47			\N	\N	\N	2026-10-14 10:04:11.225701+00	2026-10-14 10:04:11.225701+00
247	3	267	supervisor	24	draft	2			\N	\N	\N	2026-10-14 10:04:11.234293+00	2026-10-14 10:04:11.234293+00
248	3	268	supervisor	24	draft	3.93			\N	\N	\N	2026-10-14 10:04:11.240751+00	2026-10-14 10:04:11.240751+00
249	3	269	supervisor	24	draft	3.13			\N	\N	\N	2026-10-14 10:04:11.251006+00	2026-10-14 10:04:11.251006+00
250	3	270	supervisor	24	draft	3.47			\N	\N	\N	2026-10-14 10:04:11.257323+00	2026-10-14 10:04:11.257323+00
251	3	271	supervisor	24	draft	4.13			\N	\N	\N	2026-10-14 10:04:11.262+00	2026-10-14 10:04:11.262+00
252	3	272	supervisor	24	draft	2.93			\N	\N	\N	2026-10-14 10:04:11.266625+00	2026-10-14 10:04:11.266625+00
253	3	273	supervisor	24	draft	3.47			\N	\N	\N	2026-10-14 10:04:11.271192+00	2026-10-14 10:04:11.271192+00
254	3	274	supervisor	24	draft	2.07			\N	\N	\N	2026-10-14 10:04:11.277172+00	2026-10-14 10:04:11.277172+00
255	3	275	supervisor	24	draft	5			\N	\N	\N	2026-10-14 10:04:11.281881+00	2026-10-14 10:04:11.281881+00
256	3	276	supervisor	24	draft	0			\N	\N	\N	2026-10-14 10:04:11.286196+00	2026-10-14 10:04:11.286196+00
257	3	277	supervisor	24	draft	3			\N	\N	\N	2026-10-14 10:04:11.292521+00	2026-10-14 10:04:11.292521+00
258	3	278	supervisor	24	draft	1.6			\N	\N	\N	2026-10-14 10:04:11.297254+00	2026-10-14 10:04:11.297254+00
259	3	279	supervisor	24	draft	1.73			\N	\N	\N	2026-10-14 10:04:11.302162+00	2026-10-14 10:04:11.302162+00
260	3	280	supervisor	24	draft	1.93			\N	\N	\N	2026-10-14 10:04:11.306839+00	2026-10-14 10:04:11.306839+00
261	3	281	supervisor	24	draft	3.87			\N	\N	\N	2026-10-14 10:04:11.313456+00	2026-10-14 10:04:11.313456+00
262	3	282	supervisor	24	draft	3.87			\N	\N	\N	2026-10-14 10:04:11.319839+00	2026-10-14 10:04:11.319839+00
263	3	283	supervisor	24	draft	4.67			\N	\N	\N	2026-10-14 10:04:11.324464+00	2026-10-14 10:04:11.324464+00
264	3	284	supervisor	24	draft	2.6			\N	\N	\N	2026-10-14 10:04:11.329193+00	2026-10-14 10:04:11.329193+00
265	3	285	supervisor	24	draft	3.47			\N	\N	\N	2026-10-14 10:04:11.341739+00	2026-10-14 10:04:11.341739+00
266	3	286	supervisor	24	draft	3.87			\N	\N	\N	2026-10-14 10:04:11.347424+00	2026-10-14 10:04:11.347424+00
267	3	287	supervisor	25	draft	4.73			\N	\N	\N	2026-10-14 10:04:11.356652+00	2026-10-14 10:04:11.356652+00
268	3	288	supervisor	25	draft	3.47			\N	\N	\N	2026-10-14 10:04:11.361511+00	2026-10-14 10:04:11.361511+00
269	3	289	supervisor	25	draft	5			\N	\N	\N	2026-10-14 10:04:11.365918+00	2026-10-14 10:04:11.365918+00
270	3	290	supervisor	25	draft	2.87			\N	\N	\N	2026-10-14 10:04:11.370577+00	2026-10-14 10:04:11.370577+00
271	3	291	supervisor	25	draft	5			\N	\N	\N	2026-10-14 10:04:11.375161+00	2026-10-14 10:04:11.375161+00
272	3	292	supervisor	25	draft	2.13			\N	\N	\N	2026-10-14 10:04:11.379669+00	2026-10-14 10:04:11.379669+00
273	3	293	supervisor	25	draft	2.13			\N	\N	\N	2026-10-14 10:04:11.384055+00	2026-10-14 10:04:11.384055+00
274	3	294	supervisor	25	draft	1.4			\N	\N	\N	2026-10-14 10:04:11.388753+00	2026-10-14 10:04:11.388753+00
275	3	295	supervisor	25	draft	3.4			\N	\N	\N	2026-10-14 10:04:11.393558+00	2026-10-14 10:04:11.393558+00
276	3	296	supervisor	25	draft	3.33			\N	\N	\N	2026-10-14 10:04:11.398219+00	2026-10-14 10:04:11.398219+00
277	3	297	supervisor	25	draft	3.93			\N	\N	\N	2026-10-14 10:04:11.403281+00	2026-10-14 10:04:11.403281+00
278	3	298	supervisor	25	draft	4.13			\N	\N	\N	2026-10-14 10:04:11.409242+00	2026-10-14 10:04:11.409242+00
279	3	299	supervisor	25	draft	2.87			\N	\N	\N	2026-10-14 10:04:11.414185+00	2026-10-14 10:04:11.414185+00
280	3	300	supervisor	25	draft	3.2			\N	\N	\N	2026-10-14 10:04:11.419022+00	2026-10-14 10:04:11.419022+00
281	3	301	supervisor	25	draft	0			\N	\N	\N	2026-10-14 10:04:11.423355+00	2026-10-14 10:04:11.423355+00
282	3	302	supervisor	25	draft	4.4			\N	\N	\N	2026-10-14 10:04:11.428155+00	2026-10-14 10:04:11.428155+00
283	3	303	supervisor	25	draft	3.07			\N	\N	\N	2026-10-14 10:04:11.433483+00	2026-10-14 10:04:11.433483+00
284	3	304	supervisor	25	draft	2			\N	\N	\N	2026-10-14 10:04:11.443332+00	2026-10-14 10:04:11.443332+00
285	3	305	supervisor	25	draft	2.67			\N	\N	\N	2026-10-14 10:04:11.448411+00	2026-10-14 10:04:11.448411+00
286	3	306	supervisor	25	draft	3.2			\N	\N	\N	2026-10-14 10:04:11.453339+00	2026-10-14 10:04:11.453339+00
287	3	307	supervisor	26	draft	5			\N	\N	\N	2026-10-14 10:04:11.46398+00	2026-10-14 10:04:11.46398+00
288	3	308	supervisor	26	draft	4.07			\N	\N	\N	2026-10-14 10:04:11.485553+00	2026-10-14 10:04:11.485553+00
289	3	309	supervisor	26	draft	4.2			\N	\N	\N	2026-10-14 10:04:11.495785+00	2026-10-14 10:04:11.495785+00
290	3	310	supervisor	26	draft	2.13			\N	\N	\N	2026-10-14 10:04:11.501179+00	2026-10-14 10:04:11.501179+00
291	3	311	supervisor	26	draft	3.07			\N	\N	\N	2026-10-14 10:04:11.506237+00	2026-10-14 10:04:11.506237+00
292	3	312	supervisor	26	draft	2.73			\N	\N	\N	2026-10-14 10:04:11.515439+00	2026-10-14 10:04:11.515439+00
293	3	313	supervisor	26	draft	2.13			\N	\N	\N	2026-10-14 10:04:11.524554+00	2026-10-14 10:04:11.524554+00
294	3	314	supervisor	26	draft	4.13			\N	\N	\N	2026-10-14 10:04:11.544569+00	2026-10-14 10:04:11.544569+00
295	3	315	supervisor	26	draft	3.6			\N	\N	\N	2026-10-14 10:04:11.560577+00	2026-10-14 10:04:11.560577+00
296	3	316	supervisor	26	draft	3.07			\N	\N	\N	2026-10-14 10:04:11.57207+00	2026-10-14 10:04:11.57207+00
297	3	317	supervisor	26	draft	2			\N	\N	\N	2026-10-14 10:04:11.576892+00	2026-10-14 10:04:11.576892+00
298	3	318	supervisor	26	draft	4.07			\N	\N	\N	2026-10-14 10:04:11.582045+00	2026-10-14 10:04:11.582045+00
299	3	319	supervisor	26	draft	4.67			\N	\N	\N	2026-10-14 10:04:11.587828+00	2026-10-14 10:04:11.587828+00
300	3	320	supervisor	26	draft	3.73			\N	\N	\N	2026-10-14 10:04:11.592912+00	2026-10-14 10:04:11.592912+00
301	3	321	supervisor	26	draft	4.07			\N	\N	\N	2026-10-14 10:04:11.597924+00	2026-10-14 10:04:11.597924+00
302	3	322	supervisor	26	draft	4.73			\N	\N	\N	2026-10-14 10:04:11.602814+00	2026-10-14 10:04:11.602814+00
303	3	323	supervisor	26	draft	3.73			\N	\N	\N	2026-10-14 10:04:11.607534+00	2026-10-14 10:04:11.607534+00
304	3	324	supervisor	26	draft	3.67			\N	\N	\N	2026-10-14 10:04:11.612591+00	2026-10-14 10:04:11.612591+00
305	3	325	supervisor	26	draft	3.13			\N	\N	\N	2026-10-14 10:04:11.617416+00	2026-10-14 10:04:11.617416+00
306	3	326	supervisor	26	draft	0			\N	\N	\N	2026-10-14 10:04:11.622078+00	2026-10-14 10:04:11.622078+00
307	3	9	supervisor	5	draft	0			\N	\N	\N	2026-10-14 10:33:46.309968+00	2026-10-14 10:33:46.309968+00
308	3	10	supervisor	5	draft	0			\N	\N	\N	2026-10-14 10:33:46.31887+00	2026-10-14 10:33:46.31887+00
309	3	11	supervisor	5	draft	0			\N	\N	\N	2026-10-14 10:33:46.324961+00	2026-10-14 10:33:46.324961+00
310	3	147	supervisor	18	draft	4.56			\N	\N	\N	2026-10-14 10:33:46.440643+00	2026-10-14 10:33:46.440643+00
311	3	148	supervisor	18	draft	2.89			\N	\N	\N	2026-10-14 10:33:46.446068+00	2026-10-14 10:33:46.446068+00
312	3	149	supervisor	18	draft	2.67			\N	\N	\N	2026-10-14 10:33:46.451145+00	2026-10-14 10:33:46.451145+00
313	3	150	supervisor	18	draft	1.78			\N	\N	\N	2026-10-14 10:33:46.456226+00	2026-10-14 10:33:46.456226+00
315	3	152	supervisor	18	draft	1.78			\N	\N	\N	2026-10-14 10:33:46.46764+00	2026-10-14 10:33:46.46764+00
316	3	153	supervisor	18	draft	4.22			\N	\N	\N	2026-10-14 10:33:46.473068+00	2026-10-14 10:33:46.473068+00
317	3	154	supervisor	18	draft	4.67			\N	\N	\N	2026-10-14 10:33:46.4788+00	2026-10-14 10:33:46.4788+00
318	3	155	supervisor	18	draft	1.44			\N	\N	\N	2026-10-14 10:33:46.484943+00	2026-10-14 10:33:46.484943+00
319	3	156	supervisor	18	draft	1.89			\N	\N	\N	2026-10-14 10:33:46.489807+00	2026-10-14 10:33:46.489807+00
320	3	157	supervisor	18	draft	3			\N	\N	\N	2026-10-14 10:33:46.496607+00	2026-10-14 10:33:46.496607+00
321	3	158	supervisor	18	draft	2.33			\N	\N	\N	2026-10-14 10:33:46.507149+00	2026-10-14 10:33:46.507149+00
322	3	159	supervisor	18	draft	5			\N	\N	\N	2026-10-14 10:33:46.513477+00	2026-10-14 10:33:46.513477+00
323	3	160	supervisor	18	draft	3.44			\N	\N	\N	2026-10-14 10:33:46.525999+00	2026-10-14 10:33:46.525999+00
324	3	161	supervisor	18	draft	4.78			\N	\N	\N	2026-10-14 10:33:46.552215+00	2026-10-14 10:33:46.552215+00
325	3	162	supervisor	18	draft	4.22			\N	\N	\N	2026-10-14 10:33:46.563804+00	2026-10-14 10:33:46.563804+00
326	3	163	supervisor	18	draft	5			\N	\N	\N	2026-10-14 10:33:46.598287+00	2026-10-14 10:33:46.598287+00
327	3	164	supervisor	18	draft	3.22			\N	\N	\N	2026-10-14 10:33:46.605173+00	2026-10-14 10:33:46.605173+00
328	3	165	supervisor	18	draft	4.44			\N	\N	\N	2026-10-14 10:33:46.61282+00	2026-10-14 10:33:46.61282+00
329	3	166	supervisor	18	draft	2.78			\N	\N	\N	2026-10-14 10:33:46.61957+00	2026-10-14 10:33:46.61957+00
330	3	167	supervisor	19	draft	5			\N	\N	\N	2026-10-14 10:33:46.626054+00	2026-10-14 10:33:46.626054+00
331	3	168	supervisor	19	draft	4.67			\N	\N	\N	2026-10-14 10:33:46.633862+00	2026-10-14 10:33:46.633862+00
332	3	169	supervisor	19	draft	1.78			\N	\N	\N	2026-10-14 10:33:46.638758+00	2026-10-14 10:33:46.638758+00
333	3	170	supervisor	19	draft	4.11			\N	\N	\N	2026-10-14 10:33:46.643667+00	2026-10-14 10:33:46.643667+00
334	3	171	supervisor	19	draft	3.44			\N	\N	\N	2026-10-14 10:33:46.650292+00	2026-10-14 10:33:46.650292+00
335	3	172	supervisor	19	draft	2.11			\N	\N	\N	2026-10-14 10:33:46.658164+00	2026-10-14 10:33:46.658164+00
336	3	173	supervisor	19	draft	4.22			\N	\N	\N	2026-10-14 10:33:46.66689+00	2026-10-14 10:33:46.66689+00
337	3	174	supervisor	19	draft	3.44			\N	\N	\N	2026-10-14 10:33:46.672474+00	2026-10-14 10:33:46.672474+00
338	3	175	supervisor	19	draft	2.22			\N	\N	\N	2026-10-14 10:33:46.677643+00	2026-10-14 10:33:46.677643+00
339	3	176	supervisor	19	draft	0			\N	\N	\N	2026-10-14 10:33:46.682137+00	2026-10-14 10:33:46.682137+00
340	3	177	supervisor	19	draft	3			\N	\N	\N	2026-10-14 10:33:46.687252+00	2026-10-14 10:33:46.687252+00
341	3	178	supervisor	19	draft	5			\N	\N	\N	2026-10-14 10:33:46.694003+00	2026-10-14 10:33:46.694003+00
342	3	179	supervisor	19	draft	2.67			\N	\N	\N	2026-10-14 10:33:46.699648+00	2026-10-14 10:33:46.699648+00
343	3	180	supervisor	19	draft	4.56			\N	\N	\N	2026-10-14 10:33:46.704532+00	2026-10-14 10:33:46.704532+00
344	3	181	supervisor	19	draft	2.11			\N	\N	\N	2026-10-14 10:33:46.709387+00	2026-10-14 10:33:46.709387+00
345	3	182	supervisor	19	draft	3.44			\N	\N	\N	2026-10-14 10:33:46.714349+00	2026-10-14 10:33:46.714349+00
346	3	183	supervisor	19	draft	1.89			\N	\N	\N	2026-10-14 10:33:46.719042+00	2026-10-14 10:33:46.719042+00
347	3	184	supervisor	19	draft	4.67			\N	\N	\N	2026-10-14 10:33:46.724149+00	2026-10-14 10:33:46.724149+00
348	3	185	supervisor	19	draft	4.44			\N	\N	\N	2026-10-14 10:33:46.728981+00	2026-10-14 10:33:46.728981+00
349	3	186	supervisor	19	draft	4.22			\N	\N	\N	2026-10-14 10:33:46.736428+00	2026-10-14 10:33:46.736428+00
350	3	187	supervisor	20	draft	4.56			\N	\N	\N	2026-10-14 10:33:46.741523+00	2026-10-14 10:33:46.741523+00
351	3	188	supervisor	20	draft	4.78			\N	\N	\N	2026-10-14 10:33:46.746534+00	2026-10-14 10:33:46.746534+00
352	3	189	supervisor	20	draft	4.78			\N	\N	\N	2026-10-14 10:33:46.751722+00	2026-10-14 10:33:46.751722+00
353	3	190	supervisor	20	draft	5			\N	\N	\N	2026-10-14 10:33:46.759488+00	2026-10-14 10:33:46.759488+00
354	3	191	supervisor	20	draft	4			\N	\N	\N	2026-10-14 10:33:46.768791+00	2026-10-14 10:33:46.768791+00
355	3	192	supervisor	20	draft	4.78			\N	\N	\N	2026-10-14 10:33:46.77384+00	2026-10-14 10:33:46.77384+00
356	3	193	supervisor	20	draft	4.22			\N	\N	\N	2026-10-14 10:33:46.778813+00	2026-10-14 10:33:46.778813+00
357	3	194	supervisor	20	draft	4.67			\N	\N	\N	2026-10-14 10:33:46.783753+00	2026-10-14 10:33:46.783753+00
358	3	195	supervisor	20	draft	4.67			\N	\N	\N	2026-10-14 10:33:46.788501+00	2026-10-14 10:33:46.788501+00
359	3	196	supervisor	20	draft	3.44			\N	\N	\N	2026-10-14 10:33:46.793511+00	2026-10-14 10:33:46.793511+00
360	3	197	supervisor	20	draft	5			\N	\N	\N	2026-10-14 10:33:46.798388+00	2026-10-14 10:33:46.798388+00
361	3	198	supervisor	20	draft	1			\N	\N	\N	2026-10-14 10:33:46.803232+00	2026-10-14 10:33:46.803232+00
362	3	199	supervisor	20	draft	4			\N	\N	\N	2026-10-14 10:33:46.80789+00	2026-10-14 10:33:46.80789+00
363	3	200	supervisor	20	draft	2.89			\N	\N	\N	2026-10-14 10:33:46.812468+00	2026-10-14 10:33:46.812468+00
364	3	201	supervisor	20	draft	0			\N	\N	\N	2026-10-14 10:33:46.816976+00	2026-10-14 10:33:46.816976+00
365	3	202	supervisor	20	draft	2.11			\N	\N	\N	2026-10-14 10:33:46.821633+00	2026-10-14 10:33:46.821633+00
366	3	203	supervisor	20	draft	2.44			\N	\N	\N	2026-10-14 10:33:46.826329+00	2026-10-14 10:33:46.826329+00
367	3	204	supervisor	20	draft	4.78			\N	\N	\N	2026-10-14 10:33:46.83118+00	2026-10-14 10:33:46.83118+00
368	3	205	supervisor	20	draft	4			\N	\N	\N	2026-10-14 10:33:46.83671+00	2026-10-14 10:33:46.83671+00
369	3	206	supervisor	20	draft	1.67			\N	\N	\N	2026-10-14 10:33:46.841431+00	2026-10-14 10:33:46.841431+00
314	3	151	supervisor	18	approved	4.76			1	2026-10-14 10:40:08.540383+00	2026-10-14 15:50:08.306015+00	2026-10-14 10:33:46.462458+00	2026-10-14 15:50:08.306279+00
3	3	27	supervisor	12	approved	2.92			1	2026-10-14 09:55:54.179777+00	2026-10-14 15:50:08.313969+00	2026-10-14 09:47:35.741065+00	2026-10-14 15:50:08.314205+00
11	3	30	supervisor	12	rejected	5			\N	\N	\N	2026-10-14 10:04:09.847249+00	2026-10-14 16:01:38.236069+00
370	3	12	self	12	submitted	5			\N	2026-10-14 17:46:33.677243+00	\N	2026-10-14 17:46:33.567924+00	2026-10-14 17:46:33.67747+00
\.


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.levels (id, name, sort_order) FROM stdin;
1	junior	1
2	senior	2
3	lead	3
4	manager	4
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.positions (id, name) FROM stdin;
1	Engineering Manager
2	HR Manager
3	Marketing Manager
4	QA Engineer
5	Marketing Executive
6	Software Engineer
7	Graphic Designer
8	ผู้อำนวยการ
9	Content Marketer
10	นักบัญชีอาวุโส
\.


--
-- Data for Name: promotion_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_requests (id, evaluation_id, cycle_id, employee_id, from_position, to_position, from_level, to_level, status, note, decision_note, created_by, decided_by, decided_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: salary_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.salary_records (id, employee_id, amount, effective_date, created_by, created_at) FROM stdin;
1	6	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
2	7	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
3	8	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
4	9	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
5	10	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
6	11	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
7	27	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
8	28	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
9	29	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
10	30	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
11	31	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
12	32	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
13	33	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
14	34	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
15	35	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
16	36	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
17	37	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
18	38	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
19	39	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
20	40	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
21	41	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
22	42	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
23	43	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
24	44	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
25	45	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
26	46	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
27	47	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
28	48	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
29	49	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
30	50	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
31	51	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
32	52	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
33	53	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
34	54	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
35	55	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
36	56	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
37	57	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
38	58	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
39	59	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
40	60	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
41	61	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
42	62	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
43	63	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
44	64	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
45	65	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
46	66	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
47	67	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
48	68	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
49	69	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
50	70	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
51	71	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
52	72	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
53	73	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
54	74	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
55	75	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
56	76	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
57	77	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
58	78	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
59	79	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
60	80	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
61	81	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
62	82	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
63	83	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
64	84	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
65	85	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
66	86	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
67	87	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
68	88	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
69	89	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
70	90	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
71	91	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
72	92	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
73	93	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
74	94	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
75	95	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
76	96	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
77	97	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
78	98	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
79	99	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
80	100	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
81	101	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
82	102	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
83	103	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
84	104	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
85	105	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
86	106	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
87	107	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
88	108	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
89	109	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
90	110	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
91	111	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
92	112	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
93	113	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
94	114	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
95	115	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
96	116	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
97	117	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
98	118	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
99	119	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
100	120	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
101	121	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
102	122	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
103	123	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
104	124	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
105	125	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
106	126	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
107	127	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
108	128	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
109	129	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
110	130	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
111	131	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
112	132	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
113	133	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
114	134	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
115	135	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
116	136	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
117	137	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
118	138	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
119	139	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
120	140	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
121	141	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
122	142	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
123	143	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
124	144	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
125	145	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
126	146	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
127	147	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
128	148	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
129	149	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
130	150	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
131	151	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
132	152	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
133	153	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
134	154	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
135	155	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
136	156	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
137	157	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
138	158	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
139	159	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
140	160	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
141	161	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
142	162	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
143	163	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
144	164	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
145	165	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
146	166	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
147	167	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
148	168	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
149	169	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
150	170	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
151	171	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
152	172	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
153	173	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
154	174	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
155	175	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
156	176	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
157	177	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
158	178	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
159	179	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
160	180	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
161	181	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
162	182	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
163	183	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
164	184	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
165	185	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
166	186	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
167	187	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
168	188	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
169	189	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
170	190	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
171	191	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
172	192	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
173	193	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
174	194	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
175	195	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
176	196	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
177	197	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
178	198	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
179	199	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
180	200	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
181	201	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
182	202	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
183	203	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
184	204	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
185	205	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
186	206	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
187	207	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
188	208	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
189	209	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
190	210	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
191	211	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
192	212	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
193	213	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
194	214	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
195	215	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
196	216	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
197	217	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
198	218	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
199	219	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
200	220	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
201	221	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
202	222	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
203	223	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
204	224	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
205	225	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
206	226	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
207	227	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
208	228	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
209	229	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
210	230	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
211	231	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
212	232	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
213	233	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
214	234	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
215	235	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
216	236	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
217	237	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
218	238	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
219	239	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
220	240	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
221	241	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
222	242	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
223	243	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
224	244	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
225	245	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
226	246	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
227	247	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
228	248	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
229	249	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
230	250	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
231	251	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
232	252	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
233	253	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
234	254	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
235	255	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
236	256	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
237	257	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
238	258	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
239	259	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
240	260	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
241	261	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
242	262	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
243	263	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
244	264	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
245	265	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
246	266	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
247	267	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
248	268	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
249	269	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
250	270	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
251	271	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
252	272	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
253	273	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
254	274	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
255	275	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
256	276	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
257	277	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
258	278	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
259	279	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
260	280	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
261	281	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
262	282	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
263	283	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
264	284	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
265	285	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
266	286	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
267	287	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
268	288	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
269	289	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
270	290	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
271	291	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
272	292	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
273	293	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
274	294	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
275	295	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
276	296	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
277	297	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
278	298	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
279	299	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
280	300	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
281	301	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
282	302	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
283	303	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
284	304	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
285	305	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
286	306	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
287	307	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
288	308	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
289	309	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
290	310	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
291	311	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
292	312	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
293	313	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
294	314	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
295	315	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
296	316	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
297	317	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
298	318	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
299	319	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
300	320	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
301	321	25000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
302	322	28000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
303	323	31000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
304	324	34000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
305	325	37000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
306	326	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:22:51.62291+00
307	4	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
308	5	44000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
309	12	48000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
310	13	52000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
311	14	56000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
312	15	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
313	16	44000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
314	17	48000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
315	18	52000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
316	19	56000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
317	20	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
318	21	44000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
319	22	48000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
320	23	52000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
321	24	56000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
322	25	40000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
323	26	44000	2026-01-01 00:00:00+00	3	2026-10-15 03:31:27.362456+00
324	2	80000	2026-01-01 00:00:00+00	3	2026-10-15 03:32:49.871127+00
325	1	45000	2026-01-01 00:00:00+00	3	2026-10-15 03:32:49.871127+00
326	3	42000	2026-01-01 00:00:00+00	3	2026-10-15 03:32:49.871127+00
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, employee_id, title, due_date, completed_at, status, reviewed, revisions, created_at) FROM stdin;
1	6	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
2	6	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
3	6	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
4	6	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
5	6	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 02:33:34.207804+00
6	6	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
7	6	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
8	6	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
9	6	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
10	6	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
11	6	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
12	6	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
13	6	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
14	6	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
15	6	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 02:33:34.207804+00
16	6	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
17	6	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
18	6	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
19	6	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
20	6	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 02:33:34.207804+00
21	7	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
22	7	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 02:33:34.21172+00
23	7	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
24	7	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
25	7	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.21172+00
26	7	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 02:33:34.21172+00
27	7	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
28	7	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
29	7	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
30	7	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.21172+00
31	7	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
32	7	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
33	7	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
34	7	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 02:33:34.21172+00
35	7	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.21172+00
36	7	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
37	7	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
38	7	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 02:33:34.21172+00
39	7	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 02:33:34.21172+00
40	7	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.21172+00
41	8	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 02:33:34.214829+00
42	8	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 02:33:34.214829+00
43	8	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.214829+00
44	8	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 02:33:34.214829+00
45	8	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 02:33:34.214829+00
46	8	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.214829+00
47	8	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 02:33:34.214829+00
48	8	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 02:33:34.214829+00
49	8	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.214829+00
50	8	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 02:33:34.214829+00
51	8	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 02:33:34.214829+00
52	8	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.214829+00
53	8	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 02:33:34.214829+00
54	8	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 02:33:34.214829+00
55	8	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.214829+00
56	8	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 02:33:34.214829+00
57	8	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 02:33:34.214829+00
58	8	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 02:33:34.214829+00
59	27	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
60	27	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:10.870402+00
61	27	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:10.870402+00
62	27	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.870402+00
63	27	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:10.870402+00
64	27	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
65	27	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.870402+00
66	27	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
67	27	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
68	27	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.870402+00
69	27	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:10.870402+00
70	27	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
71	27	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
72	27	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
73	27	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.870402+00
74	27	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:10.870402+00
75	28	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.941515+00
76	28	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:10.941515+00
77	28	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:10.941515+00
78	28	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:10.941515+00
79	28	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:10.941515+00
80	28	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:10.941515+00
81	28	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.941515+00
82	28	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.941515+00
83	28	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:10.941515+00
84	28	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:10.941515+00
85	28	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:10.941515+00
86	28	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.941515+00
87	28	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:10.941515+00
88	28	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:10.941515+00
89	28	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	1	2026-10-14 09:11:10.941515+00
90	28	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:10.941515+00
91	29	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
92	29	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
93	29	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
94	29	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
95	29	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
96	29	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
97	29	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:11.01142+00
98	29	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
99	29	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
100	29	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
101	29	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
102	29	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
103	29	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
104	29	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
105	29	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
106	29	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:11.01142+00
107	29	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
108	29	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
109	29	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.01142+00
110	29	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
111	29	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:11.01142+00
112	30	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
113	30	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
114	30	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
115	30	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
116	30	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
117	30	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
118	30	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
119	30	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
120	30	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
121	30	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
122	30	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
123	30	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
124	30	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
125	30	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
126	30	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
127	30	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
128	30	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
129	30	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
130	30	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:11.083136+00
131	31	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
132	31	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
133	31	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
134	31	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:11.154219+00
135	31	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
136	31	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
137	31	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
138	31	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
139	31	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
140	31	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
141	31	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
142	31	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
143	31	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
144	31	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
145	31	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:11.154219+00
146	32	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
147	32	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:11.226464+00
148	32	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
149	32	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.226464+00
150	32	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:11.226464+00
151	32	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
152	32	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.226464+00
153	32	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:11.226464+00
154	32	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.226464+00
155	32	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:11.226464+00
156	32	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:11.226464+00
157	32	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:11.226464+00
158	32	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.226464+00
159	32	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
160	32	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
161	32	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.226464+00
162	32	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:11.226464+00
163	32	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.226464+00
164	32	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
165	32	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:11.226464+00
166	32	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
167	32	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.226464+00
168	33	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:11.296824+00
169	33	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.296824+00
170	33	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.296824+00
171	33	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.296824+00
172	33	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.296824+00
173	33	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.296824+00
174	33	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:11.296824+00
175	33	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:11.296824+00
176	33	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:11.296824+00
177	33	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	2	2026-10-14 09:11:11.296824+00
178	33	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.296824+00
179	33	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.296824+00
180	33	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.296824+00
181	33	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:11.296824+00
182	33	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.296824+00
183	34	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
184	34	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
185	34	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
186	34	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:11.369313+00
187	34	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:11.369313+00
188	34	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
189	34	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:11.369313+00
190	34	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
191	34	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
192	34	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
193	34	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:11.369313+00
194	34	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:11.369313+00
195	34	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:11.369313+00
196	34	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
197	34	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	1	2026-10-14 09:11:11.369313+00
198	34	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:11.369313+00
199	34	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.369313+00
200	34	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
201	34	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:11.369313+00
202	34	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:11.369313+00
203	34	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.369313+00
204	35	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
205	35	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
206	35	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
207	35	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:11.441065+00
208	35	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:11.441065+00
209	35	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
210	35	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
211	35	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
212	35	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
213	35	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:11.441065+00
214	35	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
215	35	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
216	35	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
217	35	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
218	35	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
219	35	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
220	35	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
221	35	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:11.441065+00
222	36	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
223	36	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
224	36	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	2	2026-10-14 09:11:11.512068+00
225	36	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
226	36	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.512068+00
227	36	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
228	36	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
229	36	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
230	36	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
231	36	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
232	36	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.512068+00
233	36	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:11.512068+00
234	36	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
235	36	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
236	36	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	2	2026-10-14 09:11:11.512068+00
237	36	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
238	36	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.512068+00
239	36	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:11.512068+00
240	36	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
241	36	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.512068+00
242	36	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
243	36	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	1	2026-10-14 09:11:11.512068+00
244	36	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:11.512068+00
245	37	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
246	37	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
247	37	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
248	37	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
249	37	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:11.58285+00
250	37	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
251	37	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
252	37	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
253	37	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
254	37	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
255	37	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
256	37	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
257	37	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
258	37	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	2	2026-10-14 09:11:11.58285+00
259	37	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
260	37	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:11.58285+00
261	37	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
262	37	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
263	37	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
264	37	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
265	37	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:11.58285+00
266	38	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
267	38	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
268	38	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
269	38	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
270	38	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
271	38	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
272	38	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
273	38	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
274	38	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
275	38	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
276	38	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
277	38	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
278	38	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
279	38	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
280	38	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
281	38	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
282	38	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:11.653909+00
283	39	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
284	39	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
285	39	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
286	39	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.731365+00
287	39	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.731365+00
288	39	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.731365+00
289	39	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
290	39	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
291	39	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
292	39	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
293	39	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
294	39	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
295	39	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.731365+00
296	39	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
297	39	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
298	39	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:11.731365+00
299	39	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.731365+00
300	39	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
301	39	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:11.731365+00
302	40	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
303	40	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.802453+00
304	40	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
305	40	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
306	40	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.802453+00
307	40	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:11.802453+00
308	40	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
309	40	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	2	2026-10-14 09:11:11.802453+00
310	40	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
311	40	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.802453+00
312	40	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
313	40	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.802453+00
314	40	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:11.802453+00
315	40	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
316	40	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:11.802453+00
317	40	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.802453+00
318	40	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:11.802453+00
319	40	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	2	2026-10-14 09:11:11.802453+00
320	40	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.802453+00
321	40	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.802453+00
322	41	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
323	41	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
324	41	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
325	41	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:11.902215+00
326	41	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
327	41	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
328	41	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
329	41	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
330	41	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
331	41	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
332	41	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
333	41	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
334	41	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
335	41	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
336	41	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:11.902215+00
337	41	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
338	41	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:11.902215+00
339	42	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.001226+00
340	42	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
341	42	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
342	42	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
343	42	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
344	42	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
345	42	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
346	42	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:12.001226+00
347	42	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
348	42	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
349	42	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
350	42	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.001226+00
351	42	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:12.001226+00
352	42	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
353	42	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
354	42	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:12.001226+00
355	42	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
356	42	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:12.001226+00
357	42	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
358	42	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
359	42	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:12.001226+00
360	42	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	2	2026-10-14 09:11:12.001226+00
361	42	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
362	42	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
363	42	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-12 03:00:00+00	done	t	0	2026-10-14 09:11:12.001226+00
364	43	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.074066+00
365	43	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:12.074066+00
366	43	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
367	43	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.074066+00
368	43	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:12.074066+00
369	43	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
370	43	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.074066+00
371	43	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
372	43	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:12.074066+00
373	43	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
374	43	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:12.074066+00
375	43	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.074066+00
376	43	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:12.074066+00
377	43	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
378	43	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
379	43	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
380	43	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	1	2026-10-14 09:11:12.074066+00
381	43	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
382	43	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:12.074066+00
383	43	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.074066+00
384	43	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:12.074066+00
385	44	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.144887+00
386	44	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:12.144887+00
387	44	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
388	44	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
389	44	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
390	44	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
391	44	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
392	44	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
393	44	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
394	44	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
395	44	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
396	44	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
397	44	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
398	44	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
399	44	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
400	44	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
401	44	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
402	44	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:12.144887+00
403	44	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:12.144887+00
404	44	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
405	44	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.144887+00
406	44	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
407	44	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
408	44	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.144887+00
409	45	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.227915+00
410	45	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
411	45	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
412	45	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
413	45	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
414	45	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:12.227915+00
415	45	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
416	45	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	1	2026-10-14 09:11:12.227915+00
417	45	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:12.227915+00
418	45	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
419	45	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
420	45	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
421	45	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
422	45	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.227915+00
423	45	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
424	45	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
425	45	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
426	45	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.227915+00
427	45	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:12.227915+00
428	46	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
429	46	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
430	46	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
431	46	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:12.298919+00
432	46	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
433	46	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
434	46	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
435	46	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
436	46	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
437	46	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.298919+00
438	46	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:12.298919+00
439	46	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
440	46	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
441	46	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
442	46	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
443	46	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
444	46	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.298919+00
445	46	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:12.298919+00
446	47	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
447	47	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
448	47	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
449	47	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
450	47	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
451	47	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
452	47	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
453	47	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
454	47	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
455	47	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
456	47	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
457	47	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
458	47	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
459	47	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
460	47	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
461	47	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
462	47	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
463	47	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:12.393474+00
464	48	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.486207+00
465	48	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.486207+00
466	48	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
467	48	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
468	48	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
469	48	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
470	48	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
471	48	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.486207+00
472	48	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
473	48	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:12.486207+00
474	48	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
475	48	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
476	48	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
477	48	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
478	48	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:12.486207+00
479	48	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
480	48	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
481	48	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
482	48	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
483	48	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
484	48	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:12.486207+00
485	49	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:12.58943+00
486	49	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
487	49	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
488	49	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
489	49	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
490	49	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
491	49	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
492	49	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
493	49	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
494	49	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
495	49	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
496	49	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
497	49	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
498	49	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
499	49	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
500	49	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
501	49	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
502	49	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
503	49	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
504	49	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.58943+00
505	50	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
506	50	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
507	50	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
508	50	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:12.667333+00
509	50	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
510	50	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
511	50	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
512	50	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
513	50	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
514	50	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
515	50	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
516	50	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
517	50	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
518	50	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
519	50	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
520	50	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
521	50	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
522	50	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
523	50	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
524	50	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
525	50	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:12.667333+00
526	50	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	1	2026-10-14 09:11:12.667333+00
527	51	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.739716+00
528	51	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:12.739716+00
529	52	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	2	2026-10-14 09:11:12.809911+00
530	52	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
531	52	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
532	52	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.809911+00
533	52	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:12.809911+00
534	52	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.809911+00
535	52	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:12.809911+00
536	52	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
537	52	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:12.809911+00
538	52	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:12.809911+00
539	52	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:12.809911+00
540	52	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
541	52	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
542	52	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:12.809911+00
543	52	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
544	52	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.809911+00
545	52	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.809911+00
546	52	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
547	52	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
548	52	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
549	52	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:12.809911+00
550	52	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.809911+00
551	52	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:12.809911+00
552	52	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.809911+00
553	52	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	1	2026-10-14 09:11:12.809911+00
554	53	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
555	53	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
556	53	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
557	53	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
558	53	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
559	53	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
560	53	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
561	53	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
562	53	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
563	53	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
564	53	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
565	53	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:12.880216+00
566	53	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
567	53	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:12.880216+00
568	53	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
569	53	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
570	53	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
571	53	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
572	53	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.880216+00
573	53	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
574	53	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
575	53	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.880216+00
576	53	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
577	53	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
578	53	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:12.880216+00
579	54	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
580	54	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	2	2026-10-14 09:11:12.951071+00
581	54	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:12.951071+00
582	54	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:12.951071+00
583	54	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:12.951071+00
584	54	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:12.951071+00
585	54	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
586	54	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
587	54	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:12.951071+00
588	54	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
589	54	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:12.951071+00
590	54	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:12.951071+00
591	54	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
592	54	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
593	54	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
594	54	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
595	54	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:12.951071+00
596	54	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	1	2026-10-14 09:11:12.951071+00
597	54	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
598	54	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:12.951071+00
599	55	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.021301+00
600	55	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:13.021301+00
601	55	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:13.021301+00
602	55	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.021301+00
603	55	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:13.021301+00
604	55	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:13.021301+00
605	55	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.021301+00
606	55	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.021301+00
607	55	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:13.021301+00
608	55	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.021301+00
609	55	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.021301+00
610	55	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:13.021301+00
611	55	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:13.021301+00
612	55	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:13.021301+00
613	55	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.021301+00
614	55	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:13.021301+00
615	55	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:13.021301+00
616	55	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:13.021301+00
617	55	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	2	2026-10-14 09:11:13.021301+00
618	56	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.1041+00
619	56	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
620	56	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.1041+00
621	56	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
622	56	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
623	56	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	2	2026-10-14 09:11:13.1041+00
624	56	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.1041+00
625	56	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
626	56	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
627	56	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
628	56	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
629	56	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
630	56	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:13.1041+00
631	56	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:13.1041+00
632	56	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.1041+00
633	56	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:13.1041+00
634	57	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
635	57	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:13.175218+00
636	57	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.175218+00
637	57	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
638	57	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
639	57	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
640	57	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
641	57	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.175218+00
642	57	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.175218+00
643	57	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
644	57	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:13.175218+00
645	57	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:13.175218+00
646	57	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:13.175218+00
647	57	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
648	57	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
649	57	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
650	57	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
651	57	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.175218+00
652	57	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
653	57	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.175218+00
654	57	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
655	57	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.175218+00
656	57	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:13.175218+00
657	57	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.175218+00
658	57	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	1	2026-10-14 09:11:13.175218+00
659	58	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.247736+00
660	58	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:13.247736+00
661	58	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.247736+00
662	58	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	2	2026-10-14 09:11:13.247736+00
663	58	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.247736+00
664	58	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	2	2026-10-14 09:11:13.247736+00
665	58	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:13.247736+00
666	58	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:13.247736+00
667	58	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:13.247736+00
668	58	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:13.247736+00
669	58	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:13.247736+00
670	58	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:13.247736+00
671	58	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:13.247736+00
672	58	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:13.247736+00
673	58	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:13.247736+00
674	59	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
675	59	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
676	59	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
677	59	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
678	59	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
679	59	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
680	59	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:13.318444+00
681	59	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
682	59	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
683	59	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
684	59	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
685	59	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
686	59	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
687	59	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
688	59	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
689	59	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.318444+00
690	59	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
691	59	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
692	59	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:13.318444+00
693	59	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:13.318444+00
694	60	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
695	60	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
696	60	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
697	60	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:13.388111+00
698	60	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
699	60	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
700	60	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
701	60	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
702	60	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
703	60	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
704	60	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
705	60	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
706	60	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
707	60	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
708	60	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
709	60	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
710	60	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.388111+00
711	61	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
712	61	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
713	61	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
714	61	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:13.460366+00
715	61	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
716	61	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.460366+00
717	61	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
718	61	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
719	61	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:13.460366+00
720	61	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
721	61	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
722	61	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:13.460366+00
723	61	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:13.460366+00
724	61	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
725	61	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
726	61	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
727	61	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:13.460366+00
728	61	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
729	61	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
730	61	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:13.460366+00
731	61	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:13.460366+00
732	61	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.460366+00
733	61	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:13.460366+00
734	61	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	2	2026-10-14 09:11:13.460366+00
735	61	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	2	2026-10-14 09:11:13.460366+00
736	62	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
737	62	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
738	62	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
739	62	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
740	62	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
741	62	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
742	62	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
743	62	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
744	62	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
745	62	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
746	62	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
747	62	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
748	62	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.5317+00
749	62	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:13.5317+00
750	62	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:13.5317+00
751	62	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.5317+00
752	62	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.5317+00
753	63	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
754	63	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
755	63	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.604913+00
756	63	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
757	63	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:13.604913+00
758	63	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
759	63	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	1	2026-10-14 09:11:13.604913+00
760	63	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
761	63	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
762	63	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
763	63	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
764	63	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.604913+00
765	63	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
766	63	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:13.604913+00
767	63	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:13.604913+00
768	64	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
769	64	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
770	64	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
771	64	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
772	64	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
773	64	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
774	64	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
775	64	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:13.677385+00
776	64	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
777	64	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
778	64	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
779	64	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
780	64	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
781	64	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
782	64	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:13.677385+00
783	65	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
784	65	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:13.751075+00
785	65	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
786	65	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
787	65	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.751075+00
788	65	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
789	65	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:13.751075+00
790	65	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
791	65	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
792	65	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
793	65	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:13.751075+00
794	65	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:13.751075+00
795	65	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
796	65	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	2	2026-10-14 09:11:13.751075+00
797	65	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:13.751075+00
798	65	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:13.751075+00
799	65	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.751075+00
800	65	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
801	65	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
802	65	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:13.751075+00
803	65	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
804	65	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.751075+00
805	65	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:13.751075+00
806	66	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.822237+00
807	66	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
808	66	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:13.822237+00
809	66	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
810	66	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.822237+00
811	66	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
812	66	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:13.822237+00
813	66	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
814	66	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
815	66	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	2	2026-10-14 09:11:13.822237+00
816	66	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:13.822237+00
817	66	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:13.822237+00
818	66	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:13.822237+00
819	66	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
820	66	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	2	2026-10-14 09:11:13.822237+00
821	66	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:13.822237+00
822	66	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.822237+00
823	66	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
824	66	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.822237+00
825	67	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
826	67	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
827	67	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
828	67	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
829	67	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
830	67	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
831	67	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
832	67	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
833	67	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
834	67	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
835	67	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
836	67	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.89396+00
837	67	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
838	67	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
839	67	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
840	67	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:13.89396+00
841	67	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.89396+00
842	68	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
843	68	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
844	68	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
845	68	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
846	68	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
847	68	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:13.967763+00
848	68	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
849	68	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:13.967763+00
850	68	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
851	68	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
852	68	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
853	68	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:13.967763+00
854	68	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
855	68	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
856	68	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
857	68	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:13.967763+00
858	68	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
859	68	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
860	68	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
861	68	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
862	68	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
863	68	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
864	68	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
865	68	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-08 03:00:00+00	done	t	0	2026-10-14 09:11:13.967763+00
866	69	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
867	69	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
868	69	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
869	69	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
870	69	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:14.058084+00
871	69	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.058084+00
872	69	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
873	69	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
874	69	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
875	69	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
876	69	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:14.058084+00
877	69	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
878	69	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
879	69	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
880	69	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
881	69	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
882	69	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
883	69	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
884	69	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:14.058084+00
885	69	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:14.058084+00
886	69	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
887	69	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:14.058084+00
888	70	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
889	70	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
890	70	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
891	70	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
892	70	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.128822+00
893	70	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
894	70	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
895	70	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
896	70	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
897	70	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
898	70	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
899	70	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
900	70	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.128822+00
901	70	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
902	70	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.128822+00
903	70	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
904	70	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	2	2026-10-14 09:11:14.128822+00
905	70	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
906	70	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
907	70	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.128822+00
908	70	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.128822+00
909	70	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:14.128822+00
910	71	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
911	71	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
912	71	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
913	71	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
914	71	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
915	71	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
916	71	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:14.199434+00
917	71	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.199434+00
918	71	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
919	71	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:14.199434+00
920	71	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
921	71	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:14.199434+00
922	71	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.199434+00
923	71	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:14.199434+00
924	71	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:14.199434+00
925	71	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.199434+00
926	71	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:14.199434+00
927	72	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:14.271119+00
928	72	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
929	72	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:14.271119+00
930	72	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
931	72	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
932	72	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:14.271119+00
933	72	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
934	72	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.271119+00
935	72	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.271119+00
936	72	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
937	72	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
938	72	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
939	72	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
940	72	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
941	72	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
942	72	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
943	72	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
944	72	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.271119+00
945	72	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
946	72	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
947	72	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	2	2026-10-14 09:11:14.271119+00
948	72	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:14.271119+00
949	72	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.271119+00
950	72	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	2	2026-10-14 09:11:14.271119+00
951	73	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:14.34187+00
952	73	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
953	73	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
954	73	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
955	73	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
956	73	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
957	73	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
958	73	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
959	73	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
960	73	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.34187+00
961	73	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
962	73	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
963	73	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
964	73	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
965	73	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
966	73	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
967	73	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
968	73	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
969	73	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
970	73	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
971	73	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
972	73	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	1	2026-10-14 09:11:14.34187+00
973	73	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
974	73	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
975	73	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.34187+00
976	74	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.412722+00
977	74	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
978	74	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
979	74	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
980	74	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
981	74	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.412722+00
982	74	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.412722+00
983	74	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
984	74	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
985	74	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
986	74	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.412722+00
987	74	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
988	74	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
989	74	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
990	74	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
991	74	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:14.412722+00
992	74	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
993	74	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:14.412722+00
994	74	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
995	74	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:14.412722+00
996	75	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
997	75	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
998	75	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
999	75	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1000	75	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1001	75	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1002	75	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:14.484918+00
1003	75	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1004	75	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1005	75	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1006	75	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1007	75	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1008	75	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1009	75	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1010	75	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1011	75	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1012	75	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1013	75	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1014	75	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1015	75	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1016	75	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1017	75	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1018	75	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1019	75	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1020	75	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.484918+00
1021	76	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.557499+00
1022	76	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.557499+00
1023	77	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1024	77	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1025	77	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1026	77	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1027	77	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1028	77	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1029	77	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1030	77	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1031	77	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:14.628254+00
1032	77	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.628254+00
1033	77	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:14.628254+00
1034	77	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1035	77	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:14.628254+00
1036	77	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1037	77	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1038	77	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1039	77	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1040	77	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:14.628254+00
1041	77	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1042	77	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:14.628254+00
1043	77	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.628254+00
1044	78	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:14.710148+00
1045	78	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:14.710148+00
1046	78	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:14.710148+00
1047	78	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:14.710148+00
1048	78	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.710148+00
1049	78	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:14.710148+00
1050	78	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.710148+00
1051	78	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.710148+00
1052	78	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:14.710148+00
1053	78	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.710148+00
1054	78	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:14.710148+00
1055	78	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:14.710148+00
1056	78	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:14.710148+00
1057	78	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.710148+00
1058	78	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:14.710148+00
1059	78	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.710148+00
1060	79	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:14.782126+00
1061	79	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1062	79	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1063	79	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.782126+00
1064	79	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.782126+00
1065	79	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1066	79	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1067	79	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.782126+00
1068	79	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1069	79	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.782126+00
1070	79	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.782126+00
1071	79	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	1	2026-10-14 09:11:14.782126+00
1072	79	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:14.782126+00
1073	79	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:14.782126+00
1074	79	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:14.782126+00
1075	79	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1076	79	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:14.782126+00
1077	79	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1078	79	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1079	79	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1080	79	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1081	79	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:14.782126+00
1082	80	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1083	80	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1084	80	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1085	80	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1086	80	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:14.852529+00
1087	80	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.852529+00
1088	80	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:14.852529+00
1089	80	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1090	80	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1091	80	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1092	80	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.852529+00
1093	80	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1094	80	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1095	80	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.852529+00
1096	80	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:14.852529+00
1097	81	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:14.92222+00
1098	81	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1099	81	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1100	81	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1101	81	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1102	81	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	1	2026-10-14 09:11:14.92222+00
1103	81	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1104	81	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1105	81	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1106	81	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1107	81	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1108	81	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:14.92222+00
1109	81	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1110	81	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1111	81	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1112	81	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1113	81	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1114	81	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1115	81	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1116	81	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1117	81	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:14.92222+00
1118	82	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:14.99388+00
1119	82	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.99388+00
1120	82	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:14.99388+00
1121	82	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:14.99388+00
1122	82	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:14.99388+00
1123	82	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:14.99388+00
1124	82	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:14.99388+00
1125	82	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:14.99388+00
1126	82	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:14.99388+00
1127	82	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:14.99388+00
1128	82	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:14.99388+00
1129	82	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:14.99388+00
1130	82	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.99388+00
1131	82	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:14.99388+00
1132	82	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:14.99388+00
1133	83	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.064638+00
1134	83	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.064638+00
1135	83	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:15.064638+00
1136	83	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:15.064638+00
1137	83	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:15.064638+00
1138	83	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.064638+00
1139	83	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:15.064638+00
1140	83	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.064638+00
1141	83	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	2	2026-10-14 09:11:15.064638+00
1142	83	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.064638+00
1143	83	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.064638+00
1144	83	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:15.064638+00
1145	83	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:15.064638+00
1146	83	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:15.064638+00
1147	83	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.064638+00
1148	83	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:15.064638+00
1149	84	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1150	84	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.144841+00
1151	84	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.144841+00
1152	84	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1153	84	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.144841+00
1154	84	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1155	84	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.144841+00
1156	84	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:15.144841+00
1157	84	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:15.144841+00
1158	84	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1159	84	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1160	84	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1161	84	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1162	84	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.144841+00
1163	84	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1164	84	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	1	2026-10-14 09:11:15.144841+00
1165	84	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1166	84	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1167	84	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.144841+00
1168	84	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:15.144841+00
1169	84	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.144841+00
1170	84	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1171	84	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:15.144841+00
1172	84	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	2	2026-10-14 09:11:15.144841+00
1173	85	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1174	85	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:15.223859+00
1175	85	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1176	85	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1177	85	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:15.223859+00
1178	85	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:15.223859+00
1179	85	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1180	85	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1181	85	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1182	85	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1183	85	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1184	85	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1185	85	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1186	85	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1187	85	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1188	85	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1189	85	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1190	85	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1191	85	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.223859+00
1192	85	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1193	85	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:15.223859+00
1194	85	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:15.223859+00
1195	86	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1196	86	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1197	86	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1198	86	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1199	86	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1200	86	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1201	86	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:15.295464+00
1202	86	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1203	86	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1204	86	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1205	86	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1206	86	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1207	86	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1208	86	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1209	86	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1210	86	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1211	86	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1212	86	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1213	86	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1214	86	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:15.295464+00
1215	86	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:15.295464+00
1216	87	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1217	87	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1218	87	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1219	87	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1220	87	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1221	87	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1222	87	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1223	87	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1224	87	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.366084+00
1225	87	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:15.366084+00
1226	87	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1227	87	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1228	87	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1229	87	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1230	87	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1231	87	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1232	87	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1233	87	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:15.366084+00
1234	87	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.366084+00
1235	87	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1236	87	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	1	2026-10-14 09:11:15.366084+00
1237	87	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1238	87	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:15.366084+00
1239	88	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	1	2026-10-14 09:11:15.439345+00
1240	88	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:15.439345+00
1241	88	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:15.439345+00
1242	88	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:15.439345+00
1243	88	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.439345+00
1244	88	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:15.439345+00
1245	88	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:15.439345+00
1246	88	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.439345+00
1247	88	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:15.439345+00
1248	88	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.439345+00
1249	88	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:15.439345+00
1250	88	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:15.439345+00
1251	88	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:15.439345+00
1252	88	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.439345+00
1253	88	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:15.439345+00
1254	88	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:15.439345+00
1255	88	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.439345+00
1256	88	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	2	2026-10-14 09:11:15.439345+00
1257	88	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.439345+00
1258	88	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:15.439345+00
1259	89	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1260	89	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1261	89	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:15.512582+00
1262	89	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1263	89	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1264	89	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1265	89	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1266	89	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1267	89	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1268	89	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1269	89	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1270	89	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1271	89	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1272	89	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1273	89	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:15.512582+00
1274	89	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1275	89	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1276	89	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1277	89	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:15.512582+00
1278	90	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1279	90	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.827504+00
1280	90	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1281	90	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.827504+00
1282	90	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1283	90	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1284	90	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1285	90	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1286	90	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1287	90	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1288	90	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1289	90	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1290	90	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1291	90	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:15.827504+00
1292	90	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.827504+00
1293	90	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1294	90	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.827504+00
1295	90	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:15.827504+00
1296	91	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1297	91	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1298	91	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1299	91	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1300	91	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1301	91	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1302	91	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1303	91	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1304	91	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1305	91	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1306	91	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1307	91	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1308	91	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1309	91	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1310	91	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1311	91	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1312	91	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1313	91	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1314	91	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1315	91	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1316	91	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1317	91	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1318	91	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	1	2026-10-14 09:11:15.89748+00
1319	91	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1320	91	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-12 03:00:00+00	done	t	0	2026-10-14 09:11:15.89748+00
1321	92	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:15.969533+00
1322	92	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1323	92	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:15.969533+00
1324	92	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1325	92	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:15.969533+00
1326	92	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:15.969533+00
1327	92	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1328	92	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1329	92	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:15.969533+00
1330	92	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:15.969533+00
1331	92	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1332	92	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1333	92	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1334	92	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:15.969533+00
1335	92	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:15.969533+00
1336	92	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1337	92	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1338	92	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1339	92	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:15.969533+00
1340	92	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:15.969533+00
1341	92	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:15.969533+00
1342	93	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1343	93	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1344	93	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:16.040515+00
1345	93	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1346	93	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1347	93	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.040515+00
1348	93	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1349	93	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1350	93	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1351	93	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1352	93	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:16.040515+00
1353	93	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1354	93	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.040515+00
1355	93	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:16.040515+00
1356	93	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1357	93	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1358	93	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1359	93	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:16.040515+00
1360	93	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:16.040515+00
1361	93	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1362	93	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1363	93	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.040515+00
1364	93	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1365	93	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1366	93	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.040515+00
1367	94	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1368	94	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:16.122254+00
1369	94	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1370	94	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:16.122254+00
1371	94	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1372	94	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1373	94	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1374	94	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1375	94	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1376	94	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:16.122254+00
1377	94	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1378	94	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1379	94	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1380	94	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1381	94	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:16.122254+00
1382	94	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:16.122254+00
1383	94	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1384	94	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1385	94	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1386	94	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.122254+00
1387	94	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1388	94	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:16.122254+00
1389	95	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.193313+00
1390	95	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.193313+00
1391	95	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1392	95	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.193313+00
1393	95	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1394	95	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:16.193313+00
1395	95	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:16.193313+00
1396	95	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1397	95	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1398	95	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1399	95	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:16.193313+00
1400	95	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:16.193313+00
1401	95	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:16.193313+00
1402	95	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1403	95	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1404	95	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1405	95	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:16.193313+00
1406	95	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1407	95	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1408	95	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:16.193313+00
1409	95	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1410	95	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.193313+00
1411	95	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:16.193313+00
1412	95	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-08 03:00:00+00	done	t	2	2026-10-14 09:11:16.193313+00
1413	95	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.193313+00
1414	96	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.265499+00
1415	96	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1416	96	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.265499+00
1417	96	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1418	96	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1419	96	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1420	96	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1421	96	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1422	96	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1423	96	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1424	96	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1425	96	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.265499+00
1426	96	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:16.265499+00
1427	96	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1428	96	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:16.265499+00
1429	96	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1430	96	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1431	96	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1432	96	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1433	96	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1434	96	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1435	96	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:16.265499+00
1436	97	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1437	97	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1438	97	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.337619+00
1439	97	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1440	97	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1441	97	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1442	97	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1443	97	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1444	97	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:16.337619+00
1445	97	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:16.337619+00
1446	97	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1447	97	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1448	97	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1449	97	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:16.337619+00
1450	97	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1451	97	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1452	97	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1453	97	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1454	97	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1455	97	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1456	97	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1457	97	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:16.337619+00
1458	98	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1459	98	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1460	98	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1461	98	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1462	98	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.409267+00
1463	98	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1464	98	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1465	98	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1466	98	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1467	98	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1468	98	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1469	98	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1470	98	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1471	98	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1472	98	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1473	98	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.409267+00
1474	98	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:16.409267+00
1475	99	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1476	99	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1477	99	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1478	99	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1479	99	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1480	99	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1481	99	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1482	99	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1483	99	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1484	99	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1485	99	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1486	99	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1487	99	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:16.479676+00
1488	99	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1489	99	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.479676+00
1490	100	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1491	100	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1492	100	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1493	100	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.551947+00
1494	100	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1495	100	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1496	100	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1497	100	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:16.551947+00
1498	100	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:16.551947+00
1499	100	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1500	100	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1501	100	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1502	100	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1503	100	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1504	100	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1505	100	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1506	100	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1507	100	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:16.551947+00
1508	100	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:16.551947+00
1509	101	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.623643+00
1510	101	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:16.623643+00
1511	102	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1512	102	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1513	102	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.694284+00
1514	102	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:16.694284+00
1515	102	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1516	102	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1517	102	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:16.694284+00
1518	102	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.694284+00
1519	102	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1520	102	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1521	102	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1522	102	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:16.694284+00
1523	102	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.694284+00
1524	102	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:16.694284+00
1525	102	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1526	102	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:16.694284+00
1527	102	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.694284+00
1528	103	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1529	103	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:16.772079+00
1530	103	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1531	103	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1532	103	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1533	103	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1534	103	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1535	103	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1536	103	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1537	103	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1538	103	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1539	103	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:16.772079+00
1540	103	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1541	103	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.772079+00
1542	103	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.772079+00
1543	103	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1544	103	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	1	2026-10-14 09:11:16.772079+00
1545	103	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:16.772079+00
1546	103	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1547	103	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1548	103	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1549	103	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1550	103	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:16.772079+00
1551	103	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.772079+00
1552	104	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1553	104	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1554	104	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1555	104	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1556	104	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1557	104	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:16.845855+00
1558	104	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1559	104	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1560	104	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1561	104	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1562	104	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1563	104	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1564	104	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1565	104	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1566	104	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1567	104	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.845855+00
1568	105	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:16.915819+00
1569	105	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:16.915819+00
1570	105	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1571	105	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:16.915819+00
1572	105	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.915819+00
1573	105	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:16.915819+00
1574	105	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1575	105	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1576	105	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.915819+00
1577	105	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1578	105	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.915819+00
1579	105	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1580	105	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:16.915819+00
1581	105	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	2	2026-10-14 09:11:16.915819+00
1582	105	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1583	105	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:16.915819+00
1584	105	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:16.915819+00
1585	105	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1586	105	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1587	105	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1588	105	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	2	2026-10-14 09:11:16.915819+00
1589	105	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1590	105	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.915819+00
1591	105	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:16.915819+00
1592	106	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.986875+00
1593	106	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:16.986875+00
1594	106	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:16.986875+00
1595	106	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1596	106	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1597	106	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:16.986875+00
1598	106	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1599	106	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1600	106	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1601	106	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1602	106	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1603	106	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1604	106	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1605	106	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1606	106	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1607	106	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:16.986875+00
1608	107	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1609	107	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1610	107	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1611	107	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.058088+00
1612	107	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.058088+00
1613	107	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1614	107	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1615	107	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1616	107	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1617	107	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:17.058088+00
1618	107	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:17.058088+00
1619	107	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.058088+00
1620	107	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1621	107	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.058088+00
1622	107	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.058088+00
1623	108	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1624	108	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	2	2026-10-14 09:11:17.128186+00
1625	108	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	2	2026-10-14 09:11:17.128186+00
1626	108	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1627	108	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1628	108	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1629	108	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:17.128186+00
1630	108	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1631	108	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1632	108	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1633	108	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1634	108	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.128186+00
1635	108	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.128186+00
1636	108	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1637	108	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1638	108	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1639	108	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1640	108	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1641	108	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:17.128186+00
1642	108	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.128186+00
1643	109	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1644	109	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1645	109	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1646	109	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:17.199907+00
1647	109	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1648	109	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:17.199907+00
1649	109	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1650	109	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1651	109	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1652	109	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1653	109	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1654	109	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.199907+00
1655	109	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1656	109	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1657	109	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1658	109	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1659	109	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1660	109	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:17.199907+00
1661	110	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:17.271524+00
1662	110	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1663	110	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1664	110	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1665	110	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1666	110	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1667	110	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1668	110	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	1	2026-10-14 09:11:17.271524+00
1669	110	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1670	110	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1671	110	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1672	110	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:17.271524+00
1673	110	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:17.271524+00
1674	110	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.271524+00
1675	110	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.271524+00
1676	110	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:17.271524+00
1677	111	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1678	111	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.34182+00
1679	111	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1680	111	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1681	111	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:17.34182+00
1682	111	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.34182+00
1683	111	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1684	111	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.34182+00
1685	111	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1686	111	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1687	111	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1688	111	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1689	111	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1690	111	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.34182+00
1691	111	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1692	111	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1693	111	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.34182+00
1694	111	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.34182+00
1695	111	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.34182+00
1696	111	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:17.34182+00
1697	111	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:17.34182+00
1698	112	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1699	112	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1700	112	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1701	112	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1702	112	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.421265+00
1703	112	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:17.421265+00
1704	112	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1705	112	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1706	112	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1707	112	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.421265+00
1708	112	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1709	112	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1710	112	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1711	112	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:17.421265+00
1712	112	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1713	112	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1714	112	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.421265+00
1715	113	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1716	113	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.500393+00
1717	113	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.500393+00
1718	113	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1719	113	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:17.500393+00
1720	113	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1721	113	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1722	113	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:17.500393+00
1723	113	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.500393+00
1724	113	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1725	113	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1726	113	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.500393+00
1727	113	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:17.500393+00
1728	113	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1729	113	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.500393+00
1730	113	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:17.500393+00
1731	113	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.500393+00
1732	114	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1733	114	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1734	114	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:17.572794+00
1735	114	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.572794+00
1736	114	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:17.572794+00
1737	114	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1738	114	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:17.572794+00
1739	114	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1740	114	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:17.572794+00
1741	114	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1742	114	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.572794+00
1743	114	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1744	114	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:17.572794+00
1745	114	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:17.572794+00
1746	114	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1747	114	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1748	114	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.572794+00
1749	114	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.572794+00
1750	114	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:17.572794+00
1751	115	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1752	115	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1753	115	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1754	115	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1755	115	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1756	115	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1757	115	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1758	115	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1759	115	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1760	115	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:17.643615+00
1761	115	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1762	115	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1763	115	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1764	115	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1765	115	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.643615+00
1766	116	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1767	116	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:17.732005+00
1768	116	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1769	116	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1770	116	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1771	116	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1772	116	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	1	2026-10-14 09:11:17.732005+00
1773	116	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1774	116	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.732005+00
1775	116	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:17.732005+00
1776	116	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1777	116	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1778	116	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:17.732005+00
1779	116	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1780	116	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1781	116	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1782	116	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:17.732005+00
1783	116	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1784	116	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:17.732005+00
1785	117	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:17.804647+00
1786	117	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1787	117	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1788	117	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1789	117	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1790	117	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1791	117	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1792	117	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:17.804647+00
1793	117	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1794	117	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:17.804647+00
1795	117	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1796	117	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1797	117	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1798	117	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1799	117	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1800	117	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1801	117	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1802	117	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:17.804647+00
1803	117	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1804	117	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1805	117	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1806	117	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	1	2026-10-14 09:11:17.804647+00
1807	117	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1808	117	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.804647+00
1809	118	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1810	118	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1811	118	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.886745+00
1812	118	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.886745+00
1813	118	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1814	118	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:17.886745+00
1815	118	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1816	118	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1817	118	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1818	118	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1819	118	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.886745+00
1820	118	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:17.886745+00
1821	118	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1822	118	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:17.886745+00
1823	118	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:17.886745+00
1824	118	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:17.886745+00
1825	118	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	2	2026-10-14 09:11:17.886745+00
1826	118	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:17.886745+00
1827	118	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:17.886745+00
1828	118	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.886745+00
1829	118	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.886745+00
1830	119	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:17.963716+00
1831	119	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1832	119	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1833	119	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1834	119	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:17.963716+00
1835	119	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1836	119	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1837	119	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1838	119	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1839	119	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1840	119	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1841	119	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1842	119	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1843	119	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1844	119	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1845	119	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	2	2026-10-14 09:11:17.963716+00
1846	119	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1847	119	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:17.963716+00
1848	119	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:17.963716+00
1849	119	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1850	119	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:17.963716+00
1851	119	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1852	119	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	2	2026-10-14 09:11:17.963716+00
1853	119	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:17.963716+00
1854	120	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1855	120	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:18.034635+00
1856	120	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1857	120	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1858	120	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:18.034635+00
1859	120	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1860	120	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1861	120	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1862	120	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1863	120	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1864	120	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:18.034635+00
1865	120	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1866	120	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1867	120	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1868	120	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1869	120	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:18.034635+00
1870	121	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1871	121	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1872	121	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	1	2026-10-14 09:11:18.117526+00
1873	121	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1874	121	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1875	121	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1876	121	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:18.117526+00
1877	121	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1878	121	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1879	121	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1880	121	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:18.117526+00
1881	121	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1882	121	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1883	121	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1884	121	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1885	121	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1886	121	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1887	121	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1888	121	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	1	2026-10-14 09:11:18.117526+00
1889	121	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:18.117526+00
1890	121	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1891	121	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.117526+00
1892	121	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:18.117526+00
1893	122	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.215605+00
1894	122	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:18.215605+00
1895	122	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:18.215605+00
1896	122	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:18.215605+00
1897	122	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:18.215605+00
1898	122	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:18.215605+00
1899	122	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.215605+00
1900	122	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:18.215605+00
1901	122	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:18.215605+00
1902	122	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:18.215605+00
1903	122	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.215605+00
1904	122	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:18.215605+00
1905	122	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:18.215605+00
1906	122	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:18.215605+00
1907	122	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:18.215605+00
1908	122	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:18.215605+00
1909	123	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1910	123	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1911	123	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1912	123	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.285986+00
1913	123	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1914	123	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.285986+00
1915	123	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1916	123	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:18.285986+00
1917	123	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1918	123	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:18.285986+00
1919	123	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:18.285986+00
1920	123	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1921	123	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1922	123	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1923	123	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:18.285986+00
1924	123	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1925	123	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1926	123	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.285986+00
1927	123	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.285986+00
1928	123	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1929	123	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:18.285986+00
1930	124	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:18.357607+00
1931	124	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:18.357607+00
1932	124	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.357607+00
1933	124	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:18.357607+00
1934	124	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:18.357607+00
1935	124	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:18.357607+00
1936	124	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:18.357607+00
1937	124	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:18.357607+00
1938	124	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:18.357607+00
1939	124	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:18.357607+00
1940	124	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.357607+00
1941	124	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:18.357607+00
1942	124	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.357607+00
1943	124	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:18.357607+00
1944	124	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	2	2026-10-14 09:11:18.357607+00
1945	125	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1946	125	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1947	125	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1948	125	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1949	125	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1950	125	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1951	125	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:18.42835+00
1952	125	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:18.42835+00
1953	125	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1954	125	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1955	125	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1956	125	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1957	125	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1958	125	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1959	125	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:18.42835+00
1960	126	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.501302+00
1961	126	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:18.501302+00
1962	127	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1963	127	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1964	127	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1965	127	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1966	127	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1967	127	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:18.572738+00
1968	127	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1969	127	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1970	127	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1971	127	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1972	127	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1973	127	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:18.572738+00
1974	127	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1975	127	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1976	127	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:18.572738+00
1977	128	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:18.644191+00
1978	128	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:18.644191+00
1979	128	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1980	128	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:18.644191+00
1981	128	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:18.644191+00
1982	128	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:18.644191+00
1983	128	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1984	128	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1985	128	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1986	128	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1987	128	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:18.644191+00
1988	128	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:18.644191+00
1989	128	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1990	128	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:18.644191+00
1991	128	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1992	128	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:18.644191+00
1993	128	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:18.644191+00
1994	128	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	1	2026-10-14 09:11:18.644191+00
1995	128	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1996	128	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.644191+00
1997	128	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:18.644191+00
1998	128	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:18.644191+00
1999	129	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.716677+00
2000	129	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.716677+00
2001	129	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.716677+00
2002	129	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:18.716677+00
2003	129	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:18.716677+00
2004	129	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:18.716677+00
2005	129	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.716677+00
2006	129	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.716677+00
2007	129	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.716677+00
2008	129	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:18.716677+00
2009	129	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:18.716677+00
2010	129	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.716677+00
2011	129	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:18.716677+00
2012	129	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:18.716677+00
2013	129	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:18.716677+00
2014	129	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:18.716677+00
2015	129	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.716677+00
2016	130	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:18.787869+00
2017	130	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.787869+00
2018	130	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:18.787869+00
2019	130	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2020	130	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.787869+00
2021	130	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2022	130	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:18.787869+00
2023	130	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2024	130	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.787869+00
2025	130	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2026	130	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2027	130	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:18.787869+00
2028	130	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2029	130	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2030	130	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:18.787869+00
2031	130	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2032	130	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.787869+00
2033	130	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.787869+00
2034	131	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2035	131	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.863787+00
2036	131	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2037	131	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2038	131	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2039	131	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2040	131	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2041	131	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2042	131	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2043	131	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.863787+00
2044	131	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2045	131	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2046	131	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:18.863787+00
2047	131	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2048	131	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2049	131	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:18.863787+00
2050	132	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	2	2026-10-14 09:11:18.935754+00
2051	132	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.935754+00
2052	132	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:18.935754+00
2053	132	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:18.935754+00
2054	132	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:18.935754+00
2055	132	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:18.935754+00
2056	132	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:18.935754+00
2057	132	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	1	2026-10-14 09:11:18.935754+00
2058	132	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.935754+00
2059	132	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:18.935754+00
2060	132	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.935754+00
2061	132	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:18.935754+00
2062	132	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:18.935754+00
2063	132	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:18.935754+00
2064	132	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:18.935754+00
2065	132	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.935754+00
2066	132	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.935754+00
2067	132	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:18.935754+00
2068	132	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.935754+00
2069	132	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:18.935754+00
2070	132	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:18.935754+00
2071	133	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2072	133	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2073	133	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2074	133	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2075	133	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2076	133	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2077	133	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2078	133	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2079	133	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2080	133	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2081	133	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:19.006395+00
2082	133	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2083	133	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2084	133	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2085	133	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2086	133	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:19.006395+00
2087	133	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2088	133	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:19.006395+00
2089	133	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2090	133	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2091	133	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2092	133	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:19.006395+00
2093	134	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.077059+00
2094	134	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.077059+00
2095	134	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.077059+00
2096	134	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.077059+00
2097	134	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2098	134	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.077059+00
2099	134	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:19.077059+00
2100	134	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.077059+00
2101	134	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:19.077059+00
2102	134	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2103	134	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:19.077059+00
2104	134	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2105	134	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2106	134	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:19.077059+00
2107	134	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2108	134	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2109	134	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.077059+00
2110	134	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2111	134	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:19.077059+00
2112	134	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:19.077059+00
2113	134	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:19.077059+00
2114	135	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2115	135	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2116	135	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	1	2026-10-14 09:11:19.147768+00
2117	135	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2118	135	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2119	135	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.147768+00
2120	135	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.147768+00
2121	135	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2122	135	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2123	135	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2124	135	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:19.147768+00
2125	135	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2126	135	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2127	135	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.147768+00
2128	135	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.147768+00
2129	135	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2130	135	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2131	135	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2132	135	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2133	135	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2134	135	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.147768+00
2135	136	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.220987+00
2136	136	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.220987+00
2137	136	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2138	136	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2139	136	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2140	136	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2141	136	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2142	136	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:19.220987+00
2143	136	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.220987+00
2144	136	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.220987+00
2145	136	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2146	136	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2147	136	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2148	136	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:19.220987+00
2149	136	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:19.220987+00
2150	137	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2151	137	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2152	137	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:19.291417+00
2153	137	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2154	137	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:19.291417+00
2155	137	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2156	137	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2157	137	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2158	137	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.291417+00
2159	137	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.291417+00
2160	137	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2161	137	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2162	137	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2163	137	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2164	137	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2165	137	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2166	137	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2167	137	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2168	137	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.291417+00
2169	138	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2170	138	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2171	138	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2172	138	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2173	138	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2174	138	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2175	138	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:19.363955+00
2176	138	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2177	138	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:19.363955+00
2178	138	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:19.363955+00
2179	138	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2180	138	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2181	138	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:19.363955+00
2182	138	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2183	138	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2184	138	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2185	138	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.363955+00
2186	138	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	2	2026-10-14 09:11:19.363955+00
2187	138	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2188	138	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2189	138	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2190	138	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:19.363955+00
2191	139	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2192	139	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2193	139	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2194	139	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2195	139	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:19.435221+00
2196	139	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2197	139	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2198	139	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2199	139	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2200	139	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2201	139	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:19.435221+00
2202	139	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2203	139	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2204	139	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2205	139	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:19.435221+00
2206	139	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2207	139	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2208	139	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:19.435221+00
2209	139	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2210	139	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2211	139	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2212	139	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2213	139	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.435221+00
2214	139	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2215	139	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.435221+00
2216	140	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2217	140	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2218	140	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.505651+00
2219	140	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2220	140	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2221	140	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.505651+00
2222	140	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.505651+00
2223	140	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:19.505651+00
2224	140	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2225	140	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2226	140	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:19.505651+00
2227	140	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.505651+00
2228	140	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.505651+00
2229	140	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.505651+00
2230	140	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2231	140	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2232	140	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:19.505651+00
2233	140	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:19.505651+00
2234	140	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2235	140	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.505651+00
2236	140	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2237	140	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:19.505651+00
2238	141	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2239	141	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2240	141	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2241	141	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2242	141	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:19.577125+00
2243	141	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2244	141	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2245	141	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2246	141	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2247	141	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2248	141	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2249	141	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2250	141	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2251	141	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2252	141	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:19.577125+00
2253	141	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:19.577125+00
2254	142	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:19.648204+00
2255	142	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:19.648204+00
2256	142	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:19.648204+00
2257	142	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.648204+00
2258	142	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:19.648204+00
2259	142	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2260	142	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2261	142	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:19.648204+00
2262	142	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:19.648204+00
2263	142	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.648204+00
2264	142	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:19.648204+00
2265	142	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2266	142	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:19.648204+00
2267	142	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2268	142	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2269	142	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:19.648204+00
2270	142	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:19.648204+00
2271	142	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2272	142	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	1	2026-10-14 09:11:19.648204+00
2273	142	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2274	142	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:19.648204+00
2275	142	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	1	2026-10-14 09:11:19.648204+00
2276	142	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2277	142	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.648204+00
2278	143	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.729047+00
2279	143	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:19.729047+00
2280	143	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.729047+00
2281	143	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	2	2026-10-14 09:11:19.729047+00
2282	143	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:19.729047+00
2283	143	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	1	2026-10-14 09:11:19.729047+00
2284	143	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:19.729047+00
2285	143	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.729047+00
2286	143	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:19.729047+00
2287	143	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.729047+00
2288	143	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:19.729047+00
2289	143	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:19.729047+00
2290	143	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:19.729047+00
2291	143	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:19.729047+00
2292	143	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.729047+00
2293	143	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:19.729047+00
2294	143	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.729047+00
2295	143	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:19.729047+00
2296	143	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:19.729047+00
2297	143	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:19.729047+00
2298	143	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.729047+00
2299	143	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.729047+00
2300	144	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2301	144	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2302	144	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2303	144	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2304	144	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:19.801766+00
2305	144	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2306	144	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2307	144	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2308	144	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2309	144	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2310	144	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2311	144	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2312	144	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2313	144	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2314	144	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2315	144	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2316	144	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2317	144	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:19.801766+00
2318	144	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2319	144	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2320	144	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.801766+00
2321	145	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2322	145	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2323	145	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2324	145	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2325	145	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:19.878714+00
2326	145	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2327	145	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2328	145	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2329	145	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2330	145	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:19.878714+00
2331	145	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2332	145	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2333	145	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.878714+00
2334	145	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.878714+00
2335	145	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2336	145	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2337	145	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2338	145	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:19.878714+00
2339	145	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2340	145	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.878714+00
2341	145	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2342	145	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.878714+00
2343	145	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2344	145	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:19.878714+00
2345	146	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	2	2026-10-14 09:11:19.949954+00
2346	146	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2347	146	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2348	146	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.949954+00
2349	146	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:19.949954+00
2350	146	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:19.949954+00
2351	146	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2352	146	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2353	146	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2354	146	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:19.949954+00
2355	146	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2356	146	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.949954+00
2357	146	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2358	146	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:19.949954+00
2359	146	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2360	146	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2361	146	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2362	146	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:19.949954+00
2363	146	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.949954+00
2364	146	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2365	146	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:19.949954+00
2366	146	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:19.949954+00
2367	146	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	2	2026-10-14 09:11:19.949954+00
2368	147	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2369	147	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2370	147	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2371	147	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2372	147	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:20.021146+00
2373	147	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2374	147	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2375	147	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2376	147	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:20.021146+00
2377	147	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:20.021146+00
2378	147	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:20.021146+00
2379	147	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2380	147	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2381	147	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2382	147	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2383	147	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:20.021146+00
2384	148	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2385	148	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.092266+00
2386	148	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2387	148	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.092266+00
2388	148	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:20.092266+00
2389	148	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:20.092266+00
2390	148	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2391	148	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2392	148	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:20.092266+00
2393	148	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2394	148	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2395	148	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2396	148	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:20.092266+00
2397	148	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	2	2026-10-14 09:11:20.092266+00
2398	148	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.092266+00
2399	148	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2400	148	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2401	148	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:20.092266+00
2402	148	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	1	2026-10-14 09:11:20.092266+00
2403	148	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.092266+00
2404	149	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.164859+00
2405	149	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:20.164859+00
2406	149	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:20.164859+00
2407	149	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:20.164859+00
2408	149	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:20.164859+00
2409	149	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.164859+00
2410	149	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:20.164859+00
2411	149	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:20.164859+00
2412	149	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:20.164859+00
2413	149	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:20.164859+00
2414	149	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:20.164859+00
2415	149	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.164859+00
2416	149	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:20.164859+00
2417	149	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:20.164859+00
2418	149	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:20.164859+00
2419	150	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	2	2026-10-14 09:11:20.320667+00
2420	150	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.320667+00
2421	150	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:20.320667+00
2422	150	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.320667+00
2423	150	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:20.320667+00
2424	150	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	1	2026-10-14 09:11:20.320667+00
2425	150	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:20.320667+00
2426	150	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:20.320667+00
2427	150	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:20.320667+00
2428	150	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.320667+00
2429	150	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:20.320667+00
2430	150	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.320667+00
2431	150	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:20.320667+00
2432	150	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.320667+00
2433	150	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:20.320667+00
2434	150	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	1	2026-10-14 09:11:20.320667+00
2435	150	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:20.320667+00
2436	150	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:20.320667+00
2437	150	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.320667+00
2438	150	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.320667+00
2439	151	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:20.417919+00
2440	151	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:20.417919+00
2441	152	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:20.49989+00
2442	152	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:20.49989+00
2443	152	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.49989+00
2444	152	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.49989+00
2445	152	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:20.49989+00
2446	152	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.49989+00
2447	152	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:20.49989+00
2448	152	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:20.49989+00
2449	152	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.49989+00
2450	152	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.49989+00
2451	152	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:20.49989+00
2452	152	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.49989+00
2453	152	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:20.49989+00
2454	152	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:20.49989+00
2455	152	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:20.49989+00
2456	152	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:20.49989+00
2457	152	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.49989+00
2458	152	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:20.49989+00
2459	152	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	1	2026-10-14 09:11:20.49989+00
2460	152	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:20.49989+00
2461	153	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2462	153	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.574903+00
2463	153	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2464	153	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2465	153	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2466	153	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2467	153	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2468	153	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2469	153	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2470	153	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2471	153	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:20.574903+00
2472	153	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2473	153	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2474	153	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2475	153	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2476	153	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2477	153	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2478	153	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2479	153	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2480	153	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2481	153	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2482	153	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.574903+00
2483	153	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.574903+00
2484	153	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-08 03:00:00+00	done	t	0	2026-10-14 09:11:20.574903+00
2485	154	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2486	154	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2487	154	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2488	154	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2489	154	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2490	154	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2491	154	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.645818+00
2492	154	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2493	154	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2494	154	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2495	154	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2496	154	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2497	154	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2498	154	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2499	154	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2500	154	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:20.645818+00
2501	154	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2502	154	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2503	154	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2504	154	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2505	154	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2506	154	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2507	154	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	2	2026-10-14 09:11:20.645818+00
2508	154	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.645818+00
2509	155	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.732496+00
2510	155	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	2	2026-10-14 09:11:20.732496+00
2511	155	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.732496+00
2512	155	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:20.732496+00
2513	155	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.732496+00
2514	155	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:20.732496+00
2515	155	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:20.732496+00
2516	155	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	2	2026-10-14 09:11:20.732496+00
2517	155	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.732496+00
2518	155	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:20.732496+00
2519	155	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:20.732496+00
2520	155	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:20.732496+00
2521	155	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.732496+00
2522	155	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.732496+00
2523	155	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.732496+00
2524	156	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.806056+00
2525	156	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	2	2026-10-14 09:11:20.806056+00
2526	156	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:20.806056+00
2527	156	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:20.806056+00
2528	156	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:20.806056+00
2529	156	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:20.806056+00
2530	156	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.806056+00
2531	156	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:20.806056+00
2532	156	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:20.806056+00
2533	156	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.806056+00
2534	156	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:20.806056+00
2535	156	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:20.806056+00
2536	156	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:20.806056+00
2537	156	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.806056+00
2538	156	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	1	2026-10-14 09:11:20.806056+00
2539	156	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.806056+00
2540	156	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:20.806056+00
2541	157	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2542	157	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2543	157	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2544	157	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2545	157	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2546	157	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	1	2026-10-14 09:11:20.878324+00
2547	157	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2548	157	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2549	157	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2550	157	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2551	157	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2552	157	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2553	157	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2554	157	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.878324+00
2555	157	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2556	157	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2557	157	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:20.878324+00
2558	157	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.878324+00
2559	157	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:20.878324+00
2560	158	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2561	158	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.949179+00
2562	158	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2563	158	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:20.949179+00
2564	158	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2565	158	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2566	158	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2567	158	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.949179+00
2568	158	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:20.949179+00
2569	158	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2570	158	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:20.949179+00
2571	158	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2572	158	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2573	158	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.949179+00
2574	158	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2575	158	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:20.949179+00
2576	158	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2577	158	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.949179+00
2578	158	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.949179+00
2579	158	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:20.949179+00
2580	158	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.949179+00
2581	158	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	2	2026-10-14 09:11:20.949179+00
2582	158	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:20.949179+00
2583	159	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2584	159	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2585	159	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2586	159	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2587	159	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2588	159	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2589	159	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2590	159	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:21.024358+00
2591	159	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2592	159	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2593	159	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2594	159	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2595	159	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2596	159	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:21.024358+00
2597	159	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.024358+00
2598	159	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2599	159	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2600	159	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2601	159	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2602	159	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2603	159	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2604	159	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2605	159	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2606	159	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2607	159	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.024358+00
2608	160	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2609	160	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.098187+00
2610	160	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2611	160	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2612	160	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2613	160	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:21.098187+00
2614	160	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.098187+00
2615	160	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2616	160	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:21.098187+00
2617	160	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2618	160	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2619	160	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2620	160	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:21.098187+00
2621	160	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2622	160	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2623	160	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2624	160	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	2	2026-10-14 09:11:21.098187+00
2625	160	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2626	160	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2627	160	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2628	160	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2629	160	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2630	160	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	1	2026-10-14 09:11:21.098187+00
2631	160	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.098187+00
2632	160	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.098187+00
2633	161	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2634	161	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2635	161	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:21.172908+00
2636	161	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2637	161	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2638	161	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2639	161	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2640	161	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2641	161	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2642	161	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2643	161	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2644	161	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2645	161	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2646	161	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	2	2026-10-14 09:11:21.172908+00
2647	161	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:21.172908+00
2648	161	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2649	161	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2650	161	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.172908+00
2651	161	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2652	161	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2653	161	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2654	161	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2655	161	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:21.172908+00
2656	162	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2657	162	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2658	162	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2659	162	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2660	162	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.245476+00
2661	162	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2662	162	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2663	162	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:21.245476+00
2664	162	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2665	162	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2666	162	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2667	162	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2668	162	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:21.245476+00
2669	162	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:21.245476+00
2670	162	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2671	162	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2672	162	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2673	162	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:21.245476+00
2674	162	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	1	2026-10-14 09:11:21.245476+00
2675	163	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2676	163	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.316985+00
2677	163	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:21.316985+00
2678	163	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2679	163	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2680	163	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2681	163	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.316985+00
2682	163	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2683	163	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2684	163	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2685	163	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:21.316985+00
2686	163	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2687	163	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2688	163	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2689	163	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2690	163	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2691	163	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2692	163	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2693	163	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2694	163	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2695	163	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2696	163	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.316985+00
2697	164	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2698	164	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2699	164	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2700	164	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.390043+00
2701	164	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.390043+00
2702	164	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:21.390043+00
2703	164	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:21.390043+00
2704	164	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.390043+00
2705	164	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.390043+00
2706	164	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2707	164	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2708	164	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2709	164	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2710	164	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2711	164	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2712	164	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2713	164	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2714	164	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:21.390043+00
2715	165	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.461742+00
2716	165	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2717	165	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2718	165	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2719	165	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:21.461742+00
2720	165	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2721	165	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2722	165	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2723	165	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2724	165	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2725	165	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2726	165	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:21.461742+00
2727	165	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2728	165	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2729	165	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2730	165	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.461742+00
2731	166	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2732	166	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2733	166	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2734	166	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:21.531905+00
2735	166	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2736	166	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2737	166	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	1	2026-10-14 09:11:21.531905+00
2738	166	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.531905+00
2739	166	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.531905+00
2740	166	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2741	166	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2742	166	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:21.531905+00
2743	166	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.531905+00
2744	166	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.531905+00
2745	166	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2746	166	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.531905+00
2747	166	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.531905+00
2748	166	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:21.531905+00
2749	166	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2750	166	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:21.531905+00
2751	166	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:21.531905+00
2752	167	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2753	167	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2754	167	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2755	167	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2756	167	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2757	167	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2758	167	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2759	167	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2760	167	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2761	167	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2762	167	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2763	167	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2764	167	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2765	167	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2766	167	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2767	167	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2768	167	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:21.603902+00
2769	167	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2770	167	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2771	167	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2772	167	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:21.603902+00
2773	167	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	1	2026-10-14 09:11:21.603902+00
2774	168	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2775	168	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2776	168	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2777	168	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2778	168	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2779	168	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2780	168	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2781	168	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2782	168	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2783	168	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2784	168	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2785	168	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2786	168	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2787	168	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2788	168	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2789	168	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.675521+00
2790	169	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.746412+00
2791	169	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:21.746412+00
2792	169	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	1	2026-10-14 09:11:21.746412+00
2793	169	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.746412+00
2794	169	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:21.746412+00
2795	169	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:21.746412+00
2796	169	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:21.746412+00
2797	169	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:21.746412+00
2798	169	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.746412+00
2799	169	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:21.746412+00
2800	169	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.746412+00
2801	169	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:21.746412+00
2802	169	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.746412+00
2803	169	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:21.746412+00
2804	169	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.746412+00
2805	169	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	1	2026-10-14 09:11:21.746412+00
2806	169	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.746412+00
2807	169	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:21.746412+00
2808	169	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.746412+00
2809	170	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.81672+00
2810	170	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2811	170	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2812	170	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2813	170	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2814	170	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2815	170	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:21.81672+00
2816	170	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:21.81672+00
2817	170	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:21.81672+00
2818	170	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2819	170	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2820	170	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.81672+00
2821	170	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2822	170	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2823	170	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2824	170	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2825	170	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2826	170	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2827	170	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2828	170	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2829	170	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2830	170	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2831	170	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	1	2026-10-14 09:11:21.81672+00
2832	170	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-08 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2833	170	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-12 03:00:00+00	done	t	0	2026-10-14 09:11:21.81672+00
2834	171	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2835	171	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2836	171	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:21.894238+00
2837	171	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.894238+00
2838	171	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.894238+00
2839	171	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2840	171	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2841	171	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2842	171	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2843	171	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2844	171	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:21.894238+00
2845	171	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2846	171	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:21.894238+00
2847	171	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2848	171	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2849	171	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:21.894238+00
2850	172	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	2	2026-10-14 09:11:21.964829+00
2851	172	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2852	172	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:21.964829+00
2853	172	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2854	172	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:21.964829+00
2855	172	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:21.964829+00
2856	172	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:21.964829+00
2857	172	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2858	172	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:21.964829+00
2859	172	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:21.964829+00
2860	172	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:21.964829+00
2861	172	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:21.964829+00
2862	172	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2863	172	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:21.964829+00
2864	172	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2865	172	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2866	172	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2867	172	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:21.964829+00
2868	172	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2869	172	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:21.964829+00
2870	172	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2871	172	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:21.964829+00
2872	172	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:21.964829+00
2873	172	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:21.964829+00
2874	172	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	2	2026-10-14 09:11:21.964829+00
2875	173	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.035846+00
2876	173	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2877	173	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2878	173	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2879	173	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2880	173	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2881	173	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2882	173	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.035846+00
2883	173	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:22.035846+00
2884	173	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2885	173	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2886	173	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2887	173	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:22.035846+00
2888	173	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.035846+00
2889	173	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2890	173	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2891	173	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.035846+00
2892	173	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2893	173	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2894	173	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2895	173	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2896	173	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2897	173	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2898	173	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.035846+00
2899	174	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.108201+00
2900	174	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2901	174	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2902	174	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.108201+00
2903	174	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2904	174	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2905	174	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2906	174	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2907	174	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2908	174	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2909	174	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.108201+00
2910	174	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2911	174	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:22.108201+00
2912	174	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:22.108201+00
2913	174	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:22.108201+00
2914	174	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	2	2026-10-14 09:11:22.108201+00
2915	174	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	2	2026-10-14 09:11:22.108201+00
2916	174	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2917	174	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2918	174	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:22.108201+00
2919	175	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	1	2026-10-14 09:11:22.179425+00
2920	175	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.179425+00
2921	175	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.179425+00
2922	175	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:22.179425+00
2923	175	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:22.179425+00
2924	175	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	2	2026-10-14 09:11:22.179425+00
2925	175	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:22.179425+00
2926	175	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.179425+00
2927	175	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.179425+00
2928	175	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:22.179425+00
2929	175	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:22.179425+00
2930	175	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:22.179425+00
2931	175	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.179425+00
2932	175	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:22.179425+00
2933	175	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	1	2026-10-14 09:11:22.179425+00
2934	175	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.179425+00
2935	175	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:22.179425+00
2936	175	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:22.179425+00
2937	175	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:22.179425+00
2938	175	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.179425+00
2939	175	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:22.179425+00
2940	175	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.179425+00
2941	176	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:22.252372+00
2942	176	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.252372+00
2943	177	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.323632+00
2944	177	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:22.323632+00
2945	177	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2946	177	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.323632+00
2947	177	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:22.323632+00
2948	177	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:22.323632+00
2949	177	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.323632+00
2950	177	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2951	177	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2952	177	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2953	177	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:22.323632+00
2954	177	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2955	177	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.323632+00
2956	177	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2957	177	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2958	177	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2959	177	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2960	177	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2961	177	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.323632+00
2962	177	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.323632+00
2963	177	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	1	2026-10-14 09:11:22.323632+00
2964	177	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2965	177	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:22.323632+00
2966	178	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2967	178	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2968	178	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2969	178	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2970	178	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2971	178	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2972	178	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2973	178	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2974	178	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2975	178	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2976	178	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2977	178	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2978	178	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2979	178	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2980	178	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2981	178	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2982	178	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2983	178	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2984	178	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2985	178	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2986	178	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.394977+00
2987	179	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
2988	179	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:22.474907+00
2989	179	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.474907+00
2990	179	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	2	2026-10-14 09:11:22.474907+00
2991	179	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
2992	179	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
2993	179	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.474907+00
2994	179	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
2995	179	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
2996	179	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.474907+00
2997	179	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:22.474907+00
2998	179	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
2999	179	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
3000	179	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.474907+00
3001	179	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.474907+00
3002	180	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3003	180	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3004	180	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3005	180	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.550871+00
3006	180	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3007	180	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3008	180	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3009	180	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.550871+00
3010	180	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3011	180	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3012	180	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3013	180	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.550871+00
3014	180	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:22.550871+00
3015	180	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3016	180	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3017	180	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3018	180	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:22.550871+00
3019	181	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.621388+00
3020	181	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.621388+00
3021	181	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:22.621388+00
3022	181	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:22.621388+00
3023	181	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3024	181	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.621388+00
3025	181	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3026	181	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3027	181	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3028	181	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3029	181	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:22.621388+00
3030	181	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.621388+00
3031	181	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:22.621388+00
3032	181	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3033	181	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3034	181	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3035	181	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3036	181	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3037	181	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	2	2026-10-14 09:11:22.621388+00
3038	181	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:22.621388+00
3039	181	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	1	2026-10-14 09:11:22.621388+00
3040	181	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.621388+00
3041	181	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	2	2026-10-14 09:11:22.621388+00
3042	181	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.621388+00
3043	182	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3044	182	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3045	182	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:22.714732+00
3046	182	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:22.714732+00
3047	182	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3048	182	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3049	182	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3050	182	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.714732+00
3051	182	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3052	182	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3053	182	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3054	182	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3055	182	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.714732+00
3056	182	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:22.714732+00
3057	182	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:22.714732+00
3058	182	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3059	182	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3060	182	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3061	182	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:22.714732+00
3062	183	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.812646+00
3063	183	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.812646+00
3064	183	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:22.812646+00
3065	183	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.812646+00
3066	183	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:22.812646+00
3067	183	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.812646+00
3068	183	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.812646+00
3069	183	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.812646+00
3070	183	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.812646+00
3071	183	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:22.812646+00
3072	183	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:22.812646+00
3073	183	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:22.812646+00
3074	183	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.812646+00
3075	183	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.812646+00
3076	183	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.812646+00
3077	183	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.812646+00
3078	183	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:22.812646+00
3079	184	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3080	184	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3081	184	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3082	184	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3083	184	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3084	184	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3085	184	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3086	184	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3087	184	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3088	184	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3089	184	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3090	184	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3091	184	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:22.894397+00
3092	184	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3093	184	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3094	184	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3095	184	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.894397+00
3096	184	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.894397+00
3097	184	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:22.894397+00
3098	184	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3099	184	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3100	184	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3101	184	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3102	184	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.894397+00
3103	185	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3104	185	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3105	185	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3106	185	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3107	185	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3108	185	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3109	185	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:22.983547+00
3110	185	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:22.983547+00
3111	185	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:22.983547+00
3112	185	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3113	185	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:22.983547+00
3114	185	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3115	185	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3116	185	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3117	185	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3118	185	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3119	185	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3120	185	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:22.983547+00
3121	186	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3122	186	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3123	186	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3124	186	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3125	186	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:23.056596+00
3126	186	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3127	186	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3128	186	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.056596+00
3129	186	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3130	186	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:23.056596+00
3131	186	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3132	186	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:23.056596+00
3133	186	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3134	186	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3135	186	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.056596+00
3136	186	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	1	2026-10-14 09:11:23.056596+00
3137	187	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:23.127823+00
3138	187	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:23.127823+00
3139	187	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3140	187	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3141	187	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3142	187	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3143	187	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3144	187	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3145	187	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:23.127823+00
3146	187	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3147	187	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3148	187	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.127823+00
3149	187	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:23.127823+00
3150	187	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3151	187	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3152	187	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3153	187	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3154	187	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:23.127823+00
3155	187	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3156	187	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3157	187	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.127823+00
3158	188	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3159	188	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3160	188	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3161	188	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3162	188	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:23.226167+00
3163	188	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3164	188	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3165	188	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3166	188	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3167	188	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3168	188	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3169	188	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3170	188	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3171	188	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:23.226167+00
3172	188	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3173	188	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3174	188	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3175	188	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.226167+00
3176	189	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3177	189	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3178	189	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:23.298468+00
3179	189	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:23.298468+00
3180	189	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3181	189	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3182	189	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3183	189	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3184	189	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3185	189	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3186	189	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3187	189	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3188	189	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3189	189	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3190	189	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3191	189	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3192	189	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3193	189	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.298468+00
3194	190	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:23.369935+00
3195	190	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.369935+00
3196	190	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3197	190	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3198	190	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.369935+00
3199	190	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3200	190	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3201	190	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3202	190	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3203	190	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:23.369935+00
3204	190	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3205	190	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3206	190	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3207	190	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3208	190	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3209	190	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3210	190	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3211	190	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3212	190	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3213	190	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3214	190	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3215	190	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:23.369935+00
3216	191	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.449274+00
3217	191	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3218	191	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3219	191	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3220	191	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.449274+00
3221	191	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:23.449274+00
3222	191	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3223	191	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:23.449274+00
3224	191	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3225	191	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.449274+00
3226	191	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3227	191	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:23.449274+00
3228	191	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3229	191	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3230	191	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3231	191	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3232	191	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3233	191	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3234	191	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	2	2026-10-14 09:11:23.449274+00
3235	191	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3236	191	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3237	191	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3238	191	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:23.449274+00
3239	192	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3240	192	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3241	192	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3242	192	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3243	192	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3244	192	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3245	192	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:23.521734+00
3246	192	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3247	192	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.521734+00
3248	192	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3249	192	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3250	192	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3251	192	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3252	192	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:23.521734+00
3253	192	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3254	192	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3255	192	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3256	192	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3257	192	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:23.521734+00
3258	192	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3259	192	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.521734+00
3260	193	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3261	193	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:23.592331+00
3262	193	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3263	193	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3264	193	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:23.592331+00
3265	193	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:23.592331+00
3266	193	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3267	193	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3268	193	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3269	193	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.592331+00
3270	193	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:23.592331+00
3271	193	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.592331+00
3272	193	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3273	193	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3274	193	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3275	193	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3276	193	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3277	193	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3278	193	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3279	193	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3280	193	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3281	193	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	1	2026-10-14 09:11:23.592331+00
3282	193	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:23.592331+00
3283	193	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	2	2026-10-14 09:11:23.592331+00
3284	194	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3285	194	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3286	194	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.664132+00
3287	194	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3288	194	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3289	194	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3290	194	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3291	194	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3292	194	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3293	194	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3294	194	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3295	194	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3296	194	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3297	194	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3298	194	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:23.664132+00
3299	195	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3300	195	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3301	195	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3302	195	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3303	195	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3304	195	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3305	195	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3306	195	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3307	195	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3308	195	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3309	195	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3310	195	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3311	195	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3312	195	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:23.736076+00
3313	195	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3314	195	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3315	195	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3316	195	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.736076+00
3317	196	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3318	196	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.806859+00
3319	196	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3320	196	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.806859+00
3321	196	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:23.806859+00
3322	196	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3323	196	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3324	196	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:23.806859+00
3325	196	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3326	196	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3327	196	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3328	196	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3329	196	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:23.806859+00
3330	196	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3331	196	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3332	196	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3333	196	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3334	196	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.806859+00
3335	196	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:23.806859+00
3336	197	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3337	197	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3338	197	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3339	197	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3340	197	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3341	197	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3342	197	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3343	197	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3344	197	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.883213+00
3345	197	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3346	197	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3347	197	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3348	197	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3349	197	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3350	197	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3351	197	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3352	197	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3353	197	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3354	197	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3355	197	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:23.883213+00
3356	197	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3357	197	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3358	197	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3359	197	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:23.883213+00
3360	198	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3361	198	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:23.964087+00
3362	198	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:23.964087+00
3363	198	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3364	198	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:23.964087+00
3365	198	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:23.964087+00
3366	198	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:23.964087+00
3367	198	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3368	198	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:23.964087+00
3369	198	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3370	198	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3371	198	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:23.964087+00
3372	198	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:23.964087+00
3373	198	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:23.964087+00
3374	198	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3375	198	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3376	198	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:23.964087+00
3377	198	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:23.964087+00
3378	198	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:23.964087+00
3379	198	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3380	198	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:23.964087+00
3381	198	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:23.964087+00
3382	199	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3383	199	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3384	199	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:24.03517+00
3385	199	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3386	199	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:24.03517+00
3387	199	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3388	199	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3389	199	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3390	199	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3391	199	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:24.03517+00
3392	199	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3393	199	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3394	199	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3395	199	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:24.03517+00
3396	199	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:24.03517+00
3397	199	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:24.03517+00
3398	200	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3399	200	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3400	200	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3401	200	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3402	200	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3403	200	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:24.106839+00
3404	200	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:24.106839+00
3405	200	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:24.106839+00
3406	200	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.106839+00
3407	200	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.106839+00
3408	200	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3409	200	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3410	200	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3411	200	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.106839+00
3412	200	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:24.106839+00
3413	200	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.106839+00
3414	200	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.106839+00
3415	200	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3416	200	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.106839+00
3417	200	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.106839+00
3418	200	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.106839+00
3419	201	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:24.177212+00
3420	201	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.177212+00
3421	202	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	1	2026-10-14 09:11:24.247903+00
3422	202	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3423	202	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3424	202	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:24.247903+00
3425	202	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3426	202	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:24.247903+00
3427	202	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:24.247903+00
3428	202	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:24.247903+00
3429	202	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3430	202	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:24.247903+00
3431	202	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:24.247903+00
3432	202	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:24.247903+00
3433	202	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.247903+00
3434	202	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:24.247903+00
3435	202	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3436	202	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.247903+00
3437	202	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:24.247903+00
3438	202	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:24.247903+00
3439	202	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3440	202	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3441	202	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.247903+00
3442	202	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:24.247903+00
3443	203	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.321479+00
3444	203	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.321479+00
3445	203	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3446	203	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.321479+00
3447	203	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3448	203	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3449	203	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.321479+00
3450	203	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:24.321479+00
3451	203	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.321479+00
3452	203	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3453	203	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:24.321479+00
3454	203	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.321479+00
3455	203	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3456	203	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3457	203	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3458	203	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3459	203	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.321479+00
3460	203	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3461	203	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:24.321479+00
3462	204	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3463	204	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3464	204	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:24.391653+00
3465	204	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3466	204	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3467	204	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3468	204	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3469	204	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3470	204	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:24.391653+00
3471	204	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.391653+00
3472	204	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3473	204	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:24.391653+00
3474	204	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.391653+00
3475	204	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3476	204	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3477	204	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3478	204	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3479	204	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3480	204	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3481	204	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.391653+00
3482	205	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.462722+00
3483	205	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:24.462722+00
3484	205	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3485	205	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3486	205	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3487	205	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3488	205	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3489	205	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:24.462722+00
3490	205	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3491	205	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3492	205	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3493	205	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:24.462722+00
3494	205	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:24.462722+00
3495	205	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:24.462722+00
3496	205	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:24.462722+00
3497	206	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.544423+00
3498	206	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3499	206	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3500	206	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.544423+00
3501	206	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3502	206	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3503	206	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.544423+00
3504	206	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3505	206	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.544423+00
3506	206	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	2	2026-10-14 09:11:24.544423+00
3507	206	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:24.544423+00
3508	206	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.544423+00
3509	206	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3510	206	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3511	206	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.544423+00
3512	206	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:24.544423+00
3513	206	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:24.544423+00
3514	206	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.544423+00
3515	207	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3516	207	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3517	207	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3518	207	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3519	207	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3520	207	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3521	207	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3522	207	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3523	207	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3524	207	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3525	207	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3526	207	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3527	207	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3528	207	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3529	207	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3530	207	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3531	207	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3532	207	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:24.626179+00
3533	207	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3534	207	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3535	207	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:24.626179+00
3536	207	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3537	207	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3538	207	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.626179+00
3539	207	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	1	2026-10-14 09:11:24.626179+00
3540	208	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:24.704645+00
3541	208	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:24.704645+00
3542	208	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3543	208	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:24.704645+00
3544	208	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3545	208	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3546	208	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:24.704645+00
3547	208	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3548	208	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:24.704645+00
3549	208	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3550	208	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3551	208	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:24.704645+00
3552	208	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3553	208	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3554	208	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3555	208	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.704645+00
3556	208	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3557	208	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3558	208	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3559	208	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3560	208	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3561	208	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:24.704645+00
3562	209	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.776681+00
3563	209	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3564	209	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:24.776681+00
3565	209	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3566	209	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3567	209	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.776681+00
3568	209	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3569	209	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3570	209	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3571	209	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3572	209	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3573	209	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3574	209	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3575	209	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:24.776681+00
3576	209	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:24.776681+00
3577	209	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.776681+00
3578	209	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3579	209	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3580	209	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.776681+00
3581	209	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.776681+00
3582	209	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:24.776681+00
3583	210	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3584	210	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3585	210	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:24.850162+00
3586	210	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3587	210	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3588	210	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3589	210	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3590	210	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3591	210	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3592	210	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:24.850162+00
3593	210	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3594	210	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3595	210	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3596	210	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3597	210	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3598	210	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3599	210	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3600	210	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3601	210	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:24.850162+00
3602	210	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:24.850162+00
3603	210	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3604	210	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3605	210	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3606	210	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3607	210	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.850162+00
3608	211	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3609	211	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:24.923419+00
3610	211	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3611	211	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3612	211	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3613	211	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3614	211	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:24.923419+00
3615	211	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3616	211	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3617	211	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3618	211	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3619	211	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3620	211	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3621	211	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3622	211	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3623	211	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3624	211	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3625	211	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3626	211	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:24.923419+00
3627	212	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3628	212	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3629	212	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3630	212	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3631	212	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3632	212	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3633	212	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3634	212	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3635	212	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3636	212	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3637	212	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3638	212	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3639	212	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3640	212	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3641	212	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3642	212	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3643	212	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3644	212	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3645	212	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3646	212	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3647	212	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3648	212	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:24.994015+00
3649	213	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3650	213	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:25.065002+00
3651	213	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3652	213	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3653	213	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3654	213	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.065002+00
3655	213	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3656	213	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:25.065002+00
3657	213	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3658	213	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3659	213	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.065002+00
3660	213	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3661	213	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3662	213	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3663	213	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3664	213	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.065002+00
3665	214	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.135418+00
3666	214	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3667	214	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3668	214	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.135418+00
3669	214	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3670	214	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:25.135418+00
3671	214	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:25.135418+00
3672	214	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	2	2026-10-14 09:11:25.135418+00
3673	214	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3674	214	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.135418+00
3675	214	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3676	214	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3677	214	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:25.135418+00
3678	214	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3679	214	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3680	214	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	1	2026-10-14 09:11:25.135418+00
3681	214	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.135418+00
3682	214	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3683	214	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:25.135418+00
3684	215	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3685	215	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3686	215	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3687	215	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3688	215	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3689	215	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3690	215	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3691	215	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3692	215	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3693	215	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3694	215	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3695	215	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3696	215	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3697	215	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3698	215	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3699	215	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3700	215	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.207518+00
3701	215	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3702	215	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3703	215	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3704	215	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3705	215	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:25.207518+00
3706	216	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3707	216	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3708	216	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:25.277684+00
3709	216	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3710	216	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:25.277684+00
3711	216	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3712	216	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:25.277684+00
3713	216	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.277684+00
3714	216	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:25.277684+00
3715	216	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3716	216	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3717	216	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3718	216	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:25.277684+00
3719	216	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3720	216	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:25.277684+00
3721	216	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3722	216	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.277684+00
3723	216	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.277684+00
3724	216	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:25.277684+00
3725	216	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.277684+00
3726	217	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3727	217	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	2	2026-10-14 09:11:25.378343+00
3728	217	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3729	217	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:25.378343+00
3730	217	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.378343+00
3731	217	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3732	217	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:25.378343+00
3733	217	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3734	217	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3735	217	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3736	217	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3737	217	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:25.378343+00
3738	217	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.378343+00
3739	217	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3740	217	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.378343+00
3741	217	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3742	217	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:25.378343+00
3743	218	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:25.453157+00
3744	218	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3745	218	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	1	2026-10-14 09:11:25.453157+00
3746	218	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:25.453157+00
3747	218	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3748	218	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.453157+00
3749	218	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3750	218	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:25.453157+00
3751	218	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3752	218	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3753	218	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3754	218	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:25.453157+00
3755	218	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.453157+00
3756	218	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3757	218	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:25.453157+00
3758	218	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3759	218	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.453157+00
3760	218	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3761	218	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3762	218	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3763	218	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.453157+00
3764	219	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.523699+00
3765	219	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3766	219	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3767	219	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.523699+00
3768	219	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3769	219	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3770	219	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3771	219	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3772	219	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3773	219	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:25.523699+00
3774	219	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:25.523699+00
3775	219	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3776	219	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.523699+00
3777	219	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3778	219	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3779	219	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:25.523699+00
3780	219	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.523699+00
3781	219	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3782	219	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3783	219	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3784	219	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:25.523699+00
3785	219	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3786	219	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3787	219	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:25.523699+00
3788	220	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3789	220	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3790	220	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3791	220	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3792	220	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3793	220	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3794	220	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3795	220	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3796	220	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3797	220	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3798	220	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.596376+00
3799	220	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3800	220	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3801	220	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3802	220	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.596376+00
3803	220	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.596376+00
3804	221	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:25.667149+00
3805	221	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3806	221	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3807	221	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3808	221	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3809	221	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:25.667149+00
3810	221	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.667149+00
3811	221	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3812	221	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.667149+00
3813	221	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.667149+00
3814	221	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3815	221	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:25.667149+00
3816	221	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3817	221	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3818	221	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3819	221	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3820	221	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.667149+00
3821	221	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3822	221	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:25.667149+00
3823	221	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.667149+00
3824	221	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3825	221	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:25.667149+00
3826	222	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3827	222	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3828	222	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3829	222	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3830	222	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3831	222	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3832	222	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3833	222	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3834	222	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.73918+00
3835	222	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3836	222	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3837	222	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3838	222	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3839	222	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3840	222	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:25.73918+00
3841	223	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:25.813681+00
3842	223	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.813681+00
3843	223	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3844	223	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3845	223	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.813681+00
3846	223	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3847	223	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3848	223	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3849	223	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3850	223	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3851	223	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3852	223	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3853	223	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3854	223	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:25.813681+00
3855	223	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3856	223	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3857	223	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3858	223	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3859	223	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.813681+00
3860	223	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3861	223	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:25.813681+00
3862	224	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:25.884881+00
3863	224	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3864	224	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3865	224	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3866	224	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:25.884881+00
3867	224	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3868	224	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3869	224	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3870	224	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:25.884881+00
3871	224	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3872	224	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3873	224	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:25.884881+00
3874	224	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3875	224	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3876	224	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3877	224	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3878	224	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:25.884881+00
3879	224	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:25.884881+00
3880	225	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3881	225	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3882	225	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3883	225	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3884	225	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3885	225	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3886	225	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:25.957196+00
3887	225	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3888	225	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3889	225	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3890	225	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:25.957196+00
3891	225	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:25.957196+00
3892	225	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3893	225	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:25.957196+00
3894	225	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3895	225	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3896	225	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:25.957196+00
3897	226	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:26.027371+00
3898	226	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.027371+00
3899	227	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:26.097892+00
3900	227	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.097892+00
3901	227	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:26.097892+00
3902	227	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:26.097892+00
3903	227	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3904	227	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3905	227	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3906	227	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	2	2026-10-14 09:11:26.097892+00
3907	227	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3908	227	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.097892+00
3909	227	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:26.097892+00
3910	227	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3911	227	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:26.097892+00
3912	227	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3913	227	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.097892+00
3914	227	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3915	227	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3916	227	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3917	227	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:26.097892+00
3918	228	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3919	228	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:26.168982+00
3920	228	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.168982+00
3921	228	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3922	228	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:26.168982+00
3923	228	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3924	228	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3925	228	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3926	228	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	2	2026-10-14 09:11:26.168982+00
3927	228	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:26.168982+00
3928	228	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3929	228	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3930	228	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:26.168982+00
3931	228	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.168982+00
3932	228	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	2	2026-10-14 09:11:26.168982+00
3933	228	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3934	228	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:26.168982+00
3935	228	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:26.168982+00
3936	228	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3937	228	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.168982+00
3938	228	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:26.168982+00
3939	229	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3940	229	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3941	229	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3942	229	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3943	229	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3944	229	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3945	229	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3946	229	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:26.239517+00
3947	229	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.239517+00
3948	229	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3949	229	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3950	229	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3951	229	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3952	229	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3953	229	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3954	229	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3955	229	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3956	229	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:26.239517+00
3957	230	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:26.310253+00
3958	230	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:26.310253+00
3959	230	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3960	230	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:26.310253+00
3961	230	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.310253+00
3962	230	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3963	230	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3964	230	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3965	230	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3966	230	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3967	230	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3968	230	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3969	230	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3970	230	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3971	230	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3972	230	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3973	230	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:26.310253+00
3974	230	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:26.310253+00
3975	230	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.310253+00
3976	230	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:26.310253+00
3977	231	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3978	231	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3979	231	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3980	231	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3981	231	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.382185+00
3982	231	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.382185+00
3983	231	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.382185+00
3984	231	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3985	231	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3986	231	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3987	231	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3988	231	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.382185+00
3989	231	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3990	231	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3991	231	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.382185+00
3992	231	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.382185+00
3993	232	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
3994	232	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
3995	232	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
3996	232	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.453109+00
3997	232	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:26.453109+00
3998	232	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
3999	232	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
4000	232	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
4001	232	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
4002	232	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.453109+00
4003	232	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
4004	232	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:26.453109+00
4005	232	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
4006	232	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
4007	232	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:26.453109+00
4008	233	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:26.523452+00
4009	233	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4010	233	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:26.523452+00
4011	233	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:26.523452+00
4012	233	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4013	233	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4014	233	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.523452+00
4015	233	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:26.523452+00
4016	233	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4017	233	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:26.523452+00
4018	233	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4019	233	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4020	233	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4021	233	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4022	233	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	1	2026-10-14 09:11:26.523452+00
4023	233	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:26.523452+00
4024	233	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4025	233	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.523452+00
4026	233	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:26.523452+00
4027	233	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:26.523452+00
4028	234	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4029	234	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4030	234	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:26.600826+00
4031	234	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.600826+00
4032	234	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:26.600826+00
4033	234	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4034	234	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4035	234	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4036	234	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:26.600826+00
4037	234	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4038	234	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4039	234	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4040	234	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.600826+00
4041	234	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.600826+00
4042	234	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:26.600826+00
4043	234	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.600826+00
4044	235	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:26.682476+00
4045	235	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4046	235	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4047	235	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:26.682476+00
4048	235	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4049	235	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4050	235	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4051	235	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4052	235	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4053	235	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4054	235	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4055	235	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4056	235	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4057	235	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4058	235	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4059	235	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4060	235	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4061	235	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4062	235	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4063	235	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4064	235	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4065	235	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:26.682476+00
4066	236	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:26.753694+00
4067	236	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.753694+00
4068	236	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4069	236	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4070	236	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4071	236	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4072	236	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4073	236	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4074	236	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4075	236	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4076	236	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4077	236	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4078	236	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4079	236	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4080	236	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:26.753694+00
4081	237	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:26.825083+00
4082	237	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.825083+00
4083	237	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.825083+00
4084	237	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.825083+00
4085	237	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:26.825083+00
4086	237	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4087	237	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4088	237	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4089	237	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4090	237	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.825083+00
4091	237	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.825083+00
4092	237	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4093	237	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4094	237	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4095	237	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:26.825083+00
4096	237	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4097	237	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4098	237	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4099	237	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4100	237	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:26.825083+00
4101	237	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	1	2026-10-14 09:11:26.825083+00
4102	237	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4103	237	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	0	2026-10-14 09:11:26.825083+00
4104	238	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4105	238	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:26.895981+00
4106	238	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4107	238	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4108	238	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.895981+00
4109	238	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4110	238	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4111	238	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:26.895981+00
4112	238	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4113	238	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4114	238	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4115	238	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4116	238	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4117	238	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4118	238	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4119	238	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.895981+00
4120	238	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:26.895981+00
4121	238	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4122	238	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4123	238	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4124	238	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4125	238	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	2	2026-10-14 09:11:26.895981+00
4126	238	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:26.895981+00
4127	239	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4128	239	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4129	239	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4130	239	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	1	2026-10-14 09:11:26.97021+00
4131	239	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:26.97021+00
4132	239	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.97021+00
4133	239	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4134	239	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.97021+00
4135	239	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4136	239	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:26.97021+00
4137	239	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4138	239	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:26.97021+00
4139	239	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4140	239	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:26.97021+00
4141	239	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4142	239	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:26.97021+00
4143	239	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4144	239	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:26.97021+00
4145	239	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4146	239	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4147	239	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4148	239	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:26.97021+00
4149	240	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4150	240	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4151	240	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.040516+00
4152	240	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4153	240	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4154	240	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:27.040516+00
4155	240	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4156	240	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4157	240	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:27.040516+00
4158	240	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4159	240	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4160	240	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4161	240	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4162	240	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4163	240	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:27.040516+00
4164	240	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.040516+00
4165	240	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4166	240	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4167	240	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4168	240	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4169	240	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:27.040516+00
4170	240	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4171	240	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4172	240	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4173	240	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.040516+00
4174	241	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4175	241	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4176	241	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4177	241	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4178	241	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4179	241	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4180	241	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:27.113233+00
4181	241	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4182	241	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4183	241	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4184	241	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4185	241	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4186	241	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4187	241	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4188	241	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.113233+00
4189	242	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:27.184674+00
4190	242	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4191	242	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4192	242	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4193	242	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4194	242	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4195	242	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4196	242	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4197	242	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4198	242	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4199	242	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4200	242	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4201	242	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4202	242	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4203	242	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4204	242	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4205	242	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4206	242	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4207	242	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:27.184674+00
4208	242	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4209	242	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4210	242	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:27.184674+00
4211	243	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4212	243	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4213	243	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4214	243	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4215	243	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4216	243	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4217	243	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4218	243	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4219	243	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4220	243	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4221	243	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4222	243	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4223	243	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.257719+00
4224	243	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4225	243	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.257719+00
4226	244	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4227	244	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.329146+00
4228	244	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4229	244	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4230	244	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4231	244	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4232	244	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4233	244	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:27.329146+00
4234	244	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4235	244	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4236	244	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4237	244	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4238	244	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:27.329146+00
4239	244	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4240	244	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4241	244	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:27.329146+00
4242	244	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4243	244	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4244	244	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:27.329146+00
4245	244	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4246	244	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:27.329146+00
4247	244	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:27.329146+00
4248	244	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	2	2026-10-14 09:11:27.329146+00
4249	245	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4250	245	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4251	245	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4252	245	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4253	245	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4254	245	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4255	245	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4256	245	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4257	245	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4258	245	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4259	245	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4260	245	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4261	245	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4262	245	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:27.400343+00
4263	245	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4264	245	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4265	245	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4266	245	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4267	245	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4268	245	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4269	245	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:27.400343+00
4270	245	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4271	245	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:27.400343+00
4272	246	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4273	246	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	2	2026-10-14 09:11:27.472217+00
4274	246	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:27.472217+00
4275	246	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4276	246	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:27.472217+00
4277	246	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4278	246	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:27.472217+00
4279	246	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4280	246	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.472217+00
4281	246	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.472217+00
4282	246	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4283	246	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4284	246	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4285	246	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4286	246	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.472217+00
4287	246	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4288	246	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:27.472217+00
4289	246	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4290	246	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4291	246	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.472217+00
4292	246	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4293	246	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	1	2026-10-14 09:11:27.472217+00
4294	246	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4295	246	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	1	2026-10-14 09:11:27.472217+00
4296	246	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.472217+00
4297	247	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4298	247	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4299	247	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4300	247	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4301	247	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4302	247	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4303	247	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4304	247	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4305	247	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4306	247	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4307	247	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4308	247	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4309	247	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4310	247	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:27.54485+00
4311	247	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:27.54485+00
4312	248	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:27.61643+00
4313	248	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.61643+00
4314	248	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.61643+00
4315	248	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.61643+00
4316	248	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:27.61643+00
4317	248	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.61643+00
4318	248	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.61643+00
4319	248	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:27.61643+00
4320	248	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.61643+00
4321	248	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:27.61643+00
4322	248	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:27.61643+00
4323	248	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.61643+00
4324	248	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:27.61643+00
4325	248	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.61643+00
4326	248	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:27.61643+00
4327	249	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4328	249	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4329	249	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4330	249	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4331	249	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4332	249	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4333	249	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4334	249	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4335	249	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4336	249	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4337	249	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:27.691239+00
4338	249	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4339	249	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4340	249	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4341	249	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4342	249	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:27.691239+00
4343	249	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:27.691239+00
4344	249	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4345	249	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4346	249	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:27.691239+00
4347	250	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4348	250	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4349	250	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4350	250	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4351	250	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4352	250	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4353	250	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4354	250	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4355	250	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4356	250	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4357	250	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:27.761946+00
4358	250	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4359	250	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4360	250	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4361	250	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4362	250	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4363	250	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4364	250	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4365	250	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4366	250	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:27.761946+00
4367	250	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:27.761946+00
4368	251	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:27.835295+00
4369	251	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.835295+00
4370	252	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:27.9052+00
4371	252	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4372	252	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4373	252	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4374	252	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4375	252	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4376	252	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4377	252	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4378	252	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4379	252	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4380	252	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.9052+00
4381	252	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4382	252	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:27.9052+00
4383	252	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.9052+00
4384	252	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4385	252	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4386	252	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4387	252	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4388	252	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4389	252	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:27.9052+00
4390	253	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.977442+00
4391	253	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4392	253	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4393	253	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4394	253	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:27.977442+00
4395	253	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4396	253	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4397	253	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.977442+00
4398	253	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.977442+00
4399	253	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:27.977442+00
4400	253	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:27.977442+00
4401	253	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4402	253	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:27.977442+00
4403	253	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.977442+00
4404	253	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:27.977442+00
4405	253	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:27.977442+00
4406	253	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4407	253	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:27.977442+00
4408	253	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:27.977442+00
4409	254	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4410	254	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4411	254	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4412	254	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4413	254	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4414	254	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4415	254	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4416	254	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4417	254	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4418	254	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.047931+00
4419	254	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4420	254	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4421	254	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4422	254	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:28.047931+00
4423	254	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4424	254	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:28.047931+00
4425	255	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	2	2026-10-14 09:11:28.118541+00
4426	255	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.118541+00
4427	255	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.118541+00
4428	255	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:28.118541+00
4429	255	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:28.118541+00
4430	255	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:28.118541+00
4431	255	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:28.118541+00
4432	255	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:28.118541+00
4433	255	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.118541+00
4434	255	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.118541+00
4435	255	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:28.118541+00
4436	255	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.118541+00
4437	255	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:28.118541+00
4438	255	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:28.118541+00
4439	255	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:28.118541+00
4440	255	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:28.118541+00
4441	255	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.118541+00
4442	255	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.118541+00
4443	255	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.118541+00
4444	255	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.118541+00
4445	255	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.118541+00
4446	256	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.189345+00
4447	256	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:28.189345+00
4448	256	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.189345+00
4449	256	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:28.189345+00
4450	256	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:28.189345+00
4451	256	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.189345+00
4452	256	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:28.189345+00
4453	256	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.189345+00
4454	256	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:28.189345+00
4455	256	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:28.189345+00
4456	256	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:28.189345+00
4457	256	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.189345+00
4458	256	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:28.189345+00
4459	256	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:28.189345+00
4460	256	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:28.189345+00
4461	256	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:28.189345+00
4462	256	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.189345+00
4463	256	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.189345+00
4464	256	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:28.189345+00
4465	257	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4466	257	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4467	257	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4468	257	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4469	257	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4470	257	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4471	257	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4472	257	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4473	257	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4474	257	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4475	257	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4476	257	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4477	257	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4478	257	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4479	257	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:28.274596+00
4480	257	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4481	257	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4482	257	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:28.274596+00
4483	257	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4484	257	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:28.274596+00
4485	258	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4486	258	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:28.345247+00
4487	258	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4488	258	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4489	258	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4490	258	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4491	258	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4492	258	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4493	258	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4494	258	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4495	258	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4496	258	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4497	258	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4498	258	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4499	258	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4500	258	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4501	258	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4502	258	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4503	258	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:28.345247+00
4504	258	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:28.345247+00
4505	258	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4506	258	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4507	258	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:28.345247+00
4508	259	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4509	259	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.418572+00
4510	259	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4511	259	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:28.418572+00
4512	259	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.418572+00
4513	259	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.418572+00
4514	259	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:28.418572+00
4515	259	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.418572+00
4516	259	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4517	259	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4518	259	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4519	259	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4520	259	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4521	259	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4522	259	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4523	259	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.418572+00
4524	259	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.418572+00
4525	259	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:28.418572+00
4526	259	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:28.418572+00
4527	259	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4528	259	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:28.418572+00
4529	260	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4530	260	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4531	260	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4532	260	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:28.51451+00
4533	260	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4534	260	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4535	260	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4536	260	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4537	260	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4538	260	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4539	260	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4540	260	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4541	260	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4542	260	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4543	260	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4544	260	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4545	260	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4546	260	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4547	260	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4548	260	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4549	260	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.51451+00
4550	260	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4551	260	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4552	260	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4553	260	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.51451+00
4554	261	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4555	261	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4556	261	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4557	261	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4558	261	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4559	261	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4560	261	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4561	261	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:28.586726+00
4562	261	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4563	261	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4564	261	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4565	261	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4566	261	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4567	261	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4568	261	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4569	261	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4570	261	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4571	261	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:28.586726+00
4572	261	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.586726+00
4573	262	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4574	262	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:28.65844+00
4575	262	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4576	262	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4577	262	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4578	262	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4579	262	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.65844+00
4580	262	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4581	262	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4582	262	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.65844+00
4583	262	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:28.65844+00
4584	262	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4585	262	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4586	262	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4587	262	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4588	262	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4589	262	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.65844+00
4590	262	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.65844+00
4591	262	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.65844+00
4592	263	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:28.744339+00
4593	263	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:28.744339+00
4594	263	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4595	263	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4596	263	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4597	263	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:28.744339+00
4598	263	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:28.744339+00
4599	263	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:28.744339+00
4600	263	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4601	263	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4602	263	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.744339+00
4603	263	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4604	263	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:28.744339+00
4605	263	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4606	263	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4607	263	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:28.744339+00
4608	263	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4609	263	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.744339+00
4610	263	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4611	263	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4612	263	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	1	2026-10-14 09:11:28.744339+00
4613	263	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.744339+00
4614	263	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	1	2026-10-14 09:11:28.744339+00
4615	263	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.744339+00
4616	264	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4617	264	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4618	264	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4619	264	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:28.819648+00
4620	264	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4621	264	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4622	264	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4623	264	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4624	264	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4625	264	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:28.819648+00
4626	264	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:28.819648+00
4627	264	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:28.819648+00
4628	264	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4629	264	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4630	264	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.819648+00
4631	264	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.819648+00
4632	265	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4633	265	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4634	265	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4635	265	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4636	265	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4637	265	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4638	265	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4639	265	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4640	265	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:28.89383+00
4641	265	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4642	265	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4643	265	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4644	265	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4645	265	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4646	265	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4647	265	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4648	265	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4649	265	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4650	265	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4651	265	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4652	265	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4653	265	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.89383+00
4654	265	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:28.89383+00
4655	266	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4656	266	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4657	266	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:28.982699+00
4658	266	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4659	266	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4660	266	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:28.982699+00
4661	266	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:28.982699+00
4662	266	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4663	266	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4664	266	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.982699+00
4665	266	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4666	266	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:28.982699+00
4667	266	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:28.982699+00
4668	266	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4669	266	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4670	266	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:28.982699+00
4671	266	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4672	266	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4673	266	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4674	266	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4675	266	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4676	266	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:28.982699+00
4677	267	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	1	2026-10-14 09:11:29.053904+00
4678	267	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.053904+00
4679	267	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4680	267	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:29.053904+00
4681	267	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4682	267	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4683	267	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:29.053904+00
4684	267	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4685	267	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4686	267	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4687	267	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:29.053904+00
4688	267	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:29.053904+00
4689	267	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:29.053904+00
4690	267	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:29.053904+00
4691	267	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4692	267	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4693	267	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:29.053904+00
4694	267	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.053904+00
4695	267	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:29.053904+00
4696	267	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:29.053904+00
4697	267	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:29.053904+00
4698	268	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.12517+00
4699	268	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:29.12517+00
4700	268	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4701	268	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.12517+00
4702	268	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:29.12517+00
4703	268	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4704	268	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4705	268	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4706	268	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4707	268	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4708	268	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.12517+00
4709	268	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4710	268	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:29.12517+00
4711	268	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4712	268	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4713	268	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.12517+00
4714	268	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4715	268	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.12517+00
4716	268	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.12517+00
4717	268	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4718	268	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4719	268	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4720	268	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.12517+00
4721	268	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4722	268	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.12517+00
4723	269	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4724	269	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4725	269	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4726	269	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4727	269	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4728	269	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4729	269	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:29.197273+00
4730	269	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4731	269	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:29.197273+00
4732	269	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:29.197273+00
4733	269	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4734	269	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:29.197273+00
4735	269	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4736	269	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.197273+00
4737	269	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.197273+00
4738	269	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:29.197273+00
4739	269	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:29.197273+00
4740	270	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:29.268814+00
4741	270	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4742	270	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:29.268814+00
4743	270	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4744	270	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4745	270	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4746	270	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.268814+00
4747	270	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.268814+00
4748	270	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4749	270	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:29.268814+00
4750	270	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.268814+00
4751	270	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4752	270	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:29.268814+00
4753	270	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4754	270	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4755	270	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:29.268814+00
4756	270	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:29.268814+00
4757	271	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.339729+00
4758	271	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4759	271	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4760	271	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4761	271	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:29.339729+00
4762	271	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4763	271	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4764	271	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:29.339729+00
4765	271	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4766	271	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.339729+00
4767	271	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:29.339729+00
4768	271	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4769	271	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4770	271	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4771	271	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4772	271	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4773	271	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:29.339729+00
4774	271	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4775	271	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4776	271	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4777	271	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:29.339729+00
4778	272	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4779	272	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4780	272	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4781	272	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.409388+00
4782	272	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4783	272	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4784	272	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4785	272	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4786	272	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.409388+00
4787	272	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4788	272	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:29.409388+00
4789	272	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:29.409388+00
4790	272	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4791	272	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.409388+00
4792	272	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.409388+00
4793	272	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:29.409388+00
4794	272	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.409388+00
4795	273	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:29.480567+00
4796	273	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:29.480567+00
4797	273	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4798	273	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4799	273	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4800	273	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4801	273	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4802	273	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.480567+00
4803	273	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:29.480567+00
4804	273	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4805	273	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4806	273	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4807	273	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:29.480567+00
4808	273	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:29.480567+00
4809	273	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4810	273	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.480567+00
4811	273	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4812	273	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:29.480567+00
4813	273	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:29.480567+00
4814	274	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4815	274	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4816	274	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4817	274	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4818	274	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:29.551348+00
4819	274	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4820	274	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:29.551348+00
4821	274	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4822	274	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4823	274	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4824	274	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:29.551348+00
4825	274	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:29.551348+00
4826	274	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4827	274	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:29.551348+00
4828	274	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4829	274	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4830	274	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4831	274	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4832	274	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4833	274	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:29.551348+00
4834	274	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4835	274	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	1	2026-10-14 09:11:29.551348+00
4836	274	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.551348+00
4837	275	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:29.625418+00
4838	275	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4839	275	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4840	275	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4841	275	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4842	275	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4843	275	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4844	275	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4845	275	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4846	275	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4847	275	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4848	275	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4849	275	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4850	275	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4851	275	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:29.625418+00
4852	276	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:29.705326+00
4853	276	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:29.705326+00
4854	277	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:29.776574+00
4855	277	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4856	277	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4857	277	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4858	277	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:29.776574+00
4859	277	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.776574+00
4860	277	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.776574+00
4861	277	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.776574+00
4862	277	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.776574+00
4863	277	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4864	277	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4865	277	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4866	277	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.776574+00
4867	277	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	2	2026-10-14 09:11:29.776574+00
4868	277	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.776574+00
4869	277	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4870	277	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:29.776574+00
4871	277	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:29.776574+00
4872	277	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4873	277	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4874	277	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4875	277	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4876	277	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4877	277	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:29.776574+00
4878	278	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4879	278	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:29.848154+00
4880	278	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4881	278	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4882	278	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:29.848154+00
4883	278	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4884	278	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4885	278	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4886	278	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4887	278	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4888	278	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4889	278	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:29.848154+00
4890	278	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4891	278	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4892	278	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4893	278	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4894	278	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4895	278	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:29.848154+00
4896	278	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4897	278	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4898	278	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:29.848154+00
4899	278	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.848154+00
4900	279	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.9192+00
4901	279	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.9192+00
4902	279	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	2	2026-10-14 09:11:29.9192+00
4903	279	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.9192+00
4904	279	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.9192+00
4905	279	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	1	2026-10-14 09:11:29.9192+00
4906	279	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:29.9192+00
4907	279	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:29.9192+00
4908	279	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.9192+00
4909	279	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:29.9192+00
4910	279	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:29.9192+00
4911	279	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:29.9192+00
4912	279	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.9192+00
4913	279	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:29.9192+00
4914	279	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.9192+00
4915	279	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:29.9192+00
4916	279	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.9192+00
4917	279	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:29.9192+00
4918	279	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:29.9192+00
4919	279	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:29.9192+00
4920	279	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:29.9192+00
4921	280	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4922	280	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4923	280	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4924	280	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4925	280	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4926	280	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4927	280	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:29.993812+00
4928	280	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4929	280	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4930	280	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4931	280	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4932	280	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4933	280	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4934	280	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4935	280	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:29.993812+00
4936	280	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4937	280	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4938	280	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:29.993812+00
4939	280	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:29.993812+00
4940	280	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4941	280	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:29.993812+00
4942	280	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:29.993812+00
4943	281	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4944	281	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	1	2026-10-14 09:11:30.066157+00
4945	281	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4946	281	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4947	281	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4948	281	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4949	281	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4950	281	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:30.066157+00
4951	281	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4952	281	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4953	281	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:30.066157+00
4954	281	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4955	281	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.066157+00
4956	281	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:30.066157+00
4957	281	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	2	2026-10-14 09:11:30.066157+00
4958	282	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4959	282	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.138865+00
4960	282	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.138865+00
4961	282	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:30.138865+00
4962	282	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:30.138865+00
4963	282	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	2	2026-10-14 09:11:30.138865+00
4964	282	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4965	282	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4966	282	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:30.138865+00
4967	282	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4968	282	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4969	282	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4970	282	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:30.138865+00
4971	282	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4972	282	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4973	282	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:30.138865+00
4974	282	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4975	282	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4976	282	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4977	282	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:30.138865+00
4978	282	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:30.138865+00
4979	283	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.212536+00
4980	283	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4981	283	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4982	283	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4983	283	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4984	283	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4985	283	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4986	283	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:30.212536+00
4987	283	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4988	283	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4989	283	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4990	283	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4991	283	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4992	283	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4993	283	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4994	283	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4995	283	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4996	283	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4997	283	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4998	283	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:30.212536+00
4999	284	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5000	284	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:30.284506+00
5001	284	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5002	284	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5003	284	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:30.284506+00
5004	284	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5005	284	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5006	284	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5007	284	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5008	284	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5009	284	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5010	284	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:30.284506+00
5011	284	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5012	284	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5013	284	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5014	284	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5015	284	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5016	284	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5017	284	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	1	2026-10-14 09:11:30.284506+00
5018	284	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5019	284	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5020	284	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.284506+00
5021	284	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5022	284	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5023	284	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.284506+00
5024	285	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	1	2026-10-14 09:11:30.358278+00
5025	285	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5026	285	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5027	285	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5028	285	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.358278+00
5029	285	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.358278+00
5030	285	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5031	285	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:30.358278+00
5032	285	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:30.358278+00
5033	285	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:30.358278+00
5034	285	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5035	285	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5036	285	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5037	285	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5038	285	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:30.358278+00
5039	285	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5040	285	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5041	285	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5042	285	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5043	285	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	1	2026-10-14 09:11:30.358278+00
5044	285	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.358278+00
5045	285	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:30.358278+00
5046	286	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5047	286	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.451452+00
5048	286	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.451452+00
5049	286	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5050	286	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5051	286	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.451452+00
5052	286	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5053	286	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5054	286	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	2	2026-10-14 09:11:30.451452+00
5055	286	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.451452+00
5056	286	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5057	286	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5058	286	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5059	286	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5060	286	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.451452+00
5061	287	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5062	287	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5063	287	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5064	287	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5065	287	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5066	287	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5067	287	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5068	287	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5069	287	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5070	287	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5071	287	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5072	287	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5073	287	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5074	287	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5075	287	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:30.531626+00
5076	287	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5077	287	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5078	287	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:30.531626+00
5079	287	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:30.531626+00
5080	287	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5081	287	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:30.531626+00
5082	288	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.603334+00
5083	288	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5084	288	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:30.603334+00
5085	288	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5086	288	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:30.603334+00
5087	288	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:30.603334+00
5088	288	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5089	288	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5090	288	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5091	288	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.603334+00
5092	288	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5093	288	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5094	288	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5095	288	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:30.603334+00
5096	288	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5097	288	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:30.603334+00
5098	288	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:30.603334+00
5099	289	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5100	289	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5101	289	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5102	289	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5103	289	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5104	289	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5105	289	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5106	289	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:30.674307+00
5107	289	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5108	289	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5109	289	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5110	289	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5111	289	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5112	289	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5113	289	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5114	289	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:30.674307+00
5115	290	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5116	290	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.745935+00
5117	290	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5118	290	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5119	290	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	1	2026-10-14 09:11:30.745935+00
5120	290	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:30.745935+00
5121	290	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:30.745935+00
5122	290	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:30.745935+00
5123	290	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:30.745935+00
5124	290	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5125	290	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5126	290	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.745935+00
5127	290	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5128	290	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5129	290	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5130	290	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5131	290	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:30.745935+00
5132	290	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.745935+00
5133	290	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5134	290	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	1	2026-10-14 09:11:30.745935+00
5135	290	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.745935+00
5136	290	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	2	2026-10-14 09:11:30.745935+00
5137	290	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	1	2026-10-14 09:11:30.745935+00
5138	290	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.745935+00
5139	291	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5140	291	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5141	291	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5142	291	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5143	291	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5144	291	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:30.830859+00
5145	291	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5146	291	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5147	291	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5148	291	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5149	291	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5150	291	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5151	291	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5152	291	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5153	291	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.830859+00
5154	292	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.909478+00
5155	292	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:30.909478+00
5156	292	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:30.909478+00
5157	292	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	2	2026-10-14 09:11:30.909478+00
5158	292	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:30.909478+00
5159	292	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:30.909478+00
5160	292	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.909478+00
5161	292	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:30.909478+00
5162	292	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:30.909478+00
5163	292	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:30.909478+00
5164	292	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:30.909478+00
5165	292	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.909478+00
5166	292	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:30.909478+00
5167	292	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.909478+00
5168	292	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:30.909478+00
5169	292	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:30.909478+00
5170	292	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:30.909478+00
5171	292	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	1	2026-10-14 09:11:30.909478+00
5172	292	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:30.909478+00
5173	293	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:30.985964+00
5174	293	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:30.985964+00
5175	293	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	2	2026-10-14 09:11:30.985964+00
5176	293	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:30.985964+00
5177	293	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.985964+00
5178	293	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.985964+00
5179	293	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.985964+00
5180	293	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:30.985964+00
5181	293	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:30.985964+00
5182	293	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	2	2026-10-14 09:11:30.985964+00
5183	293	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:30.985964+00
5184	293	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:30.985964+00
5185	293	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:30.985964+00
5186	293	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:30.985964+00
5187	293	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:30.985964+00
5188	294	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:31.057059+00
5189	294	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.057059+00
5190	294	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:31.057059+00
5191	294	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.057059+00
5192	294	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	2	2026-10-14 09:11:31.057059+00
5193	294	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.057059+00
5194	294	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.057059+00
5195	294	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:31.057059+00
5196	294	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:31.057059+00
5197	294	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.057059+00
5198	294	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.057059+00
5199	294	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:31.057059+00
5200	294	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	1	2026-10-14 09:11:31.057059+00
5201	294	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:31.057059+00
5202	294	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	2	2026-10-14 09:11:31.057059+00
5203	295	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5204	295	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5205	295	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5206	295	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5207	295	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.129103+00
5208	295	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:31.129103+00
5209	295	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.129103+00
5210	295	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.129103+00
5211	295	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5212	295	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:31.129103+00
5213	295	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5214	295	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5215	295	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5216	295	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5217	295	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5218	295	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5219	295	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:31.129103+00
5220	295	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5221	295	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:31.129103+00
5222	295	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5223	295	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:31.129103+00
5224	296	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:31.199826+00
5225	296	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5226	296	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5227	296	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5228	296	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5229	296	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5230	296	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5231	296	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.199826+00
5232	296	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.199826+00
5233	296	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:31.199826+00
5234	296	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5235	296	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5236	296	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5237	296	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.199826+00
5238	296	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.199826+00
5239	296	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5240	296	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:31.199826+00
5241	296	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:31.199826+00
5242	296	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.199826+00
5243	297	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5244	297	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:31.271147+00
5245	297	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5246	297	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5247	297	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.271147+00
5248	297	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.271147+00
5249	297	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5250	297	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5251	297	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5252	297	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5253	297	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5254	297	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5255	297	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5256	297	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5257	297	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5258	297	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5259	297	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5260	297	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5261	297	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:31.271147+00
5262	297	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5263	297	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5264	297	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5265	297	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5266	297	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:31.271147+00
5267	297	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.271147+00
5268	298	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5269	298	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5270	298	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.341889+00
5271	298	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5272	298	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5273	298	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5274	298	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:31.341889+00
5275	298	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5276	298	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5277	298	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5278	298	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:31.341889+00
5279	298	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	2	2026-10-14 09:11:31.341889+00
5280	298	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5281	298	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5282	298	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.341889+00
5283	298	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5284	298	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:31.341889+00
5285	298	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5286	298	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5287	298	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5288	298	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	2	2026-10-14 09:11:31.341889+00
5289	298	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.341889+00
5290	299	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5291	299	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.412925+00
5292	299	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:31.412925+00
5293	299	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	1	2026-10-14 09:11:31.412925+00
5294	299	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5295	299	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5296	299	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5297	299	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:31.412925+00
5298	299	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5299	299	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5300	299	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:31.412925+00
5301	299	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:31.412925+00
5302	299	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5303	299	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5304	299	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:31.412925+00
5305	299	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5306	299	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5307	299	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5308	299	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:31.412925+00
5309	299	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5310	299	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5311	299	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:31.412925+00
5312	300	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:31.485406+00
5313	300	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.485406+00
5314	300	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:31.485406+00
5315	300	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.485406+00
5316	300	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.485406+00
5317	300	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:31.485406+00
5318	300	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.485406+00
5319	300	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	2	2026-10-14 09:11:31.485406+00
5320	300	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.485406+00
5321	300	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	2	2026-10-14 09:11:31.485406+00
5322	300	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:31.485406+00
5323	300	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:31.485406+00
5324	300	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:31.485406+00
5325	300	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.485406+00
5326	300	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:31.485406+00
5327	301	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	1	2026-10-14 09:11:31.558529+00
5328	301	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.558529+00
5329	302	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:31.632067+00
5330	302	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.632067+00
5331	302	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5332	302	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5333	302	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5334	302	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:31.632067+00
5335	302	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5336	302	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5337	302	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5338	302	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5339	302	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:31.632067+00
5340	302	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5341	302	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5342	302	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5343	302	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5344	302	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:31.632067+00
5345	303	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:31.704806+00
5346	303	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	1	2026-10-14 09:11:31.704806+00
5347	303	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:31.704806+00
5348	303	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.704806+00
5349	303	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:31.704806+00
5350	303	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.704806+00
5351	303	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.704806+00
5352	303	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5353	303	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5354	303	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:31.704806+00
5355	303	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.704806+00
5356	303	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5357	303	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:31.704806+00
5358	303	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5359	303	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5360	303	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5361	303	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5362	303	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5363	303	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.704806+00
5364	303	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5365	303	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:31.704806+00
5366	304	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.779206+00
5367	304	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.779206+00
5368	304	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	1	2026-10-14 09:11:31.779206+00
5369	304	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5370	304	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5371	304	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.779206+00
5372	304	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5373	304	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	2	2026-10-14 09:11:31.779206+00
5374	304	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5375	304	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5376	304	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.779206+00
5377	304	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:31.779206+00
5378	304	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5379	304	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	2	2026-10-14 09:11:31.779206+00
5380	304	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5381	304	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:31.779206+00
5382	304	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.779206+00
5383	304	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.779206+00
5384	304	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.779206+00
5385	305	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:31.850387+00
5386	305	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5387	305	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.850387+00
5388	305	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.850387+00
5389	305	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5390	305	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5391	305	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5392	305	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5393	305	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.850387+00
5394	305	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5395	305	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5396	305	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5397	305	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5398	305	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5399	305	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:31.850387+00
5400	305	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.850387+00
5401	305	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.850387+00
5402	305	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	0	2026-10-14 09:11:31.850387+00
5403	305	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:31.850387+00
5404	306	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:31.92303+00
5405	306	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.92303+00
5406	306	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	1	2026-10-14 09:11:31.92303+00
5407	306	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.92303+00
5408	306	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:31.92303+00
5409	306	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:31.92303+00
5410	306	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.92303+00
5411	306	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:31.92303+00
5412	306	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:31.92303+00
5413	306	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:31.92303+00
5414	306	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:31.92303+00
5415	306	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:31.92303+00
5416	306	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:31.92303+00
5417	306	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	1	2026-10-14 09:11:31.92303+00
5418	306	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:31.92303+00
5419	307	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5420	307	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5421	307	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5422	307	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5423	307	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5424	307	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5425	307	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5426	307	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5427	307	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5428	307	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5429	307	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5430	307	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5431	307	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5432	307	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5433	307	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5434	307	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5435	307	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5436	307	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5437	307	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5438	307	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5439	307	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5440	307	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	2	2026-10-14 09:11:31.99719+00
5441	307	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5442	307	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5443	307	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-10 03:00:00+00	done	t	0	2026-10-14 09:11:31.99719+00
5444	308	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5445	308	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5446	308	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5447	308	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5448	308	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5449	308	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5450	308	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5451	308	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5452	308	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5453	308	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5454	308	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:32.067823+00
5455	308	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	1	2026-10-14 09:11:32.067823+00
5456	308	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:32.067823+00
5457	308	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5458	308	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5459	308	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5460	308	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:32.067823+00
5461	309	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5462	309	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5463	309	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:32.138369+00
5464	309	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5465	309	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:32.138369+00
5466	309	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5467	309	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5468	309	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:32.138369+00
5469	309	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5470	309	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.138369+00
5471	309	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5472	309	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5473	309	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	1	2026-10-14 09:11:32.138369+00
5474	309	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:32.138369+00
5475	309	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:32.138369+00
5476	310	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:32.20872+00
5477	310	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.20872+00
5478	310	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	2	2026-10-14 09:11:32.20872+00
5479	310	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.20872+00
5480	310	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.20872+00
5481	310	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.20872+00
5482	310	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:32.20872+00
5483	310	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:32.20872+00
5484	310	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.20872+00
5485	310	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:32.20872+00
5486	310	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	1	2026-10-14 09:11:32.20872+00
5487	310	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	2	2026-10-14 09:11:32.20872+00
5488	310	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	2	2026-10-14 09:11:32.20872+00
5489	310	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.20872+00
5490	310	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	1	2026-10-14 09:11:32.20872+00
5491	310	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.20872+00
5492	310	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:32.20872+00
5493	310	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:32.20872+00
5494	311	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.27919+00
5495	311	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5496	311	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5497	311	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5498	311	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5499	311	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5500	311	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5501	311	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5502	311	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5503	311	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	1	2026-10-14 09:11:32.27919+00
5504	311	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5505	311	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:32.27919+00
5506	311	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.27919+00
5507	311	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:32.27919+00
5508	311	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	2	2026-10-14 09:11:32.27919+00
5509	311	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.27919+00
5510	312	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.349908+00
5511	312	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	2	2026-10-14 09:11:32.349908+00
5512	312	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5513	312	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5514	312	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5515	312	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.349908+00
5516	312	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5517	312	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.349908+00
5518	312	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.349908+00
5519	312	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	2	2026-10-14 09:11:32.349908+00
5520	312	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5521	312	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5522	312	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5523	312	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5524	312	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:32.349908+00
5525	312	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	2	2026-10-14 09:11:32.349908+00
5526	312	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	1	2026-10-14 09:11:32.349908+00
5527	312	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-14 03:00:00+00	done	t	1	2026-10-14 09:11:32.349908+00
5528	312	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:32.349908+00
5529	313	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.423372+00
5530	313	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.423372+00
5531	313	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:32.423372+00
5532	313	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	2	2026-10-14 09:11:32.423372+00
5533	313	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.423372+00
5534	313	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.423372+00
5535	313	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:32.423372+00
5536	313	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:32.423372+00
5537	313	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:32.423372+00
5538	313	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:32.423372+00
5539	313	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:32.423372+00
5540	313	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.423372+00
5541	313	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.423372+00
5542	313	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.423372+00
5543	313	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	1	2026-10-14 09:11:32.423372+00
5544	313	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-06 03:00:00+00	done	t	1	2026-10-14 09:11:32.423372+00
5545	313	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.423372+00
5546	313	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.423372+00
5547	313	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	1	2026-10-14 09:11:32.423372+00
5548	314	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5549	314	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5550	314	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:32.496004+00
5551	314	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5552	314	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5553	314	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5554	314	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5555	314	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5556	314	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5557	314	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:32.496004+00
5558	314	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5559	314	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5560	314	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5561	314	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5562	314	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5563	314	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5564	314	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:32.496004+00
5565	314	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	2	2026-10-14 09:11:32.496004+00
5566	314	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	2	2026-10-14 09:11:32.496004+00
5567	315	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5568	315	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5569	315	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	2	2026-10-14 09:11:32.569597+00
5570	315	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:32.569597+00
5571	315	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.569597+00
5572	315	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5573	315	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	1	2026-10-14 09:11:32.569597+00
5574	315	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5575	315	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-09 03:00:00+00	done	t	1	2026-10-14 09:11:32.569597+00
5576	315	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.569597+00
5577	315	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5578	315	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	1	2026-10-14 09:11:32.569597+00
5579	315	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5580	315	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	2	2026-10-14 09:11:32.569597+00
5581	315	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5582	315	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5583	315	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:32.569597+00
5584	315	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:32.569597+00
5585	315	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5586	315	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:32.569597+00
5587	316	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	1	2026-10-14 09:11:32.641379+00
5588	316	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5589	316	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:32.641379+00
5590	316	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5591	316	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.641379+00
5592	316	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.641379+00
5593	316	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.641379+00
5594	316	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.641379+00
5595	316	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:32.641379+00
5596	316	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5597	316	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	2	2026-10-14 09:11:32.641379+00
5598	316	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5599	316	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5600	316	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	1	2026-10-14 09:11:32.641379+00
5601	316	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.641379+00
5602	316	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5603	316	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5604	316	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5605	316	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:32.641379+00
5606	317	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:32.71277+00
5607	317	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.71277+00
5608	317	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5609	317	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	2	2026-10-14 09:11:32.71277+00
5610	317	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5611	317	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	1	2026-10-14 09:11:32.71277+00
5612	317	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5613	317	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5614	317	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:32.71277+00
5615	317	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5616	317	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	2	2026-10-14 09:11:32.71277+00
5617	317	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:32.71277+00
5618	317	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5619	317	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.71277+00
5620	317	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:32.71277+00
5621	317	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.71277+00
5622	317	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5623	317	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.71277+00
5624	318	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5625	318	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.783763+00
5626	318	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5627	318	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5628	318	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5629	318	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5630	318	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5631	318	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	1	2026-10-14 09:11:32.783763+00
5632	318	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	1	2026-10-14 09:11:32.783763+00
5633	318	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5634	318	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5635	318	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.783763+00
5636	318	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5637	318	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5638	318	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5639	318	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5640	318	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5641	318	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5642	318	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	1	2026-10-14 09:11:32.783763+00
5643	318	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5644	318	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5645	318	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5646	318	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5647	318	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	2	2026-10-14 09:11:32.783763+00
5648	318	งานที่ 25 (ข้อมูลจำลอง)	2026-10-09 17:00:00+00	2026-10-12 03:00:00+00	done	t	0	2026-10-14 09:11:32.783763+00
5649	319	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5650	319	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5651	319	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5652	319	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5653	319	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5654	319	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5655	319	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5656	319	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5657	319	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5658	319	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5659	319	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5660	319	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5661	319	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5662	319	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5663	319	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5664	319	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5665	319	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5666	319	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5667	319	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5668	319	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5669	319	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5670	319	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5671	319	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	0	2026-10-14 09:11:32.857397+00
5672	320	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5673	320	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5674	320	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5675	320	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5676	320	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	1	2026-10-14 09:11:32.99739+00
5677	320	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5678	320	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:32.99739+00
5679	320	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5680	320	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5681	320	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	1	2026-10-14 09:11:32.99739+00
5682	320	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	1	2026-10-14 09:11:32.99739+00
5683	320	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5684	320	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5685	320	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.99739+00
5686	320	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:32.99739+00
5687	320	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	1	2026-10-14 09:11:32.99739+00
5688	320	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5689	320	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5690	320	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:32.99739+00
5691	321	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5692	321	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5693	321	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-16 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5694	321	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5695	321	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.105091+00
5696	321	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:33.105091+00
5697	321	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.105091+00
5698	321	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5699	321	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5700	321	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5701	321	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5702	321	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5703	321	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5704	321	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-29 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5705	321	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:33.105091+00
5706	321	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5707	321	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	2	2026-10-14 09:11:33.105091+00
5708	321	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5709	321	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-18 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5710	321	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:33.105091+00
5711	322	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5712	322	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5713	322	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5714	322	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5715	322	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5716	322	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5717	322	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5718	322	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-05 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5719	322	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5720	322	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5721	322	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5722	322	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5723	322	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5724	322	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5725	322	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	2	2026-10-14 09:11:33.17942+00
5726	322	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5727	322	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5728	322	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	1	2026-10-14 09:11:33.17942+00
5729	322	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.17942+00
5730	322	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	2	2026-10-14 09:11:33.17942+00
5731	322	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5732	322	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5733	322	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-02 03:00:00+00	done	t	1	2026-10-14 09:11:33.17942+00
5734	322	งานที่ 24 (ข้อมูลจำลอง)	2026-10-05 17:00:00+00	2026-10-06 03:00:00+00	done	t	0	2026-10-14 09:11:33.17942+00
5735	323	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	2	2026-10-14 09:11:33.250073+00
5736	323	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5737	323	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	1	2026-10-14 09:11:33.250073+00
5738	323	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5739	323	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-24 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5740	323	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	2	2026-10-14 09:11:33.250073+00
5741	323	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-07-30 03:00:00+00	done	t	2	2026-10-14 09:11:33.250073+00
5742	323	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5743	323	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.250073+00
5744	323	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5745	323	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-17 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5746	323	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-19 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5747	323	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.250073+00
5748	323	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5749	323	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5750	323	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5751	323	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5752	323	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5753	323	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:33.250073+00
5754	324	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5755	324	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5756	324	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5757	324	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-18 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5758	324	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:33.333939+00
5759	324	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-28 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5760	324	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.333939+00
5761	324	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.333939+00
5762	324	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	2	2026-10-14 09:11:33.333939+00
5763	324	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-13 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5764	324	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5765	324	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	2026-08-21 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5766	324	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-23 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5767	324	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	2026-08-27 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5768	324	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-08-31 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5769	324	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5770	324	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	1	2026-10-14 09:11:33.333939+00
5771	324	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.333939+00
5772	324	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	2026-09-16 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5773	324	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-22 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5774	324	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-26 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5775	324	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	0	2026-10-14 09:11:33.333939+00
5776	324	งานที่ 23 (ข้อมูลจำลอง)	2026-10-01 17:00:00+00	2026-10-04 03:00:00+00	done	t	1	2026-10-14 09:11:33.333939+00
5777	325	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-06 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5778	325	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-12 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5779	325	งานที่ 3 (ข้อมูลจำลอง)	2026-07-13 17:00:00+00	2026-07-14 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5780	325	งานที่ 4 (ข้อมูลจำลอง)	2026-07-17 17:00:00+00	2026-07-20 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5781	325	งานที่ 5 (ข้อมูลจำลอง)	2026-07-21 17:00:00+00	2026-07-22 03:00:00+00	done	t	2	2026-10-14 09:11:33.405129+00
5782	325	งานที่ 6 (ข้อมูลจำลอง)	2026-07-25 17:00:00+00	2026-07-26 03:00:00+00	done	t	1	2026-10-14 09:11:33.405129+00
5783	325	งานที่ 7 (ข้อมูลจำลอง)	2026-07-29 17:00:00+00	2026-08-01 03:00:00+00	done	t	2	2026-10-14 09:11:33.405129+00
5784	325	งานที่ 8 (ข้อมูลจำลอง)	2026-08-02 17:00:00+00	2026-08-03 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5785	325	งานที่ 9 (ข้อมูลจำลอง)	2026-08-06 17:00:00+00	2026-08-07 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5786	325	งานที่ 10 (ข้อมูลจำลอง)	2026-08-10 17:00:00+00	2026-08-11 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5787	325	งานที่ 11 (ข้อมูลจำลอง)	2026-08-14 17:00:00+00	2026-08-15 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5788	325	งานที่ 12 (ข้อมูลจำลอง)	2026-08-18 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.405129+00
5789	325	งานที่ 13 (ข้อมูลจำลอง)	2026-08-22 17:00:00+00	2026-08-25 03:00:00+00	done	t	2	2026-10-14 09:11:33.405129+00
5790	325	งานที่ 14 (ข้อมูลจำลอง)	2026-08-26 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.405129+00
5791	325	งานที่ 15 (ข้อมูลจำลอง)	2026-08-30 17:00:00+00	2026-09-02 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5792	325	งานที่ 16 (ข้อมูลจำลอง)	2026-09-03 17:00:00+00	2026-09-04 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5793	325	งานที่ 17 (ข้อมูลจำลอง)	2026-09-07 17:00:00+00	2026-09-08 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5794	325	งานที่ 18 (ข้อมูลจำลอง)	2026-09-11 17:00:00+00	2026-09-12 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5795	325	งานที่ 19 (ข้อมูลจำลอง)	2026-09-15 17:00:00+00	\N	todo	f	0	2026-10-14 09:11:33.405129+00
5796	325	งานที่ 20 (ข้อมูลจำลอง)	2026-09-19 17:00:00+00	2026-09-20 03:00:00+00	done	t	0	2026-10-14 09:11:33.405129+00
5797	325	งานที่ 21 (ข้อมูลจำลอง)	2026-09-23 17:00:00+00	2026-09-24 03:00:00+00	done	t	1	2026-10-14 09:11:33.405129+00
5798	325	งานที่ 22 (ข้อมูลจำลอง)	2026-09-27 17:00:00+00	2026-09-28 03:00:00+00	done	t	2	2026-10-14 09:11:33.405129+00
5799	326	งานที่ 1 (ข้อมูลจำลอง)	2026-07-05 17:00:00+00	2026-07-08 03:00:00+00	done	t	0	2026-10-14 09:11:33.479211+00
5800	326	งานที่ 2 (ข้อมูลจำลอง)	2026-07-09 17:00:00+00	2026-07-10 03:00:00+00	done	t	0	2026-10-14 09:11:33.479211+00
\.


--
-- Data for Name: training_plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.training_plans (id, evaluation_id, employee_id, topic, reason, start_date, end_date, status, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: transfer_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transfer_requests (id, evaluation_id, cycle_id, employee_id, from_department, to_department, effective_date, status, note, decision_note, created_by, decided_by, decided_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, employee_code, name, email, password_hash, role, department, "position", manager_id, is_active, created_at, updated_at, level) FROM stdin;
1	HR001	สมหญิง ใจดี	hr@example.com	$2a$10$rH.Cg0jZyAUSU/TI77roU.L/ORIeuZwV5ISMjpe9dvHk6m5.kydI6	hr	ทรัพยากรบุคคล	HR Manager	\N	t	2026-10-14 01:52:14.459282+00	2026-10-14 01:52:14.459282+00	
2	EX001	วิชัย มั่นคง	executive@example.com	$2a$10$9BpUEokzo9P.ws9tYQuI7u4YDO1N4jQ6.J4wTOV/MJ.J1t0Ow0lcW	executive	บริหาร	ผู้อำนวยการ	\N	t	2026-10-14 01:52:14.529212+00	2026-10-14 01:52:14.529212+00	
3	AC001	นภา บัญชีดี	accounting@example.com	$2a$10$d85RkRHgeskfxD9wBxYOVupj2vqFRV7eQq4Nqv9I/M3IfSHY2TBMq	accounting	บัญชี	นักบัญชีอาวุโส	\N	t	2026-10-14 01:52:14.597581+00	2026-10-14 01:52:14.597581+00	
4	MG001	สมชาย หัวหน้า	manager1@example.com	$2a$10$9vjcs6Vbf5PWGddwBYDpCOhikgoYfn/dFHnIQExvBKioIQPG.BXri	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 01:52:14.667048+00	2026-10-14 01:52:14.667048+00	
5	MG002	ปราณี นำทีม	manager2@example.com	$2a$10$5gMq6qSCo0ClejaQAnOO2epOuMeXitQ4OVREDBiNKPBaERX213y/C	manager	การตลาด	Marketing Manager	\N	t	2026-10-14 01:52:14.743122+00	2026-10-14 01:52:14.743122+00	
6	EM001	อนุชา ขยันงาน	employee1@example.com	$2a$10$ta6KWW0o0A03H05SAms1WeNBzgr1F9JAUQMnOSbXC..Co7oKODVx2	employee	พัฒนาซอฟต์แวร์	Software Engineer	4	t	2026-10-14 01:52:14.821032+00	2026-10-14 01:52:14.821032+00	senior
7	EM002	กัญญา เรียนรู้	employee2@example.com	$2a$10$WhojsbSnP.2l0LZz4RdZguJyq.dRZyrkZcHV67wy0tOlRC84js1KW	employee	พัฒนาซอฟต์แวร์	Software Engineer	4	t	2026-10-14 01:52:14.898063+00	2026-10-14 01:52:14.898063+00	junior
8	EM003	ธนา ตั้งใจ	employee3@example.com	$2a$10$iXGAqjaawZRS8kvl7P6OyuQ9yAFswvBTveVjwjb/lj57XntujfF0C	employee	พัฒนาซอฟต์แวร์	QA Engineer	4	t	2026-10-14 01:52:14.967634+00	2026-10-14 01:52:14.967634+00	junior
9	EM004	พิมพ์ใจ สร้างสรรค์	employee4@example.com	$2a$10$SHHT2Vb2nc0FS3OnxZkOdO77GIYC6sBct8nuj/P6arkZMdikEzDKS	employee	การตลาด	Content Marketer	5	t	2026-10-14 01:52:15.035888+00	2026-10-14 01:52:15.035888+00	senior
10	EM005	ศิริพร ประสานงาน	employee5@example.com	$2a$10$Cro8nq92rldwzy0Mf4Mj5.2PPY1MMy.OSF.ScqJUeOeGKi1GWmizy	employee	การตลาด	Marketing Executive	5	t	2026-10-14 01:52:15.109482+00	2026-10-14 01:52:15.109482+00	junior
11	EM006	ณัฐพล พัฒนา	employee6@example.com	$2a$10$BDNi8lTJCXFRG1PfBVIRlODGhesJPd8feaBr7B8WagJBRcyl0ulBe	employee	การตลาด	Graphic Designer	5	t	2026-10-14 01:52:15.181012+00	2026-10-14 01:52:15.181012+00	junior
12	BM01	หัวหน้าทดสอบ 01	bulk.mgr01@example.com	$2a$10$18dwRsEBPG2MR4hfgErbCeaSnfNAvxqvRZlen/xcb90D2BApeAuKy	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:09.76908+00	2026-10-14 09:11:09.76908+00	
13	BM02	หัวหน้าทดสอบ 02	bulk.mgr02@example.com	$2a$10$I9ep.PdM8ftEfuo8.skbkuxL3QIqyXrLDNrxxipMZOkMFJulQH1cq	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:09.88367+00	2026-10-14 09:11:09.88367+00	
14	BM03	หัวหน้าทดสอบ 03	bulk.mgr03@example.com	$2a$10$x.qzSeQndVV9wg0CLRt7k.wCEffgGhHSitRdpLZlxqTXrJBT2IXI6	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:09.952392+00	2026-10-14 09:11:09.952392+00	
15	BM04	หัวหน้าทดสอบ 04	bulk.mgr04@example.com	$2a$10$nuzsXXMLlO.doWCFlVcKAuwoGWIWy20Tf565dKfNIuxppeKf.cvk6	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.020851+00	2026-10-14 09:11:10.020851+00	
16	BM05	หัวหน้าทดสอบ 05	bulk.mgr05@example.com	$2a$10$Ot18s7vpycjwf4qE14m9re6SDqnGXDODgryvluuY5HkU2yrakqrcm	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.098265+00	2026-10-14 09:11:10.098265+00	
17	BM06	หัวหน้าทดสอบ 06	bulk.mgr06@example.com	$2a$10$ipx43rgIDwbF8To1MpBJ6em/4PadU9uZjKyjMAfvxSNpmAVSx4cBe	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.174945+00	2026-10-14 09:11:10.174945+00	
18	BM07	หัวหน้าทดสอบ 07	bulk.mgr07@example.com	$2a$10$Z4cd9Kh5GdHP8He1m3IT6OJRR7/AkeWY76wrWU7gsUoSOuth3epB6	manager	การตลาด	Marketing Manager	\N	t	2026-10-14 09:11:10.243769+00	2026-10-14 09:11:10.243769+00	
19	BM08	หัวหน้าทดสอบ 08	bulk.mgr08@example.com	$2a$10$Ww/RcQFL4YZ4Go8qYTwsRuWQC7vMmwtCX/aJD1rVUUxIQKeD5GnRm	manager	การตลาด	Marketing Manager	\N	t	2026-10-14 09:11:10.312293+00	2026-10-14 09:11:10.312293+00	
20	BM09	หัวหน้าทดสอบ 09	bulk.mgr09@example.com	$2a$10$rvYOZ6gWBcteHFjgOP9aguZcQsSgeblb62NUjo1uiVzxpJ1wjbBfS	manager	การตลาด	Marketing Manager	\N	t	2026-10-14 09:11:10.380494+00	2026-10-14 09:11:10.380494+00	
21	BM10	หัวหน้าทดสอบ 10	bulk.mgr10@example.com	$2a$10$u3LmsRjzvaWf469dW0FOc.aMvlr5UPSETevhJam.TWumAoh7XhdNa	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.448886+00	2026-10-14 09:11:10.448886+00	
22	BM11	หัวหน้าทดสอบ 11	bulk.mgr11@example.com	$2a$10$y84kJXXRJit/K05YwTpch.YxgLY/BOwk/NvKjR.dn0DnHgJKZ2YXe	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.519443+00	2026-10-14 09:11:10.519443+00	
23	BM12	หัวหน้าทดสอบ 12	bulk.mgr12@example.com	$2a$10$rDU7Fz9xV666SqmMXX07IuaYPh8zQQa0KCbvPOGUUZT.Q4BFqhAWK	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.58844+00	2026-10-14 09:11:10.58844+00	
24	BM13	หัวหน้าทดสอบ 13	bulk.mgr13@example.com	$2a$10$2YS.DkOY.TpMN/aMVAaTJey28zjrwan4osAKnks.VJvHc.F3UvzBe	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.657864+00	2026-10-14 09:11:10.657864+00	
25	BM14	หัวหน้าทดสอบ 14	bulk.mgr14@example.com	$2a$10$ASp7aOpm1zGQ0YkckbHmLOgTbf0wA4OcfcGno4086X7g5OFu/JJiu	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.731743+00	2026-10-14 09:11:10.731743+00	
26	BM15	หัวหน้าทดสอบ 15	bulk.mgr15@example.com	$2a$10$DzuEr/9cfyDpr8dXovgtvOLQ1eLOHe9hMGL07qZI18gDaqIuujTVS	manager	พัฒนาซอฟต์แวร์	Engineering Manager	\N	t	2026-10-14 09:11:10.799743+00	2026-10-14 09:11:10.799743+00	
27	BE0001	พนักงานทดสอบ 0001	bulk.emp0001@example.com	$2a$10$rwHfwBii4P9RqQl7LVPlGe3XNCF3EoT33PHOeChG5F1v7xhYBU0Si	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:10.868343+00	2026-10-14 09:11:10.868343+00	junior
28	BE0002	พนักงานทดสอบ 0002	bulk.emp0002@example.com	$2a$10$LotyBfqUxWi685fLan3iWOtbztg2PDdqYoGpSVpXiKAZ5lGnVfEH.	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:10.939879+00	2026-10-14 09:11:10.939879+00	junior
29	BE0003	พนักงานทดสอบ 0003	bulk.emp0003@example.com	$2a$10$WcFebMPBp8bflkU28Jf0Se1RG2pJxDafiA.hGmyaI3qbpTjGb92Hu	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:11.009822+00	2026-10-14 09:11:11.009822+00	junior
30	BE0004	พนักงานทดสอบ 0004	bulk.emp0004@example.com	$2a$10$dFRSLotSYlW.Qfh8jpmvkuAEE2I9INXRKC.RcsyR5nsfjn.wTrs7O	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:11.081378+00	2026-10-14 09:11:11.081378+00	junior
31	BE0005	พนักงานทดสอบ 0005	bulk.emp0005@example.com	$2a$10$8D3jymGJeP7gvjMJ.f0VYOjwlQeG0OeVnKy57ewhWqjl6LgJwfPC6	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:11.152372+00	2026-10-14 09:11:11.152372+00	junior
32	BE0006	พนักงานทดสอบ 0006	bulk.emp0006@example.com	$2a$10$aG/NH2agw8HewjPB2je6y.gTvFYzO86xXkBcq.D3qrL1wHiaB8LIa	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:11.224678+00	2026-10-14 09:11:11.224678+00	senior
33	BE0007	พนักงานทดสอบ 0007	bulk.emp0007@example.com	$2a$10$vZo7jQIVIPr7Pr/69RHibO9U11Gfb7GZ4TPfMqmdneW.6d7wDkgzi	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:11.2952+00	2026-10-14 09:11:11.2952+00	senior
34	BE0008	พนักงานทดสอบ 0008	bulk.emp0008@example.com	$2a$10$RJlyJrey6KnzFuz5DsmWmO.jKxZuNW3dxiqQJ3XsmdovOaVikyMhO	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:11.3675+00	2026-10-14 09:11:11.3675+00	senior
35	BE0009	พนักงานทดสอบ 0009	bulk.emp0009@example.com	$2a$10$nO2euu/686Oe0kBDwjmnnuLHyu2MjO9aCrSTVAQS2lSaoW8czKLNC	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:11.439225+00	2026-10-14 09:11:11.439225+00	lead
36	BE0010	พนักงานทดสอบ 0010	bulk.emp0010@example.com	$2a$10$hlyauxtBKEPRRgUV8k2J3OYoLTO1Hk08M6usn7SiZW5fyY7V9IPA2	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:11.510454+00	2026-10-14 09:11:11.510454+00	junior
37	BE0011	พนักงานทดสอบ 0011	bulk.emp0011@example.com	$2a$10$cEH2nmV7GO4o8kZ9OsuDEOkTWomd3S/0I7XbKUE/xZLL6z.SfjYoC	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:11.581295+00	2026-10-14 09:11:11.581295+00	junior
38	BE0012	พนักงานทดสอบ 0012	bulk.emp0012@example.com	$2a$10$HBo14Mqe7XIBCEenlpklH.Hc8CFRhetVYzc2oeSbTrE.KeM/XEKku	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:11.652098+00	2026-10-14 09:11:11.652098+00	junior
39	BE0013	พนักงานทดสอบ 0013	bulk.emp0013@example.com	$2a$10$5/qaaHtjYyp7VKLlrXifZu6a3jCFTSBsFW0jbY7LZV5BfRGX1/aXq	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:11.729722+00	2026-10-14 09:11:11.729722+00	junior
40	BE0014	พนักงานทดสอบ 0014	bulk.emp0014@example.com	$2a$10$5rpG7GM3rjpw1seuhCwhveMFBOmlMEOMre9jIDt160/M5ieF.RqhO	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:11.800891+00	2026-10-14 09:11:11.800891+00	junior
41	BE0015	พนักงานทดสอบ 0015	bulk.emp0015@example.com	$2a$10$WDgci5xx3.k8cQfa9YVJm.zATaAbiixr.SRRcOc/lA117fhDknZ82	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:11.896765+00	2026-10-14 09:11:11.896765+00	junior
42	BE0016	พนักงานทดสอบ 0016	bulk.emp0016@example.com	$2a$10$S4VAVVkIIs4woenuwp1vJ.urBp3VMlCdqeSuPrxg42nF2OMVuT9L6	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:11.999409+00	2026-10-14 09:11:11.999409+00	senior
43	BE0017	พนักงานทดสอบ 0017	bulk.emp0017@example.com	$2a$10$gWzccvEJLlcCR7LzZGGQQO9bU8/w0KdJt6P0nKfX0UD1/eK7sSGYG	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:12.072343+00	2026-10-14 09:11:12.072343+00	senior
44	BE0018	พนักงานทดสอบ 0018	bulk.emp0018@example.com	$2a$10$c3gqxsll6TwI8yPPHCeHuOv6DyvH8kYnF5XbLkLKg10aBHEcK9N2e	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:12.143187+00	2026-10-14 09:11:12.143187+00	senior
45	BE0019	พนักงานทดสอบ 0019	bulk.emp0019@example.com	$2a$10$5BwkWNEegXq7z/vmVZ9gHe02kJnxzhVbM49.vYkNhODgICPwek7U2	employee	พัฒนาซอฟต์แวร์	QA Engineer	12	t	2026-10-14 09:11:12.226041+00	2026-10-14 09:11:12.226041+00	lead
46	BE0020	พนักงานทดสอบ 0020	bulk.emp0020@example.com	$2a$10$xk2Io.AmQVZIUuPWsFaGLuV90W7bQOl6jIUlpyMOhGiWV4ZNQOPZW	employee	พัฒนาซอฟต์แวร์	Software Engineer	12	t	2026-10-14 09:11:12.29726+00	2026-10-14 09:11:12.29726+00	junior
47	BE0021	พนักงานทดสอบ 0021	bulk.emp0021@example.com	$2a$10$3blo7jKtnUzia3kzT/jfVuEH/IJRVRYhya0WhFoMykot7FYL9Js.K	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:12.370875+00	2026-10-14 09:11:12.370875+00	junior
48	BE0022	พนักงานทดสอบ 0022	bulk.emp0022@example.com	$2a$10$ErYr.AvpdggdNW4uQuFOSef2U6FYpFKDT.9miVCeIXHa8.tI75g.a	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:12.484072+00	2026-10-14 09:11:12.484072+00	junior
49	BE0023	พนักงานทดสอบ 0023	bulk.emp0023@example.com	$2a$10$eQNcTxw.clcXhd9r07Zhhuhdy1WMvf887qJmOCpQTkMEQllqfFEey	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:12.587349+00	2026-10-14 09:11:12.587349+00	junior
50	BE0024	พนักงานทดสอบ 0024	bulk.emp0024@example.com	$2a$10$umrpMnEdeF5Oz5c.GUocxOi5LRd7Ds8F51Vdyb0kKbhYINszNTA5i	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:12.66543+00	2026-10-14 09:11:12.66543+00	junior
51	BE0025	พนักงานทดสอบ 0025	bulk.emp0025@example.com	$2a$10$wavZTDOlR.4EK1f7kdSpDuIEKORRs1nm4z9FKSakFVj0QQG5WLm/6	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:12.73786+00	2026-10-14 09:11:12.73786+00	junior
52	BE0026	พนักงานทดสอบ 0026	bulk.emp0026@example.com	$2a$10$bpSM5vzhY9Dw619A.JjDGuYBt59dr3tBtHfp4TERZxglQgwXwGEBK	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:12.808323+00	2026-10-14 09:11:12.808323+00	senior
53	BE0027	พนักงานทดสอบ 0027	bulk.emp0027@example.com	$2a$10$f0qXBIxahztCDbjoLbw9POip6EoPoxWVX5U/Q.Mn2twrgCaaeuPEC	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:12.878504+00	2026-10-14 09:11:12.878504+00	senior
54	BE0028	พนักงานทดสอบ 0028	bulk.emp0028@example.com	$2a$10$t178n8Vo65t9EBAZnkFWH.zvjzOtLws/eeOyrUQ3Ioel.lVLReniW	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:12.949432+00	2026-10-14 09:11:12.949432+00	senior
55	BE0029	พนักงานทดสอบ 0029	bulk.emp0029@example.com	$2a$10$XNbROG/4Y1DuhR34u6yVCuIeuEVJ4ufY9Fu/AEEWDx2pseRqqKAcu	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:13.019717+00	2026-10-14 09:11:13.019717+00	lead
56	BE0030	พนักงานทดสอบ 0030	bulk.emp0030@example.com	$2a$10$PdqTrsN52xLfU0mSudchhePY.QK5ii1sf06ZCvgBux8qzVPozXAW.	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:13.102072+00	2026-10-14 09:11:13.102072+00	junior
57	BE0031	พนักงานทดสอบ 0031	bulk.emp0031@example.com	$2a$10$V9LxBoEljnS5CJzRVfbqJe/GtnI/6YBYSUQ5l2E4jLpnk15f8eyEK	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:13.173466+00	2026-10-14 09:11:13.173466+00	junior
58	BE0032	พนักงานทดสอบ 0032	bulk.emp0032@example.com	$2a$10$SN/oqwZ8X6Jk2s69ybOtXOzCpZw5HHN0KcDc1U9FDAkVVyiIR9Gai	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:13.246059+00	2026-10-14 09:11:13.246059+00	junior
59	BE0033	พนักงานทดสอบ 0033	bulk.emp0033@example.com	$2a$10$n32J6Yr8clJiVgebwgT07.K3aRpvKzFr6SZhtaMntkowZFZUSeSc2	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:13.316761+00	2026-10-14 09:11:13.316761+00	junior
60	BE0034	พนักงานทดสอบ 0034	bulk.emp0034@example.com	$2a$10$ipauhA/tGp2FMLfTyYyh8ubXQYj4Bv5XnXa3QmylEycZmjCjqYou6	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:13.386429+00	2026-10-14 09:11:13.386429+00	junior
61	BE0035	พนักงานทดสอบ 0035	bulk.emp0035@example.com	$2a$10$2r4PsJpYZXOnr/k/NVj.oOgwlCvHP8iwxZmuNnRkQ9wZyB6eDeDmu	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:13.458553+00	2026-10-14 09:11:13.458553+00	junior
62	BE0036	พนักงานทดสอบ 0036	bulk.emp0036@example.com	$2a$10$EVk8N/Njzg3Ae2mINv/tjO6o4.l1HkbvhCwbyXhmReCc0CZnKz6vq	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:13.529938+00	2026-10-14 09:11:13.529938+00	senior
63	BE0037	พนักงานทดสอบ 0037	bulk.emp0037@example.com	$2a$10$.iCLBcWwOPrqmJsbWpQEU.tLhRmJyDqqL7ZXPcwEHDihoBI/lTIH6	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:13.600763+00	2026-10-14 09:11:13.600763+00	senior
64	BE0038	พนักงานทดสอบ 0038	bulk.emp0038@example.com	$2a$10$WruCCo1I5r6dqpg7NRwS8.PeS3IoDZhJAg5ZfmAHU3xRrAvxvDPtq	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:13.675559+00	2026-10-14 09:11:13.675559+00	senior
65	BE0039	พนักงานทดสอบ 0039	bulk.emp0039@example.com	$2a$10$2jdYR3n4GWpDlSrnWB8V3OLFM7vf1XmTpW54pN.AXOj5H/Z/j/H0W	employee	พัฒนาซอฟต์แวร์	QA Engineer	13	t	2026-10-14 09:11:13.749323+00	2026-10-14 09:11:13.749323+00	lead
66	BE0040	พนักงานทดสอบ 0040	bulk.emp0040@example.com	$2a$10$/S0w8pD8b4kOHGagvWRY6u7kwriUNSBusFci1LXw5rxAR8wsbKeJ6	employee	พัฒนาซอฟต์แวร์	Software Engineer	13	t	2026-10-14 09:11:13.820613+00	2026-10-14 09:11:13.820613+00	junior
67	BE0041	พนักงานทดสอบ 0041	bulk.emp0041@example.com	$2a$10$JnKUMPY1NR9n6AKYbg3EU.g.IRJs9THpOkRx4E.EpApu3Dw80.oaW	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:13.892273+00	2026-10-14 09:11:13.892273+00	junior
68	BE0042	พนักงานทดสอบ 0042	bulk.emp0042@example.com	$2a$10$dZVh88F.Ei5KGVa.7A.kKuRSx.DRzFiubEfWFAMt9en1RAykBzEdC	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:13.962897+00	2026-10-14 09:11:13.962897+00	junior
69	BE0043	พนักงานทดสอบ 0043	bulk.emp0043@example.com	$2a$10$tveJVetlhXSUhW401EHxjeiewWWG7VvdTu2nHebGbSb.4gC8Kr6Zi	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:14.056251+00	2026-10-14 09:11:14.056251+00	junior
70	BE0044	พนักงานทดสอบ 0044	bulk.emp0044@example.com	$2a$10$ZWTG3rEoZ/1R2QAp4sIgn.GNQsctCfBzEGTza59TPBYmsLXCXmpxa	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:14.127125+00	2026-10-14 09:11:14.127125+00	junior
71	BE0045	พนักงานทดสอบ 0045	bulk.emp0045@example.com	$2a$10$aMjWDDhjQ6A18d23tlg8IuLCyMwLj6x8bjfyahkTUoxHOPOaA/29y	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:14.197737+00	2026-10-14 09:11:14.197737+00	junior
72	BE0046	พนักงานทดสอบ 0046	bulk.emp0046@example.com	$2a$10$ZbpH6NqiWj3uV.ab88Oe6OlCsIM8xqth6dudU3G.W69oYZhN/m0IS	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:14.269382+00	2026-10-14 09:11:14.269382+00	senior
73	BE0047	พนักงานทดสอบ 0047	bulk.emp0047@example.com	$2a$10$poIsDAzuWrsa4W3KU9Q4ouybkHLZlWs5dcf9PZqOesT5gaBgMj5H2	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:14.340125+00	2026-10-14 09:11:14.340125+00	senior
74	BE0048	พนักงานทดสอบ 0048	bulk.emp0048@example.com	$2a$10$14SI7RXOYwtm64mzirARxuYe4uZqB1IsARvhnYJLWYlv2WQytwoTG	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:14.410981+00	2026-10-14 09:11:14.410981+00	senior
75	BE0049	พนักงานทดสอบ 0049	bulk.emp0049@example.com	$2a$10$L0rttfWvWdghiR6Bfq/cXuW2dpIIjByHuPaJnqMc11SC4M0Y7K1/2	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:14.482962+00	2026-10-14 09:11:14.482962+00	lead
76	BE0050	พนักงานทดสอบ 0050	bulk.emp0050@example.com	$2a$10$a3J82aNhW2BSgvR5pVy0tO4cTmmUtlhOI1HCezAatcftEzOIBs8Ym	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:14.555534+00	2026-10-14 09:11:14.555534+00	junior
77	BE0051	พนักงานทดสอบ 0051	bulk.emp0051@example.com	$2a$10$rdylgm2U5mNiVwPc/Xo.COQW8fbC.TBGl1AVlg3CT84sSiwiLefPS	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:14.626339+00	2026-10-14 09:11:14.626339+00	junior
78	BE0052	พนักงานทดสอบ 0052	bulk.emp0052@example.com	$2a$10$aFWZHOOZxN7KyFctAA4ER.fxgC9RfAXJpG6Jx3De9dMoXexVG/uBK	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:14.708297+00	2026-10-14 09:11:14.708297+00	junior
79	BE0053	พนักงานทดสอบ 0053	bulk.emp0053@example.com	$2a$10$gbUNwlx.qBUfLbgGyAx0T./OosOKCnX6xjE.uBG6UDJwZq7dQ9Qq6	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:14.780409+00	2026-10-14 09:11:14.780409+00	junior
80	BE0054	พนักงานทดสอบ 0054	bulk.emp0054@example.com	$2a$10$LJeqOSYau9tnd7OnMU/hLe7AvKJ2K6Yh5h4Ko2z8QThx11jf0mzS6	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:14.850932+00	2026-10-14 09:11:14.850932+00	junior
81	BE0055	พนักงานทดสอบ 0055	bulk.emp0055@example.com	$2a$10$KF8S3CSFHONS6urvwTSohe0lAmMy7ZGbRo.2/JBuC1OTwH6bz9Bre	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:14.920447+00	2026-10-14 09:11:14.920447+00	junior
82	BE0056	พนักงานทดสอบ 0056	bulk.emp0056@example.com	$2a$10$vSkkEgqOZK2lRfrwzqZztO7GsCQXwWJW8wPAimuQHSK7/UsZP4s0.	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:14.991936+00	2026-10-14 09:11:14.991936+00	senior
83	BE0057	พนักงานทดสอบ 0057	bulk.emp0057@example.com	$2a$10$904dCKf/HWbMCdj1NH9z5epCBQd2BGOANvf7zcrwU/EnM6iX3rsDC	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:15.062626+00	2026-10-14 09:11:15.062626+00	senior
84	BE0058	พนักงานทดสอบ 0058	bulk.emp0058@example.com	$2a$10$ywWTPK3SX2ZkBUyOdMaua.kI52Ve1MnPMGvmH5Ne9ICf1bjBZK1d2	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:15.139055+00	2026-10-14 09:11:15.139055+00	senior
85	BE0059	พนักงานทดสอบ 0059	bulk.emp0059@example.com	$2a$10$aidsFOuY.O0t9PoEDmNppOa0DSwV60ridQ.S1A6v8q14.vB2QRQM6	employee	พัฒนาซอฟต์แวร์	QA Engineer	14	t	2026-10-14 09:11:15.221998+00	2026-10-14 09:11:15.221998+00	lead
86	BE0060	พนักงานทดสอบ 0060	bulk.emp0060@example.com	$2a$10$vSoVXCCpbkOyT0twxRSlVeYGvNJKn/anVtiDTB6E.5YS1FXPKmzvK	employee	พัฒนาซอฟต์แวร์	Software Engineer	14	t	2026-10-14 09:11:15.293536+00	2026-10-14 09:11:15.293536+00	junior
87	BE0061	พนักงานทดสอบ 0061	bulk.emp0061@example.com	$2a$10$5bwFNxpAZ.vS04FqeVDJTuOI5R1tsa0hiRe2TxAxs5MC.bY29hpOy	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:15.364033+00	2026-10-14 09:11:15.364033+00	junior
88	BE0062	พนักงานทดสอบ 0062	bulk.emp0062@example.com	$2a$10$/r1hfPgIhTRFmxQHLPZHyuf3KBmDKDYfjYkSjIX2bMBKWo.JqMynu	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:15.437404+00	2026-10-14 09:11:15.437404+00	junior
89	BE0063	พนักงานทดสอบ 0063	bulk.emp0063@example.com	$2a$10$ET5nAwUhL5jI14pXP8WrQ.e2Yf7/tUP6PpUfQJm6TYsNdh0C61UgW	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:15.509059+00	2026-10-14 09:11:15.509059+00	junior
90	BE0064	พนักงานทดสอบ 0064	bulk.emp0064@example.com	$2a$10$CYDWqvkUK3YwJRUJpnYeLuPs3OYMOQBEKmaS/xJPDRluK/LuOsq8S	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:15.583007+00	2026-10-14 09:11:15.583007+00	junior
91	BE0065	พนักงานทดสอบ 0065	bulk.emp0065@example.com	$2a$10$IsseZsFHxbtaxIVv2Oa5oub1jq7sGP4ILMR4gbGr8JroRn05k/LnC	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:15.895807+00	2026-10-14 09:11:15.895807+00	junior
92	BE0066	พนักงานทดสอบ 0066	bulk.emp0066@example.com	$2a$10$Nm1sR0lYAiTS19GhjKZDUeIovX1T4qmv1tjFOazvuZ3HukFR0Mw9m	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:15.967119+00	2026-10-14 09:11:15.967119+00	senior
93	BE0067	พนักงานทดสอบ 0067	bulk.emp0067@example.com	$2a$10$5354lC9SbyA3G3JdE429G.5x5eWkJM2DImLmQqzZ5IFH3J4s5Bqn.	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:16.038702+00	2026-10-14 09:11:16.038702+00	senior
94	BE0068	พนักงานทดสอบ 0068	bulk.emp0068@example.com	$2a$10$ADsn1L4k77IPF8WM6DOcOuih2uBSIcCCv6lN4fN3GBWDvUTXCmKBi	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:16.120161+00	2026-10-14 09:11:16.120161+00	senior
95	BE0069	พนักงานทดสอบ 0069	bulk.emp0069@example.com	$2a$10$lZZU7bXv1Fl5119QZQFdNulvZpI9cSoWp33sxOIwrPJsvLXnejFP.	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:16.191596+00	2026-10-14 09:11:16.191596+00	lead
96	BE0070	พนักงานทดสอบ 0070	bulk.emp0070@example.com	$2a$10$wJSdDQIzkZCoHKZWNF0D0u/zENjTIQfYjVPnYgEr2fnOL4CktB6sa	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:16.263619+00	2026-10-14 09:11:16.263619+00	junior
97	BE0071	พนักงานทดสอบ 0071	bulk.emp0071@example.com	$2a$10$HA1NJ3WnZvuu0u4eOMzolul/SLt5xwNX93jmjADf61vHFnWy/FQE6	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:16.334516+00	2026-10-14 09:11:16.334516+00	junior
98	BE0072	พนักงานทดสอบ 0072	bulk.emp0072@example.com	$2a$10$NlKGKPn6ReX7wPmrsk9SVOUxuAP.aQbkJOcZ.uCWP5JHUXFtipxq2	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:16.407334+00	2026-10-14 09:11:16.407334+00	junior
99	BE0073	พนักงานทดสอบ 0073	bulk.emp0073@example.com	$2a$10$LHkOt0tS0O7xUkpQPmjdTOrKese.bFU79cP2Tx/nylIEDkJ53tO56	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:16.477859+00	2026-10-14 09:11:16.477859+00	junior
100	BE0074	พนักงานทดสอบ 0074	bulk.emp0074@example.com	$2a$10$kuI4MpM9OBRb.y2sFSBo8OYrQTnSh1UdCziISBQI693E4qqlunSxK	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:16.55027+00	2026-10-14 09:11:16.55027+00	junior
101	BE0075	พนักงานทดสอบ 0075	bulk.emp0075@example.com	$2a$10$IVqHsjEH7u/HocrUYTHWRO2rTeEkpd5pEycRPlIk2B/nR/1srIQ2.	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:16.621728+00	2026-10-14 09:11:16.621728+00	junior
102	BE0076	พนักงานทดสอบ 0076	bulk.emp0076@example.com	$2a$10$z.ZpXAIGDlocADlHW8kl3edss/PTmHL/9GGm7utKuP5PKzTbXVZ0C	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:16.692418+00	2026-10-14 09:11:16.692418+00	senior
103	BE0077	พนักงานทดสอบ 0077	bulk.emp0077@example.com	$2a$10$0Krl4nIGY7tGulm3IBdbyOKF6hBXMGAvKn.m/.lTnUd8ms41hIsaK	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:16.766271+00	2026-10-14 09:11:16.766271+00	senior
104	BE0078	พนักงานทดสอบ 0078	bulk.emp0078@example.com	$2a$10$so7MctqoQmDEafWl1TJKK.WCXUq16LvwnbDiEhGbDbjZXLvoW7mcO	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:16.841953+00	2026-10-14 09:11:16.841953+00	senior
105	BE0079	พนักงานทดสอบ 0079	bulk.emp0079@example.com	$2a$10$d.XZEoUi6HMBi65.885/qewU3lec1cyPsyyxEkeOqgaMwi5TyjQsi	employee	พัฒนาซอฟต์แวร์	QA Engineer	15	t	2026-10-14 09:11:16.91414+00	2026-10-14 09:11:16.91414+00	lead
106	BE0080	พนักงานทดสอบ 0080	bulk.emp0080@example.com	$2a$10$R4VT39fFwY6V9sVYh.rbuusqRg.revVS65ZwFF3abY9S3HmMLgOe2	employee	พัฒนาซอฟต์แวร์	Software Engineer	15	t	2026-10-14 09:11:16.985199+00	2026-10-14 09:11:16.985199+00	junior
107	BE0081	พนักงานทดสอบ 0081	bulk.emp0081@example.com	$2a$10$zau852yMNxznKFo9dY4S8eprp8aJKvWyFd0UbVZwx9KS/HWJdKeW6	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:17.056401+00	2026-10-14 09:11:17.056401+00	junior
108	BE0082	พนักงานทดสอบ 0082	bulk.emp0082@example.com	$2a$10$vyu2zYgY1/Ukw.uRSKwKJuUGU/ibZw8Xwr2MjdCeqWPZFRi.h3HXW	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:17.126422+00	2026-10-14 09:11:17.126422+00	junior
109	BE0083	พนักงานทดสอบ 0083	bulk.emp0083@example.com	$2a$10$nDaXEDH3eJGfRBXTWcMfEuNjZ1o9HXyHcFvCKxVR.yFgbpvaTcV2K	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:17.19819+00	2026-10-14 09:11:17.19819+00	junior
110	BE0084	พนักงานทดสอบ 0084	bulk.emp0084@example.com	$2a$10$S2BX/qiZCME6Kk1lJJjnhOUoOrP1ElaWysCaaZbahL.ZvtXoLqeq2	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:17.269865+00	2026-10-14 09:11:17.269865+00	junior
111	BE0085	พนักงานทดสอบ 0085	bulk.emp0085@example.com	$2a$10$SGUguBNVTbYrhIm7lVeC.u3iWSj41mZtGwq4CfrUqncjgLbiRQa36	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:17.340091+00	2026-10-14 09:11:17.340091+00	junior
112	BE0086	พนักงานทดสอบ 0086	bulk.emp0086@example.com	$2a$10$Xn6XvhxM.459k.Djs9ucFe0Fiv.WWPUSZ3lFMPM8M6Dne7z2p7oYC	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:17.416836+00	2026-10-14 09:11:17.416836+00	senior
113	BE0087	พนักงานทดสอบ 0087	bulk.emp0087@example.com	$2a$10$578KIPIV/s9rdP5/nPsuHue6Smj4Gqlv3LccTbc3GhpCOQREHnVa.	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:17.498509+00	2026-10-14 09:11:17.498509+00	senior
114	BE0088	พนักงานทดสอบ 0088	bulk.emp0088@example.com	$2a$10$F2pft4iTfwvXo7N3Hfdu2e4zRIoXYnrvlBpMkXMnlzK5OHcAxbxdm	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:17.569878+00	2026-10-14 09:11:17.569878+00	senior
115	BE0089	พนักงานทดสอบ 0089	bulk.emp0089@example.com	$2a$10$SVZ.7u1EwpyJtSZWzmtLAuQAq.UEm6ndBqgwC3FwQCqNT1jpbtJsm	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:17.641786+00	2026-10-14 09:11:17.641786+00	lead
116	BE0090	พนักงานทดสอบ 0090	bulk.emp0090@example.com	$2a$10$6zc351FqYyemPTIxJiygD.fD4Jzlbk3kgauf2AODjsn/zaSXYxO3a	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:17.729907+00	2026-10-14 09:11:17.729907+00	junior
117	BE0091	พนักงานทดสอบ 0091	bulk.emp0091@example.com	$2a$10$Y.RGtc4T2WWMDfwS2Wga6.mDsiiXg.0CJh6JVWu/4q./dZkTcMrju	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:17.802875+00	2026-10-14 09:11:17.802875+00	junior
118	BE0092	พนักงานทดสอบ 0092	bulk.emp0092@example.com	$2a$10$ZIE7O/Cl1ANeB7/N7hBHeue842IXRpZSYJ5Tb/vDzybdp0AnRyne2	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:17.880772+00	2026-10-14 09:11:17.880772+00	junior
119	BE0093	พนักงานทดสอบ 0093	bulk.emp0093@example.com	$2a$10$DdlUOwu1VjcDLDjreXx4Cu/u0R8oiw/wUunV81XVJFDH89oYxnHUS	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:17.961955+00	2026-10-14 09:11:17.961955+00	junior
120	BE0094	พนักงานทดสอบ 0094	bulk.emp0094@example.com	$2a$10$E6dk9m/EBURd9gM9xHnie.G/pIfaegUgNAXg6bwdQV.ORwVS/6RCe	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:18.032871+00	2026-10-14 09:11:18.032871+00	junior
121	BE0095	พนักงานทดสอบ 0095	bulk.emp0095@example.com	$2a$10$F2YVUb3E3I/BtqkgMp28fuMue7g1pAz9FRgKSnm1HRSIpOwVmXTR.	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:18.107935+00	2026-10-14 09:11:18.107935+00	junior
122	BE0096	พนักงานทดสอบ 0096	bulk.emp0096@example.com	$2a$10$wRyBduGTG5hIr0qvhKfWhe3wH6jEc5mKOYAIrW1nSJKSMQ99K39Ce	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:18.213629+00	2026-10-14 09:11:18.213629+00	senior
123	BE0097	พนักงานทดสอบ 0097	bulk.emp0097@example.com	$2a$10$5Fg96htKx2gCtSEHCyjrRuFd4COEYfav1MUkEG3y6yx5YBF2mYVaW	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:18.284263+00	2026-10-14 09:11:18.284263+00	senior
124	BE0098	พนักงานทดสอบ 0098	bulk.emp0098@example.com	$2a$10$gkKfeXdHLC3fw9AHsJ1S6OWACEL4Ci5XdJWSMTBk996jDOzvoGMa6	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:18.355846+00	2026-10-14 09:11:18.355846+00	senior
125	BE0099	พนักงานทดสอบ 0099	bulk.emp0099@example.com	$2a$10$/Hsm29sXwFDr6ItnPFghAeuZnYKP6/Yx2tZAoloooFZ4DS19H6Te6	employee	พัฒนาซอฟต์แวร์	QA Engineer	16	t	2026-10-14 09:11:18.426298+00	2026-10-14 09:11:18.426298+00	lead
126	BE0100	พนักงานทดสอบ 0100	bulk.emp0100@example.com	$2a$10$Wptp7GUmL6VadVS8RDn1buEklxpN.dAlxPDDh8hPCOD4PA83SPA/6	employee	พัฒนาซอฟต์แวร์	Software Engineer	16	t	2026-10-14 09:11:18.499028+00	2026-10-14 09:11:18.499028+00	junior
127	BE0101	พนักงานทดสอบ 0101	bulk.emp0101@example.com	$2a$10$UoHobynsgLh2cQoqXk6e4uf5R/qVF4gXlrE.TTdFH9HmPOcG8qVSy	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:18.570799+00	2026-10-14 09:11:18.570799+00	junior
128	BE0102	พนักงานทดสอบ 0102	bulk.emp0102@example.com	$2a$10$t.ooUEOHbHKcX.ebOnFHPOokaK5vm6M65DHBz/hL6tO3tsuh68R2y	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:18.642103+00	2026-10-14 09:11:18.642103+00	junior
129	BE0103	พนักงานทดสอบ 0103	bulk.emp0103@example.com	$2a$10$bD2lE/KpzodZnlKFWGqdC.3pPppIl0gF/3XwpTl.5a545BeKq6dnC	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:18.714959+00	2026-10-14 09:11:18.714959+00	junior
130	BE0104	พนักงานทดสอบ 0104	bulk.emp0104@example.com	$2a$10$uGKzxpVlUXTv8a2thUHvXuGXaLZSgl5nvBdeFQHswddY9sRrKaLcy	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:18.785876+00	2026-10-14 09:11:18.785876+00	junior
131	BE0105	พนักงานทดสอบ 0105	bulk.emp0105@example.com	$2a$10$3/G2n06pJW4rpMVNJSsh8.fIPSjoev1LGhH1gG47EGlkdCj6tJjpG	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:18.862003+00	2026-10-14 09:11:18.862003+00	junior
132	BE0106	พนักงานทดสอบ 0106	bulk.emp0106@example.com	$2a$10$Vc.nte2f6HZ7fbqnd5oXoOiPi32E8bR/N4p8hU6oj5lKOQLw79mGK	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:18.933825+00	2026-10-14 09:11:18.933825+00	senior
133	BE0107	พนักงานทดสอบ 0107	bulk.emp0107@example.com	$2a$10$tbn1Lup0zzwfq7utgkGc7uapTrwDAxtNuYYWbOgIV1.x.tzP543Py	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:19.004664+00	2026-10-14 09:11:19.004664+00	senior
134	BE0108	พนักงานทดสอบ 0108	bulk.emp0108@example.com	$2a$10$2lOAyT1othExDWRlboNWz.WC/a2sQ.72N5NwZ4sfNyI1YtCQpzF3O	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:19.07518+00	2026-10-14 09:11:19.07518+00	senior
135	BE0109	พนักงานทดสอบ 0109	bulk.emp0109@example.com	$2a$10$CcVY2kV2d.oHqY3vRBizJONIg.3QPEClnMhktad1/nGjDhfmUD9sG	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:19.14604+00	2026-10-14 09:11:19.14604+00	lead
136	BE0110	พนักงานทดสอบ 0110	bulk.emp0110@example.com	$2a$10$hxL/C.jiAkU2F8AYA0lxSeuKRfMBmJ/JGemGUNiZkO3Cys/E2zBwW	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:19.217902+00	2026-10-14 09:11:19.217902+00	junior
137	BE0111	พนักงานทดสอบ 0111	bulk.emp0111@example.com	$2a$10$CN2XEXn4F4n3PtkX4PB86uVC5ZU.O70YF8/tGchJEMJJq6NPmK7NW	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:19.289458+00	2026-10-14 09:11:19.289458+00	junior
138	BE0112	พนักงานทดสอบ 0112	bulk.emp0112@example.com	$2a$10$6w8bJd8vflhfeLDnBG2m5ezE.7efqVL28gPedmk1SESd.wvC2IyJa	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:19.362054+00	2026-10-14 09:11:19.362054+00	junior
139	BE0113	พนักงานทดสอบ 0113	bulk.emp0113@example.com	$2a$10$1QoS9ZVHUAKMcRYWBfxXAerAzYW2W0sbCjUfqOVfw7xJAi/nKtHdy	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:19.433413+00	2026-10-14 09:11:19.433413+00	junior
140	BE0114	พนักงานทดสอบ 0114	bulk.emp0114@example.com	$2a$10$tHmvUb/iEAoKYR7v/96NNO69VCLrXbSnnj4jUR1uumHKcE3kH4rBm	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:19.503892+00	2026-10-14 09:11:19.503892+00	junior
141	BE0115	พนักงานทดสอบ 0115	bulk.emp0115@example.com	$2a$10$js/SbDmWYbBvxoZlsSvXce/77LNL7PZHcg4x6Yq6jojmAGPxkX9Ha	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:19.57523+00	2026-10-14 09:11:19.57523+00	junior
142	BE0116	พนักงานทดสอบ 0116	bulk.emp0116@example.com	$2a$10$AW4hbYYJsjdEx6Iq1H8Nbe57ShVEiMnr3tusdBY2d2um1ETT4i2kG	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:19.646249+00	2026-10-14 09:11:19.646249+00	senior
143	BE0117	พนักงานทดสอบ 0117	bulk.emp0117@example.com	$2a$10$dy8WRhsUFouRhvDDxB6ZMeCjoO540lEXLb7CtZpKUAVCHoLd9wTky	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:19.727238+00	2026-10-14 09:11:19.727238+00	senior
144	BE0118	พนักงานทดสอบ 0118	bulk.emp0118@example.com	$2a$10$tdn6KzT9NFHaoRJNjiREBufkToD1/xFP.mTpek9M.ZujZas7sCoJ6	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:19.800006+00	2026-10-14 09:11:19.800006+00	senior
145	BE0119	พนักงานทดสอบ 0119	bulk.emp0119@example.com	$2a$10$bDxyBR90/7yI.d1mTCGpLedmSHKGuDax38fdmk/Rf10yxjO5SIdH.	employee	พัฒนาซอฟต์แวร์	QA Engineer	17	t	2026-10-14 09:11:19.876652+00	2026-10-14 09:11:19.876652+00	lead
146	BE0120	พนักงานทดสอบ 0120	bulk.emp0120@example.com	$2a$10$RBjdrR2VW4gOHR11qXxO8e0wxw8AmfIa3hEfpPr.3/p2LgE2zkMs2	employee	พัฒนาซอฟต์แวร์	Software Engineer	17	t	2026-10-14 09:11:19.947844+00	2026-10-14 09:11:19.947844+00	junior
147	BE0121	พนักงานทดสอบ 0121	bulk.emp0121@example.com	$2a$10$wI9ZBJ9XbC69rc0y7eMeDetBidarCN3HXRdxwklio8EK2XTnANVQq	employee	การตลาด	Marketing Executive	18	t	2026-10-14 09:11:20.019257+00	2026-10-14 09:11:20.019257+00	junior
148	BE0122	พนักงานทดสอบ 0122	bulk.emp0122@example.com	$2a$10$HGZqH1oXH4NQjc.D69W/4OcexXkNCeJO35j.n4HlLhx1A7jUZVhT6	employee	การตลาด	Graphic Designer	18	t	2026-10-14 09:11:20.090031+00	2026-10-14 09:11:20.090031+00	junior
149	BE0123	พนักงานทดสอบ 0123	bulk.emp0123@example.com	$2a$10$I9zL891.x4ZvNlK6t/btuODgFr3fJohLxmsQa06UJYnjbgjHVY5KO	employee	การตลาด	Content Marketer	18	t	2026-10-14 09:11:20.16161+00	2026-10-14 09:11:20.16161+00	junior
150	BE0124	พนักงานทดสอบ 0124	bulk.emp0124@example.com	$2a$10$ioFiBjE83mackX7RyCzkOumwXd9cnMJfF5nzgelu0GN/KKFTXQ.g6	employee	การตลาด	Marketing Executive	18	t	2026-10-14 09:11:20.315643+00	2026-10-14 09:11:20.315643+00	junior
151	BE0125	พนักงานทดสอบ 0125	bulk.emp0125@example.com	$2a$10$Bt0iRX.aBsEJKqFoEkAQBeltPVnOCcgHxy2wGwmIuWaSikbe418mS	employee	การตลาด	Graphic Designer	18	t	2026-10-14 09:11:20.413379+00	2026-10-14 09:11:20.413379+00	junior
152	BE0126	พนักงานทดสอบ 0126	bulk.emp0126@example.com	$2a$10$DNcC5NY54BrHZsCK.lG8vuzy6b6XXzaEswFaBw3/8w8rVzObkH4Z.	employee	การตลาด	Content Marketer	18	t	2026-10-14 09:11:20.496521+00	2026-10-14 09:11:20.496521+00	senior
153	BE0127	พนักงานทดสอบ 0127	bulk.emp0127@example.com	$2a$10$YLhC4kbybMDMkTmSV6mIOOYeaVaprRQUyvxpI8rh4S6tIJrpvieLq	employee	การตลาด	Marketing Executive	18	t	2026-10-14 09:11:20.573109+00	2026-10-14 09:11:20.573109+00	senior
154	BE0128	พนักงานทดสอบ 0128	bulk.emp0128@example.com	$2a$10$Xy1fePlWLsRAZaOHKD.Gqe7VlB5KESVo7e7g0.NLTiPnn9fDwaLDy	employee	การตลาด	Graphic Designer	18	t	2026-10-14 09:11:20.643788+00	2026-10-14 09:11:20.643788+00	senior
155	BE0129	พนักงานทดสอบ 0129	bulk.emp0129@example.com	$2a$10$yXzndytywNUTYgt4u4gV.e22i2CtktQRxlUP0OcSvWIeWSLXkGu/G	employee	การตลาด	Content Marketer	18	t	2026-10-14 09:11:20.716915+00	2026-10-14 09:11:20.716915+00	lead
156	BE0130	พนักงานทดสอบ 0130	bulk.emp0130@example.com	$2a$10$h4gzCJr/X9JBKpR5EZG7BeYn5n2vRTQ9bc97ASSR7MKKbyST1wGle	employee	การตลาด	Marketing Executive	18	t	2026-10-14 09:11:20.804019+00	2026-10-14 09:11:20.804019+00	junior
157	BE0131	พนักงานทดสอบ 0131	bulk.emp0131@example.com	$2a$10$2APx.VRHTQZccTqdV54rz.BI1SQ2FqbBc3B/goG2AFFwhb1tCgjMe	employee	การตลาด	Graphic Designer	18	t	2026-10-14 09:11:20.876529+00	2026-10-14 09:11:20.876529+00	junior
158	BE0132	พนักงานทดสอบ 0132	bulk.emp0132@example.com	$2a$10$RUIxIMdl.0Tz95B12gPq3.K7yb/KcBcd3iUoepeiPKr3bGOjd8Um.	employee	การตลาด	Content Marketer	18	t	2026-10-14 09:11:20.947373+00	2026-10-14 09:11:20.947373+00	junior
159	BE0133	พนักงานทดสอบ 0133	bulk.emp0133@example.com	$2a$10$oBJJORUEq7YoLDzufZpTjehW.bgE.XdVn5zEUJ/r16L33GQUcryXW	employee	การตลาด	Marketing Executive	18	t	2026-10-14 09:11:21.02017+00	2026-10-14 09:11:21.02017+00	junior
160	BE0134	พนักงานทดสอบ 0134	bulk.emp0134@example.com	$2a$10$k5BPFx92gu6C5.RE9suvz.j4uGDWwfCSpFuBHgC0kKM9jOMCBZhGa	employee	การตลาด	Graphic Designer	18	t	2026-10-14 09:11:21.096173+00	2026-10-14 09:11:21.096173+00	junior
161	BE0135	พนักงานทดสอบ 0135	bulk.emp0135@example.com	$2a$10$2v53TjWQVlWlSz9yAjC/5.41ierkP/ltyj.emBd47xdXqqcHJFLUq	employee	การตลาด	Content Marketer	18	t	2026-10-14 09:11:21.16749+00	2026-10-14 09:11:21.16749+00	junior
162	BE0136	พนักงานทดสอบ 0136	bulk.emp0136@example.com	$2a$10$VSp8FIt4z1mI548UqFEPRO1obyYofKSOCikACKb0W9/V7K1g2E/LO	employee	การตลาด	Marketing Executive	18	t	2026-10-14 09:11:21.243448+00	2026-10-14 09:11:21.243448+00	senior
163	BE0137	พนักงานทดสอบ 0137	bulk.emp0137@example.com	$2a$10$0tiDXr4aN8eQgWAY6MrD8.3MGYejocW2MiSOYbC0tD5af1OYj/Cea	employee	การตลาด	Graphic Designer	18	t	2026-10-14 09:11:21.314925+00	2026-10-14 09:11:21.314925+00	senior
164	BE0138	พนักงานทดสอบ 0138	bulk.emp0138@example.com	$2a$10$78RsBauXwZr5K/sr6sAJo.YAeesKg4kHA/ShvDGen6aN2hEpPFYd.	employee	การตลาด	Content Marketer	18	t	2026-10-14 09:11:21.386842+00	2026-10-14 09:11:21.386842+00	senior
165	BE0139	พนักงานทดสอบ 0139	bulk.emp0139@example.com	$2a$10$VSZ3iWLEQFq.ePeTEuRaJeqD4//72BwSnhQQpc5o5E.J4CSn6iKmu	employee	การตลาด	Marketing Executive	18	t	2026-10-14 09:11:21.459886+00	2026-10-14 09:11:21.459886+00	lead
166	BE0140	พนักงานทดสอบ 0140	bulk.emp0140@example.com	$2a$10$4c9zTMSjZPiic4Jx0ueiOu77TaOIbApvArFB31CG8DLMOmvjQKYHu	employee	การตลาด	Graphic Designer	18	t	2026-10-14 09:11:21.529829+00	2026-10-14 09:11:21.529829+00	junior
167	BE0141	พนักงานทดสอบ 0141	bulk.emp0141@example.com	$2a$10$JjCgRNv5gNf9CCkZMRsluO.dYe6b.fkOvbBRiRuUSdOPSVI.8OwTu	employee	การตลาด	Content Marketer	19	t	2026-10-14 09:11:21.601532+00	2026-10-14 09:11:21.601532+00	junior
168	BE0142	พนักงานทดสอบ 0142	bulk.emp0142@example.com	$2a$10$mwiQLyLDHV7REYAsTBZxuOZS/SGBJtIweXotZbKoySfTzBF6ySk12	employee	การตลาด	Marketing Executive	19	t	2026-10-14 09:11:21.673661+00	2026-10-14 09:11:21.673661+00	junior
169	BE0143	พนักงานทดสอบ 0143	bulk.emp0143@example.com	$2a$10$gOnw9C3JemMemltEtyrjhup/18g3ZYhyEi2XIbFwadiqHCrOSIHui	employee	การตลาด	Graphic Designer	19	t	2026-10-14 09:11:21.744668+00	2026-10-14 09:11:21.744668+00	junior
170	BE0144	พนักงานทดสอบ 0144	bulk.emp0144@example.com	$2a$10$kQ3qa2udYSbiPao.p2/MruTpwD1PqnJqyy4TAv1MeiO5rjz9G.cbe	employee	การตลาด	Content Marketer	19	t	2026-10-14 09:11:21.814826+00	2026-10-14 09:11:21.814826+00	junior
171	BE0145	พนักงานทดสอบ 0145	bulk.emp0145@example.com	$2a$10$6B.5moHi.Q8WiTK9GlnfW.fRbsaYNt/2N.d16aM8fVboqqwYNDmvG	employee	การตลาด	Marketing Executive	19	t	2026-10-14 09:11:21.892374+00	2026-10-14 09:11:21.892374+00	junior
172	BE0146	พนักงานทดสอบ 0146	bulk.emp0146@example.com	$2a$10$f3EfYjiKef3ChH/HJLUz1uWNynH60lXJuT/AcbfaP29bBsGD7O.dW	employee	การตลาด	Graphic Designer	19	t	2026-10-14 09:11:21.962992+00	2026-10-14 09:11:21.962992+00	senior
173	BE0147	พนักงานทดสอบ 0147	bulk.emp0147@example.com	$2a$10$xMqquPOPPStyIYsRpeB7xuKiKLQeDSwUFmkI8D.lpRz6v1ujxwF8y	employee	การตลาด	Content Marketer	19	t	2026-10-14 09:11:22.034025+00	2026-10-14 09:11:22.034025+00	senior
174	BE0148	พนักงานทดสอบ 0148	bulk.emp0148@example.com	$2a$10$icJ3skTVvQYqNF.PMmUcZuRFqCVZ3qsrhY07A1f5uEy0WRRcvYG.2	employee	การตลาด	Marketing Executive	19	t	2026-10-14 09:11:22.106374+00	2026-10-14 09:11:22.106374+00	senior
175	BE0149	พนักงานทดสอบ 0149	bulk.emp0149@example.com	$2a$10$tY.3auPhu.dCAeQ9BU/vVurp0Rdeu8Pm676YmUh7KdbRRlqysjUzO	employee	การตลาด	Graphic Designer	19	t	2026-10-14 09:11:22.17748+00	2026-10-14 09:11:22.17748+00	lead
176	BE0150	พนักงานทดสอบ 0150	bulk.emp0150@example.com	$2a$10$ejkBGHSxpOAL.WGARGb/HemPjmOWLZN/ipPSbVyLTncawXK7QMl16	employee	การตลาด	Content Marketer	19	t	2026-10-14 09:11:22.250458+00	2026-10-14 09:11:22.250458+00	junior
177	BE0151	พนักงานทดสอบ 0151	bulk.emp0151@example.com	$2a$10$uaDuqaVsqyVugifv/49eieffVlNZZDwKsx8T9OtwvJEV8rpM2mOYu	employee	การตลาด	Marketing Executive	19	t	2026-10-14 09:11:22.321857+00	2026-10-14 09:11:22.321857+00	junior
178	BE0152	พนักงานทดสอบ 0152	bulk.emp0152@example.com	$2a$10$pJfvYLoEqT5HL1DQZHhMg.cKl2wYXVZ12FL6Nw5tqhQf9TltMEAc2	employee	การตลาด	Graphic Designer	19	t	2026-10-14 09:11:22.393004+00	2026-10-14 09:11:22.393004+00	junior
179	BE0153	พนักงานทดสอบ 0153	bulk.emp0153@example.com	$2a$10$LIFAhnu1iNZT5k2Muteh7eq9zuadJRO6FlTzuH/co6GquqNqfJJg6	employee	การตลาด	Content Marketer	19	t	2026-10-14 09:11:22.469304+00	2026-10-14 09:11:22.469304+00	junior
180	BE0154	พนักงานทดสอบ 0154	bulk.emp0154@example.com	$2a$10$IzaGdqGnt84nx.YNcjBV0eigPb7U/.TejvgBjbkkHbry2sbEPrFh2	employee	การตลาด	Marketing Executive	19	t	2026-10-14 09:11:22.548994+00	2026-10-14 09:11:22.548994+00	junior
181	BE0155	พนักงานทดสอบ 0155	bulk.emp0155@example.com	$2a$10$EvJk7LJU98hr8LAZuPdCiOa.Xpg87ABsOAckx4EyWF6O7aPdl67DC	employee	การตลาด	Graphic Designer	19	t	2026-10-14 09:11:22.619459+00	2026-10-14 09:11:22.619459+00	junior
182	BE0156	พนักงานทดสอบ 0156	bulk.emp0156@example.com	$2a$10$857Iw4wvoO30cOilVV2.9OsMv4qC4eHSWdtE5Q4h81BvYAbM5YlA2	employee	การตลาด	Content Marketer	19	t	2026-10-14 09:11:22.71161+00	2026-10-14 09:11:22.71161+00	senior
183	BE0157	พนักงานทดสอบ 0157	bulk.emp0157@example.com	$2a$10$MQhsGEU1TqXQW5uWB6FmROo1Mxv9p55l1xLS07BoAw8hXWoiOUmP6	employee	การตลาด	Marketing Executive	19	t	2026-10-14 09:11:22.809753+00	2026-10-14 09:11:22.809753+00	senior
184	BE0158	พนักงานทดสอบ 0158	bulk.emp0158@example.com	$2a$10$Zd/GIX2ORkgewJg64pib6OYzp2tXyV9MB6wNk4H48I4eAFHcp9e9.	employee	การตลาด	Graphic Designer	19	t	2026-10-14 09:11:22.892252+00	2026-10-14 09:11:22.892252+00	senior
185	BE0159	พนักงานทดสอบ 0159	bulk.emp0159@example.com	$2a$10$61Xex6u4qbBK1VA25hWkMOaak3y6xr6ggjOs8NoGZpTzyPPdxqviC	employee	การตลาด	Content Marketer	19	t	2026-10-14 09:11:22.980145+00	2026-10-14 09:11:22.980145+00	lead
186	BE0160	พนักงานทดสอบ 0160	bulk.emp0160@example.com	$2a$10$BEdy2mcXKxK.eWXHBw89ge6EX.Ft72mNA7YidhFYh7z7iqxfnwSHW	employee	การตลาด	Marketing Executive	19	t	2026-10-14 09:11:23.054823+00	2026-10-14 09:11:23.054823+00	junior
187	BE0161	พนักงานทดสอบ 0161	bulk.emp0161@example.com	$2a$10$8tSCf8oQRsIGYoAg345GNuCj5f6XuKKBGo7zoLuPP/a4nQUYuCaTy	employee	การตลาด	Graphic Designer	20	t	2026-10-14 09:11:23.125872+00	2026-10-14 09:11:23.125872+00	junior
188	BE0162	พนักงานทดสอบ 0162	bulk.emp0162@example.com	$2a$10$P3.PCZ4Vj4dg5Pa2125Jrubt09p7g/KdezFKwyfT7YtLgI5d8ql1G	employee	การตลาด	Content Marketer	20	t	2026-10-14 09:11:23.221653+00	2026-10-14 09:11:23.221653+00	junior
189	BE0163	พนักงานทดสอบ 0163	bulk.emp0163@example.com	$2a$10$/0YXOUu3.wNglBI66tIumuhMjF4y21QFyy21mxw4Lp2brRqB6jxqO	employee	การตลาด	Marketing Executive	20	t	2026-10-14 09:11:23.296602+00	2026-10-14 09:11:23.296602+00	junior
190	BE0164	พนักงานทดสอบ 0164	bulk.emp0164@example.com	$2a$10$l.1ObEJQUrKlSUd6n4B5AO8Z5Ru87BnWLGyVmBKKFKDGYKTsRr1si	employee	การตลาด	Graphic Designer	20	t	2026-10-14 09:11:23.368139+00	2026-10-14 09:11:23.368139+00	junior
191	BE0165	พนักงานทดสอบ 0165	bulk.emp0165@example.com	$2a$10$VXCByxHJU0VSvDlZK79nBOBgbDeDilB0xhrDVRi9dZWPsMeDoSzQq	employee	การตลาด	Content Marketer	20	t	2026-10-14 09:11:23.446875+00	2026-10-14 09:11:23.446875+00	junior
192	BE0166	พนักงานทดสอบ 0166	bulk.emp0166@example.com	$2a$10$lICwIxXvqzF.Xrbwtzt8SONDy2ys9p2ia/jNEUQr1AgQKwE4M.0oW	employee	การตลาด	Marketing Executive	20	t	2026-10-14 09:11:23.519844+00	2026-10-14 09:11:23.519844+00	senior
193	BE0167	พนักงานทดสอบ 0167	bulk.emp0167@example.com	$2a$10$2cb7phZ1wIoR.mupyXEFWeZzaAW0SBIQ4el8g6XKFGMPeBmhPnQ9K	employee	การตลาด	Graphic Designer	20	t	2026-10-14 09:11:23.590376+00	2026-10-14 09:11:23.590376+00	senior
194	BE0168	พนักงานทดสอบ 0168	bulk.emp0168@example.com	$2a$10$rG7kdgGTDq0t/1b.AbuTP.J2.XN2FahP9R1BZpVo/tXId0E7Tjeza	employee	การตลาด	Content Marketer	20	t	2026-10-14 09:11:23.662145+00	2026-10-14 09:11:23.662145+00	senior
195	BE0169	พนักงานทดสอบ 0169	bulk.emp0169@example.com	$2a$10$e92/HkpMC/vDSYUwpvA5K.An/EFtS.knBc2dmo6nFg4bw41etgm2e	employee	การตลาด	Marketing Executive	20	t	2026-10-14 09:11:23.734181+00	2026-10-14 09:11:23.734181+00	lead
196	BE0170	พนักงานทดสอบ 0170	bulk.emp0170@example.com	$2a$10$.j.QFOLlMpB1fwDTYDgDGOh5CB8IzwxW4/PKfSSw2hyw8U0dpmhvO	employee	การตลาด	Graphic Designer	20	t	2026-10-14 09:11:23.805114+00	2026-10-14 09:11:23.805114+00	junior
197	BE0171	พนักงานทดสอบ 0171	bulk.emp0171@example.com	$2a$10$AQBhXnB/mcoceeReSYKSFuq2Gvgbk4S5RlkYqIlwQZwIGcOAD7Auy	employee	การตลาด	Content Marketer	20	t	2026-10-14 09:11:23.877752+00	2026-10-14 09:11:23.877752+00	junior
198	BE0172	พนักงานทดสอบ 0172	bulk.emp0172@example.com	$2a$10$DNaT0oVo16PyHm5/o2kMF.wrt.MD5SGtko2nZQd815ZDy/ulU48pK	employee	การตลาด	Marketing Executive	20	t	2026-10-14 09:11:23.962155+00	2026-10-14 09:11:23.962155+00	junior
199	BE0173	พนักงานทดสอบ 0173	bulk.emp0173@example.com	$2a$10$4Zo02Bw6X1bGGVOhqiDkj.mT3/2zlEmDeINz8rVnhsQPazeF/k2PW	employee	การตลาด	Graphic Designer	20	t	2026-10-14 09:11:24.033318+00	2026-10-14 09:11:24.033318+00	junior
200	BE0174	พนักงานทดสอบ 0174	bulk.emp0174@example.com	$2a$10$xDZKR4TRXqr3E32k6kogp.MYUd0mf4v5/DcxeSdq/1XFuCbeqz0VW	employee	การตลาด	Content Marketer	20	t	2026-10-14 09:11:24.104992+00	2026-10-14 09:11:24.104992+00	junior
201	BE0175	พนักงานทดสอบ 0175	bulk.emp0175@example.com	$2a$10$EGeuSdf8RDax9YxgMj3Xmuw6flRTLDsDmiGkpzvH/WR.hdEAN.Pl6	employee	การตลาด	Marketing Executive	20	t	2026-10-14 09:11:24.175412+00	2026-10-14 09:11:24.175412+00	junior
202	BE0176	พนักงานทดสอบ 0176	bulk.emp0176@example.com	$2a$10$qYEjwYOTOUj9RdiLBGNHB.wVkY63iG0RV7iU5bBvZCuOc2AQhfg9C	employee	การตลาด	Graphic Designer	20	t	2026-10-14 09:11:24.245996+00	2026-10-14 09:11:24.245996+00	senior
203	BE0177	พนักงานทดสอบ 0177	bulk.emp0177@example.com	$2a$10$GL6YN.sgnEaIc1Ig4Tye/eo9g/IS27drkaswA0J2/pVu6hFg3m5J.	employee	การตลาด	Content Marketer	20	t	2026-10-14 09:11:24.31968+00	2026-10-14 09:11:24.31968+00	senior
204	BE0178	พนักงานทดสอบ 0178	bulk.emp0178@example.com	$2a$10$DzPBRfFpfm718FondeUoa.vA7pJK11JutrKhU1dEMnmozyc9of5EK	employee	การตลาด	Marketing Executive	20	t	2026-10-14 09:11:24.389886+00	2026-10-14 09:11:24.389886+00	senior
205	BE0179	พนักงานทดสอบ 0179	bulk.emp0179@example.com	$2a$10$1VBo44C4ic.6WmsgqNnb1O3P7Sd44LEJNKgOQA94vdobZvilTKsjW	employee	การตลาด	Graphic Designer	20	t	2026-10-14 09:11:24.460877+00	2026-10-14 09:11:24.460877+00	lead
206	BE0180	พนักงานทดสอบ 0180	bulk.emp0180@example.com	$2a$10$eqFI9dP1fWIkWbtZ4N4c4OQLbA68.syyNSRgP/vON.WqfPSXb6fke	employee	การตลาด	Content Marketer	20	t	2026-10-14 09:11:24.542099+00	2026-10-14 09:11:24.542099+00	junior
207	BE0181	พนักงานทดสอบ 0181	bulk.emp0181@example.com	$2a$10$N9HNV.71eDCIn.rhwTDNPeBp0mxKhMnA1t0G53cs2LEw4SEYAIoBi	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:24.624077+00	2026-10-14 09:11:24.624077+00	junior
208	BE0182	พนักงานทดสอบ 0182	bulk.emp0182@example.com	$2a$10$ZGnQOi74GgFRrmSMlUeKnOVrfd5AbhTKl22toOL4BnQZtQ0d9U79e	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:24.701805+00	2026-10-14 09:11:24.701805+00	junior
209	BE0183	พนักงานทดสอบ 0183	bulk.emp0183@example.com	$2a$10$NqpNVFzogQguhdphTGtZfe3Vb9VTDwNkOcivXIpJhXXgEWmcx2dEi	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:24.774877+00	2026-10-14 09:11:24.774877+00	junior
210	BE0184	พนักงานทดสอบ 0184	bulk.emp0184@example.com	$2a$10$dx6cMHlnnQ4qekbo/JDRXOxb80Pu3Ujz2of2twpRYoGnrTqmaAdES	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:24.848066+00	2026-10-14 09:11:24.848066+00	junior
211	BE0185	พนักงานทดสอบ 0185	bulk.emp0185@example.com	$2a$10$RTM3X16AtoYBeKs030qsJulHHkPoOmiiE3iahVOCj8GsCP2LDJfci	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:24.92155+00	2026-10-14 09:11:24.92155+00	junior
212	BE0186	พนักงานทดสอบ 0186	bulk.emp0186@example.com	$2a$10$lsB.lYoCUKcnsBE9IvNfRuIdEITT02gOD49J60XDHj0govXHfXNd.	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:24.992132+00	2026-10-14 09:11:24.992132+00	senior
213	BE0187	พนักงานทดสอบ 0187	bulk.emp0187@example.com	$2a$10$gAcxjlY4ksWT2/DfldSOjORjdAZnhrWs1LV/0LFSwsn53WPuNpnf.	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:25.06308+00	2026-10-14 09:11:25.06308+00	senior
214	BE0188	พนักงานทดสอบ 0188	bulk.emp0188@example.com	$2a$10$.FkBSZT5AAlvc4Z5irNP9uKF8G6JhJIKvWwSuEZbkasfV2o/B6oJS	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:25.133477+00	2026-10-14 09:11:25.133477+00	senior
215	BE0189	พนักงานทดสอบ 0189	bulk.emp0189@example.com	$2a$10$S9hHqHnoJucbCO0q1vHzF.bhEbdQ5vkR3OFLvgJMvG7cLzbYU2uIa	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:25.205743+00	2026-10-14 09:11:25.205743+00	lead
216	BE0190	พนักงานทดสอบ 0190	bulk.emp0190@example.com	$2a$10$JtZKLQghW5kMWlXMAizgoOED7kDCLdBruwXQGj/Y82udjPzSb8X4u	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:25.275883+00	2026-10-14 09:11:25.275883+00	junior
217	BE0191	พนักงานทดสอบ 0191	bulk.emp0191@example.com	$2a$10$Sx121c0JX.YzgKV9Kz9LbO6t5/QCwl.Mg7K9.w0JEj3KfPQIGcm/e	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:25.358187+00	2026-10-14 09:11:25.358187+00	junior
218	BE0192	พนักงานทดสอบ 0192	bulk.emp0192@example.com	$2a$10$JGydDv442x0wK.vPgz4D5.WZ2wkt.y.uz4pyD89Jke1I5VcOvTvXW	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:25.451196+00	2026-10-14 09:11:25.451196+00	junior
219	BE0193	พนักงานทดสอบ 0193	bulk.emp0193@example.com	$2a$10$nlc.zG1dWan.fpJHhnOiNuyXRfKNSTxcFH9G4pxogW1kkOfcapuii	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:25.521929+00	2026-10-14 09:11:25.521929+00	junior
220	BE0194	พนักงานทดสอบ 0194	bulk.emp0194@example.com	$2a$10$a9WxfiIrf0k78n9ltKpm5.PTIzZpjLgrYNm9xZnqYlOHGJgrjnw.a	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:25.593372+00	2026-10-14 09:11:25.593372+00	junior
221	BE0195	พนักงานทดสอบ 0195	bulk.emp0195@example.com	$2a$10$Fme5dvlQArtHd0Nsh3LHv.4hOqlsdNVr1kDP41GQHAtW/.r6Wyjm6	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:25.665264+00	2026-10-14 09:11:25.665264+00	junior
222	BE0196	พนักงานทดสอบ 0196	bulk.emp0196@example.com	$2a$10$eR/PeSA8pFr6H27mF4Dq9OrOtqOhnWUM7zQrHO2rZawIKiMrGkbRu	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:25.737209+00	2026-10-14 09:11:25.737209+00	senior
223	BE0197	พนักงานทดสอบ 0197	bulk.emp0197@example.com	$2a$10$vrIwjH/VbG5rDW/WSGb7Ye7Swn.iNCQ6x4woar4hITbpbBVMRxPBO	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:25.811892+00	2026-10-14 09:11:25.811892+00	senior
224	BE0198	พนักงานทดสอบ 0198	bulk.emp0198@example.com	$2a$10$bVBbkjD4Bkvon57pCF0f.eNg1APYtYlpioX.NBFBYliB7UjarEbAa	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:25.883118+00	2026-10-14 09:11:25.883118+00	senior
225	BE0199	พนักงานทดสอบ 0199	bulk.emp0199@example.com	$2a$10$TyX07yQSN0zya9Clok5Ar.1NTWTTUUkvruw95HyG0FBdVCyyFh0.a	employee	พัฒนาซอฟต์แวร์	QA Engineer	21	t	2026-10-14 09:11:25.955335+00	2026-10-14 09:11:25.955335+00	lead
226	BE0200	พนักงานทดสอบ 0200	bulk.emp0200@example.com	$2a$10$FakmzFpMrNc1whcDbm68zeaIJomPkKLD2U/yhugT4uyNWLesV3PCy	employee	พัฒนาซอฟต์แวร์	Software Engineer	21	t	2026-10-14 09:11:26.025521+00	2026-10-14 09:11:26.025521+00	junior
227	BE0201	พนักงานทดสอบ 0201	bulk.emp0201@example.com	$2a$10$TLNxUsLw8EP191Ylf0UXg.VyEQOwFYBPAGu98t6FIsxpxPHo.j1K.	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:26.096056+00	2026-10-14 09:11:26.096056+00	junior
228	BE0202	พนักงานทดสอบ 0202	bulk.emp0202@example.com	$2a$10$Jij4wuoSNK.0Ex3TXHZbAeFRT/pavsXqt2mmQy2oDYjaCnVVBjINC	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:26.167155+00	2026-10-14 09:11:26.167155+00	junior
229	BE0203	พนักงานทดสอบ 0203	bulk.emp0203@example.com	$2a$10$.bbHlKb2F01e0FgXXW31hOzBugZzW00IdvChFxsnY4Ah6iydZoSp.	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:26.237742+00	2026-10-14 09:11:26.237742+00	junior
230	BE0204	พนักงานทดสอบ 0204	bulk.emp0204@example.com	$2a$10$W8EeRAfLvWk/G9If0WWEbesefoiH6Z1RhcqED9ta5uzn3K17/Ay9S	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:26.307961+00	2026-10-14 09:11:26.307961+00	junior
231	BE0205	พนักงานทดสอบ 0205	bulk.emp0205@example.com	$2a$10$fOrhFaPwyphpPbukd5nbbOSYA6kA5OsHN4D3cjkrrYz8T2b.CUXui	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:26.380268+00	2026-10-14 09:11:26.380268+00	junior
232	BE0206	พนักงานทดสอบ 0206	bulk.emp0206@example.com	$2a$10$W9glfdvv25HoY8.3EQ0hie9mqZja7j2EjS3w9eAG8imwTR2/77x1O	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:26.451164+00	2026-10-14 09:11:26.451164+00	senior
233	BE0207	พนักงานทดสอบ 0207	bulk.emp0207@example.com	$2a$10$WsxWZOeUt/u57dJ8ZCXtDuLJ/YHRP8/QcyuRgctHrZGWekwnhhVJ6	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:26.521546+00	2026-10-14 09:11:26.521546+00	senior
234	BE0208	พนักงานทดสอบ 0208	bulk.emp0208@example.com	$2a$10$N5s1Y4d9XYt7Sp6UylDRf.IygzH4n9rZNZz0BpSGWEOGJtmu.vQJS	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:26.596888+00	2026-10-14 09:11:26.596888+00	senior
235	BE0209	พนักงานทดสอบ 0209	bulk.emp0209@example.com	$2a$10$PKo4EFhraaHXHUGa9cvKdeXJhV9kENOYE1cFivZSge/XikBiAmDWS	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:26.679749+00	2026-10-14 09:11:26.679749+00	lead
236	BE0210	พนักงานทดสอบ 0210	bulk.emp0210@example.com	$2a$10$c9Lq2iUfEgRDp4oRQKtC/.XaNZ.hRdQCaIVuzvDYfF14pG2IH05LO	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:26.751649+00	2026-10-14 09:11:26.751649+00	junior
237	BE0211	พนักงานทดสอบ 0211	bulk.emp0211@example.com	$2a$10$aqUQdrf5slnh8IAoX7MNnObrm8Tp2N24Jc.kwpqAdsupU2rvl50aG	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:26.822895+00	2026-10-14 09:11:26.822895+00	junior
238	BE0212	พนักงานทดสอบ 0212	bulk.emp0212@example.com	$2a$10$aSpQrERupSv4w5UyLC5EBuZ.SsozJkGzVhL7It1FFGHBu59ArdJZG	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:26.894071+00	2026-10-14 09:11:26.894071+00	junior
239	BE0213	พนักงานทดสอบ 0213	bulk.emp0213@example.com	$2a$10$3d3q.TICKsy1sNIt0bEhSu1UvdizTVlndxB5Cc/0uikJchbC7MEvG	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:26.96836+00	2026-10-14 09:11:26.96836+00	junior
240	BE0214	พนักงานทดสอบ 0214	bulk.emp0214@example.com	$2a$10$QOd/UFmEFTBR81yBmxK4ceWihkSS4oTrkzAQ0/sTawNJAMirymzX6	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:27.038699+00	2026-10-14 09:11:27.038699+00	junior
241	BE0215	พนักงานทดสอบ 0215	bulk.emp0215@example.com	$2a$10$tYVWGe6DQXJlorrwogmqlua2QHbvvEiIYVJtiK60R.P7mH2Sd8oSW	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:27.111054+00	2026-10-14 09:11:27.111054+00	junior
242	BE0216	พนักงานทดสอบ 0216	bulk.emp0216@example.com	$2a$10$n34Rghp21Sc9dltwMa9B8.roCur4/zby2eIwPfKnA7qdC9h9aem0O	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:27.182408+00	2026-10-14 09:11:27.182408+00	senior
243	BE0217	พนักงานทดสอบ 0217	bulk.emp0217@example.com	$2a$10$NuA61Ah/JQdz0og60I.PC.CQpo2i3yDhIH5ab9lxejVXhSrot..sC	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:27.255532+00	2026-10-14 09:11:27.255532+00	senior
244	BE0218	พนักงานทดสอบ 0218	bulk.emp0218@example.com	$2a$10$vKe6MQvvm3Bp4SqqpRL3DOdGgFPC7UTFRZ6ENcbThekPp3MApjeCO	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:27.327158+00	2026-10-14 09:11:27.327158+00	senior
245	BE0219	พนักงานทดสอบ 0219	bulk.emp0219@example.com	$2a$10$FQIFpKHhKrB27znv9UVtuO2ta1hiBHLWGkjwDzyuanSFQ7DSdOtz6	employee	พัฒนาซอฟต์แวร์	QA Engineer	22	t	2026-10-14 09:11:27.398357+00	2026-10-14 09:11:27.398357+00	lead
246	BE0220	พนักงานทดสอบ 0220	bulk.emp0220@example.com	$2a$10$LR/YuGPeT7De14LUPiKpWuJgxBKmrnHsS2CMOmWwEKMFYDHF/xEne	employee	พัฒนาซอฟต์แวร์	Software Engineer	22	t	2026-10-14 09:11:27.470173+00	2026-10-14 09:11:27.470173+00	junior
247	BE0221	พนักงานทดสอบ 0221	bulk.emp0221@example.com	$2a$10$TBE1zD7OYT/BKdodZo81aO3wVA.bZn5ctAd7JmONHsmnl4v6Maegy	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:27.54287+00	2026-10-14 09:11:27.54287+00	junior
248	BE0222	พนักงานทดสอบ 0222	bulk.emp0222@example.com	$2a$10$di5SZ/UWaDT/r3LkJPYixunj2i16zQr2MNERoZf0tG3jgiSHlePLC	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:27.614328+00	2026-10-14 09:11:27.614328+00	junior
249	BE0223	พนักงานทดสอบ 0223	bulk.emp0223@example.com	$2a$10$zHA7VmPaAJozfxuirnlS.eKI98A6xUSRhP8H.yI1P9VJpW9/cqQWi	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:27.688107+00	2026-10-14 09:11:27.688107+00	junior
250	BE0224	พนักงานทดสอบ 0224	bulk.emp0224@example.com	$2a$10$pK/tdzq3iq7gS9B.ywZjoeZJ4C5HwhLh/D/unzYg5x/zlV.YCTUdO	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:27.759911+00	2026-10-14 09:11:27.759911+00	junior
251	BE0225	พนักงานทดสอบ 0225	bulk.emp0225@example.com	$2a$10$rGrE0RVIBSxkIHxCTm5O2ObVAV7/uQpF9.eKzQJNJ/AMCchLdGQdK	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:27.833413+00	2026-10-14 09:11:27.833413+00	junior
252	BE0226	พนักงานทดสอบ 0226	bulk.emp0226@example.com	$2a$10$bOAMUlpIYzo2OeHEFijPKezS8AWvWURsXboQt778vHqXCfZJl7mF6	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:27.903316+00	2026-10-14 09:11:27.903316+00	senior
253	BE0227	พนักงานทดสอบ 0227	bulk.emp0227@example.com	$2a$10$Tzjui0zZvmFmkBquA0qesO2pknZTHF/S8RA2jNv7xTntDKlD3ka02	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:27.975372+00	2026-10-14 09:11:27.975372+00	senior
254	BE0228	พนักงานทดสอบ 0228	bulk.emp0228@example.com	$2a$10$yCdBkWfm0MQEJIb7Ou9bFekr1ZbSCM9ZkppNvjGKw8I3Sy6gRhIFG	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:28.046055+00	2026-10-14 09:11:28.046055+00	senior
255	BE0229	พนักงานทดสอบ 0229	bulk.emp0229@example.com	$2a$10$Bnbio/afsKMvrNc08z.r7OiLzBmY1bbJpLlsht.6DQHeBw6xmRdvG	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:28.116558+00	2026-10-14 09:11:28.116558+00	lead
256	BE0230	พนักงานทดสอบ 0230	bulk.emp0230@example.com	$2a$10$L5O00B0X1aHSy1Pm9cQ16ez9hkM62E/5ww0Dc/wdJf6IckVLCCfPO	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:28.187347+00	2026-10-14 09:11:28.187347+00	junior
257	BE0231	พนักงานทดสอบ 0231	bulk.emp0231@example.com	$2a$10$olWI2SQ8K6t8tDf5ZNmqoe4q0JsRsE2eyt4uRRaV0ZXsMhS9gXQFS	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:28.272484+00	2026-10-14 09:11:28.272484+00	junior
258	BE0232	พนักงานทดสอบ 0232	bulk.emp0232@example.com	$2a$10$YUtjQx0TlYripPSpzB38PODHojh7xrWazspxGI01YlzmR0H4PAokK	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:28.343335+00	2026-10-14 09:11:28.343335+00	junior
259	BE0233	พนักงานทดสอบ 0233	bulk.emp0233@example.com	$2a$10$xjmc62kqaI/RwvKeREABoeodeA1JYvHNbSpMtlXVoQYzoK0FfbbzG	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:28.414872+00	2026-10-14 09:11:28.414872+00	junior
260	BE0234	พนักงานทดสอบ 0234	bulk.emp0234@example.com	$2a$10$flzs5Pj20V1/DiCT3Daej.wCWSFbnZ65C/GcNQQI2TV/EqGysgEGq	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:28.512357+00	2026-10-14 09:11:28.512357+00	junior
261	BE0235	พนักงานทดสอบ 0235	bulk.emp0235@example.com	$2a$10$JJSGw6mzc36WTc6o.7mZ3ebW9WCTFVnBAWZh6.kGXz5QpAErJC3V6	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:28.584536+00	2026-10-14 09:11:28.584536+00	junior
262	BE0236	พนักงานทดสอบ 0236	bulk.emp0236@example.com	$2a$10$diHW4uffEawWZ5uKb7WNTuuHCS8Fg44YNVFNfk/fMkXwC6JyrG96y	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:28.656282+00	2026-10-14 09:11:28.656282+00	senior
263	BE0237	พนักงานทดสอบ 0237	bulk.emp0237@example.com	$2a$10$ugWN8V8vQakWx/R/nadwUu5Sx2FVzrLynks76YkdcjzGR9fdImt9G	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:28.742+00	2026-10-14 09:11:28.742+00	senior
264	BE0238	พนักงานทดสอบ 0238	bulk.emp0238@example.com	$2a$10$p/aIaL7oxeA5m3m.rVlteue909wXxyH.5SrN26mvVirJcA6Jes8oy	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:28.817612+00	2026-10-14 09:11:28.817612+00	senior
265	BE0239	พนักงานทดสอบ 0239	bulk.emp0239@example.com	$2a$10$DwjUFztMtsc/S0VOtIM2z./8RveUpMYj3rrFJy1t.j9NrtfLuekuy	employee	พัฒนาซอฟต์แวร์	QA Engineer	23	t	2026-10-14 09:11:28.888933+00	2026-10-14 09:11:28.888933+00	lead
266	BE0240	พนักงานทดสอบ 0240	bulk.emp0240@example.com	$2a$10$J0ss9FOCvU8bIuW2BSTg3epvlUskfWPXcgEqf6tRBxj1AByOeoJNW	employee	พัฒนาซอฟต์แวร์	Software Engineer	23	t	2026-10-14 09:11:28.98055+00	2026-10-14 09:11:28.98055+00	junior
267	BE0241	พนักงานทดสอบ 0241	bulk.emp0241@example.com	$2a$10$QoEGOF52IhnKCawmUnbsw.SYeJmQJzH8VIAN1MEVfmGMpora9LIBe	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:29.051787+00	2026-10-14 09:11:29.051787+00	junior
268	BE0242	พนักงานทดสอบ 0242	bulk.emp0242@example.com	$2a$10$qyXn9vNVhyuVH2lBun9dsOFuGlFNzWjiBcNNRjkHclLI3wIRDSGIi	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:29.123155+00	2026-10-14 09:11:29.123155+00	junior
269	BE0243	พนักงานทดสอบ 0243	bulk.emp0243@example.com	$2a$10$3Ewjd.uRBBjysX1PNki2XOsejHodUaUso5pAgm4PH1T1xhnNoXX82	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:29.19529+00	2026-10-14 09:11:29.19529+00	junior
270	BE0244	พนักงานทดสอบ 0244	bulk.emp0244@example.com	$2a$10$A1.iMPyOP1WIWlykLW9rGet80BElZYgbDK79IOqcg1nIgxYSIUVby	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:29.265832+00	2026-10-14 09:11:29.265832+00	junior
271	BE0245	พนักงานทดสอบ 0245	bulk.emp0245@example.com	$2a$10$sOEjFe0ViNVKRznmIw95OO.d7KQu6RaE3btZ7NcgCCaq0XJJpqwBS	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:29.337723+00	2026-10-14 09:11:29.337723+00	junior
272	BE0246	พนักงานทดสอบ 0246	bulk.emp0246@example.com	$2a$10$q1i/xuvwVGFOO5jzrN3ln.iXDiIB5eC7LhH8IrBFcI/AXV7PBCUeG	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:29.407467+00	2026-10-14 09:11:29.407467+00	senior
273	BE0247	พนักงานทดสอบ 0247	bulk.emp0247@example.com	$2a$10$hdG2eULS1Qt2IB2YRvukVevoW4yrlg5z/SAn5D19VhuyGgVsHqb0u	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:29.478666+00	2026-10-14 09:11:29.478666+00	senior
274	BE0248	พนักงานทดสอบ 0248	bulk.emp0248@example.com	$2a$10$WGdlAWlbDpSD1dqFM8E5iOqjz/E48YMIo4xTsSq5X6Y50YSj34Kje	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:29.549462+00	2026-10-14 09:11:29.549462+00	senior
275	BE0249	พนักงานทดสอบ 0249	bulk.emp0249@example.com	$2a$10$apwbSHb3sXGtNRXMTybo/.8VY1mSC63c4dNqSkvQxVQt69/92tjGe	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:29.623484+00	2026-10-14 09:11:29.623484+00	lead
276	BE0250	พนักงานทดสอบ 0250	bulk.emp0250@example.com	$2a$10$o6xOjIZ90WLs5q9wtCygB.E6RCDhYJ4eKl7LjE5DU6IQ1ptkXE7bq	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:29.703077+00	2026-10-14 09:11:29.703077+00	junior
277	BE0251	พนักงานทดสอบ 0251	bulk.emp0251@example.com	$2a$10$wFFUMnrxX4/FLF0JZVGrM.gkkkJJMVzco/3XQnPgWYaUNys.B0wqm	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:29.774666+00	2026-10-14 09:11:29.774666+00	junior
278	BE0252	พนักงานทดสอบ 0252	bulk.emp0252@example.com	$2a$10$9Y5w49JUaZK/sxC5kCmPye3JwdD2G0UY66vzpb4.jPFG7ZvK.Si/u	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:29.846245+00	2026-10-14 09:11:29.846245+00	junior
279	BE0253	พนักงานทดสอบ 0253	bulk.emp0253@example.com	$2a$10$7zAjzBxdIgAAWG903OHpBenjKPYxizjOveTwFCNrkqOo2rD8/Z6m.	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:29.917243+00	2026-10-14 09:11:29.917243+00	junior
280	BE0254	พนักงานทดสอบ 0254	bulk.emp0254@example.com	$2a$10$ojAhoRnen0lE3qtpl7.5fudGP3oevPvO68fJ4zE.kyy5QgJUg38Ti	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:29.99176+00	2026-10-14 09:11:29.99176+00	junior
281	BE0255	พนักงานทดสอบ 0255	bulk.emp0255@example.com	$2a$10$AcIJ8Koq7f9AKQ7qKwB/YeUCYT3fGercI3NiWcIdPbRvduhFrLjuy	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:30.063952+00	2026-10-14 09:11:30.063952+00	junior
282	BE0256	พนักงานทดสอบ 0256	bulk.emp0256@example.com	$2a$10$vg5YBxjuUw.8RwCuKXAFQemYqIjmfhVfIRSnoattWtM4QRtFLpD6a	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:30.136863+00	2026-10-14 09:11:30.136863+00	senior
283	BE0257	พนักงานทดสอบ 0257	bulk.emp0257@example.com	$2a$10$aDMSiLAA9zgfwexDn2C1f.4Y3TC0.62og.G2w9XneS8ANhCZoFB0C	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:30.209432+00	2026-10-14 09:11:30.209432+00	senior
284	BE0258	พนักงานทดสอบ 0258	bulk.emp0258@example.com	$2a$10$X1czes4VUaayDM5zqlGPleXQTzVmU3BSWRDws3flrHB8m1WzrbM9G	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:30.282622+00	2026-10-14 09:11:30.282622+00	senior
285	BE0259	พนักงานทดสอบ 0259	bulk.emp0259@example.com	$2a$10$vqNvvlWuFK5E9sCcoU7OHe1UcKSp1Je9xCdIkXfyxJKT1UeJIbefa	employee	พัฒนาซอฟต์แวร์	QA Engineer	24	t	2026-10-14 09:11:30.356376+00	2026-10-14 09:11:30.356376+00	lead
286	BE0260	พนักงานทดสอบ 0260	bulk.emp0260@example.com	$2a$10$lDxP19KF.oDGFvcZAz2h0O/TxQQ4GTLLY2YpfsFF7VOVjf6WPSQJS	employee	พัฒนาซอฟต์แวร์	Software Engineer	24	t	2026-10-14 09:11:30.435761+00	2026-10-14 09:11:30.435761+00	junior
287	BE0261	พนักงานทดสอบ 0261	bulk.emp0261@example.com	$2a$10$1tnLhJaKxtpQFndu69tcJ.0oT4kMT8lfd9Lopa0Apr0/DkqYheAaW	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:30.529713+00	2026-10-14 09:11:30.529713+00	junior
288	BE0262	พนักงานทดสอบ 0262	bulk.emp0262@example.com	$2a$10$PM9dOEeLqtq6Q2l4woZg4eQa5RlvlOIkOKIkPx.RBqfxp5GyHsHc2	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:30.601126+00	2026-10-14 09:11:30.601126+00	junior
289	BE0263	พนักงานทดสอบ 0263	bulk.emp0263@example.com	$2a$10$yso7FUWiGe9KQbq/z0VWXeWR/E0NBOhnFTT45n5VM88i98g5Pj7pq	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:30.671315+00	2026-10-14 09:11:30.671315+00	junior
290	BE0264	พนักงานทดสอบ 0264	bulk.emp0264@example.com	$2a$10$J/8sQ1BWB1iPBmgjP0KOjOc.6W2M6hcypTEwtUkkru4ZVzAZ7Udey	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:30.744012+00	2026-10-14 09:11:30.744012+00	junior
291	BE0265	พนักงานทดสอบ 0265	bulk.emp0265@example.com	$2a$10$bSdB1D.JLEXN0YU43gxYXeV20TzEmetUmPaAM5ou6Np41VDipXGHa	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:30.82839+00	2026-10-14 09:11:30.82839+00	junior
292	BE0266	พนักงานทดสอบ 0266	bulk.emp0266@example.com	$2a$10$qngP5i1PWWiD0NHhpK1fHu/10Ajq5zGID/quCuxyd/0my27W4EOv6	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:30.906207+00	2026-10-14 09:11:30.906207+00	senior
293	BE0267	พนักงานทดสอบ 0267	bulk.emp0267@example.com	$2a$10$S0TbIrzXi7NAjisOmbnbjuZy2JMycqqPoCKsFheTbgkTxeKtn1Tcq	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:30.983971+00	2026-10-14 09:11:30.983971+00	senior
294	BE0268	พนักงานทดสอบ 0268	bulk.emp0268@example.com	$2a$10$bYtqKU/ZwZ8oAMsSYbS5YusreSsf5Piwcu1KOlSNi7E2fvJ331DDy	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:31.055129+00	2026-10-14 09:11:31.055129+00	senior
295	BE0269	พนักงานทดสอบ 0269	bulk.emp0269@example.com	$2a$10$XIrAb2wEb9XRSC5.NZkYFevZ1y.w4Gh207DQ2/3ADvHrIxOXIQI2i	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:31.126904+00	2026-10-14 09:11:31.126904+00	lead
296	BE0270	พนักงานทดสอบ 0270	bulk.emp0270@example.com	$2a$10$jAQyZJR3e9Hm/TKRQ5LwwOWKadP1/dr2Q8Yr53NYTb/BrFZ7MuiCC	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:31.197908+00	2026-10-14 09:11:31.197908+00	junior
297	BE0271	พนักงานทดสอบ 0271	bulk.emp0271@example.com	$2a$10$kgISCGovyGqyua7WzGMvaeOO35r9t6AX0yS5au6HzQ0E8ai.2FLY.	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:31.268925+00	2026-10-14 09:11:31.268925+00	junior
298	BE0272	พนักงานทดสอบ 0272	bulk.emp0272@example.com	$2a$10$l96NDSgz5dqtMgeaPdHLr.hY1P70HlvaFrzxxFq7yRQH0RajUUxwO	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:31.339905+00	2026-10-14 09:11:31.339905+00	junior
299	BE0273	พนักงานทดสอบ 0273	bulk.emp0273@example.com	$2a$10$6qS1Zg3INSctESnoVLKlauu5VqZz3WSOewnbTQNg71ofpAlHbpCZO	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:31.410953+00	2026-10-14 09:11:31.410953+00	junior
300	BE0274	พนักงานทดสอบ 0274	bulk.emp0274@example.com	$2a$10$WxQ4WMN17sj5Djqyr1XSruKonZ2ltc9r7ywSovo8VJguL6/D5GsT6	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:31.483386+00	2026-10-14 09:11:31.483386+00	junior
301	BE0275	พนักงานทดสอบ 0275	bulk.emp0275@example.com	$2a$10$4M7C.gSVQtQ.Vo6GiXUsle6JVjQl.M3eFMvqrbwws1G4.f1gMuPXy	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:31.556546+00	2026-10-14 09:11:31.556546+00	junior
302	BE0276	พนักงานทดสอบ 0276	bulk.emp0276@example.com	$2a$10$8pS9Xq0vWMmwmvpoXcVKH.KN0/prJ9idFS7axxSPvLJl1ZMIUX5J6	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:31.62971+00	2026-10-14 09:11:31.62971+00	senior
303	BE0277	พนักงานทดสอบ 0277	bulk.emp0277@example.com	$2a$10$dAeAQcIaifCxCTmzVzyyR.k.UjxvnrLMCqeQhGE8mL/.IeFwF4hEe	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:31.702745+00	2026-10-14 09:11:31.702745+00	senior
304	BE0278	พนักงานทดสอบ 0278	bulk.emp0278@example.com	$2a$10$8kj5dcNdE4soQPNel6Bs7uNFI4nI1gMyUrcfJhtV0Ccmjh9pXN16G	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:31.777164+00	2026-10-14 09:11:31.777164+00	senior
305	BE0279	พนักงานทดสอบ 0279	bulk.emp0279@example.com	$2a$10$UmAXlhotzwVsk5W0VTZ8n.iuITchyeTO4Qoeya1296QwGwv8La0jG	employee	พัฒนาซอฟต์แวร์	QA Engineer	25	t	2026-10-14 09:11:31.848431+00	2026-10-14 09:11:31.848431+00	lead
306	BE0280	พนักงานทดสอบ 0280	bulk.emp0280@example.com	$2a$10$eNIW.5itfzaHgqrcjB/OPel99snbjKIE7mu1J/bbn3AxT8xGR7lOi	employee	พัฒนาซอฟต์แวร์	Software Engineer	25	t	2026-10-14 09:11:31.921093+00	2026-10-14 09:11:31.921093+00	junior
307	BE0281	พนักงานทดสอบ 0281	bulk.emp0281@example.com	$2a$10$NwnfOQ6.cf/KoIEpL8uM4.IHvTR8IGQJo2GHOLyAoByDc/dMsdwRC	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:31.993928+00	2026-10-14 09:11:31.993928+00	junior
308	BE0282	พนักงานทดสอบ 0282	bulk.emp0282@example.com	$2a$10$.ENKKu3oXVrTPbk3sa78gOoc.HWeePmCjpu9vAPO899TrurFnmdUK	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:32.065827+00	2026-10-14 09:11:32.065827+00	junior
309	BE0283	พนักงานทดสอบ 0283	bulk.emp0283@example.com	$2a$10$HSlFZ8Iegf/J7TYb/.48g.aNuDZis9SuFptlK3MWsQ7EtuUWs.FT6	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:32.136411+00	2026-10-14 09:11:32.136411+00	junior
310	BE0284	พนักงานทดสอบ 0284	bulk.emp0284@example.com	$2a$10$qcyUm1nK9rirLaxZiKEEK.IDZyncdOnD9InrPx5V5SH7pr0Gl3xxi	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:32.206873+00	2026-10-14 09:11:32.206873+00	junior
311	BE0285	พนักงานทดสอบ 0285	bulk.emp0285@example.com	$2a$10$R1cH/xBJ.d8RH9xzrpvIvOJa9pPvgpWH8988ihl6Mrab5FcKAMmUS	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:32.2773+00	2026-10-14 09:11:32.2773+00	junior
312	BE0286	พนักงานทดสอบ 0286	bulk.emp0286@example.com	$2a$10$95bQeB.A92UFoAdFmBWiQe578/u4QSdoL0Cei3nlhzOOl1zdOFCCa	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:32.348+00	2026-10-14 09:11:32.348+00	senior
313	BE0287	พนักงานทดสอบ 0287	bulk.emp0287@example.com	$2a$10$X.AFAF30qdcfB/8gAseaB.DklksLDFryLsOSMt7arsae5/Hbj8qtu	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:32.421103+00	2026-10-14 09:11:32.421103+00	senior
314	BE0288	พนักงานทดสอบ 0288	bulk.emp0288@example.com	$2a$10$UqjsAZktxroX9w7kVvuHs.8HWYpzGo4SSBpcfewPzm1KhU1PkZN2O	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:32.4939+00	2026-10-14 09:11:32.4939+00	senior
315	BE0289	พนักงานทดสอบ 0289	bulk.emp0289@example.com	$2a$10$UcgxpCB9RLvT6qOTHSPorewVSUxnO0OHyHEOQwxZYRUy7kFCLEbti	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:32.567164+00	2026-10-14 09:11:32.567164+00	lead
316	BE0290	พนักงานทดสอบ 0290	bulk.emp0290@example.com	$2a$10$swQ23NHKiwJ/HRsFeUjnWOVtjsA69GzEwbLWBltwDnxwtRubLuTLW	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:32.639125+00	2026-10-14 09:11:32.639125+00	junior
317	BE0291	พนักงานทดสอบ 0291	bulk.emp0291@example.com	$2a$10$UqqAZ.SUveY6AHxk1iM51eq4NJVKeBX.c.7SAhVVwXAEvPw6IBcgC	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:32.710784+00	2026-10-14 09:11:32.710784+00	junior
318	BE0292	พนักงานทดสอบ 0292	bulk.emp0292@example.com	$2a$10$7JlEOR.EhzUWoCXQ44z52O8gkZCydnIjg4H/odqgT/ar7dEQii5jG	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:32.781743+00	2026-10-14 09:11:32.781743+00	junior
319	BE0293	พนักงานทดสอบ 0293	bulk.emp0293@example.com	$2a$10$YufGDlbZGaPTzdJDxqQkg.iaT/4r7Ukogrx9/O3azo9hGCMMwDiei	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:32.853857+00	2026-10-14 09:11:32.853857+00	junior
320	BE0294	พนักงานทดสอบ 0294	bulk.emp0294@example.com	$2a$10$STeLfZxBc0TfhAfzdAsRbeoZdm3RFlGUpStvRNwRgQmkRZCfAdAkK	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:32.993153+00	2026-10-14 09:11:32.993153+00	junior
321	BE0295	พนักงานทดสอบ 0295	bulk.emp0295@example.com	$2a$10$/BAM1MRw..nC2QiwMbgzU.FLPIo8QGnrVHNZf7D2ebG./lffpX2IS	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:33.099308+00	2026-10-14 09:11:33.099308+00	junior
322	BE0296	พนักงานทดสอบ 0296	bulk.emp0296@example.com	$2a$10$NSNqseBSNgjT4swFGqWT2.zTWNFT4x0r3gHj3Fm1JoQ5Z3akImQpG	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:33.177387+00	2026-10-14 09:11:33.177387+00	senior
323	BE0297	พนักงานทดสอบ 0297	bulk.emp0297@example.com	$2a$10$imFvRkKwf2gqP9k0Y/MjGuGla7x8G6SSsukzZEhS79M92.OUAIs4K	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:33.248043+00	2026-10-14 09:11:33.248043+00	senior
324	BE0298	พนักงานทดสอบ 0298	bulk.emp0298@example.com	$2a$10$6UYokW6eHJkN3I8Nlx7IPOvt6l83Km7Vpb3IcomPHcLskU.hIsrFW	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:33.331765+00	2026-10-14 09:11:33.331765+00	senior
325	BE0299	พนักงานทดสอบ 0299	bulk.emp0299@example.com	$2a$10$RENWHz8u.nf6tfcYyQTpf.ONjtsijRstDX.i9iSyCyHytq9kBFcwi	employee	พัฒนาซอฟต์แวร์	QA Engineer	26	t	2026-10-14 09:11:33.403146+00	2026-10-14 09:11:33.403146+00	lead
326	BE0300	พนักงานทดสอบ 0300	bulk.emp0300@example.com	$2a$10$GjyU97q1wNZq0OxR9RmUp.P34cyhY/536Ohg15pL7ELUpBmi59/qS	employee	พัฒนาซอฟต์แวร์	Software Engineer	26	t	2026-10-14 09:11:33.477206+00	2026-10-14 09:11:33.477206+00	junior
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 403, true);


--
-- Name: bonus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bonus_id_seq', 308, true);


--
-- Name: criteria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.criteria_id_seq', 16, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.departments_id_seq', 7, true);


--
-- Name: evaluation_cycles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.evaluation_cycles_id_seq', 3, true);


--
-- Name: evaluation_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.evaluation_scores_id_seq', 2518, true);


--
-- Name: evaluations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.evaluations_id_seq', 676, true);


--
-- Name: levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.levels_id_seq', 4, true);


--
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.positions_id_seq', 10, true);


--
-- Name: promotion_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.promotion_requests_id_seq', 1, false);


--
-- Name: salary_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.salary_records_id_seq', 326, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tasks_id_seq', 5800, true);


--
-- Name: training_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.training_plans_id_seq', 1, false);


--
-- Name: transfer_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transfer_requests_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 326, true);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: bonus bonus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bonus
    ADD CONSTRAINT bonus_pkey PRIMARY KEY (id);


--
-- Name: criteria criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.criteria
    ADD CONSTRAINT criteria_pkey PRIMARY KEY (id);


--
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: evaluation_cycles evaluation_cycles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_cycles
    ADD CONSTRAINT evaluation_cycles_pkey PRIMARY KEY (id);


--
-- Name: evaluation_scores evaluation_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_scores
    ADD CONSTRAINT evaluation_scores_pkey PRIMARY KEY (id);


--
-- Name: evaluations evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (id);


--
-- Name: levels levels_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_name_key UNIQUE (name);


--
-- Name: levels levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (id);


--
-- Name: positions positions_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_name_key UNIQUE (name);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: promotion_requests promotion_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_requests
    ADD CONSTRAINT promotion_requests_pkey PRIMARY KEY (id);


--
-- Name: salary_records salary_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: training_plans training_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_plans
    ADD CONSTRAINT training_plans_pkey PRIMARY KEY (id);


--
-- Name: transfer_requests transfer_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfer_requests
    ADD CONSTRAINT transfer_requests_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_audit_logs_entity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_entity_id ON public.audit_logs USING btree (entity_id);


--
-- Name: idx_audit_logs_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_user_id ON public.audit_logs USING btree (user_id);


--
-- Name: idx_bonus_cycle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bonus_cycle_id ON public.bonus USING btree (cycle_id);


--
-- Name: idx_bonus_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bonus_employee_id ON public.bonus USING btree (employee_id);


--
-- Name: idx_bonus_evaluation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_bonus_evaluation_id ON public.bonus USING btree (evaluation_id);


--
-- Name: idx_criteria_department; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_criteria_department ON public.criteria USING btree (department);


--
-- Name: idx_cycle_employee_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_cycle_employee_type ON public.evaluations USING btree (cycle_id, employee_id, type);


--
-- Name: idx_evaluation_scores_evaluation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evaluation_scores_evaluation_id ON public.evaluation_scores USING btree (evaluation_id);


--
-- Name: idx_evaluations_evaluator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evaluations_evaluator_id ON public.evaluations USING btree (evaluator_id);


--
-- Name: idx_promotion_evaluation; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_promotion_evaluation ON public.promotion_requests USING btree (evaluation_id);


--
-- Name: idx_promotion_requests_cycle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotion_requests_cycle_id ON public.promotion_requests USING btree (cycle_id);


--
-- Name: idx_promotion_requests_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_promotion_requests_employee_id ON public.promotion_requests USING btree (employee_id);


--
-- Name: idx_salary_emp_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_salary_emp_date ON public.salary_records USING btree (employee_id, effective_date);


--
-- Name: idx_task_emp_due; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_task_emp_due ON public.tasks USING btree (employee_id, due_date);


--
-- Name: idx_training_plans_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_training_plans_employee_id ON public.training_plans USING btree (employee_id);


--
-- Name: idx_training_plans_evaluation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_training_plans_evaluation_id ON public.training_plans USING btree (evaluation_id);


--
-- Name: idx_transfer_evaluation; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_transfer_evaluation ON public.transfer_requests USING btree (evaluation_id);


--
-- Name: idx_transfer_requests_cycle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transfer_requests_cycle_id ON public.transfer_requests USING btree (cycle_id);


--
-- Name: idx_transfer_requests_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transfer_requests_employee_id ON public.transfer_requests USING btree (employee_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_employee_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_users_employee_code ON public.users USING btree (employee_code);


--
-- Name: idx_users_manager_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_manager_id ON public.users USING btree (manager_id);


--
-- Name: evaluation_scores fk_evaluations_scores; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.evaluation_scores
    ADD CONSTRAINT fk_evaluations_scores FOREIGN KEY (evaluation_id) REFERENCES public.evaluations(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict uaHQaqe9CUWob9FlN1TXuTCi7ecG8llU4AV2G0EzKpfVmXIDTTz6b8pxIzGeM3u

