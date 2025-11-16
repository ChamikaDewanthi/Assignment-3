--
-- PostgreSQL database dump
--

\restrict 1yy5fjbnbjvnqBtducNPpRo3v0IiukDFUNI393CGvSkjKLqJhqIvFnJKFhKzyWr

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-16 18:49:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16462)
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    record_id integer NOT NULL,
    employee_id integer,
    date text,
    status text,
    hours_work integer
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16468)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    department_id integer NOT NULL,
    department_name text,
    location text,
    manager_name text,
    extension integer
);


ALTER TABLE public.department OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16456)
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    employee_id integer NOT NULL,
    name text,
    age integer,
    department_id integer,
    email text,
    phone text,
    job_title text
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16465)
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    project_id integer NOT NULL,
    project_name text,
    department_id integer,
    budget integer,
    start_date text,
    end_date text
);


ALTER TABLE public.project OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16459)
-- Name: salary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salary (
    employee_id integer,
    base_salary integer,
    bonus integer,
    tax_rate integer,
    pay_grade integer
);


ALTER TABLE public.salary OWNER TO postgres;

--
-- TOC entry 5028 (class 0 OID 16462)
-- Dependencies: 221
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (record_id, employee_id, date, status, hours_work) FROM stdin;
1	8	3/24/2025	Leave	8
2	15	1/5/2025	Leave	2
3	15	3/21/2025	Leave	0
4	23	9/9/2025	Absent	3
5	13	11/13/2025	Remote	9
6	13	2/23/2025	Absent	5
7	1	3/8/2025	Remote	0
8	27	6/28/2025	Remote	6
9	22	3/13/2025	Leave	7
10	12	2/9/2025	Absent	9
11	23	6/12/2025	Present	1
12	17	7/18/2025	Present	8
13	17	4/9/2025	Absent	7
14	4	8/25/2025	Present	6
15	6	7/12/2025	Leave	7
16	25	7/22/2025	Present	1
\.


--
-- TOC entry 5030 (class 0 OID 16468)
-- Dependencies: 223
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (department_id, department_name, location, manager_name, extension) FROM stdin;
1	Bookseller Dept	Robinsonberg	Brian Colon	8461
2	Petroleum Dept	Micheleland	John Miller Jr.	4245
3	Arboriculturist Dept	Port Angela	Amber Santiago	9115
4	Accountant, Dept	Jonathanshire	Jason Hanna	9853
5	Air Dept	East Susan	Terri Hanson	9372
6	Engineer, Dept	East Angelaland	Anthony Barton	3935
7	Runner, Dept	Simsfurt	Tammy Lee	6790
8	Librarian, Dept	Brookshaven	Brittney Marshall	7381
9	Metallurgist Dept	Justinstad	Lisa Williams	6832
10	Astronomer Dept	Lake Markfort	Douglas Smith	6897
11	Social Dept	Adamsview	Amanda Carpenter	3580
12	Horticultural Dept	Armstrongland	Brianna Mcdonald	5128
13	Optometrist Dept	Wolfeshire	Sara Roberts	1822
14	Patent Dept	East Laura	Alexis Morales	4024
15	Surveyor, Dept	Hillfurt	Ms. Cynthia Dominguez PhD	1755
\.


--
-- TOC entry 5026 (class 0 OID 16456)
-- Dependencies: 219
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (employee_id, name, age, department_id, email, phone, job_title) FROM stdin;
1	Tiffany Sutton	48	29	mary96@gmail.com	001-210-865-2226x8889	Translator
2	Judy Riley	59	9	dmorris@lang.com	988-089-8848x3594	Garment/textile technologist
3	Francisco Mendez MD	29	1	judyperkins@thompson.biz	-10816	Petroleum engineer
4	Nicholas Edwards	26	26	tony95@hotmail.com	903-374-3438x734	Jewellery designer
5	Michael Robinson	53	1	judithdennis@hotmail.com	756.504.3253x195	Accommodation manager
6	Katherine Roberts	29	25	owalls@hotmail.com	524-018-8574x45841	Historic buildings inspector/conservation officer
7	Suzanne Lawrence	58	25	alex16@gmail.com	(449)615-4895	Risk analyst
8	Michael Williams	26	30	ksoto@yahoo.com	543-466-8246x9491	Textile designer
9	Christine Hester	23	21	humphreyjoseph@taylor-lewis.net	(744)388-9286	Armed forces logistics/support/administrative officer
10	Valerie Houston	37	10	julie21@carlson.biz	(965)772-5990	Chief Marketing Officer
11	Sharon Davila	38	8	rojasjames@gmail.com	(766)612-9150	Chartered loss adjuster
12	Pamela Lopez	56	9	qcoleman@yahoo.com	395-571-4454x1777	Engineer, technical sales
13	Angel Perez	44	8	shannon43@chang.com	+1-623-709-9114x21847	Surveyor, mining
14	Austin Lewis	49	27	amber57@todd.net	802.546.8774	Mudlogger
16	Ashley Fisher	34	23	asingleton@hotmail.com	593.859.3052x94404	Engineer, manufacturing systems
15	Danny Cook	29	16	martinwilliam@hooper.com	+1-328-374-3736x883	Scientist, audiological
\.


--
-- TOC entry 5029 (class 0 OID 16465)
-- Dependencies: 222
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (project_id, project_name, department_id, budget, start_date, end_date) FROM stdin;
1	Project Law	19	46687	11/6/2020	4/4/2025
2	Project Gas	28	137455	11/19/2020	11/3/2024
3	Project Response	28	95143	11/13/2023	7/10/2025
4	Project When	15	178925	7/10/2024	11/29/2022
5	Project Shake	24	31615	11/19/2020	2/20/2021
6	Project Institution	10	112524	5/23/2021	5/4/2025
7	Project Top	27	123853	12/14/2022	8/5/2021
8	Project Argue	1	78939	5/1/2024	9/11/2020
9	Project Something	17	47926	11/30/2020	6/24/2021
10	Project Level	6	20486	1/8/2024	5/8/2022
11	Project Remember	16	23918	3/9/2022	5/23/2025
12	Project Already	14	85273	10/30/2022	1/23/2024
13	Project Natural	27	81786	11/13/2022	6/15/2020
14	Project Get	25	77622	6/6/2025	9/4/2021
15	Project Century	19	195119	10/20/2021	7/1/2024
16	Project Write	2	46979	6/24/2025	10/27/2025
\.


--
-- TOC entry 5027 (class 0 OID 16459)
-- Dependencies: 220
-- Data for Name: salary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salary (employee_id, base_salary, bonus, tax_rate, pay_grade) FROM stdin;
1	111206	2777	23	2
2	40464	7019	19	1
3	32100	13049	29	1
4	84693	5847	23	3
5	53207	12385	28	4
6	40245	5115	26	3
7	69529	6368	13	3
8	36211	11026	22	4
9	38398	3047	10	2
10	67830	9225	24	4
11	36842	4826	26	3
12	38104	6382	28	1
13	70782	7107	27	1
14	80487	5000	26	3
15	58830	11541	29	4
16	103769	5621	10	4
\.


--
-- TOC entry 4874 (class 2606 OID 16478)
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (record_id);


--
-- TOC entry 4878 (class 2606 OID 16483)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (department_id);


--
-- TOC entry 4872 (class 2606 OID 16488)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 4876 (class 2606 OID 16493)
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (project_id);


-- Completed on 2025-11-16 18:49:56

--
-- PostgreSQL database dump complete
--

\unrestrict 1yy5fjbnbjvnqBtducNPpRo3v0IiukDFUNI393CGvSkjKLqJhqIvFnJKFhKzyWr

