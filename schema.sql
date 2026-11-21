-- ==============================================================================
-- EASYPOLL - OFFICIAL SUPABASE DATABASE SCHEMA
-- Real-Time Anonymous Audience Polling, Quizzes & Descriptive Q&A
-- Supports 200+ Participants with 100% Strict Anonymity by Design
-- ==============================================================================

-- 1. Enable Required Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. Clean Existing Tables (if re-running schema)
DROP TABLE IF EXISTS responses CASCADE;
DROP TABLE IF EXISTS question_options CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS polls CASCADE;
DROP TABLE IF EXISTS admin_settings CASCADE;

-- 3. Polls Table (Supports Quizzes & Polls)
CREATE TABLE polls (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    title VARCHAR(255) NOT NULL,
    description TEXT DEFAULT '',
    type VARCHAR(50) DEFAULT 'poll', -- 'poll' or 'quiz'
    status VARCHAR(50) DEFAULT 'active', -- 'active' or 'closed'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Questions Table (Multiple Choice & Descriptive / Paragraph Q&A)
CREATE TABLE questions (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    poll_id TEXT NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL, -- 'mcq' or 'paragraph' / 'descriptive'
    order_num INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Question Options Table (For Multiple Choice Questions)
CREATE TABLE question_options (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    icon VARCHAR(50) DEFAULT '💡',
    order_num INT NOT NULL DEFAULT 1
);

-- 6. Anonymous Responses Table
-- CRITICAL ANONYMITY REQUIREMENT:
-- Absolutely NO personal identifying columns (no user_id, ip_address, session_token, email, or device fingerprint).
-- Responses are completely unlinked from participant identity.
CREATE TABLE responses (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    poll_id TEXT NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
    question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_id TEXT REFERENCES question_options(id) ON DELETE SET NULL, -- for MCQ
    answer_text TEXT, -- for descriptive paragraph answers (up to 2000 chars)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. Admin Settings & Credentials Table
CREATE TABLE admin_settings (
    key VARCHAR(100) PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. High-Performance Indexes for Real-Time Analytics
CREATE INDEX idx_questions_poll_id ON questions(poll_id);
CREATE INDEX idx_options_question_id ON question_options(question_id);
CREATE INDEX idx_responses_poll_id ON responses(poll_id);
CREATE INDEX idx_responses_question_id ON responses(question_id);
CREATE INDEX idx_responses_option_id ON responses(option_id);

-- 9. Enable Row Level Security (RLS)
ALTER TABLE polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE question_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_settings ENABLE ROW LEVEL SECURITY;

-- 10. Permissive RLS Policies for Anonymous Participation
-- Anonymous participants and host can select and insert without auth barriers
CREATE POLICY "Public full access to polls" ON polls FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public full access to questions" ON questions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public full access to question_options" ON question_options FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public full access to responses" ON responses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public full access to admin_settings" ON admin_settings FOR ALL USING (true) WITH CHECK (true);

-- 11. Enable Full Replica Identity for Complete Realtime Payloads
ALTER TABLE polls REPLICA IDENTITY FULL;
ALTER TABLE questions REPLICA IDENTITY FULL;
ALTER TABLE question_options REPLICA IDENTITY FULL;
ALTER TABLE responses REPLICA IDENTITY FULL;

-- 12. Enable Supabase Realtime Publication for Instant Live Sync
DO $$
BEGIN
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE polls;
    EXCEPTION WHEN duplicate_object THEN END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE questions;
    EXCEPTION WHEN duplicate_object THEN END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE question_options;
    EXCEPTION WHEN duplicate_object THEN END;
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE responses;
    EXCEPTION WHEN duplicate_object THEN END;
END $$;

-- 13. Seed Starter Data
-- Default Admin Credentials
INSERT INTO admin_settings (key, value)
VALUES ('credentials', '{"username": "admin", "password": "password123", "name": "System Administrator", "initials": "EP"}'::jsonb)
ON CONFLICT (key) DO NOTHING;

-- Session 1: Live On-The-Spot Q&A Session
INSERT INTO polls (id, title, description, type, status, created_at)
VALUES (
    'live-session-1',
    'Live Audience Q&A & Polling Session',
    '200 Participant Capacity. Questions & Descriptive Answers broadcast live on the spot.',
    'poll',
    'active',
    now()
) ON CONFLICT (id) DO NOTHING;

-- Session 2: Project Topic Selection
INSERT INTO polls (id, title, description, type, status, created_at)
VALUES (
    'poll-topic-selection',
    'Project Topic Selection',
    'Audience voting on upcoming engineering & software projects',
    'poll',
    'active',
    now() - INTERVAL '2 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO questions (id, poll_id, question_text, question_type, order_num)
VALUES 
    ('q-topic-1', 'poll-topic-selection', 'Select one preferred project domain.', 'mcq', 1),
    ('q-topic-2', 'poll-topic-selection', 'Any suggestions or alternative project ideas?', 'paragraph', 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO question_options (id, question_id, option_text, icon, order_num)
VALUES 
    ('opt-top-1', 'q-topic-1', 'Autonomous Mobile Robot (AMR)', '🤖', 1),
    ('opt-top-2', 'q-topic-1', 'Smart Relay Automation System', '💻', 2),
    ('opt-top-3', 'q-topic-1', 'DripSense - Smart Irrigation IoT', '🌱', 3),
    ('opt-top-4', 'q-topic-1', 'Machine Vision Inspection Pipeline', '📷', 4)
ON CONFLICT (id) DO NOTHING;

-- Session 3: Digital Electronics Quiz
INSERT INTO polls (id, title, description, type, status, created_at)
VALUES (
    'quiz-digital-elec',
    'Digital Electronics - Unit 1',
    'Logic gates, truth tables, and boolean fundamentals quick assessment',
    'quiz',
    'active',
    now() - INTERVAL '1 day'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO questions (id, poll_id, question_text, question_type, order_num)
VALUES 
    ('q-quiz-1', 'quiz-digital-elec', 'Which logic gate produces HIGH output only when all inputs are HIGH?', 'mcq', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO question_options (id, question_id, option_text, icon, order_num)
VALUES 
    ('opt-qz-1', 'q-quiz-1', 'AND Gate', '⚡', 1),
    ('opt-qz-2', 'q-quiz-1', 'OR Gate', '💡', 2),
    ('opt-qz-3', 'q-quiz-1', 'NAND Gate', '🔧', 3),
    ('opt-qz-4', 'q-quiz-1', 'XOR Gate', '🎯', 4)
ON CONFLICT (id) DO NOTHING;
