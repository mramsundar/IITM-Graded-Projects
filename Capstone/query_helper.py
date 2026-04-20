import sqlite3
import os
import pandas as pd

def create_connection(db_file):
    """Create a database connection to the SQLite database specified by db_file"""
    os.makedirs(os.path.dirname(db_file), exist_ok=True)
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        print("Connection to database successful.")
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
    return conn

def get_connection():
    """Get connection to the hospital database"""
    root_dir = os.path.dirname(os.getcwd())
    db_path = os.path.join(root_dir, "Database", "hospital.db")
    return create_connection(db_path)

def execute_script(conn, script_file):
    """Execute a SQL script from a file"""
    with open(script_file, "r") as file:
        script = file.read()
    try:
        cursor = conn.cursor()
        cursor.executescript(script)
        conn.commit()
        print(f"Executed script: {script_file}")
    except sqlite3.Error as e:
        print(f"Error executing script {script_file}: {e}")

def import_csv(conn, csv_file, table_name):
    """Import CSV files into the database"""
    try:
        df = pd.read_csv(csv_file)
        df.to_sql(table_name, conn, if_exists="append", index=False)
        print(f"Imported {len(df)} rows from {csv_file} into {table_name}")
    except Exception as e:
        print(f"Error importing {csv_file}: {e}")

def run_query(conn, query, title="Query"):
    """Run a query and display results with query plan"""
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")

    plan = pd.read_sql(f"EXPLAIN QUERY PLAN {query}", conn)
    print("\n📋 Query Plan:")
    for _, row in plan.iterrows():
        print(f"   {row['detail']}")

    df = pd.read_sql(query, conn)
    print(f"\n📊 Results ({len(df)} rows):")
    display(df)
    return df