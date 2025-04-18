import psycopg2
import csv

# Pronouns mapping
pronouns_map = {
    "Male": "he/him",
    "Female": "she/her",
    "Genderfluid": "they/them",
    "Non-binary": "they/them",
    "Agender": "they/them",
    "Bigender": "they/them",
    "Genderqueer": "they/them",
    "Polygender": "they/them"
}


# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="evalio_app_dev",
    user="evaliouser123",
    password="evaliopass123",
    host="localhost",  # Change if hosted elsewhere
    port="5432"
)
cur = conn.cursor()

# Create the mentees table (with pronouns column instead of gender)
cur.execute("""
CREATE TABLE IF NOT EXISTS mentees (
    mentee_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    pronouns TEXT,
    profile_picture TEXT,
    cohort TEXT,
    batch INTEGER,
    attendance_percent INTEGER,
    assignment_percent INTEGER
);
""")

# Read from CSV file
with open("MENTEE_DATA2.csv", mode='r', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)  # assuming tab-delimited

    for row in reader:
        original_gender = row['gender'].strip()
        pronouns = pronouns_map.get(original_gender, 'they/them')  # default fallback

        cur.execute("""
        INSERT INTO mentees (
            mentee_id, first_name, last_name, email, pronouns,
            profile_picture, cohort, batch, attendance_percent, assignment_percent
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (mentee_id) DO NOTHING;
        """, (
            int(row['mentee_id']),
            row['first_name'],
            row['last_name'],
            row['email'],
            pronouns,
            row['profile_picture'],
            row['cohort'],
            int(row['batch']),
            int(row['attendance_percent']),
            int(row['assignment_percent'])
        ))

# Commit and close
conn.commit()
cur.close()
conn.close()

print("Mentee data imported successfully from MENTEE_DATA2.csv.")