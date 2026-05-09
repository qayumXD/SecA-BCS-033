-- Quiz 3: Supabase Database Setup Script
-- Project: Submission Form Application
-- Table: submissions

-- 1. Create the submissions table in the public schema
CREATE TABLE IF NOT EXISTS public.submissions (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone_number TEXT NOT NULL,
  address TEXT NOT NULL,
  gender TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Enable Row Level Security (RLS)
-- This is required by Supabase to control who can access the data
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;

-- 3. Create a Policy for Anonymous Access
-- For this Quiz, we allow anonymous (anon) users to perform all CRUD operations.
-- In a production app, you would restrict this to 'authenticated' users.
CREATE POLICY "Enable all access for anonymous users" 
ON public.submissions 
FOR ALL 
TO anon 
USING (true) 
WITH CHECK (true);

-- Optional: Insert a sample record to verify setup
-- INSERT INTO public.submissions (full_name, email, phone_number, address, gender)
-- VALUES ('John Doe', 'john@example.com', '1234567890', '123 Flutter Way', 'Male');
