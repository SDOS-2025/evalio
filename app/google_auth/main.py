from google_auth import get_credentials, verify_iiitd_domain, store_user_data, init_db
from zoom_auth import authenticate_zoom
from googleapiclient.discovery import build

def main():
    print("Welcome to IIITD Authentication System")
    print("Please enter your IIITD email address:")
    email = input().strip()
    
    if not verify_iiitd_domain(email):
        print("Error: Only @iiitd.ac.in email addresses are allowed.")
        return
    
    try:
        # Initialize database
        init_db()
        
        # Get Google credentials and user info
        creds = get_credentials()
        service = build('oauth2', 'v2', credentials=creds)
        user_info = service.userinfo().get().execute()
        
        # Verify the email matches
        if user_info['email'] != email:
            print("Error: The authenticated email does not match the provided email.")
            return
        
        print("\nGoogle Authentication successful!")
        print("\nUser Information:")
        print("-" * 50)
        print(f"Name: {user_info.get('name', 'N/A')}")
        print(f"Email: {user_info.get('email', 'N/A')}")
        print(f"Profile Picture URL: {user_info.get('picture', 'N/A')}")
        
        # Store Google user data
        store_user_data(user_info)
        
        # Ask if user wants to proceed with Zoom authentication
        print("\nWould you like to connect your Zoom account? (yes/no)")
        response = input().strip().lower()
        
        if response == 'yes':
            # Proceed with Zoom authentication
            zoom_success = authenticate_zoom(user_info['id'])
            if zoom_success:
                print("\nAuthentication process completed successfully!")
            else:
                print("\nZoom authentication failed, but Google authentication is still valid.")
        else:
            print("\nSkipping Zoom authentication. Google authentication is complete!")
            
    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == '__main__':
    main() 