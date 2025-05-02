# Google Authentication

This module provides Google OAuth authentication specifically for IIITD domain users (@iiitd.ac.in).

## Setup Instructions

1. Install the required Python packages:
   ```bash
   pip install -r requirements.txt
   ```

2. Set up Google OAuth credentials:
   - Go to the [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable the Google+ API
   - Go to Credentials
   - Create OAuth 2.0 Client ID
   - Choose "Desktop app" as the application type
   - Download the credentials file and save it as `credentials.json` in this directory

3. Set up PostgreSQL Database:
   ```bash
   # Install PostgreSQL (if not already installed)
   brew install postgresql@14

   # Start PostgreSQL service
   brew services start postgresql@14

   # Create the database
   createdb google_auth_db
   ```

4. Configure Database Connection:
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

## Usage

To run on CLI:
1. Run the authentication script:
   ```bash
   python google_auth.py
   ```

2. Enter your IIITD email address when prompted

3. A browser window will open asking you to sign in with your Google account

4. After successful authentication, you'll see your user information displayed

To run through phoenix:
1. run python server using python3 google_auth_server.py

2. run phoenix app using mix phx.server

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

2. Using pgAdmin (GUI Tool):
   - Download and install [pgAdmin](https://www.pgadmin.org/download/)
   - Connect to your PostgreSQL server
   - Navigate to google_auth_db > Schemas > public > Tables
   - Right-click on 'users' table and select "View/Edit Data"

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

## Security Notes

- The script stores authentication tokens in `token.pickle`
- Only @iiitd.ac.in email addresses are allowed
- The credentials are verified to match the provided email address
- Database passwords should be properly secured in production environments
