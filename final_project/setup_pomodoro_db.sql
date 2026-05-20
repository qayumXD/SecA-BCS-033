-- Create pomodoro_sessions table
CREATE TABLE IF NOT EXISTS public.pomodoro_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    start_time TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    duration_minutes INTEGER NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('focus', 'short_break', 'long_break')),
    completed BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- Set up Row Level Security (RLS)
ALTER TABLE public.pomodoro_sessions ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to insert their own sessions
CREATE POLICY "Users can insert their own sessions"
ON public.pomodoro_sessions
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Create policy to allow users to view their own sessions
CREATE POLICY "Users can view their own sessions"
ON public.pomodoro_sessions
FOR SELECT
USING (auth.uid() = user_id);

-- Create policy to allow users to update their own sessions
CREATE POLICY "Users can update their own sessions"
ON public.pomodoro_sessions
FOR UPDATE
USING (auth.uid() = user_id);

-- Create policy to allow users to delete their own sessions
CREATE POLICY "Users can delete their own sessions"
ON public.pomodoro_sessions
FOR DELETE
USING (auth.uid() = user_id);
