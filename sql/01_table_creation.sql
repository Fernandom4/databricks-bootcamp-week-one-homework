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
  ticket_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title VARCHAR NOT NULL,
  status VARCHAR NOT NULL DEFAULT 'open',
  created_by VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS ticket_messages(
  message_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ticket_id INTEGER NOT NULL,
  message_text VARCHAR NOT NULL,
  author VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id) ON DELETE CASCADE
);
