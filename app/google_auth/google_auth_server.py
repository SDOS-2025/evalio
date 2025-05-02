from flask import Flask, redirect, request, session
from google_auth_oauthlib.flow import Flow
import os
import secrets
from google_auth import init_db, store_user_data, verify_iiitd_domain

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

    # Initialize DB and store user
    try:
        init_db()
        store_user_data(user_info)
    except Exception as e:
        return f"Error storing user data: {str(e)}", 500

    # For demo: create a simple token (in production, use JWT or similar)
    token = user_info["id"]  # Or sign a JWT with user_info

    # Redirect back to Phoenix with the token
    return redirect("http://127.0.0.1:4000/auth/google/callback?token={token}")

if __name__ == "__main__":
    app.run(port=5000, debug=True)