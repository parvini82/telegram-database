#!/usr/bin/env python3
import psycopg2
import random
import uuid
import time
import threading
from datetime import datetime

# Database connection string for your dbfinalproject database.
DATABASE_URL = "postgresql://root@localhost:26257/dbfinalproject?sslmode=disable"

def get_connection():
    """Establish and return a new database connection."""
    return psycopg2.connect(DATABASE_URL)

def create_user():
    """Simulate user sign-up by inserting a new user into the Users table."""
    conn = get_connection()
    cur = conn.cursor()
    user_id = str(uuid.uuid4())
    username = f"user_{random.randint(1000, 9999)}"
    phone_number = f"+1{random.randint(1000000000, 9999999999)}"
    now = datetime.now()
    query = """
        INSERT INTO Users (
            user_id, username, phone_number, 
            is_authenticated, status, last_login, 
            two_factor_enabled, is_bot
        ) VALUES (%s, %s, %s, false, 'offline', %s, false, false)
    """
    try:
        cur.execute(query, (user_id, username, phone_number, now))
        conn.commit()
        print(f"[CREATE_USER] Created user {username} ({user_id})")
    except Exception as e:
        print(f"[CREATE_USER] Error: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()
    return user_id

def login_user(user_id):
    """Simulate a user login by updating the Users table."""
    conn = get_connection()
    cur = conn.cursor()
    now = datetime.now()
    query = """
        UPDATE Users 
        SET is_authenticated = true, status = 'online', last_login = %s 
        WHERE user_id = %s
    """
    try:
        cur.execute(query, (now, user_id))
        conn.commit()
        print(f"[LOGIN_USER] User {user_id} logged in")
    except Exception as e:
        print(f"[LOGIN_USER] Error: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

def create_chat():
    """Simulate chat creation by inserting a new chat into the Chat table."""
    conn = get_connection()
    cur = conn.cursor()
    chat_id = str(uuid.uuid4())
    now = datetime.now()
    query = "INSERT INTO Chat (chat_id, type, created_at) VALUES (%s, %s, %s)"
    try:
        # For simulation, we'll use 'private' chat type.
        cur.execute(query, (chat_id, 'private', now))
        conn.commit()
        print(f"[CREATE_CHAT] Created chat {chat_id}")
    except Exception as e:
        print(f"[CREATE_CHAT] Error: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()
    return chat_id

def send_message(user_id, chat_id):
    """Simulate sending a message in a chat."""
    conn = get_connection()
    cur = conn.cursor()
    message_id = str(uuid.uuid4())
    now = datetime.now()
    message_content = "Hello, this is a test message"
    query = """
        INSERT INTO Messages (message_id, chat_id, user_id, message_content, sent_at)
        VALUES (%s, %s, %s, %s, %s)
    """
    try:
        cur.execute(query, (message_id, chat_id, user_id, message_content, now))
        conn.commit()
        print(f"[SEND_MESSAGE] User {user_id} sent a message in chat {chat_id}")
    except Exception as e:
        print(f"[SEND_MESSAGE] Error: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

def simulate_workload():
    """Perform a sequence of operations: create a user, login, create a chat, and send a message."""
    user_id = create_user()
    # Random sleep to simulate varied user behavior.
    time.sleep(random.uniform(0.1, 0.5))
    login_user(user_id)
    # Create a chat and then send a message.
    chat_id = create_chat()
    time.sleep(random.uniform(0.1, 0.5))
    send_message(user_id, chat_id)

def worker():
    """Worker thread that continuously runs simulated operations."""
    while True:
        simulate_workload()
        # Pause between iterations to control workload intensity.
        time.sleep(random.uniform(0.5, 2.0))

if __name__ == '__main__':
    NUM_WORKERS = 10  # Number of concurrent worker threads
    threads = []

    print("Starting workload simulation with {} workers...".format(NUM_WORKERS))
    for i in range(NUM_WORKERS):
        t = threading.Thread(target=worker)
        t.daemon = True
        t.start()
        threads.append(t)

    # Keep the main thread alive to let workers run indefinitely.
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Stopping workload simulation.")
