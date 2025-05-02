import requests
import json
from datetime import datetime
import psycopg2
from zoom_config import ZOOM_CONFIG, ZOOM_SCOPES
from flask import Flask, request
import webbrowser
import threading
import time
import urllib.parse
import secrets

app = Flask(__name__)
auth_code = None
auth_event = threading.Event()
oauth_state = None

@app.route('/zoom/callback')
def zoom_callback():
    global auth_code
    if request.args.get('state') != oauth_state:
        return "Invalid state parameter. Authorization failed.", 400
    auth_code = request.args.get('code')
    auth_event.set()
    return "Authorization successful! You can close this window."

def start_server():
    app.run(host='localhost', port=52120, threaded=True)

def get_db_connection():
    """Create and return a database connection."""
    try:
        conn = psycopg2.connect(
            dbname='google_auth_db',
            user='postgres',
            password='postgres',
            host='localhost',
            port='5432'
        )
        return conn
    except Exception as e:
        print(f"Error connecting to database: {str(e)}")
        raise

def init_zoom_db():
    """Initialize the Zoom meetings table."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Create zoom_meetings table if it doesn't exist
    cur.execute('''
        CREATE TABLE IF NOT EXISTS zoom_meetings (
            meeting_id VARCHAR(255) PRIMARY KEY,
            user_id VARCHAR(255) REFERENCES users(id),
            topic TEXT,
            start_time TIMESTAMP WITH TIME ZONE,
            duration INTEGER,
            recording_url TEXT,
            transcript TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    conn.commit()
    cur.close()
    conn.close()

def get_zoom_auth_url():
    """Generate Zoom OAuth URL."""
    global oauth_state
    oauth_state = secrets.token_urlsafe(32)
    
    params = {
        'response_type': 'code',
        'client_id': ZOOM_CONFIG['client_id'],
        'redirect_uri': ZOOM_CONFIG['redirect_uri'],
        'state': oauth_state,
        'scope': ' '.join(ZOOM_SCOPES)
    }
    
    query_string = urllib.parse.urlencode(params)
    auth_url = f"{ZOOM_CONFIG['authorization_base_url']}?{query_string}"
    return auth_url

def get_zoom_token(code):
    """Exchange authorization code for access token."""
    try:
        data = {
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': ZOOM_CONFIG['redirect_uri']
        }
        
        auth = (ZOOM_CONFIG['client_id'], ZOOM_CONFIG['client_secret'])
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
        
        response = requests.post(
            ZOOM_CONFIG['token_url'],
            auth=auth,
            data=data,
            headers=headers
        )
        
        if response.status_code != 200:
            print(f"Token exchange failed. Status code: {response.status_code}")
            print(f"Response: {response.text}")
            raise Exception(f"Failed to get Zoom token: {response.text}")
        
        return response.json()
        
    except Exception as e:
        print(f"Error during token exchange: {str(e)}")
        raise

def get_zoom_meetings(access_token):
    """Fetch user's Zoom meetings."""
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    
    response = requests.get(
        f"{ZOOM_CONFIG['api_base_url']}/users/me/meetings",
        headers=headers
    )
    
    if response.status_code != 200:
        raise Exception(f"Failed to fetch meetings: {response.text}")
    
    return response.json()

def get_meeting_recordings(access_token, meeting_id):
    """Fetch recordings for a specific meeting."""
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    
    response = requests.get(
        f"{ZOOM_CONFIG['api_base_url']}/meetings/{meeting_id}/recordings",
        headers=headers
    )
    
    if response.status_code != 200:
        return None
    
    return response.json()

def store_zoom_data(user_id, meetings_data):
    """Store Zoom meetings data in database."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        for meeting in meetings_data.get('meetings', []):
            data = (
                meeting.get('id'),
                user_id,
                meeting.get('topic'),
                meeting.get('start_time'),
                meeting.get('duration'),
                None,  # recording_url will be updated when fetching recordings
                None,  # transcript will be updated when fetching recordings
                datetime.now()
            )
            
            cur.execute('''
                INSERT INTO zoom_meetings 
                    (meeting_id, user_id, topic, start_time, duration, 
                     recording_url, transcript, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (meeting_id) DO UPDATE SET
                    topic = EXCLUDED.topic,
                    start_time = EXCLUDED.start_time,
                    duration = EXCLUDED.duration,
                    created_at = EXCLUDED.created_at
            ''', data)
        
        conn.commit()
        print("\nZoom meetings data stored successfully!")
    except Exception as e:
        print(f"Error storing Zoom data: {str(e)}")
        conn.rollback()
        raise
    finally:
        cur.close()
        conn.close()

def update_meeting_recordings(access_token, user_id, meetings):
    """Update meeting recordings and transcripts."""
    for meeting in meetings.get('meetings', []):
        recordings = get_meeting_recordings(access_token, meeting['id'])
        if recordings and recordings.get('recording_files'):
            conn = get_db_connection()
            cur = conn.cursor()
            try:
                recording_url = recordings['recording_files'][0].get('download_url')
                transcript = None
                for file in recordings['recording_files']:
                    if file.get('file_type') == 'TRANSCRIPT':
                        transcript = file.get('download_url')
                        break
                
                cur.execute('''
                    UPDATE zoom_meetings 
                    SET recording_url = %s, transcript = %s 
                    WHERE meeting_id = %s
                ''', (recording_url, transcript, meeting['id']))
                conn.commit()
            except Exception as e:
                print(f"Error updating recording data: {str(e)}")
            finally:
                cur.close()
                conn.close()

def authenticate_zoom(user_id):
    """Complete Zoom authentication flow."""
    try:
        # Initialize Zoom database table
        init_zoom_db()
        
        # Start local server
        server_thread = threading.Thread(target=start_server)
        server_thread.daemon = True
        server_thread.start()
        time.sleep(1)  # Give the server a moment to start
        
        # Start Zoom authentication
        print("\nStarting Zoom Authentication...")
        auth_url = get_zoom_auth_url()
        print("\nOpening browser for Zoom authorization...")
        webbrowser.open(auth_url)
        
        # Wait for the callback
        if not auth_event.wait(timeout=300):  # 5 minute timeout
            print("Timeout waiting for Zoom authorization")
            return False
            
        if not auth_code:
            print("Failed to get authorization code")
            return False
        
        # Get Zoom access token
        zoom_token = get_zoom_token(auth_code)
        
        # Fetch and store Zoom meetings
        print("\nFetching Zoom meetings...")
        meetings = get_zoom_meetings(zoom_token['access_token'])
        store_zoom_data(user_id, meetings)
        
        # Fetch and update recordings
        print("\nFetching meeting recordings...")
        update_meeting_recordings(zoom_token['access_token'], user_id, meetings)
        
        print("\nZoom integration complete!")
        return True
        
    except Exception as e:
        print(f"An error occurred during Zoom authentication: {str(e)}")
        return False 