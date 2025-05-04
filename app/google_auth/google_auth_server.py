from flask import Flask, redirect, request, session, jsonify
from google_auth_oauthlib.flow import Flow
import os
import secrets
from google_auth import init_db, store_user_data, verify_iiitd_domain, get_db_connection, get_user_tokens_by_email
import jwt  # Add this import
from datetime import datetime, timedelta
import uuid
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
import json
from flask_cors import CORS

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)
os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"  # For local testing only

CORS(app)

CLIENT_SECRETS_FILE = "credentials.json"
SCOPES = [
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/calendar.events'
]
REDIRECT_URI = "http://127.0.0.1:5000/auth/google/callback"
SECRET_KEY = "431265"  # Use a secure key and store it in an environment variable

@app.route("/login/google")
def login():
    flow = Flow.from_client_secrets_file(
        CLIENT_SECRETS_FILE,
        scopes=SCOPES,
        redirect_uri=REDIRECT_URI
    )
    authorization_url, state = flow.authorization_url(
        access_type='offline',
        prompt='consent'
    )
    session["state"] = state
    return redirect(authorization_url)

@app.route("/auth/google/callback")
def callback():
    state = session["state"]
    flow = Flow.from_client_secrets_file(
        CLIENT_SECRETS_FILE,
        scopes=SCOPES,
        state=state,
        redirect_uri=REDIRECT_URI
    )
    flow.fetch_token(authorization_response=request.url)
    credentials = flow.credentials

    from googleapiclient.discovery import build
    service = build('oauth2', 'v2', credentials=credentials)
    user_info = service.userinfo().get().execute()

    # Restrict to IIITD domain
    if not verify_iiitd_domain(user_info.get('email', '')):
        return "Error: Only @iiitd.ac.in email addresses are allowed.", 403

    # Store refresh_token in user_info for DB storage
    user_info['refresh_token'] = credentials.refresh_token

    # Generate a signed JWT token with standard claims
    now = datetime.utcnow()
    payload = {
        "sub": user_info["id"],
        "email": user_info["email"],
        "name": user_info["name"],
        "exp": now + timedelta(hours=1),  # Token expires in 1 hour
        "iat": now,
        "nbf": now,
        "jti": str(uuid.uuid4()),
        "iss": "google_auth_server",
        "aud": "evalio_app"
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")

    # Initialize DB and store user with session token and refresh token
    try:
        init_db()
        store_user_data(user_info, session_token=token)
    except Exception as e:
        return f"Error storing user data: {str(e)}", 500

    # Redirect back to Phoenix with the token
    return redirect(f"http://127.0.0.1:4000/auth/google/callback?token={token}")

from google_auth import get_db_connection
@app.route("/api/session/validate")
def validate_session():
    token = request.args.get("token")
    if not token:
        return {"error": "Token required"}, 400
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        cur.execute("SELECT id, email, name, given_name, family_name, picture FROM users WHERE session_token = %s", (token,))
        user = cur.fetchone()
        if not user:
            return {"error": "Invalid token"}, 401
        user_info = {
            "id": user[0],
            "email": user[1],
            "name": user[2],
            "given_name": user[3],
            "family_name": user[4],
            "picture": user[5]
        }
        return user_info, 200
    finally:
        cur.close()
        conn.close()

@app.route("/api/create_gmeet", methods=["POST"])
def create_gmeet():
    print("create_gmeet endpoint hit with data:", request.json)
    data = request.json
    title = data["title"]
    start_time = data["start_time"]  # ISO format string
    end_time = data["end_time"]      # ISO format string
    token = data["token"]            # User's Google OAuth access token
    refresh_token = data.get("refresh_token")  # Optional, if you store it

    # Load client_id and client_secret from credentials.json
    with open(CLIENT_SECRETS_FILE, "r") as f:
        secrets_data = json.load(f)
        if "installed" in secrets_data:
            client_id = secrets_data["installed"]["client_id"]
            client_secret = secrets_data["installed"]["client_secret"]
        elif "web" in secrets_data:
            client_id = secrets_data["web"]["client_id"]
            client_secret = secrets_data["web"]["client_secret"]
        else:
            return jsonify({"error": "Invalid credentials.json format"}), 500

    creds = Credentials(
        token,
        refresh_token=refresh_token,
        token_uri="https://oauth2.googleapis.com/token",
        client_id=client_id,
        client_secret=client_secret,
        scopes=[
            "https://www.googleapis.com/auth/calendar.events"
        ]
    )

    service = build("calendar", "v3", credentials=creds)
    event = {
        "summary": title,
        "start": {"dateTime": start_time, "timeZone": "Asia/Kolkata"},
        "end": {"dateTime": end_time, "timeZone": "Asia/Kolkata"},
        "conferenceData": {
            "createRequest": {
                "requestId": str(uuid.uuid4()),
                "conferenceSolutionKey": {"type": "hangoutsMeet"}
            }
        }
    }
    created_event = service.events().insert(
        calendarId="primary",
        body=event,
        conferenceDataVersion=1
    ).execute()
    meet_link = created_event["hangoutLink"]
    print("Creating Google Meet event:", title, start_time, end_time)
    return jsonify({"meet_link": meet_link})

@app.route("/api/user_tokens", methods=["GET"])
def user_tokens():
    print("user_tokens endpoint hit with email:", request.args.get("email"))
    email = request.args.get("email")
    if not email:
        return jsonify({"error": "Email required"}), 400
    tokens = get_user_tokens_by_email(email)
    if tokens:
        return jsonify(tokens), 200
    else:
        return jsonify({"error": "User not found"}), 404

if __name__ == "__main__":
    app.run(port=5000, debug=True)