-- MIXED SCHEMA (Base = Neon, plus Supabase extras)

-- === Begin Neon base schema ===

--
-- PostgreSQL database dump
--


-- Dumped from database version 16.9 (63f4182)
-- Dumped by pg_dump version 17.6 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
--

CREATE TABLE public.accommodations (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    type character varying NOT NULL,
    description text,
    capacity integer NOT NULL,
    amenities text[],
    price_per_night numeric(10,2) NOT NULL,
    image_url character varying,
    is_available boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.accommodations OWNER TO postgres;

--
--

CREATE TABLE public.artist_profiles (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    user_id character varying NOT NULL,
    artist_name character varying,
    specialty character varying,
    bio text,
    portfolio jsonb,
    rating numeric(3,2),
    total_works integer DEFAULT 0,
    is_verified boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.artist_profiles OWNER TO postgres;

--
--

CREATE TABLE public.bookings (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    accommodation_id character varying NOT NULL,
    user_id character varying NOT NULL,
    check_in date NOT NULL,
    check_out date NOT NULL,
    guests integer NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    special_requests text,
    stripe_payment_intent_id character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.bookings OWNER TO postgres;

--
--

CREATE TABLE public.course_enrollments (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    course_id character varying NOT NULL,
    user_id character varying NOT NULL,
    progress integer DEFAULT 0,
    completed_lessons text[] DEFAULT ARRAY[]::text[],
    enrolled_at timestamp without time zone DEFAULT now(),
    completed_at timestamp without time zone
);


ALTER TABLE public.course_enrollments OWNER TO postgres;

--
--

CREATE TABLE public.courses (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    description text,
    category character varying NOT NULL,
    instructor_id character varying NOT NULL,
    duration integer,
    level character varying NOT NULL,
    price numeric(10,2),
    image_url character varying,
    syllabus jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.courses OWNER TO postgres;

--
--

CREATE TABLE public.donations (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    project_id character varying NOT NULL,
    user_id character varying,
    amount numeric(10,2) NOT NULL,
    currency character varying DEFAULT 'EUR'::character varying,
    message text,
    is_anonymous boolean DEFAULT false,
    stripe_payment_intent_id character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.donations OWNER TO postgres;

--
--

CREATE TABLE public.event_registrations (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    event_id character varying NOT NULL,
    user_id character varying NOT NULL,
    status character varying DEFAULT 'registered'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.event_registrations OWNER TO postgres;

--
--

CREATE TABLE public.events (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    description text,
    type character varying NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    location character varying,
    capacity integer,
    price numeric(10,2),
    organizer_id character varying NOT NULL,
    image_url character varying,
    tags text[],
    status character varying DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.events OWNER TO postgres;

--
--

CREATE TABLE public.messages (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    sender_id character varying NOT NULL,
    recipient_id character varying,
    content text NOT NULL,
    type character varying DEFAULT 'text'::character varying NOT NULL,
    is_read boolean DEFAULT false,
    thread_id character varying,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.messages OWNER TO postgres;

--
--

CREATE TABLE public.projects (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    description text,
    category character varying NOT NULL,
    goal_amount numeric(10,2) NOT NULL,
    current_amount numeric(10,2) DEFAULT '0'::numeric,
    currency character varying DEFAULT 'EUR'::character varying,
    deadline date,
    status character varying DEFAULT 'active'::character varying NOT NULL,
    creator_id character varying NOT NULL,
    image_url character varying,
    updates jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.projects OWNER TO postgres;

--
--

CREATE TABLE public.resources (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    type character varying NOT NULL,
    name character varying NOT NULL,
    current_level numeric(5,2) NOT NULL,
    capacity numeric(5,2),
    unit character varying,
    status character varying DEFAULT 'normal'::character varying NOT NULL,
    last_updated timestamp without time zone DEFAULT now(),
    metadata jsonb
);


ALTER TABLE public.resources OWNER TO postgres;

--
--

CREATE TABLE public.sessions (
    sid character varying NOT NULL,
    sess jsonb NOT NULL,
    expire timestamp without time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
--

CREATE TABLE public.users (
    id character varying DEFAULT gen_random_uuid() NOT NULL,
    email character varying,
    first_name character varying,
    last_name character varying,
    profile_image_url character varying,
    role character varying DEFAULT 'visitor'::character varying NOT NULL,
    bio text,
    skills text[],
    interests text[],
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
--

ALTER TABLE ONLY public.accommodations
    ADD CONSTRAINT accommodations_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.artist_profiles
    ADD CONSTRAINT artist_profiles_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT event_registrations_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (sid);


--
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
--

CREATE INDEX "IDX_session_expire" ON public.sessions USING btree (expire);


--
--

ALTER TABLE ONLY public.artist_profiles
    ADD CONSTRAINT artist_profiles_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_accommodation_id_accommodations_id_fk FOREIGN KEY (accommodation_id) REFERENCES public.accommodations(id);


--
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_course_id_courses_id_fk FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
--

ALTER TABLE ONLY public.course_enrollments
    ADD CONSTRAINT course_enrollments_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_instructor_id_users_id_fk FOREIGN KEY (instructor_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_project_id_projects_id_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT event_registrations_event_id_events_id_fk FOREIGN KEY (event_id) REFERENCES public.events(id);


--
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT event_registrations_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_organizer_id_users_id_fk FOREIGN KEY (organizer_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_recipient_id_users_id_fk FOREIGN KEY (recipient_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_users_id_fk FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_creator_id_users_id_fk FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--



--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--



--
-- PostgreSQL database dump complete
--


-- === Add Supabase-only tables ===

-- Table from Supabase only: game_events

CREATE TABLE public.game_events (
    id bigint NOT NULL,
    user_id character varying,
    kind character varying NOT NULL,
    value integer DEFAULT 0,
    meta jsonb,
    at timestamp with time zone DEFAULT now()
);

-- Table from Supabase only: game_inventory

CREATE TABLE public.game_inventory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id character varying,
    item_id character varying NOT NULL,
    qty integer DEFAULT 1,
    acquired_via character varying,
    meta jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);

-- Table from Supabase only: game_leaderboard

CREATE TABLE public.game_leaderboard (
    season integer NOT NULL,
    user_id character varying NOT NULL,
    score integer DEFAULT 0
);

-- Table from Supabase only: game_profiles

CREATE TABLE public.game_profiles (
    user_id character varying NOT NULL,
    handle character varying,
    level integer DEFAULT 1,
    xp integer DEFAULT 0,
    last_login timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);

-- Table from Supabase only: game_rewards_rules

CREATE TABLE public.game_rewards_rules (
    trigger character varying NOT NULL,
    grant_xp integer DEFAULT 0,
    grant_item character varying,
    grant_qty integer DEFAULT 1
);

-- Table from Supabase only: membership_plans

CREATE TABLE public.membership_plans (
    id character varying NOT NULL,
    name character varying NOT NULL,
    monthly_price_cents integer DEFAULT 0 NOT NULL,
    yearly_price_cents integer DEFAULT 0 NOT NULL,
    perks jsonb DEFAULT '{}'::jsonb,
    active boolean DEFAULT true
);

-- Table from Supabase only: ticket_claims

CREATE TABLE public.ticket_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    claim_token character varying,
    donation_id uuid,
    source character varying NOT NULL,
    email character varying NOT NULL,
    user_id character varying,
    project_id integer,
    block_no integer,
    tickets integer NOT NULL,
    claimed boolean DEFAULT false,
    claimed_at timestamp with time zone,
    ip_hash text,
    created_at timestamp with time zone DEFAULT now()
);

-- Table from Supabase only: ticket_tiers

CREATE TABLE public.ticket_tiers (
    amt_eur integer NOT NULL,
    tickets integer NOT NULL
);

-- Table from Supabase only: user_memberships

CREATE TABLE public.user_memberships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id character varying NOT NULL,
    plan_id character varying NOT NULL,
    status character varying(20) NOT NULL,
    started_at timestamp with time zone DEFAULT now(),
    current_period_end timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_memberships_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'canceled'::character varying, 'past_due'::character varying])::text[])))
);

-- === Add Supabase-only columns to common tables ===
ALTER TABLE public.accommodations ADD COLUMN IF NOT EXISTS title character varying NOT NULL;
ALTER TABLE public.artist_profiles ADD COLUMN IF NOT EXISTS links jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.bookings ADD COLUMN IF NOT EXISTS ends_at timestamp with time zone;
ALTER TABLE public.bookings ADD COLUMN IF NOT EXISTS starts_at timestamp with time zone;
ALTER TABLE public.course_enrollments ADD COLUMN IF NOT EXISTS created_at timestamp with time zone DEFAULT now();
ALTER TABLE public.course_enrollments ADD COLUMN IF NOT EXISTS status character varying DEFAULT 'enrolled'::character varying;
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS amount_cents integer NOT NULL;
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS client_reference_id character varying;
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS email character varying NOT NULL;
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS status character varying DEFAULT 'completed'::character varying NOT NULL;
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS stripe_payment_intent character varying;
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS stripe_session_id character varying;
ALTER TABLE public.events ADD COLUMN IF NOT EXISTS ends_at timestamp with time zone;
ALTER TABLE public.events ADD COLUMN IF NOT EXISTS project_id integer;
ALTER TABLE public.events ADD COLUMN IF NOT EXISTS starts_at timestamp with time zone;
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS user_id character varying;
ALTER TABLE public.projects ADD COLUMN IF NOT EXISTS active boolean DEFAULT true;
ALTER TABLE public.projects ADD COLUMN IF NOT EXISTS goal_eur integer;
ALTER TABLE public.projects ADD COLUMN IF NOT EXISTS raised_eur integer DEFAULT 0;
ALTER TABLE public.projects ADD COLUMN IF NOT EXISTS slug character varying NOT NULL;
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS created_at timestamp with time zone DEFAULT now();
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS tags text[];
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS title character varying NOT NULL;
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS url text NOT NULL;
ALTER TABLE public.sessions ADD COLUMN IF NOT EXISTS created_at timestamp with time zone DEFAULT now();
ALTER TABLE public.sessions ADD COLUMN IF NOT EXISTS expires_at timestamp with time zone;
ALTER TABLE public.sessions ADD COLUMN IF NOT EXISTS id character varying NOT NULL;
ALTER TABLE public.sessions ADD COLUMN IF NOT EXISTS provider character varying NOT NULL;
ALTER TABLE public.sessions ADD COLUMN IF NOT EXISTS provider_sub character varying;
ALTER TABLE public.sessions ADD COLUMN IF NOT EXISTS user_id character varying NOT NULL;

-- === Add Supabase foreign keys (where applicable) ===

-- === Add Supabase indexes (where applicable) ===
CREATE INDEX idx_donations_email ON public.donations USING btree (email);
CREATE INDEX idx_donations_user ON public.donations USING btree (user_id);
CREATE INDEX idx_event_registrations_user ON public.event_registrations USING btree (user_id);
CREATE INDEX idx_inv_user ON public.game_inventory USING btree (user_id);
CREATE INDEX idx_sessions_user ON public.sessions USING btree (user_id);
CREATE INDEX idx_ticket_claims_email ON public.ticket_claims USING btree (email);
CREATE INDEX idx_ticket_claims_project ON public.ticket_claims USING btree (project_id);
CREATE INDEX idx_ticket_claims_user ON public.ticket_claims USING btree (user_id);
CREATE INDEX idx_user_memberships_user ON public.user_memberships USING btree (user_id);