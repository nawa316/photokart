-- Migration: Add isRead column to message table
-- Run this SQL in your Supabase SQL Editor

-- Add isRead column to message table
ALTER TABLE message 
ADD COLUMN IF NOT EXISTS "isRead" BOOLEAN DEFAULT FALSE;

-- Update existing messages:
-- Messages sent by the current user should have isRead = true (they've been read by sender)
-- Messages from others should remain false until they open the chat
-- This is a simple default, you may want to customize based on your logic
UPDATE message 
SET "isRead" = FALSE 
WHERE "isRead" IS NULL;

-- Create an index for faster queries on isRead
CREATE INDEX IF NOT EXISTS idx_message_isread 
ON message ("convoId", "isRead", "userId");

-- Optional: Create a function to auto-mark messages as read when a user opens a conversation
CREATE OR REPLACE FUNCTION mark_conversation_as_read(
  conversation_id UUID,
  current_user_id UUID
)
RETURNS void AS $$
BEGIN
  UPDATE message
  SET "isRead" = TRUE
  WHERE "convoId" = conversation_id
    AND "userId" != current_user_id
    AND "isRead" = FALSE;
END;
$$ LANGUAGE plpgsql;
