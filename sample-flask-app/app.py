from flask import Flask, jsonify
import psycopg2
import os
import socket

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "appdb")
DB_USER = os.getenv("DB_USER", "appuser")
DB_PASS = os.getenv("DB_PASS", "apppass")

@app.route("/")
def home():
    return jsonify({"message": "Hello from DEV Flask in Docker running on ECS Fargate!","container_id": socket.gethostname()})

@app.route("/qa/")
def qa_index():
    return jsonify({"message": "Hello from QA Flask in Docker running on ECS Fargate!","container_id": socket.gethostname()})


@app.route("/db-check")
def db_check():
    try:
        conn = psycopg2.connect(
            host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS
        )
        cur = conn.cursor()
        cur.execute("SELECT NOW();")
        result = cur.fetchone()
        cur.close()
        conn.close()
        return jsonify({"db_status": "connected", "time": str(result[0])})
    except Exception as e:
        return jsonify({"db_status": "error", "details": str(e)}), 500

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
