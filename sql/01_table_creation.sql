/*
1. Create the Lakebase schema
Create at least these two related tables:

tickets:

ticket_id,title,status,created_by,created_at

ticket_messages:

message_id,ticket_id,message_text,author,created_at

The ticket_messages.ticket_id column must reference a ticket in the tickets table.
*/


CREATE TABLE IF NOT EXISTS tickets(
  ticket_id INTEGER,
  title VARCHAR,
  status VARCHAR,
  created_by VARCHAR,
  created_at TIMESTAMP  
)
;

CREATE TABLE IF NOT EXISTS ticket_messages(
  message_id INTEGER,
  ticket_id INTEGER,
  message_text VARCHAR,
  author VARCHAR,
  created_at TIMESTAMP  
)
;
