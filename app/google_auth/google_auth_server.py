from flask import Flask, redirect, request, session
from google_auth_oauthlib.flow import Flow
import os
import secrets
from google_auth import init_db, store_user_data, verify_iiitd_domain, get_db_connection
import jwt  # Add this import
from datetime import datetime, timedelta
import uuid

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)
os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"  # For local testing only

CLIENT_SECRETS_FILE = "credentials.json"
SCOPES = [
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile'
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
    authorization_url, state = flow.authorization_url()
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

    # Initialize DB and store user with session token
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

if __name__ == "__main__":
    app.run(port=5000, debug=True)