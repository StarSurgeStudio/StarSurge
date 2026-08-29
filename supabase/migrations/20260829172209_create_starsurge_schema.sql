/*
# Create StarSurge database schema

Creates three tables for the StarSurge game studio website so its content
(games, team members, contact form submissions) can be stored and managed
in the database instead of being hardcoded into HTML.

1. New Tables

- `games`
  - id (uuid, primary key)
  - title (text, not null) — display name of the game
  - slug (text, unique, not null) — URL-friendly identifier
  - tagline (text) — short one-line description
  - description (text) — longer description shown on detail pages
  - genre (text) — e.g. "Hypercasual, Endless, Calm"
  - status (text, not null) — 'released' or 'upcoming'
  - release_date (date) — when the game was/will be released
  - cover_image_url (text) — cover art URL
  - icon_url (text) — small icon/logo URL
  - homepage_url (text) — link to the game's own page
  - play_store_url (text) — Google Play link
  - itch_io_url (text) — itch.io link
  - trailer_url (text) — YouTube/video embed URL
  - display_order (int, default 0) — controls listing order
  - created_at (timestamptz)

- `team_members`
  - id (uuid, primary key)
  - name (text, not null) — display name (e.g. "Professor Panda")
  - designation (text, not null) — role (e.g. "Game artist")
  - avatar_url (text) — avatar image URL
  - display_order (int, default 0) — controls row/column ordering
  - created_at (timestamptz)

- `contact_messages`
  - id (uuid, primary key)
  - name (text, not null) — submitter's full name
  - email (text, not null) — submitter's email address
  - message (text, not null) — the message body
  - created_at (timestamptz)
  - is_read (boolean, default false) — tracks whether the message has been reviewed

2. Security

This is a single-tenant, no-sign-in website. The frontend uses the anon key,
so policies must allow the `anon` role to operate.

- `games`: public read (anon + authenticated SELECT). Writes restricted to
  authenticated users (studio staff) — but since there is no auth UI yet,
  inserts/updates/deletes are also left open to anon + authenticated so the
  site can be seeded. This is intentionally public/shared data.
- `team_members`: same public/shared pattern as games.
- `contact_messages`: anyone (anon) can INSERT (submit the contact form),
  but only authenticated users can SELECT/UPDATE/DELETE (read/manage
  submissions). This prevents the public from reading other people's
  messages while still allowing form submissions.
*/

-- ============================================================
-- games
-- ============================================================
CREATE TABLE IF NOT EXISTS games (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    slug text UNIQUE NOT NULL,
    tagline text,
    description text,
    genre text,
    status text NOT NULL DEFAULT 'released',
    release_date date,
    cover_image_url text,
    icon_url text,
    homepage_url text,
    play_store_url text,
    itch_io_url text,
    trailer_url text,
    display_order int NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE games ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_games" ON games;
CREATE POLICY "anon_select_games" ON games FOR SELECT
    TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_games" ON games;
CREATE POLICY "anon_insert_games" ON games FOR INSERT
    TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_games" ON games;
CREATE POLICY "anon_update_games" ON games FOR UPDATE
    TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_games" ON games;
CREATE POLICY "anon_delete_games" ON games FOR DELETE
    TO anon, authenticated USING (true);

-- ============================================================
-- team_members
-- ============================================================
CREATE TABLE IF NOT EXISTS team_members (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    designation text NOT NULL,
    avatar_url text,
    display_order int NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_team_members" ON team_members;
CREATE POLICY "anon_select_team_members" ON team_members FOR SELECT
    TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_team_members" ON team_members;
CREATE POLICY "anon_insert_team_members" ON team_members FOR INSERT
    TO anon, authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_update_team_members" ON team_members;
CREATE POLICY "anon_update_team_members" ON team_members FOR UPDATE
    TO anon, authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_delete_team_members" ON team_members;
CREATE POLICY "anon_delete_team_members" ON team_members FOR DELETE
    TO anon, authenticated USING (true);

-- ============================================================
-- contact_messages
-- ============================================================
CREATE TABLE IF NOT EXISTS contact_messages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    email text NOT NULL,
    message text NOT NULL,
    is_read boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Anyone can submit a contact message (the public contact form)
DROP POLICY IF EXISTS "anon_insert_contact_messages" ON contact_messages;
CREATE POLICY "anon_insert_contact_messages" ON contact_messages FOR INSERT
    TO anon, authenticated WITH CHECK (true);

-- Only authenticated users can read/manage messages (studio staff)
DROP POLICY IF EXISTS "auth_select_contact_messages" ON contact_messages;
CREATE POLICY "auth_select_contact_messages" ON contact_messages FOR SELECT
    TO authenticated USING (true);

DROP POLICY IF EXISTS "auth_update_contact_messages" ON contact_messages;
CREATE POLICY "auth_update_contact_messages" ON contact_messages FOR UPDATE
    TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_delete_contact_messages" ON contact_messages;
CREATE POLICY "auth_delete_contact_messages" ON contact_messages FOR DELETE
    TO authenticated USING (true);

-- ============================================================
-- Indexes
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_games_status ON games (status);
CREATE INDEX IF NOT EXISTS idx_games_display_order ON games (display_order);
CREATE INDEX IF NOT EXISTS idx_team_members_display_order ON team_members (display_order);
CREATE INDEX IF NOT EXISTS idx_contact_messages_created_at ON contact_messages (created_at DESC);
