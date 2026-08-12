from datetime import datetime, timezone
from typing import Optional

from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi import Request
from pydantic import BaseModel

import lakebase

app = FastAPI()
templates = Jinja2Templates(directory="templates")


# ---------- request/response models ----------


class TicketCreate(BaseModel):
    title: str
    created_by: str
    status: str = "open"


class MessageCreate(BaseModel):
    message_text: str
    author: str


class StatusUpdate(BaseModel):
    status: str


# ---------- health check ----------


@app.get("/healthz")
def healthz():
    return {"status": "ok"}


# ---------- frontend ----------


@app.get("/", response_class=HTMLResponse)
def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


# ---------- tickets ----------


@app.get("/tickets")
def list_tickets():
    """View all support tickets."""
    rows = lakebase.run_query(
        "SELECT ticket_id, title, status, created_by, created_at "
        "FROM tickets ORDER BY created_at DESC"
    )
    return rows


@app.post("/tickets")
def create_ticket(ticket: TicketCreate):
    """Create a new ticket."""
    with lakebase.get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO tickets (title, status, created_by, created_at)
                VALUES (%s, %s, %s, %s)
                RETURNING ticket_id, title, status, created_by, created_at
                """,
                (
                    ticket.title,
                    ticket.status,
                    ticket.created_by,
                    datetime.now(timezone.utc),
                ),
            )
            new_ticket = cur.fetchone()
            conn.commit()
    return new_ticket


@app.patch("/tickets/{ticket_id}/status")
def update_ticket_status(ticket_id: int, update: StatusUpdate):
    """Update a ticket's status."""
    affected = lakebase.run_write(
        "UPDATE tickets SET status = %s WHERE ticket_id = %s",
        (update.status, ticket_id),
    )
    if affected == 0:
        raise HTTPException(status_code=404, detail=f"Ticket {ticket_id} not found")
    return {"ticket_id": ticket_id, "status": update.status}


# ---------- messages ----------


@app.get("/tickets/{ticket_id}/messages")
def list_messages(ticket_id: int):
    """View all messages for a given ticket."""
    ticket = lakebase.run_query(
        "SELECT ticket_id FROM tickets WHERE ticket_id = %s", (ticket_id,)
    )
    if not ticket:
        raise HTTPException(status_code=404, detail=f"Ticket {ticket_id} not found")

    rows = lakebase.run_query(
        "SELECT message_id, ticket_id, message_text, author, created_at "
        "FROM ticket_messages WHERE ticket_id = %s ORDER BY created_at ASC",
        (ticket_id,),
    )
    return rows


@app.post("/tickets/{ticket_id}/messages")
def add_message(ticket_id: int, message: MessageCreate):
    """Add a message to an existing ticket."""
    ticket = lakebase.run_query(
        "SELECT ticket_id FROM tickets WHERE ticket_id = %s", (ticket_id,)
    )
    if not ticket:
        raise HTTPException(status_code=404, detail=f"Ticket {ticket_id} not found")

    with lakebase.get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO ticket_messages (ticket_id, message_text, author, created_at)
                VALUES (%s, %s, %s, %s)
                RETURNING message_id, ticket_id, message_text, author, created_at
                """,
                (
                    ticket_id,
                    message.message_text,
                    message.author,
                    datetime.now(timezone.utc),
                ),
            )
            new_message = cur.fetchone()
            conn.commit()
    return new_message
