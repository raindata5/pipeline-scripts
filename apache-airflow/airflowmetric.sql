--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Ubuntu 13.5-2.pgdg20.04+1)
-- Dumped by pg_dump version 13.5 (Ubuntu 13.5-2.pgdg20.04+1)

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dag_history_daily; Type: TABLE; Schema: public; Owner: raindata5
--

CREATE TABLE public.dag_history_daily (
    execution_date date,
    dag_id character varying(250),
    dag_state character varying(250),
    runtime_seconds numeric(12,4),
    dag_run_count integer
);


ALTER TABLE public.dag_history_daily OWNER TO raindata5;

--
-- Name: dag_run_history; Type: TABLE; Schema: public; Owner: raindata5
--

CREATE TABLE public.dag_run_history (
    id integer,
    dag_id character varying(250),
    execution_date timestamp with time zone,
    state character varying(250),
    run_id character varying(250),
    external_trigger boolean,
    end_date timestamp with time zone,
    start_date timestamp with time zone
);


ALTER TABLE public.dag_run_history OWNER TO raindata5;

--
-- Name: stateabbreviations; Type: TABLE; Schema: public; Owner: raindata5
--

CREATE TABLE public.stateabbreviations (
    us_state text,
    postal_abbreviation text
);


ALTER TABLE public.stateabbreviations OWNER TO raindata5;

--
-- Name: stateabbreviations2; Type: TABLE; Schema: public; Owner: raindata5
--

CREATE TABLE public.stateabbreviations2 (
    us_state text,
    postal_abbreviation text
);


ALTER TABLE public.stateabbreviations2 OWNER TO raindata5;

--
-- Name: validation_run_history; Type: TABLE; Schema: public; Owner: raindata5
--

CREATE TABLE public.validation_run_history (
    script_1 character varying(255),
    script_2 character varying(255),
    comp_operator character varying(10),
    test_result character varying(20),
    test_run_at timestamp without time zone
);


ALTER TABLE public.validation_run_history OWNER TO raindata5;

--
-- Name: validator_summary_daily; Type: TABLE; Schema: public; Owner: raindata5
--

CREATE TABLE public.validator_summary_daily (
    test_date date,
    script_1 character varying(255),
    script_2 character varying(255),
    comp_operator character varying(10),
    test_composite_name character varying(800),
    test_result character varying(20),
    test_count integer
);


ALTER TABLE public.validator_summary_daily OWNER TO raindata5;

--
-- Data for Name: dag_history_daily; Type: TABLE DATA; Schema: public; Owner: raindata5
--

COPY public.dag_history_daily (execution_date, dag_id, dag_state, runtime_seconds, dag_run_count) FROM stdin;
2021-12-20	apache_airflow_perf	success	161.3842	1
2021-12-21	elt_validation	success	651.7272	3
2021-12-20	elt_validation	failed	91.8631	1
2021-12-15	elt_validation	failed	158.6561	3
2021-12-24	elt_validation	failed	735.3215	6
2021-12-18	apache_airflow_perf	failed	28.6000	1
2021-12-17	elt_validation	success	126.7476	3
2021-12-22	elt_validation	failed	379.9627	2
2021-12-18	elt_validation	failed	452.5416	8
2021-12-13	simple_dag	success	354.6866	2
2021-12-12	simple_dag	success	111.6880	1
2021-12-18	elt_validation	success	208.2406	2
2021-12-11	simple_dag	success	197.7463	1
2021-12-22	apache_airflow_perf	failed	379.8011	2
2021-12-21	apache_airflow_perf	failed	425.0524	2
2021-12-19	elt_validation	success	196.4781	1
2021-12-14	simple_dag	success	78.5565	1
2021-12-14	elt_validation	failed	28.6156	1
2021-12-20	apache_airflow_perf	failed	650.3162	10
2021-12-16	elt_validation	failed	468.8490	13
2021-12-24	elt_validation	success	1108.1854	3
2021-12-17	elt_validation	failed	116.5881	2
2021-12-16	elt_validation	success	126.6576	3
2021-12-21	apache_airflow_perf	success	256.0877	1
2021-12-24	apache_airflow_perf	success	230.6527	1
2021-12-24	apache_airflow_perf	failed	419.6012	4
\.


--
-- Data for Name: dag_run_history; Type: TABLE DATA; Schema: public; Owner: raindata5
--

COPY public.dag_run_history (id, dag_id, execution_date, state, run_id, external_trigger, end_date, start_date) FROM stdin;
6	elt_validation	2021-12-14 19:00:00-05	failed	scheduled__2021-12-15T00:00:00+00:00	f	2021-12-15 22:02:44.681245-05	2021-12-15 22:02:16.06565-05
21	elt_validation	2021-12-16 22:54:53.867049-05	failed	manual__2021-12-17T03:54:53.867049+00:00	t	2021-12-16 22:55:38.434781-05	2021-12-16 22:54:54.144206-05
19	elt_validation	2021-12-16 22:49:15.391795-05	failed	manual__2021-12-17T03:49:15.391795+00:00	t	2021-12-16 22:49:57.714432-05	2021-12-16 22:49:15.511365-05
20	elt_validation	2021-12-16 22:51:40.558223-05	failed	manual__2021-12-17T03:51:40.558223+00:00	t	2021-12-16 22:52:21.187651-05	2021-12-16 22:51:40.888619-05
2	simple_dag	2021-12-11 19:00:00-05	success	scheduled__2021-12-12T00:00:00+00:00	f	2021-12-13 14:08:31.689975-05	2021-12-13 14:05:13.943629-05
1	simple_dag	2021-12-13 13:38:23.582779-05	success	manual__2021-12-13T18:38:23.582779+00:00	t	2021-12-13 14:09:12.176498-05	2021-12-13 14:05:13.944091-05
23	elt_validation	2021-12-16 23:01:44.075009-05	success	manual__2021-12-17T04:01:44.075009+00:00	t	2021-12-16 23:02:27.319017-05	2021-12-16 23:01:44.937381-05
3	simple_dag	2021-12-12 19:00:00-05	success	scheduled__2021-12-13T00:00:00+00:00	f	2021-12-14 11:45:53.069313-05	2021-12-14 11:44:01.381317-05
4	simple_dag	2021-12-13 19:00:00-05	success	scheduled__2021-12-14T00:00:00+00:00	f	2021-12-15 16:57:05.694814-05	2021-12-15 16:55:09.240574-05
22	elt_validation	2021-12-16 22:59:48.687765-05	failed	manual__2021-12-17T03:59:48.687765+00:00	t	2021-12-16 23:00:32.400146-05	2021-12-16 22:59:48.868739-05
25	elt_validation	2021-12-16 23:46:31.073236-05	success	manual__2021-12-17T04:46:31.073236+00:00	t	2021-12-16 23:47:11.467596-05	2021-12-16 23:46:31.37826-05
5	simple_dag	2021-12-14 19:00:00-05	success	scheduled__2021-12-15T00:00:00+00:00	f	2021-12-15 19:01:18.899907-05	2021-12-15 19:00:00.343391-05
24	elt_validation	2021-12-16 23:35:20.275857-05	success	manual__2021-12-17T04:35:20.275857+00:00	t	2021-12-16 23:36:05.301872-05	2021-12-16 23:35:21.1152-05
7	elt_validation	2021-12-15 22:11:32.240237-05	failed	manual__2021-12-16T03:11:32.240237+00:00	t	2021-12-15 22:12:16.385797-05	2021-12-15 22:11:33.022523-05
26	elt_validation	2021-12-17 00:19:22.172317-05	success	manual__2021-12-17T05:19:22.172317+00:00	t	2021-12-17 00:20:01.154265-05	2021-12-17 00:19:23.347659-05
8	elt_validation	2021-12-15 22:51:47.892063-05	failed	manual__2021-12-16T03:51:47.892063+00:00	t	2021-12-15 22:52:30.022138-05	2021-12-15 22:51:48.670727-05
27	elt_validation	2021-12-17 00:21:42.665217-05	success	manual__2021-12-17T05:21:42.665217+00:00	t	2021-12-17 00:22:23.087596-05	2021-12-17 00:21:43.059805-05
9	elt_validation	2021-12-15 19:00:00-05	failed	scheduled__2021-12-16T00:00:00+00:00	f	2021-12-16 19:01:14.906799-05	2021-12-16 19:00:00.965364-05
10	elt_validation	2021-12-16 21:44:58.08194-05	failed	manual__2021-12-17T02:44:58.081940+00:00	t	2021-12-16 21:45:26.881713-05	2021-12-16 21:44:59.034761-05
28	elt_validation	2021-12-17 00:26:26.217134-05	success	manual__2021-12-17T05:26:26.217134+00:00	t	2021-12-17 00:27:15.433751-05	2021-12-17 00:26:26.520596-05
11	elt_validation	2021-12-16 21:46:42.810467-05	failed	manual__2021-12-17T02:46:42.810467+00:00	t	2021-12-16 21:47:03.332394-05	2021-12-16 21:46:43.259496-05
29	elt_validation	2021-12-17 00:28:26.482269-05	failed	manual__2021-12-17T05:28:26.482269+00:00	t	2021-12-17 00:29:16.246572-05	2021-12-17 00:28:26.759149-05
12	elt_validation	2021-12-16 22:00:01.00425-05	failed	manual__2021-12-17T03:00:01.004250+00:00	t	2021-12-16 22:00:20.9521-05	2021-12-16 22:00:01.357143-05
13	elt_validation	2021-12-16 22:10:37.161626-05	failed	manual__2021-12-17T03:10:37.161626+00:00	t	2021-12-16 22:11:02.87582-05	2021-12-16 22:10:38.174798-05
14	elt_validation	2021-12-16 22:14:13.867474-05	failed	manual__2021-12-17T03:14:13.867474+00:00	t	2021-12-16 22:14:37.296697-05	2021-12-16 22:14:14.507095-05
15	elt_validation	2021-12-16 22:28:46.132568-05	failed	manual__2021-12-17T03:28:46.132568+00:00	t	2021-12-16 22:29:48.208643-05	2021-12-16 22:28:46.54845-05
16	elt_validation	2021-12-16 22:38:00.225058-05	failed	manual__2021-12-17T03:38:00.225058+00:00	t	2021-12-16 22:38:44.51907-05	2021-12-16 22:38:00.744306-05
17	elt_validation	2021-12-16 22:44:12.818908-05	failed	manual__2021-12-17T03:44:12.818908+00:00	t	2021-12-16 22:44:51.855213-05	2021-12-16 22:44:13.891113-05
18	elt_validation	2021-12-16 22:46:40.55093-05	failed	manual__2021-12-17T03:46:40.550930+00:00	t	2021-12-16 22:47:21.108125-05	2021-12-16 22:46:40.987706-05
32	elt_validation	2021-12-18 21:37:31.647251-05	failed	manual__2021-12-19T02:37:31.647251+00:00	t	2021-12-18 21:38:17.314555-05	2021-12-18 21:37:32.343878-05
33	elt_validation	2021-12-18 21:39:33.438695-05	failed	manual__2021-12-19T02:39:33.438695+00:00	t	2021-12-18 21:40:19.43178-05	2021-12-18 21:39:33.81622-05
34	elt_validation	2021-12-18 21:42:45.265845-05	failed	manual__2021-12-19T02:42:45.265845+00:00	t	2021-12-18 21:43:33.481989-05	2021-12-18 21:42:46.3563-05
35	elt_validation	2021-12-18 21:47:03.351236-05	failed	manual__2021-12-19T02:47:03.351236+00:00	t	2021-12-18 21:47:52.720207-05	2021-12-18 21:47:04.523659-05
30	elt_validation	2021-12-17 19:00:00-05	failed	scheduled__2021-12-18T00:00:00+00:00	f	2021-12-18 19:41:29.537415-05	2021-12-18 19:40:22.43671-05
31	elt_validation	2021-12-18 21:31:47.637011-05	failed	manual__2021-12-19T02:31:47.637011+00:00	t	2021-12-18 21:32:37.223441-05	2021-12-18 21:31:49.136278-05
36	elt_validation	2021-12-18 21:51:43.996623-05	failed	manual__2021-12-19T02:51:43.996623+00:00	t	2021-12-18 21:53:09.724668-05	2021-12-18 21:51:45.155157-05
42	apache_airflow_perf	2021-12-20 15:23:43.386084-05	failed	manual__2021-12-20T20:23:43.386084+00:00	t	2021-12-20 15:24:14.159316-05	2021-12-20 15:23:43.576403-05
37	elt_validation	2021-12-18 21:54:53.668039-05	failed	manual__2021-12-19T02:54:53.668039+00:00	t	2021-12-18 21:56:39.116696-05	2021-12-18 21:54:53.968003-05
38	elt_validation	2021-12-18 21:57:49.306353-05	failed	manual__2021-12-19T02:57:49.306353+00:00	t	2021-12-18 21:58:18.591017-05	2021-12-18 21:57:49.763233-05
39	elt_validation	2021-12-18 22:01:16.160639-05	success	manual__2021-12-19T03:01:16.160639+00:00	t	2021-12-18 22:06:02.028269-05	2021-12-18 22:04:06.523073-05
40	elt_validation	2021-12-18 19:00:00-05	success	scheduled__2021-12-19T00:00:00+00:00	f	2021-12-19 20:42:01.337178-05	2021-12-19 20:40:28.601803-05
41	apache_airflow_perf	2021-12-18 19:00:00-05	failed	scheduled__2021-12-19T00:00:00+00:00	f	2021-12-20 15:19:27.487404-05	2021-12-20 15:18:58.8874-05
43	apache_airflow_perf	2021-12-20 15:32:27.514174-05	failed	manual__2021-12-20T20:32:27.514174+00:00	t	2021-12-20 15:33:26.059524-05	2021-12-20 15:32:27.702684-05
44	apache_airflow_perf	2021-12-20 15:35:56.905677-05	failed	manual__2021-12-20T20:35:56.905677+00:00	t	2021-12-20 15:36:49.63501-05	2021-12-20 15:35:56.993556-05
45	apache_airflow_perf	2021-12-20 16:15:22.150819-05	failed	manual__2021-12-20T21:15:22.150819+00:00	t	2021-12-20 16:16:23.470726-05	2021-12-20 16:15:23.95322-05
46	apache_airflow_perf	2021-12-20 16:21:52.335468-05	failed	manual__2021-12-20T21:21:52.335468+00:00	t	2021-12-20 16:22:56.742207-05	2021-12-20 16:21:52.879923-05
47	apache_airflow_perf	2021-12-20 16:25:48.086433-05	failed	manual__2021-12-20T21:25:48.086433+00:00	t	2021-12-20 16:26:45.034243-05	2021-12-20 16:25:48.695631-05
48	apache_airflow_perf	2021-12-20 16:36:22.138123-05	failed	manual__2021-12-20T21:36:22.138123+00:00	t	2021-12-20 16:37:39.136063-05	2021-12-20 16:36:22.390085-05
50	elt_validation	2021-12-19 19:00:00-05	success	scheduled__2021-12-20T00:00:00+00:00	f	2021-12-20 19:03:16.670699-05	2021-12-20 19:00:00.192584-05
51	apache_airflow_perf	2021-12-20 19:04:45.87582-05	failed	manual__2021-12-21T00:04:45.875820+00:00	t	2021-12-20 19:06:00.365368-05	2021-12-20 19:04:46.130931-05
52	apache_airflow_perf	2021-12-20 19:11:46.09517-05	failed	manual__2021-12-21T00:11:46.095170+00:00	t	2021-12-20 19:13:12.412629-05	2021-12-20 19:11:46.212143-05
53	apache_airflow_perf	2021-12-20 19:14:22.934993-05	success	manual__2021-12-21T00:14:22.934993+00:00	t	2021-12-20 19:17:05.204384-05	2021-12-20 19:14:23.820174-05
54	apache_airflow_perf	2021-12-20 19:00:00-05	failed	scheduled__2021-12-21T00:00:00+00:00	f	2021-12-21 20:27:41.52875-05	2021-12-21 20:26:09.693094-05
55	elt_validation	2021-12-20 19:00:00-05	failed	scheduled__2021-12-21T00:00:00+00:00	f	2021-12-21 20:27:41.556675-05	2021-12-21 20:26:09.693555-05
56	apache_airflow_perf	2021-12-21 21:02:59.484366-05	success	manual__2021-12-22T02:02:59.484366+00:00	t	2021-12-21 21:07:16.785116-05	2021-12-21 21:03:00.697405-05
57	elt_validation	2021-12-21 21:03:10.210504-05	success	manual__2021-12-22T02:03:10.210504+00:00	t	2021-12-21 21:07:16.750401-05	2021-12-21 21:03:30.116071-05
58	apache_airflow_perf	2021-12-21 19:00:00-05	failed	scheduled__2021-12-22T00:00:00+00:00	f	2021-12-22 21:40:29.538818-05	2021-12-22 21:36:57.012615-05
59	elt_validation	2021-12-21 19:00:00-05	success	scheduled__2021-12-22T00:00:00+00:00	f	2021-12-22 21:40:29.559367-05	2021-12-22 21:36:57.012921-05
60	apache_airflow_perf	2021-12-22 19:00:00-05	failed	scheduled__2021-12-23T00:00:00+00:00	f	2021-12-24 11:25:37.326779-05	2021-12-24 11:22:27.426233-05
61	elt_validation	2021-12-22 19:00:00-05	failed	scheduled__2021-12-23T00:00:00+00:00	f	2021-12-24 11:25:37.407922-05	2021-12-24 11:22:27.426571-05
62	elt_validation	2021-12-24 13:21:19.668239-05	failed	manual__2021-12-24T18:21:19.668239+00:00	t	2021-12-24 13:24:47.846081-05	2021-12-24 13:21:27.675252-05
63	apache_airflow_perf	2021-12-24 13:21:34.164637-05	failed	manual__2021-12-24T18:21:34.164637+00:00	t	2021-12-24 13:24:49.129823-05	2021-12-24 13:22:41.016665-05
64	apache_airflow_perf	2021-12-24 13:40:03.531449-05	failed	manual__2021-12-24T18:40:03.531449+00:00	t	2021-12-24 13:41:28.860724-05	2021-12-24 13:40:07.173292-05
58	apache_airflow_perf	2021-12-21 19:00:00-05	failed	scheduled__2021-12-22T00:00:00+00:00	f	2021-12-22 21:40:29.538818-05	2021-12-22 21:36:57.012615-05
59	elt_validation	2021-12-21 19:00:00-05	success	scheduled__2021-12-22T00:00:00+00:00	f	2021-12-22 21:40:29.559367-05	2021-12-22 21:36:57.012921-05
60	apache_airflow_perf	2021-12-22 19:00:00-05	failed	scheduled__2021-12-23T00:00:00+00:00	f	2021-12-24 11:25:37.326779-05	2021-12-24 11:22:27.426233-05
61	elt_validation	2021-12-22 19:00:00-05	failed	scheduled__2021-12-23T00:00:00+00:00	f	2021-12-24 11:25:37.407922-05	2021-12-24 11:22:27.426571-05
62	elt_validation	2021-12-24 13:21:19.668239-05	failed	manual__2021-12-24T18:21:19.668239+00:00	t	2021-12-24 13:24:47.846081-05	2021-12-24 13:21:27.675252-05
63	apache_airflow_perf	2021-12-24 13:21:34.164637-05	failed	manual__2021-12-24T18:21:34.164637+00:00	t	2021-12-24 13:24:49.129823-05	2021-12-24 13:22:41.016665-05
64	apache_airflow_perf	2021-12-24 13:40:03.531449-05	failed	manual__2021-12-24T18:40:03.531449+00:00	t	2021-12-24 13:41:28.860724-05	2021-12-24 13:40:07.173292-05
65	apache_airflow_perf	2021-12-24 13:57:02.302381-05	success	manual__2021-12-24T18:57:02.302381+00:00	t	2021-12-24 14:00:54.59259-05	2021-12-24 13:57:03.939872-05
66	elt_validation	2021-12-24 13:57:10.375646-05	failed	manual__2021-12-24T18:57:10.375646+00:00	t	2021-12-24 14:00:54.549958-05	2021-12-24 13:57:53.871781-05
67	elt_validation	2021-12-24 14:23:54.790897-05	failed	manual__2021-12-24T19:23:54.790897+00:00	t	2021-12-24 14:24:35.921861-05	2021-12-24 14:23:55.329239-05
68	elt_validation	2021-12-24 15:04:57.174227-05	failed	manual__2021-12-24T20:04:57.174227+00:00	t	2021-12-24 15:05:45.64917-05	2021-12-24 15:05:00.833012-05
69	elt_validation	2021-12-24 15:13:01.22606-05	failed	manual__2021-12-24T20:13:01.226060+00:00	t	2021-12-24 15:14:12.2378-05	2021-12-24 15:13:03.344951-05
70	elt_validation	2021-12-24 15:30:07.464559-05	success	manual__2021-12-24T20:30:07.464559+00:00	t	2021-12-24 15:32:57.814025-05	2021-12-24 15:30:11.412827-05
72	elt_validation	2021-12-24 19:00:00-05	success	scheduled__2021-12-25T00:00:00+00:00	f	2021-12-26 19:03:14.857133-05	2021-12-26 18:55:23.965052-05
72	elt_validation	2021-12-24 19:00:00-05	success	scheduled__2021-12-25T00:00:00+00:00	f	2021-12-26 19:03:14.857133-05	2021-12-26 18:55:23.965052-05
74	elt_validation	2021-12-25 19:00:00-05	success	scheduled__2021-12-26T00:00:00+00:00	f	2021-12-26 19:07:21.204889-05	2021-12-26 19:00:44.890494-05
73	apache_airflow_perf	2021-12-25 19:00:00-05	success	scheduled__2021-12-26T00:00:00+00:00	f	2021-12-26 19:07:56.706946-05	2021-12-26 19:00:44.88709-05
\.


--
-- Data for Name: stateabbreviations; Type: TABLE DATA; Schema: public; Owner: raindata5
--

COPY public.stateabbreviations (us_state, postal_abbreviation) FROM stdin;
\.


--
-- Data for Name: stateabbreviations2; Type: TABLE DATA; Schema: public; Owner: raindata5
--

COPY public.stateabbreviations2 (us_state, postal_abbreviation) FROM stdin;
Alabama	AL
Alaska	AK
Arizona	AZ
Arkansas	AR
California	CA
Colorado	CO
Connecticut	CT
Delaware	DE
Florida	FL
Georgia	GA
Hawaii	HI
Idaho	ID
Illinois	IL
Indiana	IN
Iowa	IA
Kansas	KS
Kentucky	KY
Louisiana	LA
Maine	ME
Maryland	MD
Massachusetts	MA
Michigan	MI
Minnesota	MN
Mississippi	MS
Missouri	MO
Montana	MT
Nebraska	NE
Nevada	NV
New Hampshire	NH
New Jersey	NJ
New Mexico	NM
New York	NY
North Carolina	NC
North Dakota	ND
Ohio	OH
Oklahoma	OK
Oregon	OR
Pennsylvania	PA
Rhode Island	RI
South Carolina	SC
South Dakota	SD
Tennessee	TN
Texas	TX
Utah	UT
Vermont	VT
Virginia	VA
Washington	WA
West Virginia	WV
Wisconsin	WI
Wyoming	WY
District of Columbia	DC
Guam	GU
Marshall Islands	MH
Northern Mariana Island	MP
Puerto Rico	PR
Virgin Islands	VI
\.


--
-- Data for Name: validation_run_history; Type: TABLE DATA; Schema: public; Owner: raindata5
--

COPY public.validation_run_history (script_1, script_2, comp_operator, test_result, test_run_at) FROM stdin;
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	false	2021-12-18 21:04:57.919594
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	false	2021-12-18 21:15:24.757623
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-18 21:15:25.230959
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	false	2021-12-18 21:16:42.734343
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-18 21:16:44.320943
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-18 21:53:06.231387
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-18 21:53:07.257538
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-18 21:54:37.360947
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-18 21:54:37.822116
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-18 21:56:13.33962
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-18 21:56:14.034367
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-18 22:05:40.006161
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-18 22:05:40.387835
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-19 20:41:38.334834
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-19 20:41:38.725379
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	true	2021-12-20 19:01:58.318303
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-20 19:02:50.549041
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-20 19:02:51.030497
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	true	2021-12-21 21:04:59.248649
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-21 21:05:58.478389
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-21 21:05:59.152551
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	true	2021-12-22 21:39:41.301954
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-22 21:40:02.474892
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-22 21:40:02.896029
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	true	2021-12-24 15:31:30.85532
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-24 15:32:17.009584
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-24 15:32:17.664798
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	true	2021-12-26 18:59:23.842452
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-26 19:00:42.719408
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-26 19:00:43.342664
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	true	2021-12-26 19:04:20.259376
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2021-12-26 19:05:54.666263
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2021-12-26 19:05:55.480558
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	true	2022-01-01 11:04:41.392593
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2022-01-01 11:05:13.302712
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2022-01-01 11:05:13.871565
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	false	2022-01-01 12:48:14.782621
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	true	2022-01-01 12:48:42.655027
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2022-01-01 12:48:43.158162
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	false	2022-01-01 13:06:26.563023
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	false	2022-01-01 13:06:58.012778
/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	true	2022-01-01 13:06:58.530351
\.


--
-- Data for Name: validator_summary_daily; Type: TABLE DATA; Schema: public; Owner: raindata5
--

COPY public.validator_summary_daily (test_date, script_1, script_2, comp_operator, test_composite_name, test_result, test_count) FROM stdin;
2021-12-26	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql equals	true	2
2021-12-24	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	true	1
2021-12-18	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	false	3
2021-12-19	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql _ _	true	1
2021-12-20	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	true	1
2021-12-18	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql _ _	true	6
2021-12-24	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql _ _	true	1
2021-12-21	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql _ _	true	1
2021-12-20	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql equals	true	1
2021-12-22	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql equals	true	1
2021-12-26	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql _ _	true	2
2021-12-20	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql _ _	true	1
2021-12-21	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql equals	true	1
2021-12-19	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	true	1
2021-12-22	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups2.sql _ _	true	1
2021-12-22	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	true	1
2021-12-18	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	true	4
2021-12-24	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql	equals	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa.sql /mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa2.sql equals	true	1
2021-12-21	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	true	1
2021-12-26	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql	\N	\N	/mnt/c/Users/Ron/git-repos/pipeline-scripts/apache-airflow/dags/scripts/count_sa_dups1.sql _ _	true	2
\.


--
-- PostgreSQL database dump complete
--

