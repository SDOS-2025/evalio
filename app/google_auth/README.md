# Google Authentication & Google Meet Creation

This module provides Google OAuth authentication specifically for IIITD domain users (@iiitd.ac.in), integrates with a Phoenix (Elixir) frontend, and allows authenticated users to create Google Meet meetings via the Google Calendar API.

---

## Setup Instructions

1. **Install the required Python packages:**
   ```bash
   pip install -r requirements.txt
   ```
   This will install:
   - Flask (for the Google Auth server)
   - Flask-Session
   - PyJWT
   - google-auth, google-auth-oauthlib, google-api-python-client
   - psycopg2-binary (for PostgreSQL)
   - requests
   - flask_cors

2. **Configure Database Connection:**
   - Open `google_auth.py`
   - Update the `DB_CONFIG` dictionary if needed:
     ```python
     DB_CONFIG = {
         'dbname': 'google_auth_db',
         'user': 'postgres',      # Your PostgreSQL username
         'password': 'postgres',  # Your PostgreSQL password
         'host': 'localhost',
         'port': '5432'
     }
     ```

3. **Google OAuth Credentials:**
   - Download your OAuth 2.0 credentials from the Google Cloud Console and save as `credentials.json` in this directory.
   - Make sure the credentials have the following OAuth scopes:
     - `openid`
     - `https://www.googleapis.com/auth/userinfo.email`
     - `https://www.googleapis.com/auth/userinfo.profile`
     - `https://www.googleapis.com/auth/calendar.events` (for Google Meet creation)

---

## Usage

### Running the Flask Google Auth & Meet Server

1. Start the server:
   ```bash
   python3 google_auth_server.py
   ```
   The server will run on http://127.0.0.1:5000

2. **Main Endpoints:**
   - `/login/google` — Initiates Google OAuth login
   - `/auth/google/callback` — Handles the OAuth callback and issues a JWT
   - `/api/session/validate?token=...` — Validates a JWT and returns user info
   - `/api/create_gmeet` — (POST) Creates a Google Meet event (see below)
   - `/api/create_gcal_event` — (POST) Creates a Google Calendar event for reminders (see below)

### Google Meet Creation API

- **Endpoint:** `/api/create_gmeet` (POST)
- **Description:** Creates a Google Calendar event with a Google Meet link for an authenticated user.
- **Request Body (JSON):**
  ```json
  {
    "title": "Event Title",
    "start_time": "2024-06-01T10:00:00+05:30",  // ISO format
    "end_time": "2024-06-01T11:00:00+05:30",    // ISO format
    "token": "<Google OAuth access token>",
    "refresh_token": "<Google OAuth refresh token>" // optional if stored
  }
  ```
- **Response:**
  ```json
  {
    "meet_link": "https://meet.google.com/xxx-xxxx-xxx"
  }
  ```
- **Notes:**
  - The user must be authenticated and have granted `calendar.events` scope.
  - The endpoint uses the user's access and refresh tokens to create the event.

### Google Calendar Event Creation API (Reminders Integration)

- **Endpoint:** `/api/create_gcal_event` (POST)
- **Description:** Creates a Google Calendar event (without a Meet link) for an authenticated user, used for reminders.
- **Request Body (JSON):**
  ```json
  {
    "title": "Reminder Title",
    "start_time": "2024-06-01T10:00:00+05:30",  // ISO format
    "end_time": "2024-06-01T11:00:00+05:30",    // ISO format
    "token": "<Google OAuth access token>",
    "refresh_token": "<Google OAuth refresh token>" // optional if stored
  }
  ```
- **Response:**
  ```json
  {
    "event_link": "https://calendar.google.com/calendar/event?eid=..."
  }
  ```
- **Notes:**
  - The user must be authenticated and have granted `calendar.events` scope.
  - The endpoint uses the user's access and refresh tokens to create the event.
  - This is used by the Phoenix app to sync reminders with the user's Google Calendar.

### To run with the Phoenix app:
1. Start the Flask server as above.
2. In a separate terminal, start the Phoenix app:
   ```bash
   mix phx.server
   ```
3. The Phoenix app will redirect users to Google login via the Flask server, and use the `/api/session/validate` endpoint to validate sessions.

---

## Viewing the Database

You can view the stored data in several ways:

1. Using PostgreSQL command line (psql):
   ```bash
   # Connect to the database
   psql google_auth_db

   # List all tables
   \dt

   # View all users
   SELECT * FROM users;

   # Exit psql
   \q
   ```

---

## Database Schema

The `users` table contains the following columns:
- `id` (VARCHAR): Google's unique identifier
- `email` (VARCHAR): User's email address (unique)
- `name` (VARCHAR): Full name
- `given_name` (VARCHAR): First name
- `family_name` (VARCHAR): Last name
- `picture` (TEXT): Profile picture URL
- `verified_email` (BOOLEAN): Email verification status
- `locale` (VARCHAR): Language/location settings
- `hd` (VARCHAR): Hosted domain (iiitd.ac.in)
- `last_login` (TIMESTAMP): Last authentication time
- `session_token` (TEXT): JWT session token for the user
- `refresh_token` (TEXT): Google OAuth refresh token

---

## Google OAuth API Fields

The Google OAuth API returns the following user information fields:

1. `id` - Google's unique identifier for the user account
2. `email` - User's email address
3. `verified_email` - Boolean indicating if the email is verified
4. `name` - User's full name
5. `given_name` - User's first name
6. `family_name` - User's last name
7. `picture` - URL to the user's profile picture
8. `locale` - User's preferred language/location settings
9. `hd` - The hosted domain (should be 'iiitd.ac.in' for IIITD users)

---

## Security Notes

- The script stores authentication tokens in `token.pickle` (for CLI usage)
- Only @iiitd.ac.in email addresses are allowed
- The credentials are verified to match the provided email address
- Database passwords should be properly secured in production environments
- JWT tokens are used for session management and are validated by the Phoenix app via the Flask server
- Google Meet creation requires the `calendar.events` scope and valid OAuth tokens
