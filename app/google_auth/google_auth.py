from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import os.path
import pickle
import psycopg2
from datetime import datetime

# Database configuration
DB_CONFIG = {
    'dbname': 'google_auth_db',
    'user': 'postgres',
    'password': 'postgres',
    'host': 'localhost',
    'port': '5432'
}

# If modifying these scopes, delete the file token.pickle.
SCOPES = [
    'openid',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile'
]

def get_db_connection():
    """Create and return a database connection."""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"Error connecting to database: {str(e)}")
        raise

def init_db():
    """Initialize the PostgreSQL database."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Create users table if it doesn't exist
    cur.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id VARCHAR(255) PRIMARY KEY,
            email VARCHAR(255) UNIQUE NOT NULL,
            name VARCHAR(255),
            given_name VARCHAR(255),
            family_name VARCHAR(255),
            picture TEXT,
            verified_email BOOLEAN DEFAULT FALSE,
            locale VARCHAR(10),
            hd VARCHAR(255),
            last_login TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            session_token TEXT
        )
    ''')
    
    conn.commit()
    cur.close()
    conn.close()

def store_user_data(user_info, session_token=None):
    """Store user information in the database, including session token if provided."""
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        data = (
            user_info.get('id'),
            user_info.get('email'),
            user_info.get('name'),
            user_info.get('given_name'),
            user_info.get('family_name'),
            user_info.get('picture'),
            user_info.get('verified_email', False),
            user_info.get('locale'),
            user_info.get('hd'),
            datetime.now(),
            session_token
        )
        cur.execute('''
            INSERT INTO users 
                (id, email, name, given_name, family_name, picture, 
                 verified_email, locale, hd, last_login, session_token)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (id) DO UPDATE SET
                email = EXCLUDED.email,
                name = EXCLUDED.name,
                given_name = EXCLUDED.given_name,
                family_name = EXCLUDED.family_name,
                picture = EXCLUDED.picture,
                verified_email = EXCLUDED.verified_email,
                locale = EXCLUDED.locale,
                hd = EXCLUDED.hd,
                last_login = EXCLUDED.last_login,
                session_token = EXCLUDED.session_token
        ''', data)
        conn.commit()
    except Exception as e:
        print(f"Error storing user data: {str(e)}")
        conn.rollback()
        raise
    finally:
        cur.close()
        conn.close()

def store_user_token(user_id, session_token):
    """Update the session token for a user."""
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        cur.execute('''
            UPDATE users SET session_token = %s, last_login = %s WHERE id = %s
        ''', (session_token, datetime.now(), user_id))
        conn.commit()
    except Exception as e:
        print(f"Error updating user token: {str(e)}")
        conn.rollback()
        raise
    finally:
        cur.close()
        conn.close()

def get_credentials():
    """Gets valid user credentials from storage."""
    creds = None
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)
    
    return creds

def verify_iiitd_domain(email):
    """Verifies if the email belongs to IIITD domain."""
    return email.endswith('@iiitd.ac.in')

def main():
    print("Welcome to IIITD Google Authentication")
    print("Please enter your IIITD email address:")
    email = input().strip()
    
    if not verify_iiitd_domain(email):
        print("Error: Only @iiitd.ac.in email addresses are allowed.")
        return
    
    try:
        # Initialize database
        init_db()
        
        # Get credentials
        creds = get_credentials()
        
        # Get user info
        from googleapiclient.discovery import build
        service = build('oauth2', 'v2', credentials=creds)
        user_info = service.userinfo().get().execute()
        
        # Verify the email matches
        if user_info['email'] != email:
            print("Error: The authenticated email does not match the provided email.")
            return
        
        print("\nAuthentication successful!")
        print("\nUser Information:")
        print("-" * 50)
        print(f"Name: {user_info.get('name', 'N/A')}")
        print(f"Email: {user_info.get('email', 'N/A')}")
        print(f"Profile Picture URL: {user_info.get('picture', 'N/A')}")
        
        # Store user data in database
        store_user_data(user_info)
        
    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == '__main__':
    main() 
