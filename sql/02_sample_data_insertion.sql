/*

2. Add sample data
Your database must contain:

At least three support tickets

At least two messages for each ticket

At least two different ticket statuses, such as open, in_progress, or resolved
*/

-- Note: IDs are auto-generated, so we use a CTE to capture them and reference in messages
WITH inserted_tickets AS (
  INSERT INTO tickets (title, status, created_by, created_at)
  VALUES
    ('Looker Dashboard Development','open','Fernando Marquez','2026-08-12 09:30:00'),
    ('GBQ Access','in_progress','Fernando Marquez','2026-08-11 12:45:00'),
    ('dbt Project Maitenance','resolved','Fernando Marquez','2026-08-10 12:00:00')
  RETURNING ticket_id, title
)
INSERT INTO ticket_messages (ticket_id, message_text, author, created_at)
SELECT 
  ticket_id,
  message_text,
  author,
  created_at::TIMESTAMP
FROM inserted_tickets,
LATERAL (
  VALUES 
    ('Table consolidation on hold', 'Fernando Marquez', '2026-08-12 11:32:45'),
    ('Waiting for upstream dependencies', 'Fernando Marquez', '2026-08-12 17:32:45')
) AS msgs(message_text, author, created_at)
WHERE title = 'Looker Dashboard Development'

UNION ALL

SELECT 
  ticket_id,
  message_text,
  author,
  created_at::TIMESTAMP
FROM inserted_tickets,
LATERAL (
  VALUES 
    ('Contacted IT for access', 'Fernando Marquez', '2026-08-11 12:48:00'),
    ('Waiting for manager approval', 'Fernando Marquez', '2026-08-11 14:04:32')
) AS msgs(message_text, author, created_at)
WHERE title = 'GBQ Access'

UNION ALL

SELECT 
  ticket_id,
  message_text,
  author,
  created_at::TIMESTAMP
FROM inserted_tickets,
LATERAL (
  VALUES 
    ('dbt discovery work in progress', 'Fernando Marquez', '2026-08-10 12:01:00'),
    ('dbt project migrated', 'Fernando Marquez', '2026-08-10 16:13:00')
) AS msgs(message_text, author, created_at)
WHERE title = 'dbt Project Maitenance';
